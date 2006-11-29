From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 20/33]: sip conntrack: minor cleanup
Date: Wed, 29 Nov 2006 03:09:15 +0100 (MET)
Message-ID: <20061129020915.21082.19707.sendpatchset@localhost.localdomain>
References: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: sip conntrack: minor cleanup

- Use enum for header field enumeration
- Use numerical value instead of pointer to header info structure to
  identify headers, unexport ct_sip_hdrs
- group SIP and SDP entries in header info structure
- remove double forward declaration of ct_sip_get_info

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c41ecbacb167a4adce826db76be55a0c0e089c79
tree 6f70ca81c15bd4da64281bd644c3801722fe6a4c
parent be8302ed9dba541073030f78208bd96304f13964
author Patrick McHardy <kaber@trash.net> Tue, 28 Nov 2006 23:13:28 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 29 Nov 2006 02:32:49 +0100

 include/linux/netfilter_ipv4/ip_conntrack_sip.h |   28 ++++-------
 net/ipv4/netfilter/ip_conntrack_sip.c           |   60 ++++++++++++-----------
 net/ipv4/netfilter/ip_nat_sip.c                 |   30 +++++-------
 3 files changed, 55 insertions(+), 63 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_conntrack_sip.h b/include/linux/netfilter_ipv4/ip_conntrack_sip.h
index 913dad6..2a15eb5 100644
--- a/include/linux/netfilter_ipv4/ip_conntrack_sip.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack_sip.h
@@ -5,23 +5,15 @@ #ifdef __KERNEL__
 #define SIP_PORT	5060
 #define SIP_TIMEOUT	3600
 
-#define POS_VIA		0
-#define POS_CONTACT	1
-#define POS_CONTENT	2
-#define POS_MEDIA	3
-#define POS_OWNER	4
-#define POS_CONNECTION	5
-#define POS_REQ_HEADER	6
-#define POS_SDP_HEADER	7
-
-struct sip_header_nfo {
-	const char	*lname;
-	const char	*sname;
-	const char	*ln_str;
-	size_t		lnlen;
-	size_t		snlen;
-	size_t		ln_strlen;
-	int		(*match_len)(const char *, const char *, int *);
+enum sip_header_pos {
+	POS_REQ_HEADER,
+	POS_VIA,
+	POS_CONTACT,
+	POS_CONTENT,
+	POS_MEDIA,
+	POS_OWNER,
+	POS_CONNECTION,
+	POS_SDP_HEADER,
 };
 
 extern unsigned int (*ip_nat_sip_hook)(struct sk_buff **pskb,
@@ -36,7 +28,7 @@ extern unsigned int (*ip_nat_sdp_hook)(s
 extern int ct_sip_get_info(const char *dptr, size_t dlen,
 			   unsigned int *matchoff,
 			   unsigned int *matchlen,
-			   struct sip_header_nfo *hnfo);
+			   enum sip_header_pos pos);
 extern int ct_sip_lnlen(const char *line, const char *limit);
 extern const char *ct_sip_search(const char *needle, const char *haystack,
                                  size_t needle_len, size_t haystack_len);
diff --git a/net/ipv4/netfilter/ip_conntrack_sip.c b/net/ipv4/netfilter/ip_conntrack_sip.c
index bf423db..cc31765 100644
--- a/net/ipv4/netfilter/ip_conntrack_sip.c
+++ b/net/ipv4/netfilter/ip_conntrack_sip.c
@@ -52,20 +52,32 @@ unsigned int (*ip_nat_sdp_hook)(struct s
 				const char *dptr);
 EXPORT_SYMBOL_GPL(ip_nat_sdp_hook);
 
-int ct_sip_get_info(const char *dptr, size_t dlen,
-				unsigned int *matchoff,
-				unsigned int *matchlen,
-				struct sip_header_nfo *hnfo);
-EXPORT_SYMBOL_GPL(ct_sip_get_info);
-
-
 static int digits_len(const char *dptr, const char *limit, int *shift);
 static int epaddr_len(const char *dptr, const char *limit, int *shift);
 static int skp_digits_len(const char *dptr, const char *limit, int *shift);
 static int skp_epaddr_len(const char *dptr, const char *limit, int *shift);
 
-struct sip_header_nfo ct_sip_hdrs[] = {
-	{ 	/* Via header */
+struct sip_header_nfo {
+	const char	*lname;
+	const char	*sname;
+	const char	*ln_str;
+	size_t		lnlen;
+	size_t		snlen;
+	size_t		ln_strlen;
+	int		(*match_len)(const char *, const char *, int *);
+};
+
+static struct sip_header_nfo ct_sip_hdrs[] = {
+	[POS_REQ_HEADER] = { 	/* SIP Requests headers */
+		.lname		= "sip:",
+		.lnlen		= sizeof("sip:") - 1,
+		.sname		= "sip:",
+		.snlen		= sizeof("sip:") - 1, /* yes, i know.. ;) */
+		.ln_str		= "@",
+		.ln_strlen	= sizeof("@") - 1,
+		.match_len	= epaddr_len
+	},
+	[POS_VIA] = { 		/* SIP Via header */
 		.lname		= "Via:",
 		.lnlen		= sizeof("Via:") - 1,
 		.sname		= "\r\nv:",
@@ -74,7 +86,7 @@ struct sip_header_nfo ct_sip_hdrs[] = {
 		.ln_strlen	= sizeof("UDP ") - 1,
 		.match_len	= epaddr_len,
 	},
-	{ 	/* Contact header */
+	[POS_CONTACT] = { 	/* SIP Contact header */
 		.lname		= "Contact:",
 		.lnlen		= sizeof("Contact:") - 1,
 		.sname		= "\r\nm:",
@@ -83,7 +95,7 @@ struct sip_header_nfo ct_sip_hdrs[] = {
 		.ln_strlen	= sizeof("sip:") - 1,
 		.match_len	= skp_epaddr_len
 	},
-	{ 	/* Content length header */
+	[POS_CONTENT] = { 	/* SIP Content length header */
 		.lname		= "Content-Length:",
 		.lnlen		= sizeof("Content-Length:") - 1,
 		.sname		= "\r\nl:",
@@ -92,7 +104,7 @@ struct sip_header_nfo ct_sip_hdrs[] = {
 		.ln_strlen	= sizeof(":") - 1,
 		.match_len	= skp_digits_len
 	},
-	{	/* SDP media info */
+	[POS_MEDIA] = {		/* SDP media info */
 		.lname		= "\nm=",
 		.lnlen		= sizeof("\nm=") - 1,
 		.sname		= "\rm=",
@@ -101,7 +113,7 @@ struct sip_header_nfo ct_sip_hdrs[] = {
 		.ln_strlen	= sizeof("audio ") - 1,
 		.match_len	= digits_len
 	},
-	{ 	/* SDP owner address*/
+	[POS_OWNER] = { 	/* SDP owner address*/
 		.lname		= "\no=",
 		.lnlen		= sizeof("\no=") - 1,
 		.sname		= "\ro=",
@@ -110,7 +122,7 @@ struct sip_header_nfo ct_sip_hdrs[] = {
 		.ln_strlen	= sizeof("IN IP4 ") - 1,
 		.match_len	= epaddr_len
 	},
-	{ 	/* SDP connection info */
+	[POS_CONNECTION] = { 	/* SDP connection info */
 		.lname		= "\nc=",
 		.lnlen		= sizeof("\nc=") - 1,
 		.sname		= "\rc=",
@@ -119,16 +131,7 @@ struct sip_header_nfo ct_sip_hdrs[] = {
 		.ln_strlen	= sizeof("IN IP4 ") - 1,
 		.match_len	= epaddr_len
 	},
-	{ 	/* Requests headers */
-		.lname		= "sip:",
-		.lnlen		= sizeof("sip:") - 1,
-		.sname		= "sip:",
-		.snlen		= sizeof("sip:") - 1, /* yes, i know.. ;) */
-		.ln_str		= "@",
-		.ln_strlen	= sizeof("@") - 1,
-		.match_len	= epaddr_len
-	},
-	{ 	/* SDP version header */
+	[POS_SDP_HEADER] = { 	/* SDP version header */
 		.lname		= "\nv=",
 		.lnlen		= sizeof("\nv=") - 1,
 		.sname		= "\rv=",
@@ -138,7 +141,6 @@ struct sip_header_nfo ct_sip_hdrs[] = {
 		.match_len	= digits_len
 	}
 };
-EXPORT_SYMBOL_GPL(ct_sip_hdrs);
 
 /* get line lenght until first CR or LF seen. */
 int ct_sip_lnlen(const char *line, const char *limit)
@@ -263,8 +265,9 @@ static int skp_epaddr_len(const char *dp
 int ct_sip_get_info(const char *dptr, size_t dlen,
 		    unsigned int *matchoff,
 		    unsigned int *matchlen,
-		    struct sip_header_nfo *hnfo)
+		    enum sip_header_pos pos)
 {
+	struct sip_header_nfo *hnfo = &ct_sip_hdrs[pos];
 	const char *limit, *aux, *k = dptr;
 	int shift = 0;
 
@@ -298,6 +301,7 @@ int ct_sip_get_info(const char *dptr, si
 	DEBUGP("%s header not found.\n", hnfo->lname);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ct_sip_get_info);
 
 static int set_expected_rtp(struct sk_buff **pskb,
 			    struct ip_conntrack *ct,
@@ -393,7 +397,7 @@ static int sip_help(struct sk_buff **psk
 	}
 	/* Get ip and port address from SDP packet. */
 	if (ct_sip_get_info(dptr, datalen, &matchoff, &matchlen,
-	                    &ct_sip_hdrs[POS_CONNECTION]) > 0) {
+	                    POS_CONNECTION) > 0) {
 
 		/* We'll drop only if there are parse problems. */
 		if (parse_ipaddr(dptr + matchoff, NULL, &ipaddr,
@@ -402,7 +406,7 @@ static int sip_help(struct sk_buff **psk
 			goto out;
 		}
 		if (ct_sip_get_info(dptr, datalen, &matchoff, &matchlen,
-		                    &ct_sip_hdrs[POS_MEDIA]) > 0) {
+		                    POS_MEDIA) > 0) {
 
 			port = simple_strtoul(dptr + matchoff, NULL, 10);
 			if (port < 1024) {
diff --git a/net/ipv4/netfilter/ip_nat_sip.c b/net/ipv4/netfilter/ip_nat_sip.c
index 9fad980..47097aa 100644
--- a/net/ipv4/netfilter/ip_nat_sip.c
+++ b/net/ipv4/netfilter/ip_nat_sip.c
@@ -29,18 +29,16 @@ #else
 #define DEBUGP(format, args...)
 #endif
 
-extern struct sip_header_nfo ct_sip_hdrs[];
-
 static unsigned int mangle_sip_packet(struct sk_buff **pskb,
 				      enum ip_conntrack_info ctinfo,
 				      struct ip_conntrack *ct,
 				      const char **dptr, size_t dlen,
 				      char *buffer, int bufflen,
-				      struct sip_header_nfo *hnfo)
+				      enum sip_header_pos pos)
 {
 	unsigned int matchlen, matchoff;
 
-	if (ct_sip_get_info(*dptr, dlen, &matchoff, &matchlen, hnfo) <= 0)
+	if (ct_sip_get_info(*dptr, dlen, &matchoff, &matchlen, pos) <= 0)
 		return 0;
 
 	if (!ip_nat_mangle_udp_packet(pskb, ct, ctinfo,
@@ -80,14 +78,13 @@ static unsigned int ip_nat_sip(struct sk
 		if ((ctinfo) < IP_CT_IS_REPLY) {
 			mangle_sip_packet(pskb, ctinfo, ct, dptr,
 			                  (*pskb)->len - dataoff,
-			                  buffer, bufflen,
-			                  &ct_sip_hdrs[POS_CONTACT]);
+			                  buffer, bufflen, POS_CONTACT);
 			return 1;
 		}
 
 		if (!mangle_sip_packet(pskb, ctinfo, ct, dptr,
 				       (*pskb)->len - dataoff,
-		                       buffer, bufflen, &ct_sip_hdrs[POS_VIA]))
+		                       buffer, bufflen, POS_VIA))
 			return 0;
 
 		/* This search should ignore case, but later.. */
@@ -102,25 +99,24 @@ static unsigned int ip_nat_sip(struct sk
 
 		return mangle_sip_packet(pskb, ctinfo, ct, dptr,
 					 (*pskb)->len - dataoff,
-		                         buffer, bufflen,
-					 &ct_sip_hdrs[POS_CONTACT]);
+		                         buffer, bufflen, POS_CONTACT);
 	}
 	if ((ctinfo) < IP_CT_IS_REPLY) {
 		if (!mangle_sip_packet(pskb, ctinfo, ct, dptr,
 				       (*pskb)->len - dataoff,
-		                       buffer, bufflen, &ct_sip_hdrs[POS_VIA]))
+		                       buffer, bufflen, POS_VIA))
 			return 0;
 
 		/* Mangle Contact if exists only. - watch udp_nat_mangle()! */
 		mangle_sip_packet(pskb, ctinfo, ct, dptr, (*pskb)->len - dataoff,
-		                  buffer, bufflen, &ct_sip_hdrs[POS_CONTACT]);
+		                  buffer, bufflen, POS_CONTACT);
 		return 1;
 	}
 	/* This mangle requests headers. */
 	return mangle_sip_packet(pskb, ctinfo, ct, dptr,
 	                         ct_sip_lnlen(*dptr,
 				              *dptr + (*pskb)->len - dataoff),
-	                         buffer, bufflen, &ct_sip_hdrs[POS_REQ_HEADER]);
+	                         buffer, bufflen, POS_REQ_HEADER);
 }
 
 static int mangle_content_len(struct sk_buff **pskb,
@@ -136,7 +132,7 @@ static int mangle_content_len(struct sk_
 
 	/* Get actual SDP lenght */
 	if (ct_sip_get_info(dptr, (*pskb)->len - dataoff, &matchoff,
-	                    &matchlen, &ct_sip_hdrs[POS_SDP_HEADER]) > 0) {
+	                    &matchlen, POS_SDP_HEADER) > 0) {
 
 		/* since ct_sip_get_info() give us a pointer passing 'v='
 		   we need to add 2 bytes in this count. */
@@ -144,7 +140,7 @@ static int mangle_content_len(struct sk_
 
 		/* Now, update SDP lenght */
 		if (ct_sip_get_info(dptr, (*pskb)->len - dataoff, &matchoff,
-		                    &matchlen, &ct_sip_hdrs[POS_CONTENT]) > 0) {
+		                    &matchlen, POS_CONTENT) > 0) {
 
 			bufflen = sprintf(buffer, "%u", c_len);
 
@@ -170,17 +166,17 @@ static unsigned int mangle_sdp(struct sk
 	/* Mangle owner and contact info. */
 	bufflen = sprintf(buffer, "%u.%u.%u.%u", NIPQUAD(newip));
 	if (!mangle_sip_packet(pskb, ctinfo, ct, &dptr, (*pskb)->len - dataoff,
-	                       buffer, bufflen, &ct_sip_hdrs[POS_OWNER]))
+	                       buffer, bufflen, POS_OWNER))
 		return 0;
 
 	if (!mangle_sip_packet(pskb, ctinfo, ct, &dptr, (*pskb)->len - dataoff,
-	                       buffer, bufflen, &ct_sip_hdrs[POS_CONNECTION]))
+	                       buffer, bufflen, POS_CONNECTION))
 		return 0;
 
 	/* Mangle media port. */
 	bufflen = sprintf(buffer, "%u", port);
 	if (!mangle_sip_packet(pskb, ctinfo, ct, &dptr, (*pskb)->len - dataoff,
-	                       buffer, bufflen, &ct_sip_hdrs[POS_MEDIA]))
+	                       buffer, bufflen, POS_MEDIA))
 		return 0;
 
 	return mangle_content_len(pskb, ctinfo, ct, dptr);
