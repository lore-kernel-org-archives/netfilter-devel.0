From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/2] netfilter fixes for 2.6.30-rc
Date: Tue, 05 May 2009 15:13:40 +0200
Message-ID: <20090505131219.7241.85258.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39517 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbZEENNt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 May 2009 09:13:49 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

These are a couple of fixes for 2.6.30-rc, the patch for the
`cluster' is a resend (maybe you already have it in the tree).
The other applies to ctnetlink, to fix a bug in the user-space
reporting when a conntrack entry is updated.

---

Pablo Neira Ayuso (2):
      netfilter: ctnetlink: fix wrong message type in user updates
      netfilter: iptables: fix use of cluster match with 32 nodes


 include/linux/netfilter/xt_cluster.h |    2 +
 net/netfilter/nf_conntrack_netlink.c |   48 ++++++++++++++--------------------
 net/netfilter/xt_cluster.c           |    8 +++++-
 3 files changed, 29 insertions(+), 29 deletions(-)

