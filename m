Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794532517;
	b=CTpWLxUwbwZXa7H7eZtXXHA9XkphYq6cjrNyEpFHATvOxvdv9PlFrnuYJmgXPBDSSvVp
	 oeKLFkzfvnZitOwqdZoxR6vm0sJgFDEcrpl4Xzt/R9P44XWPIcnWyE0XuVorQruDhdCz0
	 Tl72FVuyomF9WqIyyIkxgxkGsA3fkCzVzoEaeGXdXEFkVPIY2sKjCA12Ita/iUaG2AztV
	 xqECjPdFS2ulBEe/Rrjj9Ba3gw2XbH4thHjsCnKX0Q6iQS5DY5Jvt9Do4X0Ciu0QDzk5o
	 40tD8BnZQ+mjR5Pdi4ViYnJtbK66eAJKEHphipDzTbqRHndnvqtkbsR+trmUjlUmshg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794532517;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=nNa7Ue2CiZ4BGtr7lXWSKBauNGQ1E0G/YP4i9W+JhYA=;
	b=3N7UhvK/34tM2qklXS/5sEm21zhThDKhPdf/vUxkBh+3WxdpGzyRKieZ1E+hNJdiXkJq
	 PgdCPcFtmc+DiREamcUi5csREVjWKSEoD9lsjJUP0pdH/S/FML1PUQBRT3A/xEGHiB+Nl
	 XWXbb7jMbXakq/NLmZJGJYNOFt+c7VLK54fGGE89I/BK0d/TYd43SqIlVHRsU+72XKk+m
	 vkIO/4dhYRAW/V7ypZucCO2KaEZAfBs8SEMZZEVzQKz+A77gawyMSWGiRA2mWEMXkg/8t
	 T2pTDgMeSASInIjPRRRyOL0ZLrQ+48CjYK8m0xmU/HqFaKWza+QcHfe85qRG8mRxWqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ONdJcmEw;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66780606A88A;
	Fri, 13 Nov 2026 01:15:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66780606A88A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ONdJcmEw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794532514;
	bh=nNa7Ue2CiZ4BGtr7lXWSKBauNGQ1E0G/YP4i9W+JhYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ONdJcmEwgnDsquDE+YOpmfqyPrLj/UBKwBW8I64pps8fYvg9VeuGw6Ld3Tg4a3cJG
	 7azljHuDvxpZcAb8xLALUj9tnhIOr2zlxUWLVWtNSzsDj9wfrT+xO2GJc/HEH062Cs
	 eCUF+2xYKAQy656qNY597ao3PE+NFtZc5sWv1wElAdJTkVjcgWz6tn2E0LjOQBxkz1
	 1ieoFDEYrFeCTXlfG9dRPv2Sg/wCj1KjqoEv0krLv4EyOwa//rwO90td9vTm4mzSY7
	 DIjfnO0OU7nRlR6jJHEoGBDyBM5H0N737JFV/eD0szH0l7DtK1WUuZZOjeblj/zIRp
	 98+pzAtoSMDZA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 34C2C6005D;
	Fri, 13 Nov 2026 02:15:14 +0100 (CET)
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
Subject: [PATCH net 13/15] ipvs: do not create conns from packets with port 0
Date: Fri, 13 Nov 2026 02:14:45 +0100
Message-ID: <20261113011447.2357709-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113011447.2357709-1-pablo@netfilter.org>
References: <20261113011447.2357709-1-pablo@netfilter.org>
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

From: Julian Anastasov <ja@ssi.bg>

We should disallow normal connections with cport 0 to be
created from packets by the scheduler (from clients) or
by ip_vs_new_conn_out (from real servers) because later
such traffic can not hit the connection due to the
NO_CPORT requirement. As result, it can lead to duplicate
connection for every packet. Do the same for vport 0.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://sashiko.dev/#/patchset/20261104201530.147292-1-ja%40ssi.bg
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103140308.591690-3-pablo%40netfilter.org
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260925141115.16126-1-axel.mierczuk%401password.com
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_core.c       | 3 ++-
 net/netfilter/ipvs/ip_vs_proto_sctp.c | 7 +++++++
 net/netfilter/ipvs/ip_vs_proto_tcp.c  | 7 +++++++
 net/netfilter/ipvs/ip_vs_proto_udp.c  | 6 ++++++
 4 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 76213159404f..15617bd19e96 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1312,6 +1312,7 @@ static inline bool is_new_conn_expected(const struct ip_vs_conn *cp,
  *    In fwmark-VS actual vaddr and vport are unknown to IPVS
  * 2) Real Server and Virtual Service were NOT configured without port:
  *    This is to allow match of different VS to the same RS ip-addr
+ * 3) Client port is not 0
  */
 struct ip_vs_conn *ip_vs_new_conn_out(struct ip_vs_service *svc,
 				      struct ip_vs_dest *dest,
@@ -1335,7 +1336,7 @@ struct ip_vs_conn *ip_vs_new_conn_out(struct ip_vs_service *svc,
 	/* check pre-requisites are satisfied */
 	if (svc->fwmark)
 		return NULL;
-	if (!vport || !dport)
+	if (!vport || !dport || !cport)
 		return NULL;
 
 	/* for persistent service first create connection template */
diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c b/net/netfilter/ipvs/ip_vs_proto_sctp.c
index fb8af6b15a39..cb34bcceb4f6 100644
--- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
@@ -30,6 +30,7 @@ sctp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
 			sch = skb_header_pointer(skb, iph->len + sizeof(_sctph),
 						 sizeof(_schunkh), &_schunkh);
 			if (sch) {
+				/* Accept packet without scheduling? */
 				if (sch->type == SCTP_CID_ABORT ||
 				    !(sysctl_sloppy_sctp(ipvs) ||
 				      sch->type == SCTP_CID_INIT))
@@ -56,6 +57,12 @@ sctp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
 	if (svc) {
 		int ignored;
 
+		/* Do not create connection for port 0 */
+		if (!ports[0] || !ports[1]) {
+			*verdict = NF_DROP;
+			return 0;
+		}
+
 		if (ip_vs_todrop(ipvs)) {
 			/*
 			 * It seems that we are very loaded.
diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
index fec0e8b47b71..25d4576d0e12 100644
--- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
@@ -48,6 +48,7 @@ tcp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
 	if (likely(!ip_vs_iph_icmp(iph))) {
 		th = skb_header_pointer(skb, iph->len, sizeof(_tcph), &_tcph);
 		if (th) {
+			/* Accept packet without scheduling? */
 			if (th->rst || !(sysctl_sloppy_tcp(ipvs) || th->syn))
 				return 1;
 			ports = &th->source;
@@ -74,6 +75,12 @@ tcp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
 	if (svc) {
 		int ignored;
 
+		/* Do not create connection for port 0 */
+		if (!ports[0] || !ports[1]) {
+			*verdict = NF_DROP;
+			return 0;
+		}
+
 		if (ip_vs_todrop(ipvs)) {
 			/*
 			 * It seems that we are very loaded.
diff --git a/net/netfilter/ipvs/ip_vs_proto_udp.c b/net/netfilter/ipvs/ip_vs_proto_udp.c
index f32785682402..ab3ab9524168 100644
--- a/net/netfilter/ipvs/ip_vs_proto_udp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_udp.c
@@ -62,6 +62,12 @@ udp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
 	if (svc) {
 		int ignored;
 
+		/* Do not create connection for port 0 */
+		if (!ports[0] || !ports[1]) {
+			*verdict = NF_DROP;
+			return 0;
+		}
+
 		if (ip_vs_todrop(ipvs)) {
 			/*
 			 * It seems that we are very loaded.
-- 
2.47.3

