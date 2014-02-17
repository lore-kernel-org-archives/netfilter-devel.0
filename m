From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/4] nftables: bitmask and prefix fixes
Date: Mon, 17 Feb 2014 17:20:48 +0000
Message-ID: <1392657652-9815-1-git-send-email-kaber@trash.net>
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51560 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbaBQRVD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:21:03 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These patches fix a problem with bitmask types outside of a flag comparison
noticed by Florian, as well as a couple of bugs in related areas:

- always use FLAGCMP op if RHS of a relational expression has basetype bitmask
- add parens in output of binops when necessary
- fix netlink prefix expression handling

Unless there are objections, I'll push them shortly.


Patrick McHardy (4):
      evaluate: use flagcmp for single RHS bitmask expression
      binop: take care of operator precedence when printing binop arguments
      netlink_delinarize: convert *all* bitmask values into individual bit values
      netlink: fix prefix expression handling

 include/expression.h      |   8 ++++
 src/evaluate.c            |   6 ++-
 src/expression.c          |  88 +++++++++++++++++++++++++++++++++++++--
 src/netlink.c             |  27 ------------
 src/netlink_delinearize.c | 104 ++++++++++++++++++++++++++--------------------
 src/netlink_linearize.c   |  11 ++++-
 6 files changed, 165 insertions(+), 79 deletions(-)
