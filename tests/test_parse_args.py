"""Tests for imgp argument parsing.

imgp is a single-file script (no .py extension), so it is loaded
with SourceFileLoader instead of a plain import.
"""

import sys
from importlib.machinery import SourceFileLoader

import pytest


def _load_imgp():
    return SourceFileLoader("imgp_under_test", "imgp").load_module()


def test_parse_args_honors_explicit_args_despite_short_argv(monkeypatch):
    """parse_args(['-x', '50%']) must not exit when sys.argv is short.

    Regression test: parse_args() used to consult sys.argv (instead of
    the explicitly passed args) to decide there is nothing to do, so a
    programmatic caller passing explicit args while sys.argv had fewer
    than 2 entries got a SystemExit(1) plus printed help.
    """
    imgp = _load_imgp()
    monkeypatch.setattr(sys, "argv", ["imgp"])
    ns = imgp.parse_args(["-x", "50%"])
    assert ns.res == ["50%"]


def test_parse_args_no_args_still_exits_when_argv_short(monkeypatch):
    """CLI contract is unchanged: no args and short argv still exits."""
    imgp = _load_imgp()
    monkeypatch.setattr(sys, "argv", ["imgp"])
    with pytest.raises(SystemExit):
        imgp.parse_args()
