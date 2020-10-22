//
//  main.swift
//  aoc
//
//  Created by Leif Walker-Grant on 19/10/2020.
//

import Foundation
import ArgumentParser

let minDay = 1
let maxDay = 25
let minYear = 2015
let maxYear = 2020

struct Aoc: ParsableCommand {
    @Flag(name: .shortAndLong, help: "Include additional debug information in puzzle solver output.")
    var verbose = false

    @Option(name: .shortAndLong, help: "The year from which to run a puzzle solver, between \(minYear) and \(maxYear) inclusive.")
    var year: Int

    @Option(name: .shortAndLong, help: "The day for which to run the puzzle solver, between \(minDay) and \(maxDay) inclusive.")
    var day: Int

    func validate() throws {
        guard Array(minYear...maxYear).contains(year) else {
            throw ValidationError("'<year>' must be between \(minYear) and \(maxYear), inclusive.")
        }

        guard Array(minDay...maxDay).contains(day) else {
            throw ValidationError("'<day>' must be between \(minDay) and \(maxDay), inclusive.");
        }
    }

    mutating func run() throws {
        let fqcn = "aoc.SolverY\(year)D\(day)"
        let dataFilePath = "data/\(year)/day\(day).in"
        let log = ConsoleLog(enableDebug: verbose)

        guard let cls = NSClassFromString(fqcn) as? Solvable.Type else {
            log.error(theMessage: "No solver was found for \(day)/12/\(year)'s puzzle.")
            return
        }

        guard let input = try? String(contentsOfFile: dataFilePath) else {
            log.error(theMessage: "Unable to read the input data file '\(dataFilePath)'.")
            return
        }

        let solver = cls.init(withLog: log, andInput: input)
        solver.doPart1(withLog: log)
        solver.doPart2(withLog: log)
    }
}

Aoc.main()
