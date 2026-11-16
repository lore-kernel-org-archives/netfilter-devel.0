Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788190;
	b=wwDIwfY/aH1hC+i34e2fDv2DB9R4CT4ADz6++Bx2lkS4rEnD0+DZ/tfHr1VKJwoQMLhi
	 91a5F85xtyRegUg8j9boxWqg9rrPok7sXnhIJKySx1y8Jwm1EdlFd3JqsbRicZ/dzK9M2
	 p4e/bmyY9TjXaW/aUq7EB/3klzLcAW45Bly78uRz0AyZTlHz9I2wm7ARdWJZuf+XI4FdZ
	 kYchnQd37eQJXaQm19Wd/LuZLDvb/7Qm4jRwqXE9Wboyr58/n4076bni/9D8SqDcVnp2g
	 fCPFvsgYwbRA7ZwovJTCtY/oYGDjsTiq66LyCCGgu7KBWtO1rnjDe9woZuiahNX0r3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788190;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=TG/14QAYLr9AECWOTVuoUws/MaH0SzB3BMceRMURL3c=;
	b=zaOBRQUUaSbcCQmtbdeBewKgVmQGE2GukjT5yDPgUeLX9GvLxEEWclHAW1UU4jF/ktP7
	 Wpgar0ydoAph9UBiJeR+bSQmsgVOksKKtJvmkBj1pQcU/wnwOQeuONXRQTX3B0wYd1lSj
	 /qxf+nRNp3iMmHNCY1dZOjkFtaJ7C3z2e8oiGtCgZyldeItuqfiBc3Ii+EW5J77KGTIHR
	 1TKs5FvCcJw5O9c5ZL8m9t+WiZmlwdJuFzq+BmuEocJAnAnQKEQ5Bl28ksVO3oPltlkQe
	 qPqWE7KCTN9gW9nnhm1X0gwoze2rFa0Q4oR9iOJZZuRnrApUsY5TKZFC8kE7bfVyG1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="a8fl18/1";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072DB606A339;
	Mon, 16 Nov 2026 00:16:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 072DB606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=a8fl18/1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794788186;
	bh=TG/14QAYLr9AECWOTVuoUws/MaH0SzB3BMceRMURL3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a8fl18/1id9f/Ao6aFXKB+TjjCWn9buCJt4eq9P7n7Hqg11q/QK0djujI71ouRnzE
	 pN7eBkQgVgSb5qT01Y5MAQebRZBmeIg5Nk0YDAbou5XsDCecUGToCwj0c962ws3j6H
	 2Dl95ny8gCt3+umjWILwBNYkIZDoxQgyouYYE3jYIJh06HDJl3mIc6jlNJxjUcNuYX
	 Xmy0RgAcwr+7+2hV0i+COBmUdnngFCno/5A6hjnm5NFIcQqTGPCguccICMbJQolGzN
	 2QSfqBzNpSIDKbDHh/tb9CG7NHPb3D0cj1tNeYJGD7Lce/dtCC793ehKxJOS2OGZwD
	 6O3TaVp25dU7Q==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E1A7E60058;
	Mon, 16 Nov 2026 01:16:25 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 04/13] net: airoha: update stats on flow deletion
Date: Mon, 16 Nov 2026 01:16:03 +0100
Message-ID: <20261116001612.2806263-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116001612.2806263-1-pablo@netfilter.org>
References: <20261116001612.2806263-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

Update this driver to use the new approach to fetch stats on flow
deletion, introduced by ("netfilter: flowtable: retrieve stats on flow
deletion").

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/ethernet/airoha/airoha_ppe.c | 31 +++++++++++++++---------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
index f5369c45766d..af8c7fe9b7f0 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -1285,6 +1285,23 @@ static int airoha_ppe_flow_offload_replace(struct airoha_eth *eth,
 	return err;
 }
 
+static void airoha_ppe_flow_update_stats(struct airoha_eth *eth,
+					 struct flow_cls_offload *f,
+					 struct airoha_flow_table_entry *e)
+{
+	u32 idle = airoha_ppe_entry_idle_time(eth->ppe, e);
+
+	f->stats.lastused = jiffies - idle * HZ;
+	if (e->hash != 0xffff) {
+		struct airoha_foe_stats64 stats = {};
+
+		airoha_ppe_foe_entry_get_stats(eth->ppe, e->hash, &stats);
+		f->stats.pkts += (stats.packets - e->stats.packets);
+		f->stats.bytes += (stats.bytes - e->stats.bytes);
+		e->stats = stats;
+	}
+}
+
 static int airoha_ppe_flow_offload_destroy(struct airoha_eth *eth,
 					   struct flow_cls_offload *f)
 {
@@ -1295,6 +1312,7 @@ static int airoha_ppe_flow_offload_destroy(struct airoha_eth *eth,
 	if (!e)
 		return -ENOENT;
 
+	airoha_ppe_flow_update_stats(eth, f, e);
 	airoha_ppe_foe_flow_remove_entry(eth->ppe, e);
 	rhashtable_remove_fast(&eth->flow_table, &e->node,
 			       airoha_flow_table_params);
@@ -1342,24 +1360,13 @@ static int airoha_ppe_flow_offload_stats(struct airoha_eth *eth,
 					 struct flow_cls_offload *f)
 {
 	struct airoha_flow_table_entry *e;
-	u32 idle;
 
 	e = rhashtable_lookup(&eth->flow_table, &f->cookie,
 			      airoha_flow_table_params);
 	if (!e)
 		return -ENOENT;
 
-	idle = airoha_ppe_entry_idle_time(eth->ppe, e);
-	f->stats.lastused = jiffies - idle * HZ;
-
-	if (e->hash != 0xffff) {
-		struct airoha_foe_stats64 stats = {};
-
-		airoha_ppe_foe_entry_get_stats(eth->ppe, e->hash, &stats);
-		f->stats.pkts += (stats.packets - e->stats.packets);
-		f->stats.bytes += (stats.bytes - e->stats.bytes);
-		e->stats = stats;
-	}
+	airoha_ppe_flow_update_stats(eth, f, e);
 
 	return 0;
 }
-- 
2.47.3

