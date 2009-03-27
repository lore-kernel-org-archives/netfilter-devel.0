From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/5] improve ctnetlink event reliability
Date: Fri, 27 Mar 2009 10:38:42 +0100
Message-ID: <20090327093822.8259.50902.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47468 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754429AbZC0Jiy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Mar 2009 05:38:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

This is more like a RFC patch.

The following series are targeted to improve ctnetlink reliability.
I think that the first three patches can be applied safely as they
are merely cleanups. The last two patches may be more controversial,
specifically 4/5 reworks the event caching infrastructure to go over
the conntrack extension infrastructure, thus, leading to more memory
consumption per conntrack. I needed this to add optional reliable
event delivery more cleanly.

Wait for you feedback.

---

Pablo Neira Ayuso (5):
      ctnetlink: optional reliable event delivery
      conntrack: ecache: move event cache to conntrack extension infrastructure
      netfilter: conntrack: don't report events on module removal
      netfilter: conntrack: use nf_ct_kill() to destroy conntracks
      netfilter: conntrack: remove events flags from userspace exposed file


 include/linux/netfilter/nf_conntrack_common.h |   69 --------
 include/net/netfilter/nf_conntrack.h          |    2 
 include/net/netfilter/nf_conntrack_core.h     |    6 -
 include/net/netfilter/nf_conntrack_ecache.h   |  169 ++++++++++++++++----
 include/net/netfilter/nf_conntrack_extend.h   |    2 
 include/net/netns/conntrack.h                 |    6 -
 net/netfilter/nf_conntrack_core.c             |   91 ++++++-----
 net/netfilter/nf_conntrack_ecache.c           |  214 +++++++++++++++++--------
 net/netfilter/nf_conntrack_expect.c           |   12 +
 net/netfilter/nf_conntrack_ftp.c              |    4 
 net/netfilter/nf_conntrack_netlink.c          |   83 ++++++----
 net/netfilter/nf_conntrack_pptp.c             |   26 ++-
 net/netfilter/nf_conntrack_proto_dccp.c       |    5 -
 net/netfilter/nf_conntrack_proto_sctp.c       |    2 
 net/netfilter/nf_conntrack_proto_tcp.c        |   12 +
 15 files changed, 435 insertions(+), 268 deletions(-)

-- 
Signature
