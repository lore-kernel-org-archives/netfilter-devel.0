From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/03]: bridge: fix double POSTROUTING hook invocation
Date: Tue, 13 Nov 2007 11:55:44 +0100 (MET)
Message-ID: <20071113105504.25336.42744.sendpatchset@localhost.localdomain>
References: <20071113105500.25336.39074.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41892 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbXKMKzp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2007 05:55:45 -0500
In-Reply-To: <20071113105500.25336.39074.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: bridge: fix double POSTROUTING hook invocation

Packets routed between bridges have the POST_ROUTING hook invoked
twice since bridging mistakes them for bridged packets because
they have skb->nf_bridge set.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 87a1cd0a4fc1f5ac17e2e752668ae324c595b1fd
tree 38c7fdb13f7232bf77fb78ce4292a4bb1cdd5dfd
parent c94ac2cb9896fbed3065dc08216a7d13b98f0d92
author Patrick McHardy <kaber@trash.net> Tue, 13 Nov 2007 11:24:18 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 13 Nov 2007 11:24:18 +0100

 net/bridge/br_netfilter.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index da22f90..c1757c7 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -766,6 +766,9 @@ static unsigned int br_nf_post_routing(unsigned int hook, struct sk_buff *skb,
 	if (!nf_bridge)
 		return NF_ACCEPT;
 
+	if (!(nf_bridge->mask & (BRNF_BRIDGED | BRNF_BRIDGED_DNAT)))
+		return NF_ACCEPT;
+
 	if (!realoutdev)
 		return NF_DROP;
 
