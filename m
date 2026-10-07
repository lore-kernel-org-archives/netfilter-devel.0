Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D913384243
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Oct 2026 21:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791409251; cv=none; b=Vl5huS2qWzdd05KtZeDFwz1wWXKgjBX8bKlmCB2rpoXzqK+DgcBJVLdlCOS/zRKrYull001dxVDRel/QNplBSdXhxMELtKlkWeoPgw96iBQ5J/y7pU+Eiy3zGQfK2POzn1uo6rN1/Zs8myL7se3D8T/xbbUKu3E50G9ad0fNrEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791409251; c=relaxed/simple;
	bh=GNFSuucVo72/OFP+7D6Rys9GwOCMKkJMDoEvFaJZnKA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nPqXpCtxmDUuFWxTnXtZGLGLcFLo2j+7yxCCKA4VscsqQP4gBShQ90HE+DqVg2SXp8NjHFubtOVD84Ex2uaaPCLnOL0vJl6YwYxV3ZG66G/b+J7+zMk8MlA3vserptUO4miQWu/TkrlDULLPyiPCQ3Buv5KV1bMmoz06zgbsl9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qmTfx2R/; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qmTfx2R/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791409246;
	bh=6llAfob9o6o8lAf3UTEB5vtJtIsJxuiiLF4C2z8eOLQ=;
	h=From:To:Cc:Subject:Date:From;
	b=qmTfx2R/eqcWYQMiKEIpvaygRRDIij2Gv4q1+GvEU0wUj2TQYFWEWmqPWVKrySVAo
	 1OgsRFAKA62CvFqKrFK55imCCI/6EGW1Qijwztr9i7BjsauPy16Nh9eihGRR7e4G2m
	 U3Ri6MZVmHq0i+bNMR61pMiIWHGzr1ub3gW3Yg7maOte+DGPNHCiIKHNycaKqIQK2f
	 sdbGB5sX+tXyszyhpmFCZ3jUsau+ku1yTXQaLJiS+UnNcVBJpaQzWQkmV2rUJewwQI
	 uM6vnGOIxymYT9Pz5PFRfLmYoN/NJQIQQsjnC87k7b/rFjMrcv7kfJiFbMN8L65dUO
	 Gj3eshdk6uZYA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B87B060082;
	Wed,  7 Oct 2026 23:40:46 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: david.lee@trailofbits.com
Subject: [PATCH nf,v3] netfilter: nf_reject: initialize IPCB at inet ingress
Date: Wed,  7 Oct 2026 23:40:41 +0200
Message-ID: <20261007214041.1133893-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kyle Zeng <kylebot@openai.com>

The inet ingress hook runs before ip_rcv_core() and ip6_rcv_core(), so
neither IPCB nor IP6CB has been initialized when nft_reject_inet passes
a packet to nf_send_unreach() or nf_send_unreach6(). skb->cb can
therefore retain metadata from an earlier protocol layer.

For IPv4, icmp_send() treats IPCB(skb)->opt as parsed IPv4 options.
Stale option offsets can make __ip_options_echo() copy an
attacker-controlled length into its 40-byte reply option buffer and
overflow the stack. On an unpatched v7.2-rc5 kernel, the IPv4
reproducer produced:

  BUG: KASAN: stack-out-of-bounds in __ip_options_echo()
  Write of size 255

For IPv6, icmpv6_send() consumes IP6CB(skb) as parsed IPv6 metadata. It
always uses iif for source selection and, when MIP6 is enabled, uses
dsthao as an extension-header offset. These fields must not be stale.

For NF_INET_INGRESS, clear the address-family-specific control block and
restore its input interface before constructing the ICMP error.  This
matches similar initialization normally performed by ip_rcv_core() and
ip6_rcv_core().

Fixes: 117ca1f8920c ("netfilter: nft_reject_inet: allow to use reject from inet ingress")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol Codex:gpt-5.5-cyber
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Co-developed-by: David Lee <david.lee@trailofbits.com>
Signed-off-by: David Lee <david.lee@trailofbits.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: - rebase and follow myself, given no news on this for a while.
    - use skb_iif in IPv6 for simplicity to address this KASAN splat.

 net/ipv4/netfilter/nf_reject_ipv4.c | 5 +++++
 net/ipv6/netfilter/nf_reject_ipv6.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 59ec465a9df9..7cb33af671e2 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -357,6 +357,11 @@ void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
 	if (!skb_valid_dst(skb_in) && nf_reject_fill_skb_dst(skb_in) < 0)
 		return;
 
+	if (hook == NF_INET_INGRESS) {
+		memset(IPCB(skb_in), 0, sizeof(*IPCB(skb_in)));
+		IPCB(skb_in)->iif = skb_in->skb_iif;
+	}
+
 	if (skb_csum_unnecessary(skb_in) ||
 	    !nf_reject_verify_csum(skb_in, dataoff, proto)) {
 		icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0);
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 07cdaa10da0d..5e08d8529cc8 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -444,6 +444,11 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
 	if (hooknum == NF_INET_LOCAL_OUT && skb_in->dev == NULL)
 		skb_in->dev = net->loopback_dev;
 
+	if (hooknum == NF_INET_INGRESS) {
+		memset(IP6CB(skb_in), 0, sizeof(*IP6CB(skb_in)));
+		IP6CB(skb_in)->iif = skb_in->skb_iif;
+	}
+
 	if (!skb_valid_dst(skb_in) && nf_reject6_fill_skb_dst(skb_in) < 0)
 		return;
 
-- 
2.47.3

