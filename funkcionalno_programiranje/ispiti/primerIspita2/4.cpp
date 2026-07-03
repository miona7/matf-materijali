// Koristeći biblioteku range-v3, a bez upotrebe for, while, do-while petlji, 
// komande goto, rekurzije, i algoritma std::for_each implementirati sledeći zadatak:
// Napisati program koji sa standardnog ulaza čita reč po reč, transformiše sve reči tako 
// što uklanja sve brojeve (cifre) iz njih, a zatim ispisuje samo one reči čija je dužina 
// strogo veća od 3 karaktera. Svaka reč se ispisuje u novom redu.

// Za ulaz: prog123ramiranje je 99 super stvar na fakultetu1
// Treba ispisati: 
// programiranje
// super
// stvar
// fakultetu

#include <iostream>
#include <string>
#include <vector>
#include <iterator>

#include <range/v3/view.hpp>
#include <range/v3/action.hpp>
#include <range/v3/algorithm.hpp>
#include <range/v3/to_container.hpp>

#include <cassert>

using namespace ranges::v3;
namespace views = ranges::v3::view;
namespace actions = ranges::v3::action;

std::string removeNums(const std::string& s) {
    return s | views::filter([](const auto& c) {
        if(isdigit(c)) {
            return false;
        }
        return true;
    }) | to<std::string>();
}

int main() {
    std::vector<std::string> allWords{
        std::istream_iterator<std::string>{std::cin},
        std::istream_iterator<std::string>{}
    };

    auto result = allWords 
                | views::transform([](const auto& s) { return removeNums(s); } )
                | view::filter([](const auto& s) {
                    if(s.length() > 3) {
                        return true;
                    }
                    return false;
                });

    for(auto r : result) {
        std::cout << r << std::endl;
    }
}