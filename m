Received: from sender-op-o17.zoho.eu (sender-op-o17.zoho.eu [136.143.169.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6216A3F410A;
	Mon, 15 Jun 2026 13:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781530775; cv=pass; b=HK5nLBVA08CTYhhun35b512x+4l6G/WNqd8FO9sLxoN7pOkL5F7mvF1jXUsHz6jhwgSJqSw0s+Ey4eSN7WQ3aTQ+0LYyIyes0OW1vTxdmBJEk9WfCP7vLTzAPi7dziHzGhJ3lBVxX/mTHAH+hQAeZgaUMfZ8Q98MO8lI/CJ6zuw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781530775; c=relaxed/simple;
	bh=TaNWalm3ueLUHjtjzR2p09USmeki+oTeGC1XV1PxysQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aHbbkCSWkxzJ0AjfL0LrzMRwRU9q2kSW8adz4Ih5pSD7LUSkzSEpO9Pk8rkmw+u6uS6J/lzbEhLm4EHAJ1trEi7LG9nCvRFfj/d342nZ9O5Nhc7KWe3+TX0f6Y62WRzRv43Xc10059CiPgrUgFmc1bs6asO29dcTtl9L152gt20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me; spf=pass smtp.mailfrom=carlosgrillet.me; dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b=FLCIghRb; arc=pass smtp.client-ip=136.143.169.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b="FLCIghRb"
ARC-Seal: i=1; a=rsa-sha256; t=1781530748; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=g2WxHH+PvmX1qOXBVv+c+J9ixZp9Shupn7PuXbXRaAms4wTqGJlI5KU062IQEzM8lfOHiOAnKDIHQFlcoBKI7XTHy+v9BT11YoiumyHbuRaYcZsM2rD2DLiEbmIuUMC9Msfph/aGS0tMIzbWLLmC4u+QE9VbEU0agF8ZSyQKVTg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1781530748; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=2amGp+Uqp40v4+D/UhRTPE8frH0rHY1aE5A+EOt0im4=; 
	b=JX0+fdGRGyeYWKGl7n8+Rsq/kgTPV3peagMd+4EB8L+PTi9qc63mMbr4dY5/8CyCcFndhbZnQGByjF/Zoc8ONUbPh95PDMWUj3q5DDJBuD7LgsfCgyGf9htxlVBHHp5OSXInBe+rBEZISEQbyKudCPGf9zK8+WUkClfE6RqjumI=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=carlosgrillet.me;
	spf=pass  smtp.mailfrom=carlos@carlosgrillet.me;
	dmarc=pass header.from=<carlos@carlosgrillet.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781530748;
	s=zmail; d=carlosgrillet.me; i=carlos@carlosgrillet.me;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=2amGp+Uqp40v4+D/UhRTPE8frH0rHY1aE5A+EOt0im4=;
	b=FLCIghRbS03c0c7DppJ+hib25Em9xFOJT2E0QyKNRDEHHh9jx3ctvoVmHTzXd1Zy
	r6SmvsuMMrnoQaa2RRwEeMRlebbZhhQiBY6TfbB/TbTLUfafD/P6tcWZxPmmS5SV3ce
	KToIaKepw6UP/MhL/11bVUD7XiV8YyN6BPW/QPwg=
Received: by mx.zoho.eu with SMTPS id 1781530747356459.3177563679918;
	Mon, 15 Jun 2026 15:39:07 +0200 (CEST)
From: Carlos Grillet <carlos@carlosgrillet.me>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH nf-next v2 4/6] netfilter: xt_DSCP: replace u_int8_t with u8
Date: Mon, 15 Jun 2026 15:38:29 +0200
Message-ID: <20260615133835.51273-5-carlos@carlosgrillet.me>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260615133835.51273-1-carlos@carlosgrillet.me>
References: <20260615133835.51273-1-carlos@carlosgrillet.me>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Replace POSIX u_int8_t with preferred kernel type u8

No functional changes.

Signed-off-by: Carlos Grillet <carlos@carlosgrillet.me>
---
 net/netfilter/xt_DSCP.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index cfa44515ab72..76231e1dc5b5 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -30,7 +30,7 @@ static unsigned int
 dscp_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_DSCP_info *dinfo = par->targinfo;
-	u_int8_t dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
+	u8 dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
 
 	if (dscp != dinfo->dscp) {
 		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
@@ -47,7 +47,7 @@ static unsigned int
 dscp_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_DSCP_info *dinfo = par->targinfo;
-	u_int8_t dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
+	u8 dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
 
 	if (dscp != dinfo->dscp) {
 		if (skb_ensure_writable(skb, sizeof(struct ipv6hdr)))
@@ -73,7 +73,7 @@ tos_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_tos_target_info *info = par->targinfo;
 	struct iphdr *iph = ip_hdr(skb);
-	u_int8_t orig, nv;
+	u8 orig, nv;
 
 	orig = ipv4_get_dsfield(iph);
 	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
@@ -93,7 +93,7 @@ tos_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_tos_target_info *info = par->targinfo;
 	struct ipv6hdr *iph = ipv6_hdr(skb);
-	u_int8_t orig, nv;
+	u8 orig, nv;
 
 	orig = ipv6_get_dsfield(iph);
 	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
-- 
2.54.0

