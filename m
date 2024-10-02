Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C05C42AA2
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Oct 2024 16:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727884940; cv=none; b=cYwhesqlK6n1wFv2BBPpWEXyijcpQrUkT/lH2UsXv1OlH/Et2FF+z1Mo+FrXTwRYC96tKUcD00TgB4TE8lYcGCUI902C2PTrfiaqX1PZrgoRQINI63PIgi/6fnIZH9cKpUr9n+Z7jQR6EdQjTgHgpqsgGPaTMkYmajIxL623row=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727884940; c=relaxed/simple;
	bh=ZPx2k4Ubre05X3QHO5LoF6QXz5nvcpMkJvVpLTNiSjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=onhswl6Ohx/j3VjHvD7PD+ZWjQoqWpk+xjon+swtMfXLeoFdZuUmXK6xWQyCtKM4apeka5OD7Pc5eUovZdJ1d16OGeIBk+hQRZuhq0if+u/dzK0IcxeqooFdjKw3YpLN3vftRXZtl0Q+PZGswKrEZ+Ykh4HFb41Wb99mbRXTgYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sw1ns-0003Yn-Mg; Wed, 02 Oct 2024 18:02:16 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/4] netfilter: xt_nat: compact nf_nat_setup_info calls
Date: Wed,  2 Oct 2024 17:55:39 +0200
Message-ID: <20241002155550.15016-2-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241002155550.15016-1-fw@strlen.de>
References: <20241002155550.15016-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Collapse some common code, this will allow to use
kfree_skb_drop_reason in the next patch.

No semantic change intended.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_nat.c | 73 ++++++++++++++++--------------------------
 1 file changed, 28 insertions(+), 45 deletions(-)

diff --git a/net/netfilter/xt_nat.c b/net/netfilter/xt_nat.c
index b4f7bbc3f3ca..d04f7cf6b94d 100644
--- a/net/netfilter/xt_nat.c
+++ b/net/netfilter/xt_nat.c
@@ -13,6 +13,26 @@
 #include <linux/netfilter/x_tables.h>
 #include <net/netfilter/nf_nat.h>
 
+static unsigned int
+xt_nat_setup_info(struct sk_buff *skb,
+		  const struct nf_nat_range2 *range,
+		  enum nf_nat_manip_type maniptype)
+{
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (WARN_ON(!ct))
+		return NF_ACCEPT;
+
+	if (WARN_ON(!(ctinfo == IP_CT_NEW ||
+		      ctinfo == IP_CT_RELATED ||
+	    (ctinfo == IP_CT_RELATED_REPLY && maniptype == NF_NAT_MANIP_SRC))))
+		return NF_ACCEPT;
+
+	return nf_nat_setup_info(ct, range, maniptype);
+}
+
 static int xt_nat_checkentry_v0(const struct xt_tgchk_param *par)
 {
 	const struct nf_nat_ipv4_multi_range_compat *mr = par->targinfo;
@@ -53,16 +73,10 @@ xt_snat_target_v0(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct nf_nat_ipv4_multi_range_compat *mr = par->targinfo;
 	struct nf_nat_range2 range;
-	enum ip_conntrack_info ctinfo;
-	struct nf_conn *ct;
-
-	ct = nf_ct_get(skb, &ctinfo);
-	WARN_ON(!(ct != NULL &&
-		 (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
-		  ctinfo == IP_CT_RELATED_REPLY)));
 
 	xt_nat_convert_range(&range, &mr->range[0]);
-	return nf_nat_setup_info(ct, &range, NF_NAT_MANIP_SRC);
+
+	return xt_nat_setup_info(skb, &range, NF_NAT_MANIP_SRC);
 }
 
 static unsigned int
@@ -70,15 +84,10 @@ xt_dnat_target_v0(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct nf_nat_ipv4_multi_range_compat *mr = par->targinfo;
 	struct nf_nat_range2 range;
-	enum ip_conntrack_info ctinfo;
-	struct nf_conn *ct;
-
-	ct = nf_ct_get(skb, &ctinfo);
-	WARN_ON(!(ct != NULL &&
-		 (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED)));
 
 	xt_nat_convert_range(&range, &mr->range[0]);
-	return nf_nat_setup_info(ct, &range, NF_NAT_MANIP_DST);
+
+	return xt_nat_setup_info(skb, &range, NF_NAT_MANIP_DST);
 }
 
 static unsigned int
@@ -86,18 +95,11 @@ xt_snat_target_v1(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct nf_nat_range *range_v1 = par->targinfo;
 	struct nf_nat_range2 range;
-	enum ip_conntrack_info ctinfo;
-	struct nf_conn *ct;
-
-	ct = nf_ct_get(skb, &ctinfo);
-	WARN_ON(!(ct != NULL &&
-		 (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
-		  ctinfo == IP_CT_RELATED_REPLY)));
 
 	memcpy(&range, range_v1, sizeof(*range_v1));
 	memset(&range.base_proto, 0, sizeof(range.base_proto));
 
-	return nf_nat_setup_info(ct, &range, NF_NAT_MANIP_SRC);
+	return xt_nat_setup_info(skb, &range, NF_NAT_MANIP_SRC);
 }
 
 static unsigned int
@@ -105,46 +107,27 @@ xt_dnat_target_v1(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct nf_nat_range *range_v1 = par->targinfo;
 	struct nf_nat_range2 range;
-	enum ip_conntrack_info ctinfo;
-	struct nf_conn *ct;
-
-	ct = nf_ct_get(skb, &ctinfo);
-	WARN_ON(!(ct != NULL &&
-		 (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED)));
 
 	memcpy(&range, range_v1, sizeof(*range_v1));
 	memset(&range.base_proto, 0, sizeof(range.base_proto));
 
-	return nf_nat_setup_info(ct, &range, NF_NAT_MANIP_DST);
+	return xt_nat_setup_info(skb, &range, NF_NAT_MANIP_DST);
 }
 
 static unsigned int
 xt_snat_target_v2(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct nf_nat_range2 *range = par->targinfo;
-	enum ip_conntrack_info ctinfo;
-	struct nf_conn *ct;
-
-	ct = nf_ct_get(skb, &ctinfo);
-	WARN_ON(!(ct != NULL &&
-		 (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
-		  ctinfo == IP_CT_RELATED_REPLY)));
 
-	return nf_nat_setup_info(ct, range, NF_NAT_MANIP_SRC);
+	return xt_nat_setup_info(skb, range, NF_NAT_MANIP_SRC);
 }
 
 static unsigned int
 xt_dnat_target_v2(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct nf_nat_range2 *range = par->targinfo;
-	enum ip_conntrack_info ctinfo;
-	struct nf_conn *ct;
-
-	ct = nf_ct_get(skb, &ctinfo);
-	WARN_ON(!(ct != NULL &&
-		 (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED)));
 
-	return nf_nat_setup_info(ct, range, NF_NAT_MANIP_DST);
+	return xt_nat_setup_info(skb, range, NF_NAT_MANIP_DST);
 }
 
 static struct xt_target xt_nat_target_reg[] __read_mostly = {
-- 
2.45.2

