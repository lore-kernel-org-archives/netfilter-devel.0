Received: from mail.sgstbr.de (mail.sgstbr.de [94.130.16.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11002857C7;
	Thu, 28 Aug 2025 09:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.130.16.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756372504; cv=none; b=cwCFpnACg0R5LQyx478O9uQDNU9rS6un2y9ACaFdLNF0JbAOuvZ7Ksdz7yj4eAloJaPho7ubFrtl+2I2N6xiJmdUGMbsMG1uB2uEZiqmodiYbYBP2vK2Y+YLg33sZ58oFz5EABOc5omTkK8gnKcfd5ix/yFrXVKWje4zN7xhQ7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756372504; c=relaxed/simple;
	bh=HfDp8pemVhL2e98OM41X5YIIAlADWE9c/iuT1s3U+7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pM0PyzigE5SPwkmVKBmkLfWC0KfSBNIW7k9EPWmeC62wG/oFDDsFVJr6S+hS+abCIwxMnkwTvSRpMnK+EVhJvEUXwVC0ijroePOeUStvJRo10S5fxThxuN0AO3GY+8ZHzA9lbXy38xSJS9soe45Je3iMjYvjbO/X9gq3a0CVQEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=blaese.de; spf=pass smtp.mailfrom=blaese.de; dkim=pass (2048-bit key) header.d=blaese.de header.i=@blaese.de header.b=NM/4unBo; arc=none smtp.client-ip=94.130.16.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=blaese.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blaese.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=blaese.de header.i=@blaese.de header.b="NM/4unBo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=blaese.de; s=201803;
	t=1756372494; bh=QdtsQcVAzSiyr0oE0PVsZcrhGnq8QS7YuFJSnptOUAY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=NM/4unBoW/HFmZY0eWNw+4l7S/0x2OdG0lvr5E+RN+6JIWSdOQtneBPZYoKuTVRUu
	 1bg0Wjv0bz+nE5tVWvP3LWK3Wq89Odlu1AW/OHVS2UxIySY3/PM+/3bnqsSAHwQocB
	 K/n6aMg4Gr9agNOgHdt4L8NfvrUM3jLevXy4z7IVqwqC6lVreZrkX4ICthBG1QnifL
	 rtsXscywUoXyplV2tRTIO2/GhL5QBNfTkxKzgUyTnKpPWXUImRMtVns26sxrkza8rf
	 K2fSvwCLAgwiYDBgO4CxhbggBohMGApfUBdSuG4QVhXSqwZt8zh6flL4GQbGB5hV1Q
	 NMGaSj4P8Z8Og==
Received: from fbl-xps (unknown [IPv6:2a00:20:c00c:f708:c5a:4e33:bb77:1735])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: fabian@blaese.de)
	by mail.sgstbr.de (Postfix) with ESMTPSA id 7081C24B485;
	Thu, 28 Aug 2025 11:14:54 +0200 (CEST)
From: =?UTF-8?q?Fabian=20Bl=C3=A4se?= <fabian@blaese.de>
To: netdev@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Fabian=20Bl=C3=A4se?= <fabian@blaese.de>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH v3] icmp: fix icmp_ndo_send address translation for reply direction
Date: Thu, 28 Aug 2025 11:14:35 +0200
Message-ID: <20250828091435.161962-1-fabian@blaese.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250825203826.3231093-1-fabian@blaese.de>
References: <20250825203826.3231093-1-fabian@blaese.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The icmp_ndo_send function was originally introduced to ensure proper
rate limiting when icmp_send is called by a network device driver,
where the packet's source address may have already been transformed
by SNAT.

However, the original implementation only considers the
IP_CT_DIR_ORIGINAL direction for SNAT and always replaced the packet's
source address with that of the original-direction tuple. This causes
two problems:

1. For SNAT:
   Reply-direction packets were incorrectly translated using the source
   address of the CT original direction, even though no translation is
   required.

2. For DNAT:
   Reply-direction packets were not handled at all. In DNAT, the original
   direction's destination is translated. Therefore, in the reply
   direction the source address must be set to the reply-direction
   source, so rate limiting works as intended.

Fix this by using the connection direction to select the correct tuple
for source address translation, and adjust the pre-checks to handle
reply-direction packets in case of DNAT.

Additionally, wrap the `ct->status` access in READ_ONCE(). This avoids
possible KCSAN reports about concurrent updates to `ct->status`.

Fixes: 0b41713b6066 ("icmp: introduce helper for nat'd source address in network device context")

Signed-off-by: Fabian Bläse <fabian@blaese.de>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Florian Westphal <fw@strlen.de>
---
Changes v1->v2:
- Implement fix for ICMPv6 as well

Changes v2->v3:
- Collapse conditional tuple selection into a single direction lookup [Florian]
- Always apply source address translation if IPS_NAT_MASK is set [Florian]
- Wrap ct->status in READ_ONCE()
- Add a clearer explanation of the behaviour change for DNAT
---
 net/ipv4/icmp.c     | 6 ++++--
 net/ipv6/ip6_icmp.c | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 2ffe73ea644f..c48c572f024d 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -799,11 +799,12 @@ void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info)
 	struct sk_buff *cloned_skb = NULL;
 	struct ip_options opts = { 0 };
 	enum ip_conntrack_info ctinfo;
+	enum ip_conntrack_dir dir;
 	struct nf_conn *ct;
 	__be32 orig_ip;
 
 	ct = nf_ct_get(skb_in, &ctinfo);
-	if (!ct || !(ct->status & IPS_SRC_NAT)) {
+	if (!ct || !(READ_ONCE(ct->status) & IPS_NAT_MASK)) {
 		__icmp_send(skb_in, type, code, info, &opts);
 		return;
 	}
@@ -818,7 +819,8 @@ void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info)
 		goto out;
 
 	orig_ip = ip_hdr(skb_in)->saddr;
-	ip_hdr(skb_in)->saddr = ct->tuplehash[0].tuple.src.u3.ip;
+	dir = CTINFO2DIR(ctinfo);
+	ip_hdr(skb_in)->saddr = ct->tuplehash[dir].tuple.src.u3.ip;
 	__icmp_send(skb_in, type, code, info, &opts);
 	ip_hdr(skb_in)->saddr = orig_ip;
 out:
diff --git a/net/ipv6/ip6_icmp.c b/net/ipv6/ip6_icmp.c
index 9e3574880cb0..233914b63bdb 100644
--- a/net/ipv6/ip6_icmp.c
+++ b/net/ipv6/ip6_icmp.c
@@ -54,11 +54,12 @@ void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
 	struct inet6_skb_parm parm = { 0 };
 	struct sk_buff *cloned_skb = NULL;
 	enum ip_conntrack_info ctinfo;
+	enum ip_conntrack_dir dir;
 	struct in6_addr orig_ip;
 	struct nf_conn *ct;
 
 	ct = nf_ct_get(skb_in, &ctinfo);
-	if (!ct || !(ct->status & IPS_SRC_NAT)) {
+	if (!ct || !(READ_ONCE(ct->status) & IPS_NAT_MASK)) {
 		__icmpv6_send(skb_in, type, code, info, &parm);
 		return;
 	}
@@ -73,7 +74,8 @@ void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
 		goto out;
 
 	orig_ip = ipv6_hdr(skb_in)->saddr;
-	ipv6_hdr(skb_in)->saddr = ct->tuplehash[0].tuple.src.u3.in6;
+	dir = CTINFO2DIR(ctinfo);
+	ipv6_hdr(skb_in)->saddr = ct->tuplehash[dir].tuple.src.u3.in6;
 	__icmpv6_send(skb_in, type, code, info, &parm);
 	ipv6_hdr(skb_in)->saddr = orig_ip;
 out:
-- 
2.51.0

