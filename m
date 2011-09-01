From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables fixes 20110901
Date: Thu,  1 Sep 2011 11:15:47 +0200
Message-ID: <1314868551-4281-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:54859 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883Ab1IAJPz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Sep 2011 05:15:55 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit debcf48f6a72914a9c06e99b175ad64ef1f6f1cb:

  libxt_TOS: update linux kernel version list for backported fix (2011-08-26 15:14:04 +0200)

are available in the git repository at:
  git://dev.medozas.de/iptables fixes-2

Jan Engelhardt (1):
      xtoptions: fill in fallback value for nvals

Richard Weinberger (1):
      xtoptions: simplify xtables_parse_interface

Tom Eastep (1):
      libxt_conntrack: improve error message on parsing violation

 extensions/libxt_conntrack.c |   15 +++++++++++----
 iptables/xtables.c           |    4 +---
 iptables/xtoptions.c         |    6 ++++++
 3 files changed, 18 insertions(+), 7 deletions(-)
