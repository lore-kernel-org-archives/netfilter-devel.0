From: Jan Engelhardt <jengelh@medozas.de>
Subject: guided option parser, run 2
Date: Tue, 12 Apr 2011 16:23:15 +0200
Message-ID: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51078 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069Ab1DLOXq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:23:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit b18ffe3636b07cd817628de81643136e4755a944:

  libxt_cluster: use guided option parser (2011-04-06 13:12:52 +0200)

are available in the git repository at:
  git://dev.medozas.de/iptables opts

Jan Engelhardt (28):
      libxtables: XTTYPE_UINT8 support
      libip[6]t_HL: use guided option parser
      libip[6]t_hl: use guided option parser
      libxtables: XTTYPE_UINT32RC support
      libip[6]t_ah: use guided option parser
      libip6t_frag: use guided option parser
      libxt_esp: use guided option parser
      libxtables: XTTYPE_STRING support
      libip[6]t_REJECT: use guided option parser
      libip6t_dst: use guided option parser
      libip6t_hbh: use guided option parser
      libip[6]t_icmp: use guided option parser
      libip6t_ipv6header: use guided option parser
      libipt_ECN: use guided option parser
      libipt_addrtype: use guided option parser
      libxt_AUDIT: use guided option parser
      libxt_CLASSIFY: use guided option parser
      libxt_DSCP: use guided option parser
      libxt_LED: use guided option parser
      libxt_SECMARK: use guided option parser
      libxt_TCPOPTSTRIP: use guided option parser
      libxt_comment: use guided option parser
      libxt_helper: use guided option parser
      libxt_physdev: use guided option parser
      libxt_pkttype: use guided option parser
      libxt_state: use guided option parser
      libxt_time: use guided option parser
      libxt_u32: use guided option parser

 extensions/libip6t_HL.c         |  111 ++++++++++-----------------
 extensions/libip6t_REJECT.c     |   48 ++++++------
 extensions/libip6t_ah.c         |  112 +++++++---------------------
 extensions/libip6t_dst.c        |   61 +++++----------
 extensions/libip6t_frag.c       |  145 +++++++++--------------------------
 extensions/libip6t_hbh.c        |   61 ++++++----------
 extensions/libip6t_hl.c         |  106 ++++++++++----------------
 extensions/libip6t_icmp6.c      |   53 ++++---------
 extensions/libip6t_ipv6header.c |   88 +++++++---------------
 extensions/libipt_ECN.c         |   95 +++++++++--------------
 extensions/libipt_REJECT.c      |   58 ++++++--------
 extensions/libipt_TTL.c         |  110 ++++++++++-----------------
 extensions/libipt_addrtype.c    |  160 ++++++++++++++-------------------------
 extensions/libipt_ah.c          |   89 ++++------------------
 extensions/libipt_ecn.c         |   82 ++++++++------------
 extensions/libipt_icmp.c        |   47 +++++-------
 extensions/libipt_ttl.c         |  109 ++++++++++-----------------
 extensions/libxt_AUDIT.c        |   66 ++++++-----------
 extensions/libxt_CLASSIFY.c     |   55 ++++----------
 extensions/libxt_DSCP.c         |   87 ++++++---------------
 extensions/libxt_LED.c          |   84 ++++++++------------
 extensions/libxt_SECMARK.c      |   54 ++++----------
 extensions/libxt_TCPOPTSTRIP.c  |   46 +++--------
 extensions/libxt_comment.c      |   61 +++------------
 extensions/libxt_dscp.c         |   94 +++++++----------------
 extensions/libxt_esp.c          |   95 ++++-------------------
 extensions/libxt_helper.c       |   54 ++++---------
 extensions/libxt_physdev.c      |  113 ++++++++++-----------------
 extensions/libxt_pkttype.c      |   52 ++++---------
 extensions/libxt_state.c        |   50 ++++--------
 extensions/libxt_time.c         |  153 +++++++++++++------------------------
 extensions/libxt_u32.c          |   39 ++++------
 include/xtables.h.in            |   10 ++-
 xtoptions.c                     |   90 +++++++++++++++++++++-
 34 files changed, 955 insertions(+), 1783 deletions(-)
