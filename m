From: Florian Westphal <fw@strlen.de>
Subject: [PATCH conntracktools] conntrackd: support replication of connlabels
Date: Sun, 30 Jun 2013 23:10:47 +0200
Message-ID: <1372626648-19482-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40935 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752447Ab3F3VMZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Jun 2013 17:12:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

- check if ct has label attribute, and at least one label
  (bit) is set
- serialize bitmap into array-of-u32, in network byte order
- add code to build new nfct_bitmask object from array-of-u32

Current parse functions don't have length information,
this adds optional parse2() which gets struct netattr pointer.

Attributes that want to use parse2 need to set .maxsize to nonzero
value.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Change since v1:
 - don't show label names in conntrack -i/-e output

 I'll apply this if noone objects.

 include/network.h |  4 +++
 src/build.c       | 39 ++++++++++++++++++++++++++++
 src/parse.c       | 77 +++++++++++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 110 insertions(+), 10 deletions(-)

diff --git a/include/network.h b/include/network.h
index 79745f3..cc312cb 100644
--- a/include/network.h
+++ b/include/network.h
@@ -228,9 +228,13 @@ enum nta_attr {
 	NTA_TCP_WSCALE_ORIG,	/* uint8_t */
 	NTA_TCP_WSCALE_REPL,	/* uint8_t */
 	NTA_HELPER_NAME,	/* string (variable length) */
+	NTA_LABELS,		/* array of uint32_t (variable length) */
 	NTA_MAX
 };
 
+/* allow to serialize/replicate up to 4k labels per flow */
+#define NTA_LABELS_MAX_SIZE	(4096/sizeof(uint32_t))
+
 struct nta_attr_natseqadj {
 	uint32_t orig_seq_correction_pos;
 	uint32_t orig_seq_offset_before;
diff --git a/src/build.c b/src/build.c
index e15eb4f..5799b51 100644
--- a/src/build.c
+++ b/src/build.c
@@ -158,6 +158,42 @@ static void build_l4proto_udp(const struct nf_conntrack *ct, struct nethdr *n)
 		      sizeof(struct nfct_attr_grp_port));
 }
 
+static void ct_build_clabel(const struct nf_conntrack *ct, struct nethdr *n)
+{
+	const struct nfct_bitmask *b;
+	uint32_t *words;
+	unsigned int wordcount, i, maxbit;
+
+	if (!nfct_attr_is_set(ct, ATTR_CONNLABELS))
+		return;
+
+	b = nfct_get_attr(ct, ATTR_CONNLABELS);
+
+	maxbit = nfct_bitmask_maxbit(b);
+	for (i=0; i <= maxbit; i++) {
+		if (nfct_bitmask_test_bit(b, i))
+			break;
+	}
+
+	if (i > maxbit)
+		return;
+
+	wordcount = (nfct_bitmask_maxbit(b) / 32) + 1;
+	words = put_header(n, NTA_LABELS, wordcount * sizeof(*words));
+
+	for (i=0; i < wordcount; i++) {
+		int bit = 31;
+		uint32_t tmp = 0;
+
+		do {
+			if (nfct_bitmask_test_bit(b, (32 * i) + bit))
+				tmp |= (1 << bit);
+		} while (--bit >= 0);
+
+		words[i] = htonl(tmp);
+	}
+}
+
 #ifndef IPPROTO_DCCP
 #define IPPROTO_DCCP 33
 #endif
@@ -233,6 +269,9 @@ void ct2msg(const struct nf_conntrack *ct, struct nethdr *n)
 
 	if (nfct_attr_is_set(ct, ATTR_HELPER_NAME))
 		ct_build_str(ct, ATTR_HELPER_NAME, n, NTA_HELPER_NAME);
+
+	if (nfct_attr_is_set(ct, ATTR_CONNLABELS))
+		ct_build_clabel(ct, n);
 }
 
 static void
diff --git a/src/parse.c b/src/parse.c
index 8ce4495..f3ec6ac 100644
--- a/src/parse.c
+++ b/src/parse.c
@@ -29,15 +29,19 @@
 static void ct_parse_u8(struct nf_conntrack *ct, int attr, void *data);
 static void ct_parse_u16(struct nf_conntrack *ct, int attr, void *data);
 static void ct_parse_u32(struct nf_conntrack *ct, int attr, void *data);
-static void ct_parse_str(struct nf_conntrack *ct, int attr, void *data);
+static void ct_parse_str(struct nf_conntrack *ct,
+			 const struct netattr *, void *data);
 static void ct_parse_group(struct nf_conntrack *ct, int attr, void *data);
 static void ct_parse_nat_seq_adj(struct nf_conntrack *ct, int attr, void *data);
+static void ct_parse_clabel(struct nf_conntrack *ct,
+			    const struct netattr *, void *data);
 
 struct ct_parser {
 	void 	(*parse)(struct nf_conntrack *ct, int attr, void *data);
-	int 	attr;
-	int	size;
-	int	max_size;
+	void	(*parse2)(struct nf_conntrack *ct, const struct netattr *, void *);
+	uint16_t attr;
+	uint16_t size;
+	uint16_t max_size;
 };
 
 static struct ct_parser h[NTA_MAX] = {
@@ -176,10 +180,15 @@ static struct ct_parser h[NTA_MAX] = {
 		.size	= NTA_SIZE(sizeof(uint8_t)),
 	},
 	[NTA_HELPER_NAME] = {
-		.parse	= ct_parse_str,
+		.parse2	= ct_parse_str,
 		.attr	= ATTR_HELPER_NAME,
 		.max_size = NFCT_HELPER_NAME_MAX,
 	},
+	[NTA_LABELS] = {
+		.parse2 = ct_parse_clabel,
+		.attr	= ATTR_CONNLABELS,
+		.max_size = NTA_SIZE(NTA_LABELS_MAX_SIZE),
+	},
 };
 
 static void
@@ -204,9 +213,9 @@ ct_parse_u32(struct nf_conntrack *ct, int attr, void *data)
 }
 
 static void
-ct_parse_str(struct nf_conntrack *ct, int attr, void *data)
+ct_parse_str(struct nf_conntrack *ct, const struct netattr *attr, void *data)
 {
-	nfct_set_attr(ct, h[attr].attr, data);
+	nfct_set_attr(ct, h[attr->nta_attr].attr, data);
 }
 
 static void
@@ -216,6 +225,44 @@ ct_parse_group(struct nf_conntrack *ct, int attr, void *data)
 }
 
 static void
+ct_parse_clabel(struct nf_conntrack *ct, const struct netattr *attr, void *data)
+{
+	struct nfct_bitmask *bitm;
+	unsigned int i, wordcount;
+	const uint32_t *words;
+	unsigned int len;
+
+	len = attr->nta_len - NTA_LENGTH(0);
+	wordcount =  len / sizeof(*words);
+	if (!wordcount)
+		return;
+
+	if (len & (sizeof(*words) - 1))
+		return;
+
+	bitm = nfct_bitmask_new((len * 8) - 1);
+	if (!bitm)
+		return;
+
+	words = data;
+	for (i=0; i < wordcount; i++) {
+		uint32_t word;
+		int bit;
+
+		if (words[i] == 0)
+			continue;
+
+		word = htonl(words[i]);
+		bit = 31;
+		do {
+			if (word & (1 << bit))
+				nfct_bitmask_set_bit(bitm, (32 * i) + bit);
+		} while (--bit >= 0);
+	}
+	nfct_set_attr(ct, ATTR_CONNLABELS, bitm);
+}
+
+static void
 ct_parse_nat_seq_adj(struct nf_conntrack *ct, int attr, void *data)
 {
 	struct nta_attr_natseqadj *this = data;
@@ -248,14 +295,22 @@ int msg2ct(struct nf_conntrack *ct, struct nethdr *net, size_t remain)
 		ATTR_NETWORK2HOST(attr);
 		if (attr->nta_len > len)
 			return -1;
+		if (attr->nta_len < NTA_LENGTH(0))
+			return -1;
 		if (attr->nta_attr > NTA_MAX)
 			return -1;
 		if (h[attr->nta_attr].size &&
 		    attr->nta_len != h[attr->nta_attr].size)
 			return -1;
-		if (h[attr->nta_attr].max_size &&
-		    attr->nta_len > h[attr->nta_attr].max_size)
-			return -1;
+
+		if (h[attr->nta_attr].max_size) {
+			if (attr->nta_len > h[attr->nta_attr].max_size)
+				return -1;
+			h[attr->nta_attr].parse2(ct, attr, NTA_DATA(attr));
+			attr = NTA_NEXT(attr, len);
+			continue;
+		}
+
 		if (h[attr->nta_attr].parse == NULL) {
 			attr = NTA_NEXT(attr, len);
 			continue;
@@ -457,6 +512,8 @@ int msg2exp(struct nf_expect *exp, struct nethdr *net, size_t remain)
 			goto err;
 		if (attr->nta_attr > NTA_MAX)
 			goto err;
+		if (attr->nta_len < NTA_LENGTH(0))
+			goto err;
 		if (exp_h[attr->nta_attr].size &&
 		    attr->nta_len != exp_h[attr->nta_attr].size)
 			goto err;
-- 
1.8.1.5

