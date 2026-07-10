Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFDD34BA24;
	Fri, 10 Jul 2026 14:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783694300; cv=none; b=KkyFzYAFY6ZpOjWI/YDBsCZxkri7VJ8FSR0Xbv88c12c4rsxxuleZR0d6ZVEI8itOf2KOxWY22vBnGzCQxy0LpHTrNCIO58DeYGGl6PQ9lCEy97wurnAokac4wbB+Ejt84nmal2gFfu34zlacRpr9rRDlBESGlON2fP1jMsYDEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783694300; c=relaxed/simple;
	bh=dsCdYj9Sy8m+zjtY/XMIEDkI8mPsMxyggLu9uoq5vQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrSnYp5iysEUE3k+H410kIJhAnVjpfaP+VVU2y+Yk3XnSocB+rsH94VfqN8++xTVBqH0gVmAsML3ozC/G8Jf0Rc7uv9TFoVcIfgLUs2RtBLH/HfzGiToZ2HyARzN9dN68ryPravBOqbQJ/LkcWi2IZFByo2bh9BvkE5g4CEjozI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 036C260491; Fri, 10 Jul 2026 16:38:16 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 8/9] ipvs: fix more places with wrong ipv6 transport offsets
Date: Fri, 10 Jul 2026 16:37:32 +0200
Message-ID: <20260710143733.29741-9-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260710143733.29741-1-fw@strlen.de>
References: <20260710143733.29741-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Julian Anastasov <ja@ssi.bg>

Sashiko reports for more incorrect IPv6 transport offsets.

The app code for TCP was assuming IPv4 network header
even after the ipvsh argument was provided. This can
cause problems with apps over IPv6. As for the only
official app in the kernel tree (FTP) this problem is
harmless because we use Netfilter to mangle the FTP
ports and we do not adjust the TCP seq numbers.

Also, provide correct offset of the ICMPV6 header in
ip_vs_out_icmp_v6() for correct checksum checks when
the IPv6 packet has extension headers.

Fixes: d12e12299a69 ("ipvs: add ipv6 support to ftp")
Fixes: 2a3b791e6e11 ("IPVS: Add/adjust Netfilter hook functions and helpers for v6")
Cc: stable@vger.kernel.org
Link: https://sashiko.dev/#/patchset/20260706101624.69471-1-zhaoyz24%40mails.tsinghua.edu.cn
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipvs/ip_vs_app.c  | 10 ++++------
 net/netfilter/ipvs/ip_vs_core.c |  3 +--
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_app.c b/net/netfilter/ipvs/ip_vs_app.c
index d54d7da58334..b0e00be85cb1 100644
--- a/net/netfilter/ipvs/ip_vs_app.c
+++ b/net/netfilter/ipvs/ip_vs_app.c
@@ -361,14 +361,13 @@ static inline int app_tcp_pkt_out(struct ip_vs_conn *cp, struct sk_buff *skb,
 				  struct ip_vs_iphdr *ipvsh)
 {
 	int diff;
-	const unsigned int tcp_offset = ip_hdrlen(skb);
 	struct tcphdr *th;
 	__u32 seq;
 
-	if (skb_ensure_writable(skb, tcp_offset + sizeof(*th)))
+	if (skb_ensure_writable(skb, ipvsh->len + sizeof(*th)))
 		return 0;
 
-	th = (struct tcphdr *)(skb_network_header(skb) + tcp_offset);
+	th = (struct tcphdr *)(skb_network_header(skb) + ipvsh->len);
 
 	/*
 	 *	Remember seq number in case this pkt gets resized
@@ -438,14 +437,13 @@ static inline int app_tcp_pkt_in(struct ip_vs_conn *cp, struct sk_buff *skb,
 				 struct ip_vs_iphdr *ipvsh)
 {
 	int diff;
-	const unsigned int tcp_offset = ip_hdrlen(skb);
 	struct tcphdr *th;
 	__u32 seq;
 
-	if (skb_ensure_writable(skb, tcp_offset + sizeof(*th)))
+	if (skb_ensure_writable(skb, ipvsh->len + sizeof(*th)))
 		return 0;
 
-	th = (struct tcphdr *)(skb_network_header(skb) + tcp_offset);
+	th = (struct tcphdr *)(skb_network_header(skb) + ipvsh->len);
 
 	/*
 	 *	Remember seq number in case this pkt gets resized
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 35cbe821c259..bafab93451d0 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1219,8 +1219,7 @@ static int ip_vs_out_icmp_v6(struct netns_ipvs *ipvs, struct sk_buff *skb,
 	snet.in6 = ciph.saddr.in6;
 	offset = ciph.len;
 	return handle_response_icmp(AF_INET6, skb, &snet, ciph.protocol, cp,
-				    pp, offset, sizeof(struct ipv6hdr),
-				    hooknum);
+				    pp, offset, ipvsh->len, hooknum);
 }
 #endif
 
-- 
2.54.0

