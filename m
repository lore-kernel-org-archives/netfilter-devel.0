From: Jan Engelhardt <jengelh@medozas.de>
Subject: guided option parser, run 6
Date: Mon,  9 May 2011 21:54:54 +0200
Message-ID: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49329 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223Ab1EITzQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 15:55:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit c29f7ef7cb5a31620060ef721d3c65b343eb537a:

  Merge branch 'opts' of git://dev.medozas.de/iptables (2011-05-09 20:23:21 +0200)

are available in the git repository at:

  git://dev.medozas.de/iptables opts

Jan Engelhardt (17):
      libxtables: support for XTTYPE_PLENMASK
      libxt_connlimit: use guided option parser
      libxt_recent: use guided option parser
      libxtables: do not overlay addr and mask parts, and cleanup
      libxtables: flag invalid uses of XTOPT_PUT
      libxtables: XTTYPE_PLEN support
      libxt_hashlimit: use guided option parser
      libxtables: XTTYPE_HOSTMASK support
      libxt_policy: use guided option parser
      libxt_owner: use guided option parser
      libxt_osf: use guided option parser
      libxt_multiport: use guided option parser
      libipt_NETMAP: use guided option parser
      libxt_limit: use guided option parser
      libxtables: XTTYPE_PROTOCOL support
      libxt_ipvs: use guided option parser
      libxt_conntrack: use guided option parser

 extensions/libipt_NETMAP.c   |  106 +------
 extensions/libxt_TEE.c       |    2 +-
 extensions/libxt_TPROXY.c    |    6 +-
 extensions/libxt_connlimit.c |  176 ++++-------
 extensions/libxt_conntrack.c |  670 ++++++++++++++----------------------------
 extensions/libxt_hashlimit.c |  419 ++++++++------------------
 extensions/libxt_ipvs.c      |  208 ++++---------
 extensions/libxt_limit.c     |   53 ++--
 extensions/libxt_multiport.c |  178 +++++-------
 extensions/libxt_osf.c       |   97 ++-----
 extensions/libxt_owner.c     |  288 ++++++++-----------
 extensions/libxt_policy.c    |  269 +++++------------
 extensions/libxt_recent.c    |  186 +++++-------
 include/xtables.h.in         |   28 ++-
 xtoptions.c                  |  147 +++++++++-
 15 files changed, 1050 insertions(+), 1783 deletions(-)
