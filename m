From: Jan Engelhardt <jengelh@inai.de>
Subject: iptables: Mostly Parser Fixes
Date: Sat, 28 Jul 2012 19:21:02 +0200
Message-ID: <1343496069-5442-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:34343 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900Ab2G1RVQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Jul 2012 13:21:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


/*
 * Please review and if ok, merge.
 */

The following changes since commit 44191bdbd71e685fba9eab864b9df25e63905220:

  iptables-restore: move code to add_param_to_argv, cleanup (fix gcc-4.7) (2012-07-25 13:04:52 +0200)

are available in the git repository at:
  git://git.inai.de/iptables master

Jan Engelhardt (7):
      iptables-restore: warn about -t in rule lines
      doc: grammatical updates to libxt_SET
      libxt_u32: do bounds checking for @'s operands
      libxt_devgroup: consolidate devgroup specification parsing
      libxt_devgroup: guard against negative numbers
      libxt_LED: guard against negative numbers
      libxt_*limit: avoid division by zero

 extensions/libxt_LED.c       |    7 +++-
 extensions/libxt_SET.man     |   12 +++---
 extensions/libxt_devgroup.c  |   72 ++++++++++++++++++-----------------------
 extensions/libxt_hashlimit.c |   17 +++++++---
 extensions/libxt_limit.c     |   17 +++++++---
 extensions/libxt_u32.c       |   12 ++-----
 iptables/ip6tables-restore.c |    3 +-
 iptables/iptables-restore.c  |    3 +-
 8 files changed, 73 insertions(+), 70 deletions(-)
