Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B5A3C5522;
	Thu,  2 Jul 2026 10:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782989428; cv=none; b=py6qiw/kdOufrSM/mfUJ0UiMLFpF+7q/V2krHMoq+jdbG7hNdecamtkNHUTEDcbl61VRQ00yRApFBPBVWlt6cEkFKhZYaK7cIw5m1unFKLBSMSStwnaLoXCrJyOBJqOIY45QGWjJ7gj96eFM1xRJRtx3m9i5/LlQHzn3GB7nNyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782989428; c=relaxed/simple;
	bh=lLyn6IiqBvOTuNKa0gszlqTnyGlQPSkD9PNfUzGoLcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EtGSzcDEPpJGpVcydN/f0d5CyPKvrIpFxVHD4M3YuY0JzaXEXAg+RrCLz7AIg1J+0NO8/cgFk6ZAP1N67TCnOCoKFYrJASO60H9EAAT1pv59jZOmblCXjVjuOANiLS4pi1njFr45wyNy/yJpFnRt1o7mc75qJbV6dBtu+u5BGck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6BE84601F0; Thu, 02 Jul 2026 12:50:25 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 03/12] netfilter: replace u_int8_t and u_int16t with u8 and u16
Date: Thu,  2 Jul 2026 12:49:54 +0200
Message-ID: <20260702105003.13550-4-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260702105003.13550-1-fw@strlen.de>
References: <20260702105003.13550-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Grillet <carlos@carlosgrillet.me>

Use preferred kernel integer type u8 instead of the POSIX u_int8_t
variant.

No functional change.

Signed-off-by: Carlos Grillet <carlos@carlosgrillet.me>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/ip_vs.h                    | 2 +-
 net/netfilter/ipvs/ip_vs_nfct.c        | 2 +-
 net/netfilter/nf_conntrack_amanda.c    | 2 +-
 net/netfilter/nf_conntrack_h323_main.c | 2 +-
 net/netfilter/xt_TCPOPTSTRIP.c         | 8 ++++----
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 49297fec448a..ed2e9bc1bb4e 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -2123,7 +2123,7 @@ void ip_vs_update_conntrack(struct sk_buff *skb, struct ip_vs_conn *cp,
 			    int outin);
 int ip_vs_confirm_conntrack(struct sk_buff *skb);
 void ip_vs_nfct_expect_related(struct sk_buff *skb, struct nf_conn *ct,
-			       struct ip_vs_conn *cp, u_int8_t proto,
+			       struct ip_vs_conn *cp, u8 proto,
 			       const __be16 port, int from_rs);
 void ip_vs_conn_drop_conntrack(struct ip_vs_conn *cp);
 
diff --git a/net/netfilter/ipvs/ip_vs_nfct.c b/net/netfilter/ipvs/ip_vs_nfct.c
index 81974f69e5bb..347185fd0c8c 100644
--- a/net/netfilter/ipvs/ip_vs_nfct.c
+++ b/net/netfilter/ipvs/ip_vs_nfct.c
@@ -208,7 +208,7 @@ static void ip_vs_nfct_expect_callback(struct nf_conn *ct,
  * Use port 0 to expect connection from any port.
  */
 void ip_vs_nfct_expect_related(struct sk_buff *skb, struct nf_conn *ct,
-			       struct ip_vs_conn *cp, u_int8_t proto,
+			       struct ip_vs_conn *cp, u8 proto,
 			       const __be16 port, int from_rs)
 {
 	struct nf_conntrack_expect *exp;
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index ddafbdfc96dc..f10ac2c49f4b 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -89,7 +89,7 @@ static int amanda_help(struct sk_buff *skb,
 	struct nf_conntrack_tuple *tuple;
 	unsigned int dataoff, start, stop, off, i;
 	char pbuf[sizeof("65535")], *tmp;
-	u_int16_t len;
+	u16 len;
 	__be16 port;
 	int ret = NF_ACCEPT;
 	nf_nat_amanda_hook_fn *nf_nat_amanda;
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 24931e379985..37b6314ca772 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -671,7 +671,7 @@ static int expect_h245(struct sk_buff *skb, struct nf_conn *ct,
 static int callforward_do_filter(struct net *net,
 				 const union nf_inet_addr *src,
 				 const union nf_inet_addr *dst,
-				 u_int8_t family)
+				 u8 family)
 {
 	int ret = 0;
 
diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTSTRIP.c
index 93f064306901..265d21697847 100644
--- a/net/netfilter/xt_TCPOPTSTRIP.c
+++ b/net/netfilter/xt_TCPOPTSTRIP.c
@@ -16,7 +16,7 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_TCPOPTSTRIP.h>
 
-static inline unsigned int optlen(const u_int8_t *opt, unsigned int offset)
+static inline unsigned int optlen(const u8 *opt, unsigned int offset)
 {
 	/* Beware zero-length options: make finite progress */
 	if (opt[offset] <= TCPOPT_NOP || opt[offset+1] == 0)
@@ -33,8 +33,8 @@ tcpoptstrip_mangle_packet(struct sk_buff *skb,
 	const struct xt_tcpoptstrip_target_info *info = par->targinfo;
 	struct tcphdr *tcph, _th;
 	unsigned int optl, i, j;
-	u_int16_t n, o;
-	u_int8_t *opt;
+	u16 n, o;
+	u8 *opt;
 	int tcp_hdrlen;
 
 	/* This is a fragment, no TCP header is available */
@@ -97,7 +97,7 @@ tcpoptstrip_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
 	int tcphoff;
-	u_int8_t nexthdr;
+	u8 nexthdr;
 	__be16 frag_off;
 
 	nexthdr = ipv6h->nexthdr;
-- 
2.54.0

