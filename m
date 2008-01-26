From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 02/10] [NETFILTER]: annotate nf_{conntrack,nat}_sip with
 const
Date: Sat, 26 Jan 2008 02:37:04 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801260236560.15243@fbirervta.pbzchgretzou.qr>
References: <fd8d288fb2570e7feabc650d002d36a3070b43a1.1201311315.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48209 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbYAZBhF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jan 2008 20:37:05 -0500
In-Reply-To: <fd8d288fb2570e7feabc650d002d36a3070b43a1.1201311315.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 include/linux/netfilter/nf_conntrack_sip.h |    6 ++--
 net/ipv4/netfilter/nf_nat_sip.c            |    4 +-
 net/netfilter/nf_conntrack_sip.c           |   25 ++++++++++---------
 3 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index 9fff197..8e5ce1c 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -30,9 +30,9 @@ extern unsigned int (*nf_nat_sdp_hook)(struct sk_buff *skb,
 				       struct nf_conntrack_expect *exp,
 				       const char *dptr);
 
-extern int ct_sip_get_info(struct nf_conn *ct, const char *dptr, size_t dlen,
-			   unsigned int *matchoff, unsigned int *matchlen,
-			   enum sip_header_pos pos);
+extern int ct_sip_get_info(const struct nf_conn *ct, const char *dptr,
+                           size_t dlen, unsigned int *matchoff,
+                           unsigned int *matchlen, enum sip_header_pos pos);
 extern int ct_sip_lnlen(const char *line, const char *limit);
 extern const char *ct_sip_search(const char *needle, const char *haystack,
 				 size_t needle_len, size_t haystack_len,
diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index 606a170..b4c8d49 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -35,9 +35,9 @@ struct addr_map {
 	} addr[IP_CT_DIR_MAX];
 };
 
-static void addr_map_init(struct nf_conn *ct, struct addr_map *map)
+static void addr_map_init(const struct nf_conn *ct, struct addr_map *map)
 {
-	struct nf_conntrack_tuple *t;
+	const struct nf_conntrack_tuple *t;
 	enum ip_conntrack_dir dir;
 	unsigned int n;
 
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 47d8947..94180f8 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -48,10 +48,10 @@ unsigned int (*nf_nat_sdp_hook)(struct sk_buff *skb,
 				const char *dptr) __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_sdp_hook);
 
-static int digits_len(struct nf_conn *, const char *, const char *, int *);
-static int epaddr_len(struct nf_conn *, const char *, const char *, int *);
-static int skp_digits_len(struct nf_conn *, const char *, const char *, int *);
-static int skp_epaddr_len(struct nf_conn *, const char *, const char *, int *);
+static int digits_len(const struct nf_conn *, const char *, const char *, int *);
+static int epaddr_len(const struct nf_conn *, const char *, const char *, int *);
+static int skp_digits_len(const struct nf_conn *, const char *, const char *, int *);
+static int skp_epaddr_len(const struct nf_conn *, const char *, const char *, int *);
 
 struct sip_header_nfo {
 	const char	*lname;
@@ -61,7 +61,7 @@ struct sip_header_nfo {
 	size_t		snlen;
 	size_t		ln_strlen;
 	int		case_sensitive;
-	int		(*match_len)(struct nf_conn *, const char *,
+	int		(*match_len)(const struct nf_conn *, const char *,
 				     const char *, int *);
 };
 
@@ -225,7 +225,7 @@ const char *ct_sip_search(const char *needle, const char *haystack,
 }
 EXPORT_SYMBOL_GPL(ct_sip_search);
 
-static int digits_len(struct nf_conn *ct, const char *dptr,
+static int digits_len(const struct nf_conn *ct, const char *dptr,
 		      const char *limit, int *shift)
 {
 	int len = 0;
@@ -237,7 +237,7 @@ static int digits_len(struct nf_conn *ct, const char *dptr,
 }
 
 /* get digits length, skipping blank spaces. */
-static int skp_digits_len(struct nf_conn *ct, const char *dptr,
+static int skp_digits_len(const struct nf_conn *ct, const char *dptr,
 			  const char *limit, int *shift)
 {
 	for (; dptr <= limit && *dptr == ' '; dptr++)
@@ -246,8 +246,9 @@ static int skp_digits_len(struct nf_conn *ct, const char *dptr,
 	return digits_len(ct, dptr, limit, shift);
 }
 
-static int parse_addr(struct nf_conn *ct, const char *cp, const char **endp,
-		      union nf_inet_addr *addr, const char *limit)
+static int parse_addr(const struct nf_conn *ct, const char *cp,
+                      const char **endp, union nf_inet_addr *addr,
+                      const char *limit)
 {
 	const char *end;
 	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
@@ -272,7 +273,7 @@ static int parse_addr(struct nf_conn *ct, const char *cp, const char **endp,
 }
 
 /* skip ip address. returns its length. */
-static int epaddr_len(struct nf_conn *ct, const char *dptr,
+static int epaddr_len(const struct nf_conn *ct, const char *dptr,
 		      const char *limit, int *shift)
 {
 	union nf_inet_addr addr;
@@ -292,7 +293,7 @@ static int epaddr_len(struct nf_conn *ct, const char *dptr,
 }
 
 /* get address length, skiping user info. */
-static int skp_epaddr_len(struct nf_conn *ct, const char *dptr,
+static int skp_epaddr_len(const struct nf_conn *ct, const char *dptr,
 			  const char *limit, int *shift)
 {
 	const char *start = dptr;
@@ -319,7 +320,7 @@ static int skp_epaddr_len(struct nf_conn *ct, const char *dptr,
 }
 
 /* Returns 0 if not found, -1 error parsing. */
-int ct_sip_get_info(struct nf_conn *ct,
+int ct_sip_get_info(const struct nf_conn *ct,
 		    const char *dptr, size_t dlen,
 		    unsigned int *matchoff,
 		    unsigned int *matchlen,
-- 
1.5.3.4

