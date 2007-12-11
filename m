From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/02]: ctnetlink: set expected bit for related conntracks
Date: Tue, 11 Dec 2007 18:42:09 +0100 (MET)
Message-ID: <20071211174206.1042.7817.sendpatchset@localhost.localdomain>
References: <20071211174205.1042.29518.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53974 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbXLKRmL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Dec 2007 12:42:11 -0500
In-Reply-To: <20071211174205.1042.29518.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ctnetlink: set expected bit for related conntracks

This patch is a fix. It sets IPS_EXPECTED for related conntracks.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4e5080caf7901c74983fcd47af4b2789bcf9fb1c
tree b240fe271290ba1a6912abc317238385187d548f
parent 82d29bf6dc7317aeb0a3a13c2348ca8591965875
author Pablo Neira Ayuso <pablo@netfilter.org> Tue, 11 Dec 2007 18:24:41 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 11 Dec 2007 18:24:41 +0100

 net/netfilter/nf_conntrack_netlink.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 9be1826..7d23124 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1024,8 +1024,10 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 	}
 
 	/* setup master conntrack: this is a confirmed expectation */
-	if (master_ct)
+	if (master_ct) {
+		__set_bit(IPS_EXPECTED_BIT, &ct->status);
 		ct->master = master_ct;
+	}
 
 	add_timer(&ct->timeout);
 	nf_conntrack_hash_insert(ct);
