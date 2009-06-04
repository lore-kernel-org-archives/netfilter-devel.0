From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/2]
Date: Thu, 04 Jun 2009 13:07:57 +0200
Message-ID: <20090604110307.6702.10147.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44890 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927AbZFDLIG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2009 07:08:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

The first patch here re-works the conntrack event cache to use the
extension infrastructure so there is an event cache per-conntrack.
This is used by the second patch, which aims to improve ctnetlink
reliability.

Please, have a look at the patch descriptions for more details.
If you like them, you can pull them from:

git://1984.lsi.us.es/nf-next-2.6 master

Wait for your comments!

---

Pablo Neira Ayuso (2):
      netfilter: conntrack: optional reliable conntrack event delivery
      netfilter: conntrack: move event cache to conntrack extension infrastructure


 include/net/netfilter/nf_conntrack.h        |    2 
 include/net/netfilter/nf_conntrack_ecache.h |  133 +++++++++--------
 include/net/netfilter/nf_conntrack_extend.h |    2 
 include/net/netfilter/nf_conntrack_helper.h |    2 
 include/net/netns/conntrack.h               |    7 +
 net/netfilter/nf_conntrack_core.c           |  106 ++++++++++---
 net/netfilter/nf_conntrack_ecache.c         |  216 ++++++++++++++++++---------
 net/netfilter/nf_conntrack_helper.c         |   15 ++
 net/netfilter/nf_conntrack_netlink.c        |   94 +++++++-----
 9 files changed, 379 insertions(+), 198 deletions(-)

