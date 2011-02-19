From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables: misc option edits
Date: Sat, 19 Feb 2011 20:04:10 +0100
Message-ID: <1298142259-11213-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42353 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755014Ab1BSTEe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Feb 2011 14:04:34 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Please review! (And if ok, merge.)

===

The following changes since commit 87dc7c4c842deb1e2e3d38089ffcad9f238d98de:

  xtables: use strspn() to check if string needs to be quoted (2011-02-17 11:57:19 +0100)

are available in the git repository at:
  git://dev.medozas.de/iptables master

Jan Engelhardt (8):
      doc: fix wrong sentence about negation in xt_limit
      doc: fix misspelling of "field"
      extensions: remove redundant init functions
      Remove unused CVS expanded keywords
      libip6t_dst: remove unimplemented --dst-not-strict
      libip6t_hbh: remove unimplemented --hbh-not-strict
      extensions: add missing checks for specific flags
      libipt_ECN: set proper option flags

 extensions/libip6t_ah.c         |    4 +---
 extensions/libip6t_dst.c        |   29 -----------------------------
 extensions/libip6t_frag.c       |    6 +-----
 extensions/libip6t_hbh.c        |   25 -------------------------
 extensions/libip6t_ipv6header.c |   10 ----------
 extensions/libip6t_rt.c         |    8 +-------
 extensions/libipt_DNAT.c        |    2 +-
 extensions/libipt_ECN.c         |    6 ++----
 extensions/libipt_SAME.c        |   12 ------------
 extensions/libipt_TTL.c         |    2 --
 extensions/libipt_ttl.c         |    2 --
 extensions/libxt_NFLOG.c        |    1 -
 extensions/libxt_RATEEST.c      |    8 --------
 extensions/libxt_TCPOPTSTRIP.c  |    9 ---------
 extensions/libxt_dccp.c         |    8 --------
 extensions/libxt_hashlimit.c    |    1 -
 extensions/libxt_limit.man      |    7 +++++--
 extensions/libxt_osf.c          |    2 +-
 extensions/libxt_sctp.c         |    2 --
 extensions/libxt_string.c       |    3 +--
 ip6tables-restore.c             |    2 --
 iptables-restore.c              |    2 --
 iptables-xml.c                  |    2 --
 libipq/ipq_create_handle.3      |    2 --
 libipq/ipq_errstr.3             |    2 --
 libipq/ipq_message_type.3       |    2 --
 libipq/ipq_read.3               |    2 --
 libipq/ipq_set_mode.3           |    2 --
 libipq/ipq_set_verdict.3        |    2 --
 libipq/libipq.3                 |    2 --
 30 files changed, 13 insertions(+), 154 deletions(-)
