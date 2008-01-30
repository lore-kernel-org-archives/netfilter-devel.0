From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 34/69]: nf_conntrack: fix accounting with fixed timeouts
Date: Wed, 30 Jan 2008 21:17:47 +0100 (MET)
Message-ID: <20080130201744.29874.25483.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60730 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765008AbYA3URs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:17:48 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack: fix accounting with fixed timeouts

Don't skip accounting for conntracks with the FIXED_TIMEOUT bit.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 717ef6587331d45fecc0d1fa2a9f473f9d9ae1c9
tree adc3dd8a5ce9f4bd9f2ffa06a4cc2caffb5a13b3
parent 9813002a577062723e68ac1da712de25f7998f1e
author Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:05 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:05 +0100

 net/netfilter/nf_conntrack_core.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7b1f7e8..aa042c4 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -776,10 +776,8 @@ void __nf_ct_refresh_acct(struct nf_conn *ct,
 	write_lock_bh(&nf_conntrack_lock);
 
 	/* Only update if this is not a fixed timeout */
-	if (test_bit(IPS_FIXED_TIMEOUT_BIT, &ct->status)) {
-		write_unlock_bh(&nf_conntrack_lock);
-		return;
-	}
+	if (test_bit(IPS_FIXED_TIMEOUT_BIT, &ct->status))
+		goto acct;
 
 	/* If not in hash table, timer will not be active yet */
 	if (!nf_ct_is_confirmed(ct)) {
@@ -799,6 +797,7 @@ void __nf_ct_refresh_acct(struct nf_conn *ct,
 		}
 	}
 
+acct:
 #ifdef CONFIG_NF_CT_ACCT
 	if (do_acct) {
 		ct->counters[CTINFO2DIR(ctinfo)].packets++;
