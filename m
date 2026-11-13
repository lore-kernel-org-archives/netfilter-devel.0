Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794539584;
	b=ZyImWPas1J2JZQxqjCxJvOvFXOG3kBC4xoqbigT2pfmtsSQodPI/E1KRE5bTTvfy+Lzj
	 3dhyVW9Ze91EbygVR2V/rWmmdWBj08Tc5Z4QRWCsI1oYxDoecqXSMEj/tIZO3wyD3o4bJ
	 LWKaaPrI1fo7huORw432mQV5Ipv8A9eSKgKx8Mw1jC95aod4dxZ9uElFkRPJoPGvGRWgn
	 5mh1/wE+PNPkShN5Obcty7EBYUlZD9WE8o05c6jnrP02HBzsEcnjw5Svc04zNqj8ztu8N
	 T48bOcJIYDI7p7zs/Ak18c1kOKjTYklXB0FggPFnHiInnEOv8uTnostnWnjRcrhfmbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794539584;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=TG/14QAYLr9AECWOTVuoUws/MaH0SzB3BMceRMURL3c=;
	b=eXdLD2kaHJK6VbKnvc2Axtlp8jXRHWtR/fBKBp39v3iqSKM+oQNPtgzEXUdHWiS71V0K
	 qC5Qqhvs1p6l6psxMvnWxyoItM921guOcFwP+QOzH6D1AIWWMjqmW0ltRD83yuyV1u5xk
	 wCWKAJ6z7i25L7oVS6WQpraYzoEk+dCGMg7jyOtCYozITwQCrEyI6y1fgBYyRbj2J+7O2
	 rBKywcCptF1c9X8qXj5/lCYI/cfNDb90oCYhNF4KqU8AXoBIHT0jYt6xVwgd0cbrq9kgp
	 DsWVYRsMTysSuzrYh530abgil58XaE4kFa8eS+EnOnViQFAODgBnB9SVqAAphsLBlQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=KSojmTeq;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79080606A8A3;
	Fri, 13 Nov 2026 03:13:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79080606A8A3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=KSojmTeq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794539583;
	bh=TG/14QAYLr9AECWOTVuoUws/MaH0SzB3BMceRMURL3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KSojmTeqyq94OI5qlXVlXx6ezkptqBNBcEuQl6ATwaZXCjCp1lKDbJCr4HuLse7+O
	 tHQfmx241+UmUrRsLNqp2O5KUoKGG8yh6FGuZ+64KUR6hBsEK6EEifNvj/aqbQRlzo
	 h/JaqojG/Rwys29926jVNuKUocPnDI9YBi2DqSEXVV1sR9W0EJTov4swAxAIhLr0vJ
	 Y9YJ1QpfUafMeR1Gjc+JnWPbGiRtT4ocLfeiH8GzgpUUWo6X+d2nr64ei/BtTflZKH
	 f1/7Vp95efPbcQAaBTQm+slyFDZq6cua7VfWGdLskSf85/jaRjx8KsP+BMixKGGbsP
	 gg0iqnVvHIx/A==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7708B602A6;
	Fri, 13 Nov 2026 04:13:02 +0100 (CET)
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
Subject: [PATCH net-next 05/15] net: airoha: update stats on flow deletion
Date: Fri, 13 Nov 2026 04:12:41 +0100
Message-ID: <20261113031251.2437074-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113031251.2437074-1-pablo@netfilter.org>
References: <20261113031251.2437074-1-pablo@netfilter.org>
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

