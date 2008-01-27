From: Max Kellermann <max@duempel.org>
Subject: [iptables PATCH trunk7285 0/7] escaping module arguments
Date: Sun, 27 Jan 2008 19:25:03 +0100
Message-ID: <20080127182421.15959.52088.stgit@woodpecker.roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:43910 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753048AbYA0SeP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Jan 2008 13:34:15 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

the following patch set is meant to be one step forward in
iptables-save/iptables-restore idempotency.  Several modules can now
cope with whitespace, single and double quotes in their parameters.
It should be reviewed whether libxt_string.c could also use the new
function save_string().

There are some more small patches, e.g. a patch which fixes gcc
warnings.

Max

---

Max Kellermann (7):
      fix gcc warnings
      allow empty strings in argument parser
      unescape parameters
      escape strings
      use size_t
      whitespace cleanup
      manpage fixes


 configure.ac                    |    5 +-
 extensions/dscp_helper.c        |    2 -
 extensions/libip6t_HL.c         |    2 -
 extensions/libip6t_LOG.c        |    2 -
 extensions/libip6t_REJECT.c     |    2 -
 extensions/libip6t_ah.c         |    2 -
 extensions/libip6t_dst.c        |    4 +-
 extensions/libip6t_frag.c       |    2 -
 extensions/libip6t_hbh.c        |    4 +-
 extensions/libip6t_hl.c         |    2 -
 extensions/libip6t_icmp6.c      |    2 -
 extensions/libip6t_ipv6header.c |    2 -
 extensions/libip6t_mh.c         |    2 -
 extensions/libip6t_policy.c     |    2 -
 extensions/libip6t_rt.c         |    4 +-
 extensions/libipt_CLUSTERIP.c   |    2 -
 extensions/libipt_DNAT.c        |    2 -
 extensions/libipt_ECN.c         |    2 -
 extensions/libipt_LOG.c         |    8 ++-
 extensions/libipt_MASQUERADE.c  |    2 -
 extensions/libipt_NETMAP.c      |    2 -
 extensions/libipt_REDIRECT.c    |    2 -
 extensions/libipt_REDIRECT.man  |    3 -
 extensions/libipt_REJECT.c      |    2 -
 extensions/libipt_SAME.c        |    8 ++-
 extensions/libipt_SNAT.c        |    2 -
 extensions/libipt_TTL.c         |    2 -
 extensions/libipt_ULOG.c        |    8 ++-
 extensions/libipt_addrtype.c    |    2 -
 extensions/libipt_ah.c          |    2 -
 extensions/libipt_ecn.c         |    2 -
 extensions/libipt_icmp.c        |    2 -
 extensions/libipt_policy.c      |    2 -
 extensions/libipt_realm.c       |    2 -
 extensions/libipt_recent.c      |    2 -
 extensions/libipt_ttl.c         |    2 -
 extensions/libxt_CLASSIFY.c     |    2 -
 extensions/libxt_CONNMARK.c     |    2 -
 extensions/libxt_CONNSECMARK.c  |    2 -
 extensions/libxt_DSCP.c         |    2 -
 extensions/libxt_MARK.c         |    4 +-
 extensions/libxt_NFLOG.c        |   17 ++++---
 extensions/libxt_NFQUEUE.c      |    2 -
 extensions/libxt_RATEEST.c      |    2 -
 extensions/libxt_SECMARK.c      |    2 -
 extensions/libxt_TCPMSS.c       |    2 -
 extensions/libxt_TCPOPTSTRIP.c  |    6 +-
 extensions/libxt_TOS.c          |    4 +-
 extensions/libxt_comment.c      |    2 -
 extensions/libxt_connbytes.c    |    2 -
 extensions/libxt_connlimit.c    |    2 -
 extensions/libxt_connmark.c     |    2 -
 extensions/libxt_conntrack.c    |    6 ++
 extensions/libxt_dccp.c         |    2 -
 extensions/libxt_dscp.c         |    2 -
 extensions/libxt_esp.c          |    2 -
 extensions/libxt_hashlimit.c    |    2 -
 extensions/libxt_helper.c       |    5 +-
 extensions/libxt_iprange.c      |    2 -
 extensions/libxt_length.c       |    2 -
 extensions/libxt_limit.c        |    2 -
 extensions/libxt_mac.c          |    2 -
 extensions/libxt_mark.c         |    2 -
 extensions/libxt_multiport.c    |    2 -
 extensions/libxt_owner.c        |    6 +-
 extensions/libxt_physdev.c      |    2 -
 extensions/libxt_pkttype.c      |    2 -
 extensions/libxt_quota.c        |   56 +++++++++++------------
 extensions/libxt_rateest.c      |    4 +-
 extensions/libxt_sctp.c         |    2 -
 extensions/libxt_state.c        |    2 -
 extensions/libxt_statistic.c    |    4 +-
 extensions/libxt_string.c       |    2 -
 extensions/libxt_tcp.c          |    2 -
 extensions/libxt_tcpmss.c       |    2 -
 extensions/libxt_time.c         |    2 -
 extensions/libxt_tos.c          |    2 -
 extensions/libxt_u32.c          |    2 -
 extensions/libxt_udp.c          |    2 -
 extensions/tos_values.c         |    2 -
 include/libiptc/libip6tc.h      |    2 -
 include/libiptc/libiptc.h       |    2 -
 include/xtables.h               |    6 ++
 ip6tables-restore.c             |   96 +++++++++++++++++++++------------------
 ip6tables-save.c                |   30 ++++++------
 ip6tables.c                     |   39 ++++++++--------
 iptables-restore.c              |   83 +++++++++++++++-------------------
 iptables-save.c                 |   22 ++++-----
 iptables-xml.c                  |   24 +++++-----
 iptables.c                      |   26 +++++------
 xtables.c                       |   41 ++++++++++++++++-
 91 files changed, 352 insertions(+), 299 deletions(-)

