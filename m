Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6A151DE05;
	Fri, 18 Sep 2026 18:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789755862; cv=none; b=qFD46d/d15Z0y+Y5VNqOJaDsZqU6AhOMHwrWyJqqtBukWI4SH/HbTmR3K4VNsXaos/c0DD2uHnz37mcdS4t0Cib7F9nXpimpDcuQumB2lmeddqgDH0mYSz26kdc2UQenfawG1FG68/slkJY1h44PZfaZucNoMTfSC/+XARhKBiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789755862; c=relaxed/simple;
	bh=xbqq04DVh17JBWLj7IT9qjTULFD4SlagBpWmL+g5Pl8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ME0XC+eAmIluVKQrqvgObX61r0pqdrvZKNiTkVRBqMtSFnCp+uQYx507PAAvbb1wc/e+UdJFwxRIU04F3kt9WbkwHXMB1fH1bezGFxcO9zAOHVF3z82kMdph2h/eZ4+/KtZDpfPxA9HDA7+cjsLaNA0JPwZBchyM4AbQysZUDoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=DPmuQmzR; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="DPmuQmzR"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 3F0BA1A0997;
	Fri, 18 Sep 2026 18:24:18 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 13E5160649;
	Fri, 18 Sep 2026 18:24:18 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 55AF710328E70;
	Fri, 18 Sep 2026 20:24:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1789755857; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=jvYN8HpLvuT2zQeLc4uffktogt+5pniMrEPXUK0/+B8=;
	b=DPmuQmzRNjAXiUtVJ8Wd4Kx5UXLa2Vw0z47c1tRlzFquLaLmxfHESl3b+CEMvcSaRM3kc6
	wMxxj5G93pJHoqjN9kEaezB07MzRzgrMvKLkdrEMC0H5F+AD9egdIOL2l5PO/MvE3+QpfQ
	ZWEU7xjdfIHe8OwGO/tPGFY3Ob0Nw+ooZ9FSusAddPSAZMaTyN8Q+PSrlG8z7bithxNWn1
	0AiawGFBsAWcq/yfmw2qEo7J43T5kRm9w4wEM27Gr7HYMNx+cD9CdNAqW/I68FPB9pBzkN
	aPNTuGJA0Puz86DjxQtZQld07Tu3DiEBGanpSPRsdiqEe5hLX8vJJrzrCuRTbQ==
From: "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Date: Fri, 18 Sep 2026 20:23:54 +0200
Subject: [PATCH 6.6.y 1/3] netfilter: nf_conntrack_pptp: move GRE specific
 cleanup to GRE tracker
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260918-cve-2026-80668-6-6-v1-1-07f89b880b6c@bootlin.com>
References: <20260918-cve-2026-80668-6-6-v1-0-07f89b880b6c@bootlin.com>
In-Reply-To: <20260918-cve-2026-80668-6-6-v1-0-07f89b880b6c@bootlin.com>
To: stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 David Ahern <dsahern@kernel.org>
Cc: Benjamin Robin <benjamin.robin@bootlin.com>, 
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>, 
 Sasha Levin <sashal@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789755843; l=6834;
 i=miguel.gazquez@bootlin.com; s=20250708; h=from:subject:message-id;
 bh=5BQ8xm65ENU6OETpG/UvjP2cCOG3RWZ/x+rThU0mU2c=;
 b=zNkfAWlFmemYMBHVFmaw/GIh6BYKF1mjMMa+1YWVQCXtP0yYi5W7t9P3OlSrw8P/ANL87YQ1Q
 90NVhKWwHRADKAeorecBqZR7ZtD3F4yfmONUqTWlOH0x9bZ/TiSzild
X-Developer-Key: i=miguel.gazquez@bootlin.com; a=ed25519;
 pk=k/2KI9jkmayaF0ghZ8QYUH9Wm/kFHDhl8QoZ0RHbr4w=
X-Last-TLS-Session-Version: TLSv1.3

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit fe97fd540a03034a780224f24b0b2f0e21c9c763 ]

Move the GRE specific cleanup to nf_conntrack_proto_gre.c to ensure that
the .destroy callback for the pptp helper is still reachable by existing
conntrack entries while pptp module is being removed.

This is a preparation patch, no functional changes are intended.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 979c13114c0b ("netfilter: nf_conntrack_expect: store master_tuple in expectation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
---
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h |  4 ++
 net/netfilter/nf_conntrack_pptp.c              | 63 +-------------------------
 net/netfilter/nf_conntrack_proto_gre.c         | 61 +++++++++++++++++++++++++
 3 files changed, 67 insertions(+), 61 deletions(-)

diff --git a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
index 2c8c2b023848..890fa73d96d8 100644
--- a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
@@ -26,4 +26,8 @@ extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite;
 extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_gre;
 #endif
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK_PPTP)
+void gre_pptp_destroy_siblings(struct nf_conn *ct);
+#endif
+
 #endif /*_NF_CONNTRACK_IPV4_H*/
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 4c679638df06..759683d7de4f 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -124,65 +124,6 @@ static void pptp_expectfn(struct nf_conn *ct,
 	}
 }
 
-static int destroy_sibling_or_exp(struct net *net, struct nf_conn *ct,
-				  const struct nf_conntrack_tuple *t)
-{
-	const struct nf_conntrack_tuple_hash *h;
-	const struct nf_conntrack_zone *zone;
-	struct nf_conntrack_expect *exp;
-	struct nf_conn *sibling;
-
-	pr_debug("trying to timeout ct or exp for tuple ");
-	nf_ct_dump_tuple(t);
-
-	zone = nf_ct_zone(ct);
-	h = nf_conntrack_find_get(net, zone, t);
-	if (h)  {
-		sibling = nf_ct_tuplehash_to_ctrack(h);
-		pr_debug("setting timeout of conntrack %p to 0\n", sibling);
-		sibling->proto.gre.timeout	  = 0;
-		sibling->proto.gre.stream_timeout = 0;
-		nf_ct_kill(sibling);
-		nf_ct_put(sibling);
-		return 1;
-	} else {
-		exp = nf_ct_expect_find_get(net, zone, t);
-		if (exp) {
-			pr_debug("unexpect_related of expect %p\n", exp);
-			nf_ct_unexpect_related(exp);
-			nf_ct_expect_put(exp);
-			return 1;
-		}
-	}
-	return 0;
-}
-
-/* timeout GRE data connections */
-static void pptp_destroy_siblings(struct nf_conn *ct)
-{
-	struct net *net = nf_ct_net(ct);
-	const struct nf_ct_pptp_master *ct_pptp_info = nfct_help_data(ct);
-	struct nf_conntrack_tuple t;
-
-	nf_ct_gre_keymap_destroy(ct);
-
-	/* try original (pns->pac) tuple */
-	memcpy(&t, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple, sizeof(t));
-	t.dst.protonum = IPPROTO_GRE;
-	t.src.u.gre.key = ct_pptp_info->pns_call_id;
-	t.dst.u.gre.key = ct_pptp_info->pac_call_id;
-	if (!destroy_sibling_or_exp(net, ct, &t))
-		pr_debug("failed to timeout original pns->pac ct/exp\n");
-
-	/* try reply (pac->pns) tuple */
-	memcpy(&t, &ct->tuplehash[IP_CT_DIR_REPLY].tuple, sizeof(t));
-	t.dst.protonum = IPPROTO_GRE;
-	t.src.u.gre.key = ct_pptp_info->pac_call_id;
-	t.dst.u.gre.key = ct_pptp_info->pns_call_id;
-	if (!destroy_sibling_or_exp(net, ct, &t))
-		pr_debug("failed to timeout reply pac->pns ct/exp\n");
-}
-
 /* expect GRE connections (PNS->PAC and PAC->PNS direction) */
 static int exp_gre(struct nf_conn *ct, __be16 callid, __be16 peer_callid)
 {
@@ -347,7 +288,7 @@ pptp_inbound_pkt(struct sk_buff *skb, unsigned int protoff,
 		info->cstate = PPTP_CALL_NONE;
 
 		/* untrack this call id, unexpect GRE packets */
-		pptp_destroy_siblings(ct);
+		gre_pptp_destroy_siblings(ct);
 		break;
 
 	case PPTP_WAN_ERROR_NOTIFY:
@@ -593,7 +534,7 @@ static struct nf_conntrack_helper pptp __read_mostly = {
 	.tuple.src.u.tcp.port	= cpu_to_be16(PPTP_CONTROL_PORT),
 	.tuple.dst.protonum	= IPPROTO_TCP,
 	.help			= conntrack_pptp_help,
-	.destroy		= pptp_destroy_siblings,
+	.destroy		= gre_pptp_destroy_siblings,
 	.expect_policy		= &pptp_exp_policy,
 };
 
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index af369e686fc5..79b63df84a10 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -291,6 +291,67 @@ gre_timeout_nla_policy[CTA_TIMEOUT_GRE_MAX+1] = {
 };
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK_PPTP)
+static int destroy_sibling_or_exp(struct net *net, struct nf_conn *ct,
+				  const struct nf_conntrack_tuple *t)
+{
+	const struct nf_conntrack_tuple_hash *h;
+	const struct nf_conntrack_zone *zone;
+	struct nf_conntrack_expect *exp;
+	struct nf_conn *sibling;
+
+	pr_debug("trying to timeout ct or exp for tuple ");
+	nf_ct_dump_tuple(t);
+
+	zone = nf_ct_zone(ct);
+	h = nf_conntrack_find_get(net, zone, t);
+	if (h)  {
+		sibling = nf_ct_tuplehash_to_ctrack(h);
+		pr_debug("setting timeout of conntrack %p to 0\n", sibling);
+		sibling->proto.gre.timeout        = 0;
+		sibling->proto.gre.stream_timeout = 0;
+		nf_ct_kill(sibling);
+		nf_ct_put(sibling);
+		return 1;
+	} else {
+		exp = nf_ct_expect_find_get(net, zone, t);
+		if (exp) {
+			pr_debug("unexpect_related of expect %p\n", exp);
+			nf_ct_unexpect_related(exp);
+			nf_ct_expect_put(exp);
+			return 1;
+		}
+	}
+	return 0;
+}
+
+void gre_pptp_destroy_siblings(struct nf_conn *ct)
+{
+	struct net *net = nf_ct_net(ct);
+	const struct nf_ct_pptp_master *ct_pptp_info = nfct_help_data(ct);
+	struct nf_conntrack_tuple t;
+
+	nf_ct_gre_keymap_destroy(ct);
+
+	/* try original (pns->pac) tuple */
+	memcpy(&t, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple, sizeof(t));
+	t.dst.protonum = IPPROTO_GRE;
+	t.src.u.gre.key = ct_pptp_info->pns_call_id;
+	t.dst.u.gre.key = ct_pptp_info->pac_call_id;
+	if (!destroy_sibling_or_exp(net, ct, &t))
+		pr_debug("failed to timeout original pns->pac ct/exp\n");
+
+	/* try reply (pac->pns) tuple */
+	memcpy(&t, &ct->tuplehash[IP_CT_DIR_REPLY].tuple, sizeof(t));
+	t.dst.protonum = IPPROTO_GRE;
+	t.src.u.gre.key = ct_pptp_info->pac_call_id;
+	t.dst.u.gre.key = ct_pptp_info->pns_call_id;
+	if (!destroy_sibling_or_exp(net, ct, &t))
+		pr_debug("failed to timeout reply pac->pns ct/exp\n");
+}
+EXPORT_SYMBOL_GPL(gre_pptp_destroy_siblings);
+#endif
+
 void nf_conntrack_gre_init_net(struct net *net)
 {
 	struct nf_gre_net *net_gre = gre_pernet(net);

-- 
2.55.0

