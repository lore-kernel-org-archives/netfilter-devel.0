From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/3] nftables: fix segtree interval conflict reporting
Date: Fri,  7 Mar 2014 10:28:38 +0100
Message-ID: <1394184521-11419-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35817 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbaCGJ2z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:28:55 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patches fix segtree interval conflict reporting. Currently
on a conflict a debug message is printed and the error is ignored. These
patches change this to output a proper error and abort.

Additionally the cases where an conflict is detected is fixed to ignore
cases when the data associated with two intervals is equal.


Patrick McHardy (3):
      expr: make expr_binary_error() usable outside of evaluation
      expr: add comparison function for singleton expressions
      set: abort on interval conflicts

 include/expression.h | 12 ++++++++----
 src/ct.c             |  6 ++++++
 src/expression.c     | 36 ++++++++++++++++++++++++++++++++++--
 src/exthdr.c         |  7 +++++++
 src/meta.c           |  6 ++++++
 src/payload.c        | 17 +++++++++++++----
 src/rule.c           |  5 +++--
 src/segtree.c        | 21 +++++++++++++++------
 8 files changed, 92 insertions(+), 18 deletions(-)

