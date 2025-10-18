#include "path_utils.hpp"
#include <string>
#include <vector>
#include <sys/stat.h>

#ifdef __APPLE__
#include "MacPaths.h"
#elif __linux__
#include <unistd.h>
#include <limits.h>
#elif _WIN32
#include <windows.h>
#endif

namespace {
    std::string assets_dir = "";

    bool directory_exists(const std::string& path) {
        struct stat info;
        if (stat(path.c_str(), &info) != 0) {
            return false;
        }
        return (info.st_mode & S_IFDIR) != 0;
    }

    std::string get_executable_path() {
#ifdef __APPLE__
        return bundleResourcesPath();
#elif __linux__
        char result[PATH_MAX];
        ssize_t count = readlink("/proc/self/exe", result, PATH_MAX);
        return std::string(result, (count > 0) ? count : 0);
#elif _WIN32
        char result[MAX_PATH];
        GetModuleFileName(NULL, result, MAX_PATH);
        return std::string(result);
#else
        return "";
#endif
    }

    void find_assets_dir() {
        if (!assets_dir.empty()) {
            return;
        }

        std::string exe_path = get_executable_path();
        std::string exe_dir = "";
        if (!exe_path.empty()) {
            size_t last_slash = exe_path.find_last_of("/\\");
            if (last_slash != std::string::npos) {
                exe_dir = exe_path.substr(0, last_slash);
            }
        }

        std::vector<std::string> search_paths;
        search_paths.push_back("assets");
        if (!exe_dir.empty()) {
            search_paths.push_back(exe_dir + "/assets");
            search_paths.push_back(exe_dir + "/../assets");
            search_paths.push_back(exe_dir + "/../../assets");
        }

        for (const auto& path : search_paths) {
            if (directory_exists(path)) {
                assets_dir = path;
                return;
            }
        }
    }
}

std::string lif::getAssetPath(const std::string& asset_type, const std::string& asset_name) {
    find_assets_dir();
    if (assets_dir.empty()) {
        // Fallback to relative path if assets directory is not found
        return "assets/" + asset_type + "/" + asset_name;
    }
    return assets_dir + "/" + asset_type + "/" + asset_name;
}