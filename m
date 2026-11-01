Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=31.154.135.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793565581;
	b=14wqe4rjOjp6Y946OSomOdqoPcEacJFurduWfO0ce4CyWnClo6fBLyGKOBPQGFYoCJmH
	 gWlMSJZ1foauDz/H97dSd54nUgKDD+yePHgs9JgmMgs3uKr2pi7Luqma3j5tpv1gj4Z0I
	 oVWQ5khXHXcc1P+qudhOuGRlCl4nCumNrnGtcf0Mdkfrb+c2/zK/semJEgRbPpg7+FTdH
	 a5zR3x/XE9U+Zl8OBzjVrahCA10bsPtyuum1bbikFzIQV7cpjcrxgf20gZjZ//cb5E36y
	 s3v8eBkSbiZbLtfSaCoHYAfG1xJ7769zqn5a+q3+q60xaSOoYpMBmR4QfXSR4GydpUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793565581;
	h=DMARC-Filter:Received:Received:Received:Received:Received:
	 DKIM-Filter:DKIM-Signature:X-Virus-Scanned:Received:Received:From:To:
	 Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YO6H2ereBIPQT3H5CjVg3doxANGZzHdBKwqRwpNWnWw=;
	b=MxBPpe4ebqYkUQhNkr3LUHt9fspX8f5cmcgGjDSsISofPF4mruVQ+ZlYPmHmDgy+pMFw
	 14GxP/xERrMETRzKeRK2MIRQVPV+zc6KO6zLc5l+HZrcXczRjYTrkTcZQckLua8mRuXS5
	 Tk1tpqbKUY8JeFh5uHY/yidelphSLIZXotMZAb2sKAwSD2CNes0uamaxyn6VmtvEGTpWV
	 4m/1CYEIkGBAX34N7tg3NpBmSlOdhTR/iuJUTVmNpNFBBOJhMMnCaLAfKHiqB4g9B0J5x
	 RxXTVBlDcSLPmveWUpgGFRnS2jSOBEFcoSLYnzoTSxjGtxmQ2+Ut+TruPVS2I4GLsjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=inango-systems.com;
	spf=pass smtp.mailfrom=inango-systems.com;
	dkim=pass header.d=inango-systems.com header.i=@inango-systems.com header.a=rsa-sha256 header.s=45A440E0-D841-11E8-B985-5FCC721607E0 header.b=rYRZSZTU;
	arc=none smtp.remote-ip=31.154.135.10
Received: from ksserv.inango.com (ksserv.inango.com [31.154.135.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7956F606A324;
	Sun,  1 Nov 2026 20:39:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7956F606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=inango-systems.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inango-systems.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=inango-systems.com header.i=@inango-systems.com header.a=rsa-sha256 header.s=45A440E0-D841-11E8-B985-5FCC721607E0 header.b=rYRZSZTU
Received: from ksserv.inango.com (localhost [127.0.0.1])
	by ksserv.inango.com (Proxmox) with ESMTP id 903BF22979;
	Sun,  1 Nov 2026 22:39:38 +0200 (IST)
Received: from mail.inango-systems.com (unknown [192.168.70.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ksserv.inango.com (Proxmox) with ESMTPS id 4CBBF229FE;
	Sun,  1 Nov 2026 22:39:38 +0200 (IST)
Received: from localhost (localhost [127.0.0.1])
	by mail.inango-systems.com (Postfix) with ESMTP id AC725D645B3;
	Sun,  1 Nov 2026 22:39:27 +0200 (IST)
Received: from mail.inango-systems.com ([127.0.0.1])
 by localhost (mail.inango-systems.com [127.0.0.1]) (amavis, port 10032)
 with ESMTP id yjTvLRz2TfHy; Sun,  1 Nov 2026 22:39:27 +0200 (IST)
Received: from localhost (localhost [127.0.0.1])
	by mail.inango-systems.com (Postfix) with ESMTP id 7A0D9D645A5;
	Sun,  1 Nov 2026 22:39:27 +0200 (IST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.inango-systems.com 7A0D9D645A5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=inango-systems.com;
	s=45A440E0-D841-11E8-B985-5FCC721607E0; t=1793565567;
	bh=YO6H2ereBIPQT3H5CjVg3doxANGZzHdBKwqRwpNWnWw=;
	h=From:To:Date:Message-ID:MIME-Version;
	b=rYRZSZTUiNA89wc5RLZFYc04pyxOA+JBvYzt7/cXDNRvS6SFPI8JQqNCS+4yOY6Cn
	 n7htdp9gkrRiOz4KFNbi308eTeRej391v/GO8/sltYA+OpijznYJWZCifCi+1ef9UJ
	 W1HQ6FkQMgCVmTukuRXdJ0YrVWwyUlk0opTPFyeTiYJ58TlowiCer4x3UguCVdQSS0
	 2oMpqMN/MeUbUE33fYJwkIvm7DDsjKGPU20n2AwvWrkLLaeX+ItD98z9Mf2dboBx3/
	 TefiHnXRJtcEd4/E/ro3JzOW/FktElftfZqbBh9G47lRRqfblQbIRGb0c3UOY1BHdd
	 LYuQ6q98jkxSg==
X-Virus-Scanned: amavis at inango-systems.com
Received: from mail.inango-systems.com ([127.0.0.1])
 by localhost (mail.inango-systems.com [127.0.0.1]) (amavis, port 10026)
 with ESMTP id 5Q_g32nLDp1E; Sun,  1 Nov 2026 22:39:27 +0200 (IST)
Received: from steamdeck.inango.loc (unknown [193.37.156.111])
	by mail.inango-systems.com (Postfix) with ESMTPSA id 68DCED645B3;
	Sun,  1 Nov 2026 22:39:04 +0200 (IST)
From: Nikolai Merinov <n.merinov@inango-systems.com>
To: netfilter-devel@vger.kernel.org
Cc: netdev@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Nikolai Merinov <n.merinov@inango-systems.com>
Subject: [PATCH 3/3] netfilter: ip6t_NPT: Adding conntrack compatibility to NPT sessions
Date: Mon,  2 Nov 2026 00:37:16 +0400
Message-ID: <20261101203716.269343-4-n.merinov@inango-systems.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261101203716.269343-1-n.merinov@inango-systems.com>
References: <20261101203716.269343-1-n.merinov@inango-systems.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

From: Andrey Kuznetsov <a.kuznetsov@inango-systems.com>

The ip6t_NPT was implemented without connection tracking support and
official netfilter documentation for libip6t_DNPT recommends to use
NOTRACK target to disable connection tracking for translated
flow. Such solution blocks possibility to use the NPTv6 implementation
on systems with stateful IPv6 firewall.

Add function that alters conntrack reply tuple for expected replies in
both SNPT and DNPT targets. Add optional dependency on NF_CONNTRACK.

Co-developed-by: Andrey Erokhin <a.erokhin@inango-systems.com>
Signed-off-by: Andrey Erokhin <a.erokhin@inango-systems.com>
Signed-off-by: Andrey Kuznetsov <a.kuznetsov@inango-systems.com>
Co-developed-by: Nikolai Merinov <n.merinov@inango-systems.com>
Signed-off-by: Nikolai Merinov <n.merinov@inango-systems.com>
---
 net/ipv6/netfilter/Kconfig    |  1 +
 net/ipv6/netfilter/ip6t_NPT.c | 30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 81daf82ddc2d..f5fa62541db8 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -290,6 +290,7 @@ config IP6_NF_TARGET_MASQUERADE
 config IP6_NF_TARGET_NPT
 	tristate "NPT (Network Prefix translation) target support"
 	depends on IP6_NF_NAT || NFT_COMPAT
+	depends on NF_CONNTRACK || !NF_CONNTRACK
 	help
 	  This option adds the `SNPT' and `DNPT' target, which perform
 	  stateless IPv6-to-IPv6 Network Prefix Translation per RFC 6296.
diff --git a/net/ipv6/netfilter/ip6t_NPT.c b/net/ipv6/netfilter/ip6t_NPT.=
c
index d8cc0cc0339e..6ffe53a9572b 100644
--- a/net/ipv6/netfilter/ip6t_NPT.c
+++ b/net/ipv6/netfilter/ip6t_NPT.c
@@ -12,6 +12,10 @@
 #include <linux/netfilter_ipv6/ip6t_NPT.h>
 #include <linux/netfilter/x_tables.h>
=20
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+#include <net/netfilter/nf_conntrack.h>
+#endif
+
 static int ip6t_npt_checkentry(const struct xt_tgchk_param *par)
 {
 	struct ip6t_npt_tginfo *npt =3D par->targinfo;
@@ -121,6 +125,30 @@ static struct ipv6hdr *icmpv6_bounced_ipv6hdr(struct=
 sk_buff *skb,
 				  _bounced_hdr);
 }
=20
+static void ip6t_npt_ct(struct sk_buff *skb, const struct xt_action_para=
m *par)
+{
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	struct nf_conn *ct;
+	enum ip_conntrack_info ctinfo;
+	struct nf_conntrack_tuple new_tuple;
+
+	ct =3D nf_ct_get(skb, &ctinfo);
+
+	if (!ct || nf_ct_is_confirmed(ct) || nf_ct_is_dying(ct))
+		return;
+
+	new_tuple =3D ct->tuplehash[IP_CT_DIR_REPLY].tuple;
+
+	if (xt_hooknum(par) =3D=3D NF_INET_PRE_ROUTING ||
+	    xt_hooknum(par) =3D=3D NF_INET_LOCAL_OUT)
+		new_tuple.src.u3 =3D (union nf_inet_addr)ipv6_hdr(skb)->daddr;
+	else
+		new_tuple.dst.u3 =3D (union nf_inet_addr)ipv6_hdr(skb)->saddr;
+
+	nf_conntrack_alter_reply(ct, &new_tuple);
+#endif
+}
+
 static unsigned int
 ip6t_snpt_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
@@ -151,6 +179,7 @@ ip6t_snpt_tg(struct sk_buff *skb, const struct xt_act=
ion_param *par)
 			ip6t_npt_map_pfx(npt, &bounced_hdr->daddr);
 	}
=20
+	ip6t_npt_ct(skb, par);
 	return XT_CONTINUE;
 }
=20
@@ -184,6 +213,7 @@ ip6t_dnpt_tg(struct sk_buff *skb, const struct xt_act=
ion_param *par)
 			ip6t_npt_map_pfx(npt, &bounced_hdr->saddr);
 	}
=20
+	ip6t_npt_ct(skb, par);
 	return XT_CONTINUE;
 }
=20
--=20
2.55.0


