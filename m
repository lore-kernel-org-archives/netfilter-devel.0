From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/03]: nf_nat: fix memset error
Date: Tue, 13 Nov 2007 11:55:41 +0100 (MET)
Message-ID: <20071113105501.25336.58654.sendpatchset@localhost.localdomain>
References: <20071113105500.25336.39074.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41892 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414AbXKMKzn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2007 05:55:43 -0500
In-Reply-To: <20071113105500.25336.39074.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nf_nat: fix memset error

The size passing to memset is the size of a pointer.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit dd9e04a6e68abf79470ef26e242ce516bba37b3d
tree 0d6b56e83d643661a9726931a577d6626a2cfb3f
parent 325d22df7b19e0116aff3391d3a03f73d0634ded
author Li Zefan <lizf@cn.fujitsu.com> Tue, 13 Nov 2007 11:24:16 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 13 Nov 2007 11:24:16 +0100

 net/ipv4/netfilter/nf_nat_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 56e93f6..70e7997 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -681,7 +681,7 @@ static int clean_nat(struct nf_conn *i, void *data)
 
 	if (!nat)
 		return 0;
-	memset(nat, 0, sizeof(nat));
+	memset(nat, 0, sizeof(*nat));
 	i->status &= ~(IPS_NAT_MASK | IPS_NAT_DONE_MASK | IPS_SEQ_ADJUST);
 	return 0;
 }
