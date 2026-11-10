Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794271157;
	b=CqkOyYDR8gHfAiol64sV8CTdSYynv27/569F6s/TUj72Etvy6sGR3Hb90ix8WSGVWt6H
	 E9znApLi2HNcOTbt4rA0TMrqRvQRdyNk4vesrCkUg01VEhKNKCYIuAT0kRqrV+iByl+ni
	 OPTuWfPtjHIJA5JD1nwX6YRDsmNsNJYI40HgU5BF3nDWVyCTjIMaJgdI4Y1xXYK0md2Tl
	 TgJlbkVM3UivN2DdIO7ffRNtnbdFoNNGqBjLAKMdCcDj207eNpejNgDXp6RnreYJhUhwE
	 hYJYwOImg2p5+wKODxplF9+I1m7hRQkRozMFX1LMancTzbkAnKBU/mC3O/PphmBZKdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794271157;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=kZ3K/8HGTGKb4+T8Db2OSvUo2leIRPk8YIzJkHJxczs=;
	b=dFsPr4uAHB6s33QUIjAzO0sILf/IAJaQxEY7hvB2Rsrv7WvSTg79ifVKSqTq0anT69K+
	 XPDaOsbgottcp9neriU+8ay7MpsRQ1kUKW0IIF7kW8nIMbN/7C1xGVpf9HBwHeX6w3DcW
	 WYmutnvHaq85VtHBy/aGH78wtbedWBqgE1gvD9FUtdcxoAqjMYJ7z7HFhE59u3sHeA8t2
	 Bm9ZS91O32e9YuRgJXbcWzi3nedjQ3/lvXPv9shOmLJ7igEJDgTQywEInkqgGDvrIKpim
	 QaabzDjeDythNZSAQTJY+YVfBv5SUOLszzU8KDDTCz1heKQFn81cWEw/56IKtkEhkag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=naKqQmgU;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF97606A321
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 00:39:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6AF97606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=naKqQmgU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794271152;
	bh=kZ3K/8HGTGKb4+T8Db2OSvUo2leIRPk8YIzJkHJxczs=;
	h=From:To:Subject:Date:From;
	b=naKqQmgU39fuyst/hqhr57AZbdf0KiXMnlQmzk+6jX52E9niv5eJBvd6uVQTqYrsd
	 RUVu26vmNgiyV5+CYKM9Ak5JTYJr3smkGDg99EZp8l7sqnLaJh2JJnSB90HL8EZRqY
	 RGLKfwXONHTgequLy47KoTOjzJNEkIFIJMF1eZ7U5Wz5OAkT3cxq6kPgdo1Z9SER5o
	 wWhTI64e6rlcdd4sutDcv0VBzO6IRxsT0RQ7BlA4PL+yf0IhREcwBdFB1XmGHpZGKW
	 O2sZjOkCZRC3NhUs4VdDd3zRaD+eD3SD54MIOFZo4wy6azdQzbGqIPKbDfGc8JnDFs
	 AXq4xc5dn9CnQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AD41460056
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 01:39:12 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v4 1/4] netfilter: add NF_HOOK_OP_CONNTRACK and use it
Date: Tue, 10 Nov 2026 01:39:06 +0100
Message-ID: <20261110003909.1740094-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
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

Add a new NF_HOOK_OP_CONNTRACK to identify conntrack hooks, this allows to
identify these hooks from user (via nfnetlink_hook) and kernelspace.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: new in this series, this provides an easier way to identify this is
    a conntrack hook.

 include/linux/netfilter.h                  | 1 +
 net/bridge/netfilter/nf_conntrack_bridge.c | 3 +++
 net/netfilter/nf_conntrack_proto.c         | 8 ++++++++
 3 files changed, 12 insertions(+)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index e99afc1414cd..66f048a12317 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -94,6 +94,7 @@ enum nf_hook_ops_type {
 	NF_HOOK_OP_BPF,
 	NF_HOOK_OP_NFT_FT,
 	NF_HOOK_OP_NAT,
+	NF_HOOK_OP_CONNTRACK,
 };
 
 struct nf_hook_ops {
diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 8c83dc05114b..ceffab8e5a7e 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -418,18 +418,21 @@ static struct nf_hook_ops nf_ct_bridge_hook_ops[] __read_mostly = {
 		.pf		= NFPROTO_BRIDGE,
 		.hooknum	= NF_BR_PRE_ROUTING,
 		.priority	= NF_IP_PRI_CONNTRACK,
+		.hook_ops_type	= NF_HOOK_OP_CONNTRACK,
 	},
 	{
 		.hook		= nf_ct_bridge_in,
 		.pf		= NFPROTO_BRIDGE,
 		.hooknum	= NF_BR_LOCAL_IN,
 		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
+		.hook_ops_type	= NF_HOOK_OP_CONNTRACK,
 	},
 	{
 		.hook		= nf_ct_bridge_post,
 		.pf		= NFPROTO_BRIDGE,
 		.hooknum	= NF_BR_POST_ROUTING,
 		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
+		.hook_ops_type	= NF_HOOK_OP_CONNTRACK,
 	},
 };
 
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 7a40e4e0e33e..94989c84abc7 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -243,24 +243,28 @@ static const struct nf_hook_ops ipv4_conntrack_ops[] = {
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_PRE_ROUTING,
 		.priority	= NF_IP_PRI_CONNTRACK,
+		.hook_ops_type	= NF_HOOK_OP_CONNTRACK,
 	},
 	{
 		.hook		= ipv4_conntrack_local,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP_PRI_CONNTRACK,
+		.hook_ops_type	= NF_HOOK_OP_CONNTRACK,
 	},
 	{
 		.hook		= nf_confirm,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_POST_ROUTING,
 		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
+		.hook_ops_type	= NF_HOOK_OP_CONNTRACK,
 	},
 	{
 		.hook		= nf_confirm,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
+		.hook_ops_type	= NF_HOOK_OP_CONNTRACK,
 	},
 };
 
@@ -400,24 +404,28 @@ static const struct nf_hook_ops ipv6_conntrack_ops[] = {
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_PRE_ROUTING,
 		.priority	= NF_IP6_PRI_CONNTRACK,
+		.hook_ops_type	= NF_HOOK_OP_CONNTRACK,
 	},
 	{
 		.hook		= ipv6_conntrack_local,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP6_PRI_CONNTRACK,
+		.hook_ops_type	= NF_HOOK_OP_CONNTRACK,
 	},
 	{
 		.hook		= nf_confirm,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_POST_ROUTING,
 		.priority	= NF_IP6_PRI_LAST,
+		.hook_ops_type	= NF_HOOK_OP_CONNTRACK,
 	},
 	{
 		.hook		= nf_confirm,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP6_PRI_LAST - 1,
+		.hook_ops_type	= NF_HOOK_OP_CONNTRACK,
 	},
 };
 #endif
-- 
2.47.3

