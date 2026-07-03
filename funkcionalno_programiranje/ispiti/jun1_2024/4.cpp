// 4. U cpp-u napisati fju to_camel koja prima string u snake notaciji 
// i vraca u camel notaciji (foo_bar = fooBar, foo_bar_wow = fooBarWow). 
// I ukoliko zatreba, radi isto nad listom stringova.

#include <iostream>
#include <string>
#include <vector>
#include <numbers>
#include <functional>
#include <range/v3/view.hpp>

using namespace ranges::v3;

std::string to_camel(const std::string& s) {
    if(s.empty()) {
        return "";
    }

    auto result = view::zip(view::ints(0, unreachable), s)
        | view::transform([&s](auto pair) {
            auto [i, c] = pair;
            
            if(i > 0 && s[i-1] == '_') {
                return (char)std::toupper(c);
            }

            return c;
        })
        | view::filter([](const auto& value) {
            return value != '_';
        });

    return result | to<std::string>();
}

auto to_camel(const std::vector<std::string>& s) {
    return s | view::transform([](const auto& value) { return to_camel(value); });
}

int main() {
    std::string s = "foo_bar_wow";
    std::cout << "Pojedinacni: " << to_camel(s) << "\n\n"; 

    std::vector<std::string> lista = {"student_ime", "broj_indeksa", "glavna_funkcija"};
    auto result = to_camel(lista);
    
    std::cout << "Cela lista kroz pajp:" << std::endl;
    for(auto x : result) {
        std::cout << x << ", ";
    } 
    std::cout << std::endl;
}