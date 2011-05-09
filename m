From: Jan Engelhardt <jengelh@medozas.de>
Subject: guided option parser, run 5
Date: Mon,  9 May 2011 11:36:58 +0200
Message-ID: <1304933832-16412-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51656 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205Ab1EIJhO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 05:37:14 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit edc2b1adf32d2b11e126174f525293b3bca6e7bc:

  Merge branch 'opts' of git://dev.medozas.de/iptables (2011-05-09 11:26:32 +0200)

are available in the git repository at:

  git://dev.medozas.de/iptables opts

Jan Engelhardt (13):
      libxt_tos: add inversion support back again
      libxtables: fix assignment in wrong offset (XTTYPE_UINT*RC)
      libxt_u32: add missing call to xtables_option_parse
      extensions: remove bogus use of XT_GETOPT_TABLEEND
      libxt_owner: remove ifdef IPT_COMM_OWNER
      libxtables: output name of extension on rev detect failure
      extensions: const annotations
      libxt_statistic: streamline and document possible placement of negation
      libxt_statistic: increase precision on create and dump
      libxtables: XTTYPE_DOUBLE support
      libxt_statistic: use guided option parser
      libxt_IDLETIMER: use guided option parser
      libxt_NFLOG: use guided option parser

 extensions/libip6t_ipv6header.c |    6 +-
 extensions/libip6t_rt.c         |    4 +-
 extensions/libxt_IDLETIMER.c    |   70 +++--------------
 extensions/libxt_NFLOG.c        |   98 ++++++------------------
 extensions/libxt_TCPOPTSTRIP.c  |    2 +-
 extensions/libxt_dccp.c         |    6 +-
 extensions/libxt_multiport.c    |   10 +-
 extensions/libxt_owner.c        |   20 -----
 extensions/libxt_policy.c       |    4 +-
 extensions/libxt_rateest.c      |    2 +-
 extensions/libxt_sctp.c         |    6 +-
 extensions/libxt_statistic.c    |  160 ++++++++++++++++-----------------------
 extensions/libxt_statistic.man  |   11 +--
 extensions/libxt_tcp.c          |    6 +-
 extensions/libxt_tos.c          |    4 +-
 extensions/libxt_u32.c          |    1 +
 extensions/libxt_udp.c          |    6 +-
 include/xtables.h.in            |    5 +-
 xtables.c                       |    4 +-
 xtoptions.c                     |   27 ++++++-
 20 files changed, 167 insertions(+), 285 deletions(-)
