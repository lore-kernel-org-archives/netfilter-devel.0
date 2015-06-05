From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft 0/9] concat support
Date: Fri,  5 Jun 2015 15:42:42 +0200
Message-ID: <1433511771-4620-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59931 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbbFENmy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2015 09:42:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patches add support for concatenations to nft. 

The series begins by changing register allocation to take the real size
of an expression into account and allocate an approriate number of 32
bit registers. This is however only done when concatenations are actually
used, so in all other cases we'll continue to use 128 bit registers
for compatibility.

The next part is delinearization, which maps the new registers numbers
appropriately and changes individual expression reconstruction to build
concat expression when indicated by the LHS and RHS sizes.

The final patch changes set element delinearization to reconstruct the
concat expression in set elements when indicated by the key type of the
set.


Patrick McHardy (9):
  eval: prohibit variable sized types in concat expressions
  headers: sync headers for new register values
  netlink: pass expression to register allocation/release functions
  netlink_linearize: use NFT_REG32 values internally
  netlink_linearize: generate concat expressions
  netlink: pad constant concat sub-expressions
  netlink_delinearize: introduce register translation helper
  netlink_delinearize: handle relational and lookup concat expressions
  netlink: handle concat expressions in set data

 include/linux/netfilter/nf_tables.h |  34 +++++++++-
 include/netlink.h                   |  15 +++++
 src/datatype.c                      |   5 +-
 src/evaluate.c                      |   7 ++
 src/netlink.c                       |  46 ++++++++++---
 src/netlink_delinearize.c           | 130 ++++++++++++++++++++++++++++++++----
 src/netlink_linearize.c             | 105 ++++++++++++++++++++---------
 7 files changed, 288 insertions(+), 54 deletions(-)

-- 
2.1.0

