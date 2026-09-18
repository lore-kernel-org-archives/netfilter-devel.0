Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE5F51D539;
	Fri, 18 Sep 2026 18:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789755803; cv=none; b=jz5PqCJ7SkH70NJ2iU9Cr+0TMjruxYJmrzqtTU8syRPTvikTgBDKbZZuhDobDclf/Nn6beRNhSgJjqGha1FNFP3h2Fpz4580j4WZXOwpwPC3eMQ9y4OwBIZj3htFPcikl53/EJUCAhXElhbfVh73CsdD+5XhUlUteCMpEAgnef4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789755803; c=relaxed/simple;
	bh=xbqq04DVh17JBWLj7IT9qjTULFD4SlagBpWmL+g5Pl8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=i58t+P5BZRt/rPjzMpsSRt8Iouf2dpwziV4Q9d+UOy8EX2Xg0rGiX/tW/CgVI4L4hDDfPT4lMfQUvXhtYw5N3+nZLQPdvTHIMamMgCuJjWZjX4xIu6Pi5D9PkZGzahJ8ITmaMur7JAVbSSzeEoA5KNto4908SSI1JiRw5qDHrag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=QmAK6/z3; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="QmAK6/z3"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id A07561A099C;
	Fri, 18 Sep 2026 18:23:19 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 7388C60649;
	Fri, 18 Sep 2026 18:23:19 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 9572210329076;
	Fri, 18 Sep 2026 20:23:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1789755794; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=jvYN8HpLvuT2zQeLc4uffktogt+5pniMrEPXUK0/+B8=;
	b=QmAK6/z3xTaRQwDSumCD5v/BPsrCUX8kx7Gy73ocQPn6ecg8RLpwKffnpxD9D0ShYJ/+48
	fxUDoNTHg+PHe4Yd+wjBYTeD4Rg7iiltPwgH0VliXpj3PpIdYF3CCeoGkcCJw5P8IdOqJK
	22gtJEO7R7d1rKJsMX1FdXqrsWsRGD1rKk2mXuLB4nDVItUwiqXuSejoKLqNpedgemQ2WQ
	krH9AQ6ULxz6z5d++h8ZdUUeWIX1ATcdsvJNf0GvUmnoWCa/+CAS4HBx7/a6i6gK40+zsw
	7kkvQMR3tuEBbo6354dSav+My+jfi1Rlw/By4onTuTPdpf1qJa3r327Ik2CU9A==
From: "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Date: Fri, 18 Sep 2026 20:22:57 +0200
Subject: [PATCH 6.12.y 1/3] netfilter: nf_conntrack_pptp: move GRE specific
 cleanup to GRE tracker
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260918-cve-2026-80668-v2-v1-1-fcefceb49144@bootlin.com>
References: <20260918-cve-2026-80668-v2-v1-0-fcefceb49144@bootlin.com>
In-Reply-To: <20260918-cve-2026-80668-v2-v1-0-fcefceb49144@bootlin.com>
To: stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, David Ahern <dsahern@kernel.org>, 
 Florian Westphal <fw@strlen.de>
Cc: Benjamin Robin <benjamin.robin@bootlin.com>, 
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>, 
 Sasha Levin <sashal@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789755780; l=6834;
 i=miguel.gazquez@bootlin.com; s=20250708; h=from:subject:message-id;
 bh=5BQ8xm65ENU6OETpG/UvjP2cCOG3RWZ/x+rThU0mU2c=;
 b=rb3C5TKkCCUvDlQT+KBxG5fEVykZIv9j+Kh17zFvaLi5IXvSj9v5tRO3NGoG9rfLbowT+uVVM
 CLuozVPOx9ADZh6Zcv/PGE0yuskFvmlYZj3v0gpQGq0t4ehwVic4Ggz
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

