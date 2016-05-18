From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [conntrack-tools PATCH] conntrackd: add support for
 NTA_(S|D)NAT_IPV6
Date: Wed, 18 May 2016 19:05:12 +0200
Message-ID: <146359111275.1329.5525714829523602554.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: fw@strlen.de, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:46304 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752523AbcERRF0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 May 2016 13:05:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

So we can properly sync NATed IPv6 connections.

Thanks to Florian Westphal for originally ponting me to this lack of
support in conntrackd, which saved me a lot of time.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/network.h |    2 ++
 src/build.c       |   33 ++++++++++++++++++++++++++++-----
 src/parse.c       |   17 +++++++++++++++++
 3 files changed, 47 insertions(+), 5 deletions(-)

diff --git a/include/network.h b/include/network.h
index cc312cb..ab04591 100644
--- a/include/network.h
+++ b/include/network.h
@@ -229,6 +229,8 @@ enum nta_attr {
 	NTA_TCP_WSCALE_REPL,	/* uint8_t */
 	NTA_HELPER_NAME,	/* string (variable length) */
 	NTA_LABELS,		/* array of uint32_t (variable length) */
+	NTA_SNAT_IPV6,		/* struct nfct_attr_grp_ipv6 */
+	NTA_DNAT_IPV6,		/* struct nfct_attr_grp_ipv6 */
 	NTA_MAX
 };
 
diff --git a/src/build.c b/src/build.c
index 9ba8b57..5403300 100644
--- a/src/build.c
+++ b/src/build.c
@@ -66,9 +66,16 @@ ct_build_u32(const struct nf_conntrack *ct, int a, struct nethdr *n, int b)
 }
 
 static inline void
-ct_build_str(const struct nf_conntrack *ct, int a, struct nethdr *n, int b)
+ct_build_u128(const struct nf_conntrack *ct, int a, struct nethdr *n, int b)
 {
 	const char *data = nfct_get_attr(ct, a);
+	addattr(n, b, data, sizeof(uint32_t) * 4);
+}
+
+static inline void
+ct_build_str(const struct nf_conntrack *ct, int a, struct nethdr *n, int b)
+{
+	const void *data = nfct_get_attr(ct, a);
 	addattr(n, b, data, strlen(data)+1);
 }
 
@@ -258,10 +265,26 @@ void ct2msg(const struct nf_conntrack *ct, struct nethdr *n)
 	}
 
 	/*  NAT */
-	if (nfct_getobjopt(ct, NFCT_GOPT_IS_SNAT))
-		ct_build_u32(ct, ATTR_REPL_IPV4_DST, n, NTA_SNAT_IPV4);
-	if (nfct_getobjopt(ct, NFCT_GOPT_IS_DNAT))
-		ct_build_u32(ct, ATTR_REPL_IPV4_SRC, n, NTA_DNAT_IPV4);
+	switch (nfct_get_attr_u8(ct, ATTR_ORIG_L3PROTO)) {
+	case AF_INET:
+		if (nfct_getobjopt(ct, NFCT_GOPT_IS_SNAT))
+			ct_build_u32(ct, ATTR_REPL_IPV4_DST, n, NTA_SNAT_IPV4);
+		if (nfct_getobjopt(ct, NFCT_GOPT_IS_DNAT))
+			ct_build_u32(ct, ATTR_REPL_IPV4_SRC, n, NTA_DNAT_IPV4);
+		break;
+	case AF_INET6:
+		if (nfct_getobjopt(ct, NFCT_GOPT_IS_SNAT)) {
+			ct_build_u128(ct, ATTR_REPL_IPV6_DST, n,
+				      NTA_SNAT_IPV6);
+		}
+		if (nfct_getobjopt(ct, NFCT_GOPT_IS_DNAT)) {
+			ct_build_u128(ct, ATTR_REPL_IPV6_SRC, n,
+				      NTA_DNAT_IPV6);
+		}
+		break;
+	default:
+		break;
+	}
 	if (nfct_getobjopt(ct, NFCT_GOPT_IS_SPAT))
 		ct_build_u16(ct, ATTR_REPL_PORT_DST, n, NTA_SPAT_PORT);
 	if (nfct_getobjopt(ct, NFCT_GOPT_IS_DPAT))
diff --git a/src/parse.c b/src/parse.c
index 919d36c..d5d9b59 100644
--- a/src/parse.c
+++ b/src/parse.c
@@ -29,6 +29,7 @@
 static void ct_parse_u8(struct nf_conntrack *ct, int attr, void *data);
 static void ct_parse_u16(struct nf_conntrack *ct, int attr, void *data);
 static void ct_parse_u32(struct nf_conntrack *ct, int attr, void *data);
+static void ct_parse_u128(struct nf_conntrack *ct, int attr, void *data);
 static void ct_parse_str(struct nf_conntrack *ct,
 			 const struct netattr *, void *data);
 static void ct_parse_group(struct nf_conntrack *ct, int attr, void *data);
@@ -189,6 +190,16 @@ static struct ct_parser h[NTA_MAX] = {
 		.attr	= ATTR_CONNLABELS,
 		.max_size = NTA_SIZE(NTA_LABELS_MAX_SIZE),
 	},
+	[NTA_SNAT_IPV6]	= {
+		.parse	= ct_parse_u128,
+		.attr	= ATTR_SNAT_IPV6,
+		.size	= NTA_SIZE(sizeof(uint32_t) * 4),
+	},
+	[NTA_DNAT_IPV6] = {
+		.parse	= ct_parse_u128,
+		.attr	= ATTR_DNAT_IPV6,
+		.size	= NTA_SIZE(sizeof(uint32_t) * 4),
+	},
 };
 
 static void
@@ -213,6 +224,12 @@ ct_parse_u32(struct nf_conntrack *ct, int attr, void *data)
 }
 
 static void
+ct_parse_u128(struct nf_conntrack *ct, int attr, void *data)
+{
+	nfct_set_attr(ct, h[attr].attr, data);
+}
+
+static void
 ct_parse_str(struct nf_conntrack *ct, const struct netattr *attr, void *data)
 {
 	nfct_set_attr(ct, h[attr->nta_attr].attr, data);

