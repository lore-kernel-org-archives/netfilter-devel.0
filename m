From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 21/33]: sip conntrack: do case insensitive SIP header
	search
Date: Wed, 29 Nov 2006 03:09:17 +0100 (MET)
Message-ID: <20061129020916.21082.27011.sendpatchset@localhost.localdomain>
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

[NETFILTER]: sip conntrack: do case insensitive SIP header search

SIP headers are generally case-insensitive, only SDP headers are
case sensitive.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 74ea88e39e990542e1a7492edb3bc4f0bc254384
tree 21f951afd4ddab54e42683b8e9fee4096e8cc039
parent c41ecbacb167a4adce826db76be55a0c0e089c79
author Patrick McHardy <kaber@trash.net> Tue, 28 Nov 2006 23:13:29 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 29 Nov 2006 02:32:50 +0100

 include/linux/netfilter_ipv4/ip_conntrack_sip.h |    3 ++-
 net/ipv4/netfilter/ip_conntrack_sip.c           |   20 ++++++++++++++++----
 net/ipv4/netfilter/ip_nat_sip.c                 |    7 ++++---
 3 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_conntrack_sip.h b/include/linux/netfilter_ipv4/ip_conntrack_sip.h
index 2a15eb5..51c65ac 100644
--- a/include/linux/netfilter_ipv4/ip_conntrack_sip.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack_sip.h
@@ -31,6 +31,7 @@ extern int ct_sip_get_info(const char *d
 			   enum sip_header_pos pos);
 extern int ct_sip_lnlen(const char *line, const char *limit);
 extern const char *ct_sip_search(const char *needle, const char *haystack,
-                                 size_t needle_len, size_t haystack_len);
+				 size_t needle_len, size_t haystack_len,
+				 int case_sensitive);
 #endif /* __KERNEL__ */
 #endif /* __IP_CONNTRACK_SIP_H__ */
diff --git a/net/ipv4/netfilter/ip_conntrack_sip.c b/net/ipv4/netfilter/ip_conntrack_sip.c
index cc31765..a9c0d1d 100644
--- a/net/ipv4/netfilter/ip_conntrack_sip.c
+++ b/net/ipv4/netfilter/ip_conntrack_sip.c
@@ -64,6 +64,7 @@ struct sip_header_nfo {
 	size_t		lnlen;
 	size_t		snlen;
 	size_t		ln_strlen;
+	int		case_sensitive;
 	int		(*match_len)(const char *, const char *, int *);
 };
 
@@ -105,6 +106,7 @@ static struct sip_header_nfo ct_sip_hdrs
 		.match_len	= skp_digits_len
 	},
 	[POS_MEDIA] = {		/* SDP media info */
+		.case_sensitive	= 1,
 		.lname		= "\nm=",
 		.lnlen		= sizeof("\nm=") - 1,
 		.sname		= "\rm=",
@@ -114,6 +116,7 @@ static struct sip_header_nfo ct_sip_hdrs
 		.match_len	= digits_len
 	},
 	[POS_OWNER] = { 	/* SDP owner address*/
+		.case_sensitive	= 1,
 		.lname		= "\no=",
 		.lnlen		= sizeof("\no=") - 1,
 		.sname		= "\ro=",
@@ -123,6 +126,7 @@ static struct sip_header_nfo ct_sip_hdrs
 		.match_len	= epaddr_len
 	},
 	[POS_CONNECTION] = { 	/* SDP connection info */
+		.case_sensitive	= 1,
 		.lname		= "\nc=",
 		.lnlen		= sizeof("\nc=") - 1,
 		.sname		= "\rc=",
@@ -132,6 +136,7 @@ static struct sip_header_nfo ct_sip_hdrs
 		.match_len	= epaddr_len
 	},
 	[POS_SDP_HEADER] = { 	/* SDP version header */
+		.case_sensitive	= 1,
 		.lname		= "\nv=",
 		.lnlen		= sizeof("\nv=") - 1,
 		.sname		= "\rv=",
@@ -161,13 +166,19 @@ EXPORT_SYMBOL_GPL(ct_sip_lnlen);
 
 /* Linear string search, case sensitive. */
 const char *ct_sip_search(const char *needle, const char *haystack,
-                          size_t needle_len, size_t haystack_len)
+			  size_t needle_len, size_t haystack_len,
+			  int case_sensitive)
 {
 	const char *limit = haystack + (haystack_len - needle_len);
 
 	while (haystack <= limit) {
-		if (memcmp(haystack, needle, needle_len) == 0)
-			return haystack;
+		if (case_sensitive) {
+			if (strncmp(haystack, needle, needle_len) == 0)
+				return haystack;
+		} else {
+			if (strnicmp(haystack, needle, needle_len) == 0)
+				return haystack;
+		}
 		haystack++;
 	}
 	return NULL;
@@ -280,7 +291,8 @@ int ct_sip_get_info(const char *dptr, si
 			continue;
 		}
 		aux = ct_sip_search(hnfo->ln_str, dptr, hnfo->ln_strlen,
-		                    ct_sip_lnlen(dptr, limit));
+		                    ct_sip_lnlen(dptr, limit),
+				    hnfo->case_sensitive);
 		if (!aux) {
 			DEBUGP("'%s' not found in '%s'.\n", hnfo->ln_str,
 			       hnfo->lname);
diff --git a/net/ipv4/netfilter/ip_nat_sip.c b/net/ipv4/netfilter/ip_nat_sip.c
index 47097aa..e16604c 100644
--- a/net/ipv4/netfilter/ip_nat_sip.c
+++ b/net/ipv4/netfilter/ip_nat_sip.c
@@ -87,14 +87,15 @@ static unsigned int ip_nat_sip(struct sk
 		                       buffer, bufflen, POS_VIA))
 			return 0;
 
-		/* This search should ignore case, but later.. */
 		aux = ct_sip_search("CSeq:", *dptr, sizeof("CSeq:") - 1,
-		                    (*pskb)->len - dataoff);
+		                    (*pskb)->len - dataoff, 0);
 		if (!aux)
 			return 0;
 
 		if (!ct_sip_search("REGISTER", aux, sizeof("REGISTER"),
-		    ct_sip_lnlen(aux, *dptr + (*pskb)->len - dataoff)))
+				   ct_sip_lnlen(aux,
+				   		*dptr + (*pskb)->len - dataoff),
+				   1))
 			return 1;
 
 		return mangle_sip_packet(pskb, ctinfo, ct, dptr,
