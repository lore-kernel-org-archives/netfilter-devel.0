From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/8] nftables: fix and improve error reporting
Date: Tue,  4 Feb 2014 08:35:12 +0000
Message-ID: <1391502920-19186-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43618 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaBDIfZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Feb 2014 03:35:25 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patchset fixes a couple of minor issues and improves
error reporting:

- don't show "In file included from internal:0:0-0:" for files parsed with -f
- location fixes
- fix output of implicit relational ops for constant LHS or non-constant RHS
- add missing closing of scope on parsing errors of blocks
- recover from errors in blocks and continue parsing
- evaluate every command immediately after parsing it

The goal of this patchset is to make error reporting show multiple errors
at once so testing and fixing of a ruleset can be done more quickly.


With these patches, we output all errors encountered during parsing and
evaluation in one batch:

tests/error.1:4:8-8: Error: syntax error, unexpected '{', expecting string
filter {
       ^
tests/error.1:5:13-13: Error: syntax error, unexpected newline
filter input
            ^
tests/error.1:6:17-17: Error: syntax error, unexpected newline
filter input tcp
                ^
tests/error.1:7:23-23: Error: syntax error, unexpected newline
filter input tcp dport
                      ^
tests/error.1:8:24-26: Error: datatype mismatch, expected internet network service, expression has type Internet protocol
filter input tcp dport tcp
             ~~~~~~~~~ ^^^
tests/error.1:9:24-32: Error: Right hand side of relational expression (==) must be constant
filter input tcp dport tcp dport
             ~~~~~~~~~~^^^^^^^^^


I'll push this shortly unless I hear objections.


Patrick McHardy (8):
      evaluate: determine implicit relational op before RHS constant checks
      scanner: don't update location's line_offset for newlines
      scanner: update last_line in struct location
      erec: skip includes with INDESC_INTERNAL
      parser: close scope when encountering an error in a table or chain block
      parser: recover from errors in any block
      parser: evaluate commands immediately after parsing
      tests: add two tests for error reporting


 include/nftables.h |  1 +
 include/parser.h   |  2 ++
 include/rule.h     |  2 +-
 src/erec.c         |  4 +++-
 src/evaluate.c     | 35 ++++++++++++-----------------------
 src/main.c         | 11 +++--------
 src/parser.y       | 27 ++++++++++++++++++++++-----
 src/scanner.l      |  2 +-
 tests/error.1      |  9 +++++++++
 tests/error.2      | 18 ++++++++++++++++++
 10 files changed, 72 insertions(+), 39 deletions(-)

