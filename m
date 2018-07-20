From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 33/38] netfilter: nf_osf: add nf_osf_match_one()
Date: Fri, 20 Jul 2018 15:09:01 +0200
Message-ID: <20180720130906.27687-34-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This new function allows us to check if there is TCP syn packet matching
with a given fingerprint that can be reused from the upcoming new
nf_osf_find() function.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_osf.c | 207 ++++++++++++++++++++++++++-----------------------
 1 file changed, 111 insertions(+), 96 deletions(-)

diff --git a/net/netfilter/nf_osf.c b/net/netfilter/nf_osf.c
index 5ba5c7bef2f9..bd7b34dd7d87 100644
--- a/net/netfilter/nf_osf.c
+++ b/net/netfilter/nf_osf.c
@@ -21,15 +21,14 @@
 #include <linux/netfilter/nf_osf.h>
 
 static inline int nf_osf_ttl(const struct sk_buff *skb,
-			     const struct nf_osf_info *info,
-			     unsigned char f_ttl)
+			     int ttl_check, unsigned char f_ttl)
 {
 	const struct iphdr *ip = ip_hdr(skb);
 
-	if (info->flags & NF_OSF_TTL) {
-		if (info->ttl == NF_OSF_TTL_TRUE)
+	if (ttl_check != -1) {
+		if (ttl_check == NF_OSF_TTL_TRUE)
 			return ip->ttl == f_ttl;
-		if (info->ttl == NF_OSF_TTL_NOCHECK)
+		if (ttl_check == NF_OSF_TTL_NOCHECK)
 			return 1;
 		else if (ip->ttl <= f_ttl)
 			return 1;
@@ -52,6 +51,104 @@ static inline int nf_osf_ttl(const struct sk_buff *skb,
 	return ip->ttl == f_ttl;
 }
 
+static bool nf_osf_match_one(const struct sk_buff *skb,
+			     const struct nf_osf_user_finger *f,
+			     int ttl_check, u16 totlen, u16 window,
+			     const unsigned char *optp,
+			     unsigned int optsize)
+{
+	unsigned int check_WSS = 0;
+	int fmatch = FMATCH_WRONG;
+	int foptsize, optnum;
+	u16 mss = 0;
+
+	if (totlen != f->ss || !nf_osf_ttl(skb, ttl_check, f->ttl))
+		return false;
+
+	/*
+	 * Should not happen if userspace parser was written correctly.
+	 */
+	if (f->wss.wc >= OSF_WSS_MAX)
+		return false;
+
+	/* Check options */
+
+	foptsize = 0;
+	for (optnum = 0; optnum < f->opt_num; ++optnum)
+		foptsize += f->opt[optnum].length;
+
+	if (foptsize > MAX_IPOPTLEN ||
+	    optsize > MAX_IPOPTLEN ||
+	    optsize != foptsize)
+		return false;
+
+	check_WSS = f->wss.wc;
+
+	for (optnum = 0; optnum < f->opt_num; ++optnum) {
+		if (f->opt[optnum].kind == (*optp)) {
+			__u32 len = f->opt[optnum].length;
+			const __u8 *optend = optp + len;
+
+			fmatch = FMATCH_OK;
+
+			switch (*optp) {
+			case OSFOPT_MSS:
+				mss = optp[3];
+				mss <<= 8;
+				mss |= optp[2];
+
+				mss = ntohs((__force __be16)mss);
+				break;
+			case OSFOPT_TS:
+				break;
+			}
+
+			optp = optend;
+		} else
+			fmatch = FMATCH_OPT_WRONG;
+
+		if (fmatch != FMATCH_OK)
+			break;
+	}
+
+	if (fmatch != FMATCH_OPT_WRONG) {
+		fmatch = FMATCH_WRONG;
+
+		switch (check_WSS) {
+		case OSF_WSS_PLAIN:
+			if (f->wss.val == 0 || window == f->wss.val)
+				fmatch = FMATCH_OK;
+			break;
+		case OSF_WSS_MSS:
+			/*
+			 * Some smart modems decrease mangle MSS to
+			 * SMART_MSS_2, so we check standard, decreased
+			 * and the one provided in the fingerprint MSS
+			 * values.
+			 */
+#define SMART_MSS_1	1460
+#define SMART_MSS_2	1448
+			if (window == f->wss.val * mss ||
+			    window == f->wss.val * SMART_MSS_1 ||
+			    window == f->wss.val * SMART_MSS_2)
+				fmatch = FMATCH_OK;
+			break;
+		case OSF_WSS_MTU:
+			if (window == f->wss.val * (mss + 40) ||
+			    window == f->wss.val * (SMART_MSS_1 + 40) ||
+			    window == f->wss.val * (SMART_MSS_2 + 40))
+				fmatch = FMATCH_OK;
+			break;
+		case OSF_WSS_MODULO:
+			if ((window % f->wss.val) == 0)
+				fmatch = FMATCH_OK;
+			break;
+		}
+	}
+
+	return fmatch == FMATCH_OK;
+}
+
 bool
 nf_osf_match(const struct sk_buff *skb, u_int8_t family,
 	     int hooknum, struct net_device *in, struct net_device *out,
@@ -59,15 +156,16 @@ nf_osf_match(const struct sk_buff *skb, u_int8_t family,
 	     const struct list_head *nf_osf_fingers)
 {
 	const unsigned char *optp = NULL, *_optp = NULL;
-	unsigned int optsize = 0, check_WSS = 0;
-	int fmatch = FMATCH_WRONG, fcount = 0;
 	const struct iphdr *ip = ip_hdr(skb);
 	const struct nf_osf_user_finger *f;
 	unsigned char opts[MAX_IPOPTLEN];
 	const struct nf_osf_finger *kf;
-	u16 window, totlen, mss = 0;
+	int fcount = 0, ttl_check;
+	int fmatch = FMATCH_WRONG;
+	unsigned int optsize = 0;
 	const struct tcphdr *tcp;
 	struct tcphdr _tcph;
+	u16 window, totlen;
 	bool df;
 
 	tcp = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(struct tcphdr), &_tcph);
@@ -88,103 +186,20 @@ nf_osf_match(const struct sk_buff *skb, u_int8_t family,
 				sizeof(struct tcphdr), optsize, opts);
 	}
 
+	ttl_check = (info->flags & NF_OSF_TTL) ? info->ttl : -1;
+
 	list_for_each_entry_rcu(kf, &nf_osf_fingers[df], finger_entry) {
-		int foptsize, optnum;
 
 		f = &kf->finger;
 
 		if (!(info->flags & NF_OSF_LOG) && strcmp(info->genre, f->genre))
 			continue;
 
-		optp = _optp;
-		fmatch = FMATCH_WRONG;
-
-		if (totlen != f->ss || !nf_osf_ttl(skb, info, f->ttl))
-			continue;
-
-		/*
-		 * Should not happen if userspace parser was written correctly.
-		 */
-		if (f->wss.wc >= OSF_WSS_MAX)
+		if (!nf_osf_match_one(skb, f,
+				      ttl_check, totlen, window, optp, optsize))
 			continue;
 
-		/* Check options */
-
-		foptsize = 0;
-		for (optnum = 0; optnum < f->opt_num; ++optnum)
-			foptsize += f->opt[optnum].length;
-
-		if (foptsize > MAX_IPOPTLEN ||
-		    optsize > MAX_IPOPTLEN ||
-		    optsize != foptsize)
-			continue;
-
-		check_WSS = f->wss.wc;
-
-		for (optnum = 0; optnum < f->opt_num; ++optnum) {
-			if (f->opt[optnum].kind == (*optp)) {
-				__u32 len = f->opt[optnum].length;
-				const __u8 *optend = optp + len;
-
-				fmatch = FMATCH_OK;
-
-				switch (*optp) {
-				case OSFOPT_MSS:
-					mss = optp[3];
-					mss <<= 8;
-					mss |= optp[2];
-
-					mss = ntohs((__force __be16)mss);
-					break;
-				case OSFOPT_TS:
-					break;
-				}
-
-				optp = optend;
-			} else
-				fmatch = FMATCH_OPT_WRONG;
-
-			if (fmatch != FMATCH_OK)
-				break;
-		}
-
-		if (fmatch != FMATCH_OPT_WRONG) {
-			fmatch = FMATCH_WRONG;
-
-			switch (check_WSS) {
-			case OSF_WSS_PLAIN:
-				if (f->wss.val == 0 || window == f->wss.val)
-					fmatch = FMATCH_OK;
-				break;
-			case OSF_WSS_MSS:
-				/*
-				 * Some smart modems decrease mangle MSS to
-				 * SMART_MSS_2, so we check standard, decreased
-				 * and the one provided in the fingerprint MSS
-				 * values.
-				 */
-#define SMART_MSS_1	1460
-#define SMART_MSS_2	1448
-				if (window == f->wss.val * mss ||
-				    window == f->wss.val * SMART_MSS_1 ||
-				    window == f->wss.val * SMART_MSS_2)
-					fmatch = FMATCH_OK;
-				break;
-			case OSF_WSS_MTU:
-				if (window == f->wss.val * (mss + 40) ||
-				    window == f->wss.val * (SMART_MSS_1 + 40) ||
-				    window == f->wss.val * (SMART_MSS_2 + 40))
-					fmatch = FMATCH_OK;
-				break;
-			case OSF_WSS_MODULO:
-				if ((window % f->wss.val) == 0)
-					fmatch = FMATCH_OK;
-				break;
-			}
-		}
-
-		if (fmatch != FMATCH_OK)
-			continue;
+		fmatch = FMATCH_OK;
 
 		fcount++;
 
-- 
2.11.0
