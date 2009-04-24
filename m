From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/3] netfilter fixes for 2.6.30-rc
Date: Fri, 24 Apr 2009 12:29:48 +0200
Message-ID: <20090424102534.30250.37215.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40359 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbZDXK34 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Apr 2009 06:29:56 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

This patchset contains three fixes for 2.6.30-rc. Two for DCCP
conntrack support: one adding the role attribute which is required
to create consistent conntrack entries and another to fix a missing
initialization in Holger's ctnetlink message shrinking. There's
another patch for the new cluster match, I noticed a problem while
testing the user-space part in iptables (not in the git tree yet).

Please, apply!

---

Pablo Neira Ayuso (3):
      netfilter: conntrack: fix EINVAL during DCCP loading
      netfilter: iptables: fix use of cluster match with 32 nodes
      netfilter: conntrack: add missing role attributes for DCCP


 include/linux/netfilter/nfnetlink_conntrack.h |    1 +
 include/linux/netfilter/xt_cluster.h          |    2 ++
 net/netfilter/nf_conntrack_proto_dccp.c       |   16 +++++++++++++++-
 net/netfilter/xt_cluster.c                    |    8 +++++++-
 4 files changed, 25 insertions(+), 2 deletions(-)

-- 
Signature
