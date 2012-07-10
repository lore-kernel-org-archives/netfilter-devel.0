From: Jan Engelhardt <jengelh@inai.de>
Subject: xt_recent cleanups, xt_SYSRQ
Date: Wed, 11 Jul 2012 01:52:26 +0200
Message-ID: <1341964350-13809-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:54420 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755562Ab2GJXwh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:52:37 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 5c2a54214ae988708d84e3269dc99176b086ec1a:

  netfilter: xt_recent: explain if module parameters are wrong (2012-07-10 22:50:59 +0200)

are available in the git repository at:
  git://git.inai.de/linux master

Jan Engelhardt (4):
      netfilter: xt_recent: remove ip_list_hash_size parameter
      netfilter: cleanup use of the term "IPs"
      netfilter: use permission mnemonics in module_param
      netfilter: xtables: inclusion of xt_SYSRQ

 net/ipv4/netfilter/ipt_ULOG.c                  |    6 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 +-
 net/ipv4/netfilter/nf_nat_snmp_basic.c         |    2 +-
 net/netfilter/Kconfig                          |   12 +
 net/netfilter/Makefile                         |    1 +
 net/netfilter/ipset/ip_set_core.c              |    2 +-
 net/netfilter/ipvs/Kconfig                     |   15 +-
 net/netfilter/ipvs/ip_vs_conn.c                |    2 +-
 net/netfilter/ipvs/ip_vs_ftp.c                 |    2 +-
 net/netfilter/nf_conntrack_acct.c              |    2 +-
 net/netfilter/nf_conntrack_amanda.c            |    4 +-
 net/netfilter/nf_conntrack_core.c              |    2 +-
 net/netfilter/nf_conntrack_expect.c            |    2 +-
 net/netfilter/nf_conntrack_ftp.c               |    4 +-
 net/netfilter/nf_conntrack_h323_main.c         |    6 +-
 net/netfilter/nf_conntrack_helper.c            |    3 +-
 net/netfilter/nf_conntrack_irc.c               |    6 +-
 net/netfilter/nf_conntrack_sane.c              |    2 +-
 net/netfilter/nf_conntrack_sip.c               |    8 +-
 net/netfilter/nf_conntrack_tftp.c              |    2 +-
 net/netfilter/nf_conntrack_timestamp.c         |    2 +-
 net/netfilter/xt_SYSRQ.c                       |  361 ++++++++++++++++++++++++
 net/netfilter/xt_recent.c                      |   11 +-
 23 files changed, 417 insertions(+), 42 deletions(-)
 create mode 100644 net/netfilter/xt_SYSRQ.c
