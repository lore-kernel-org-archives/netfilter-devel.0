From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 00/10] nftables: set timeouts and dynamic updates
Date: Sun, 12 Apr 2015 13:16:08 +0100
Message-ID: <1428840978-27226-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58903 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbbDLMQW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Apr 2015 08:16:22 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patches contain support for the new features that have
already been merged to net-next, namely

* set and set element timeouts
* set element comments
* dynamic set updates

The first patch fixes parsing of the time time, the second one relaxes
time parsing. The third and fourth patches add support for time
specification as parameters to the grammar.

The fifth patch fixes inconsistencies in the set greammar, the six
patch adds a generic set element that will be used to attach element
attributes to expressions.

Finally, the seventh patch adds support for set timeouts, the eighth
patch for set element timeouts, the ninth for set element comments.
The last patch adds support for the "set" statement for dynamic set
updates.

I'll give them some more testing and will then push them to a -next
branch in the nftables tree.

Comments, especially regarding the syntax, are welcome.


Patrick McHardy (10):
  datatype: fix parsing of time type
  datatype: less strict time parsing
  datatype: seperate time parsing/printing from time_type
  parser: add a time_spec rule
  parser: fix inconsistencies in set expression rules
  expr: add set_elem_expr as container for set element attributes
  set: add timeout support for sets
  setelem: add timeout support for set elements
  setelem: add support for attaching comments to set elements
  nftables: add set statement

 include/datatype.h                  |   4 ++
 include/expression.h                |  11 ++++
 include/linux/netfilter/nf_tables.h |  39 ++++++++++++++
 include/rule.h                      |   5 ++
 include/statement.h                 |  11 ++++
 src/datatype.c                      |  82 ++++++++++++++--------------
 src/evaluate.c                      |  47 +++++++++++++++-
 src/expression.c                    |  42 +++++++++++++++
 src/netlink.c                       |  83 +++++++++++++++++++---------
 src/netlink_delinearize.c           |  41 ++++++++++++++
 src/netlink_linearize.c             |  26 +++++++++
 src/parser_bison.y                  | 105 +++++++++++++++++++++++++++++++-----
 src/rule.c                          |  23 +++++++-
 src/scanner.l                       |  10 ++++
 src/segtree.c                       |   8 ++-
 src/statement.c                     |  31 +++++++++++
 16 files changed, 486 insertions(+), 82 deletions(-)

-- 
2.1.0

