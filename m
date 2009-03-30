From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/3] [RFC] conntrack event caching changes
Date: Mon, 30 Mar 2009 15:27:33 +0200
Message-ID: <20090330132330.14337.4705.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41662 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750941AbZC3N1l (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Mar 2009 09:27:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

This is another round of the event caching rework. I'm not including
patch from 1/5 to 3/5 that I previously sent that are required by these
patches but that are not relevant for the RFC I think.

Basically, this rework contains:

a) The replacement for the use of the notify chain by a single function
pointer.
b) The replacement of the per-cpu event cache by a per-conntrack event
cache.
c) The addition of optional reliable conntrack event delivery containing
the recent comments during one of our discussions.

Thanks!

---

Pablo Neira Ayuso (3):
      ctnetlink: optional reliable conntrack event delivery
      conntrack: ecache: move event cache to conntrack extension infrastructure
      netfilter: ecache: replace notify chain by function pointer


 include/net/netfilter/nf_conntrack.h        |    2 
 include/net/netfilter/nf_conntrack_core.h   |    6 -
 include/net/netfilter/nf_conntrack_ecache.h |  163 +++++++++++----
 include/net/netfilter/nf_conntrack_extend.h |    2 
 include/net/netfilter/nf_conntrack_helper.h |    2 
 include/net/netns/conntrack.h               |    7 -
 net/netfilter/nf_conntrack_core.c           |  124 ++++++++----
 net/netfilter/nf_conntrack_ecache.c         |  288 ++++++++++++++++++++-------
 net/netfilter/nf_conntrack_ftp.c            |    4 
 net/netfilter/nf_conntrack_helper.c         |   15 +
 net/netfilter/nf_conntrack_netlink.c        |  103 +++++-----
 net/netfilter/nf_conntrack_proto_sctp.c     |    2 
 net/netfilter/nf_conntrack_proto_tcp.c      |    7 -
 13 files changed, 513 insertions(+), 212 deletions(-)

-- 
3.3.3
