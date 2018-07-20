From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 34/38] netfilter: nf_osf: add struct nf_osf_hdr_ctx
Date: Fri, 20 Jul 2018 15:09:02 +0200
Message-ID: <20180720130906.27687-35-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Wrap context that allow us to guess the OS into a structure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_osf.c | 105 +++++++++++++++++++++++++++++--------------------
 1 file changed, 62 insertions(+), 43 deletions(-)

diff --git a/net/netfilter/nf_osf.c b/net/netfilter/nf_osf.c
index bd7b34dd7d87..b44d62d5d9a9 100644
--- a/net/netfilter/nf_osf.c
+++ b/net/netfilter/nf_osf.c
@@ -51,18 +51,25 @@ static inline int nf_osf_ttl(const struct sk_buff *skb,
 	return ip->ttl == f_ttl;
 }
 
+struct nf_osf_hdr_ctx {
+	bool			df;
+	u16			window;
+	u16			totlen;
+	const unsigned char	*optp;
+	unsigned int		optsize;
+};
+
 static bool nf_osf_match_one(const struct sk_buff *skb,
 			     const struct nf_osf_user_finger *f,
-			     int ttl_check, u16 totlen, u16 window,
-			     const unsigned char *optp,
-			     unsigned int optsize)
+			     int ttl_check,
+			     struct nf_osf_hdr_ctx *ctx)
 {
 	unsigned int check_WSS = 0;
 	int fmatch = FMATCH_WRONG;
 	int foptsize, optnum;
 	u16 mss = 0;
 
-	if (totlen != f->ss || !nf_osf_ttl(skb, ttl_check, f->ttl))
+	if (ctx->totlen != f->ss || !nf_osf_ttl(skb, ttl_check, f->ttl))
 		return false;
 
 	/*
@@ -78,24 +85,24 @@ static bool nf_osf_match_one(const struct sk_buff *skb,
 		foptsize += f->opt[optnum].length;
 
 	if (foptsize > MAX_IPOPTLEN ||
-	    optsize > MAX_IPOPTLEN ||
-	    optsize != foptsize)
+	    ctx->optsize > MAX_IPOPTLEN ||
+	    ctx->optsize != foptsize)
 		return false;
 
 	check_WSS = f->wss.wc;
 
 	for (optnum = 0; optnum < f->opt_num; ++optnum) {
-		if (f->opt[optnum].kind == (*optp)) {
+		if (f->opt[optnum].kind == *ctx->optp) {
 			__u32 len = f->opt[optnum].length;
-			const __u8 *optend = optp + len;
+			const __u8 *optend = ctx->optp + len;
 
 			fmatch = FMATCH_OK;
 
-			switch (*optp) {
+			switch (*ctx->optp) {
 			case OSFOPT_MSS:
-				mss = optp[3];
+				mss = ctx->optp[3];
 				mss <<= 8;
-				mss |= optp[2];
+				mss |= ctx->optp[2];
 
 				mss = ntohs((__force __be16)mss);
 				break;
@@ -103,7 +110,7 @@ static bool nf_osf_match_one(const struct sk_buff *skb,
 				break;
 			}
 
-			optp = optend;
+			ctx->optp = optend;
 		} else
 			fmatch = FMATCH_OPT_WRONG;
 
@@ -116,7 +123,7 @@ static bool nf_osf_match_one(const struct sk_buff *skb,
 
 		switch (check_WSS) {
 		case OSF_WSS_PLAIN:
-			if (f->wss.val == 0 || window == f->wss.val)
+			if (f->wss.val == 0 || ctx->window == f->wss.val)
 				fmatch = FMATCH_OK;
 			break;
 		case OSF_WSS_MSS:
@@ -128,19 +135,19 @@ static bool nf_osf_match_one(const struct sk_buff *skb,
 			 */
 #define SMART_MSS_1	1460
 #define SMART_MSS_2	1448
-			if (window == f->wss.val * mss ||
-			    window == f->wss.val * SMART_MSS_1 ||
-			    window == f->wss.val * SMART_MSS_2)
+			if (ctx->window == f->wss.val * mss ||
+			    ctx->window == f->wss.val * SMART_MSS_1 ||
+			    ctx->window == f->wss.val * SMART_MSS_2)
 				fmatch = FMATCH_OK;
 			break;
 		case OSF_WSS_MTU:
-			if (window == f->wss.val * (mss + 40) ||
-			    window == f->wss.val * (SMART_MSS_1 + 40) ||
-			    window == f->wss.val * (SMART_MSS_2 + 40))
+			if (ctx->window == f->wss.val * (mss + 40) ||
+			    ctx->window == f->wss.val * (SMART_MSS_1 + 40) ||
+			    ctx->window == f->wss.val * (SMART_MSS_2 + 40))
 				fmatch = FMATCH_OK;
 			break;
 		case OSF_WSS_MODULO:
-			if ((window % f->wss.val) == 0)
+			if ((ctx->window % f->wss.val) == 0)
 				fmatch = FMATCH_OK;
 			break;
 		}
@@ -149,54 +156,66 @@ static bool nf_osf_match_one(const struct sk_buff *skb,
 	return fmatch == FMATCH_OK;
 }
 
+static const struct tcphdr *nf_osf_hdr_ctx_init(struct nf_osf_hdr_ctx *ctx,
+						const struct sk_buff *skb,
+						const struct iphdr *ip,
+						unsigned char *opts)
+{
+	const struct tcphdr *tcp;
+	struct tcphdr _tcph;
+
+	tcp = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(struct tcphdr), &_tcph);
+	if (!tcp)
+		return NULL;
+
+	if (!tcp->syn)
+		return NULL;
+
+	ctx->totlen = ntohs(ip->tot_len);
+	ctx->df = ntohs(ip->frag_off) & IP_DF;
+	ctx->window = ntohs(tcp->window);
+
+	if (tcp->doff * 4 > sizeof(struct tcphdr)) {
+		ctx->optsize = tcp->doff * 4 - sizeof(struct tcphdr);
+
+		ctx->optp = skb_header_pointer(skb, ip_hdrlen(skb) +
+				sizeof(struct tcphdr), ctx->optsize, opts);
+	}
+
+	return tcp;
+}
+
 bool
 nf_osf_match(const struct sk_buff *skb, u_int8_t family,
 	     int hooknum, struct net_device *in, struct net_device *out,
 	     const struct nf_osf_info *info, struct net *net,
 	     const struct list_head *nf_osf_fingers)
 {
-	const unsigned char *optp = NULL, *_optp = NULL;
 	const struct iphdr *ip = ip_hdr(skb);
 	const struct nf_osf_user_finger *f;
 	unsigned char opts[MAX_IPOPTLEN];
 	const struct nf_osf_finger *kf;
 	int fcount = 0, ttl_check;
 	int fmatch = FMATCH_WRONG;
-	unsigned int optsize = 0;
+	struct nf_osf_hdr_ctx ctx;
 	const struct tcphdr *tcp;
-	struct tcphdr _tcph;
-	u16 window, totlen;
-	bool df;
 
-	tcp = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(struct tcphdr), &_tcph);
-	if (!tcp)
-		return false;
+	memset(&ctx, 0, sizeof(ctx));
 
-	if (!tcp->syn)
+	tcp = nf_osf_hdr_ctx_init(&ctx, skb, ip, opts);
+	if (!tcp)
 		return false;
 
-	totlen = ntohs(ip->tot_len);
-	df = ntohs(ip->frag_off) & IP_DF;
-	window = ntohs(tcp->window);
-
-	if (tcp->doff * 4 > sizeof(struct tcphdr)) {
-		optsize = tcp->doff * 4 - sizeof(struct tcphdr);
-
-		_optp = optp = skb_header_pointer(skb, ip_hdrlen(skb) +
-				sizeof(struct tcphdr), optsize, opts);
-	}
-
 	ttl_check = (info->flags & NF_OSF_TTL) ? info->ttl : -1;
 
-	list_for_each_entry_rcu(kf, &nf_osf_fingers[df], finger_entry) {
+	list_for_each_entry_rcu(kf, &nf_osf_fingers[ctx.df], finger_entry) {
 
 		f = &kf->finger;
 
 		if (!(info->flags & NF_OSF_LOG) && strcmp(info->genre, f->genre))
 			continue;
 
-		if (!nf_osf_match_one(skb, f,
-				      ttl_check, totlen, window, optp, optsize))
+		if (!nf_osf_match_one(skb, f, ttl_check, &ctx))
 			continue;
 
 		fmatch = FMATCH_OK;
-- 
2.11.0
