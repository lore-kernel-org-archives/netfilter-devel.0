From: Jan Engelhardt <jengelh@medozas.de>
Subject: option parsing, run 9
Date: Mon, 23 May 2011 16:39:10 +0200
Message-ID: <1306161564-4370-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:44604 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755421Ab1EWOj1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 May 2011 10:39:27 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 17f7937f79af4d260c60cb800e56fc0df0a48b37:

  libxt_devgroup: actually set XT_DEVGROUP_OPT_???GROUP flags (2011-05-23 16:28:25 +0200)

are available in the git repository at:
  git://dev.medozas.de/iptables master

JP Abgrall (1):
      libxt_quota: make sure uint64 is not truncated

Jan Engelhardt (11):
      libxtables: retract _NE types and use a flag instead
      libxt_quota: readd missing XTOPT_PUT request
      libxtables: check for negative numbers in xtables_strtou*
      libxt_rateest: streamline case display of units
      doc: add some coded option examples to libxt_hashlimit
      doc: make usage of libxt_rateest more obvious
      doc: clarify that -p all is a special keyword only
      libxt_rateest: avoid optional arguments
      libxt_rateest: fix rateest save operation
      libxt_rateest: use guided option parser
      libxt_ipvs: restore network-byte order

Lutz Jaenicke (1):
      libipt_REDIRECT: "--to-ports" is not mandatory

 extensions/libipt_REDIRECT.c   |    3 +-
 extensions/libxt_TPROXY.c      |    8 +-
 extensions/libxt_hashlimit.man |   26 ++-
 extensions/libxt_ipvs.c        |    6 +-
 extensions/libxt_quota.c       |    3 +-
 extensions/libxt_rateest.c     |  378 +++++++++++++++++-----------------------
 extensions/libxt_rateest.man   |   79 +++++++--
 include/xtables.h.in           |   14 +-
 ip6tables.8.in                 |    5 +-
 iptables.8.in                  |    5 +-
 xtables.c                      |   13 +-
 xtoptions.c                    |   17 +-
 12 files changed, 280 insertions(+), 277 deletions(-)
