From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/2] qa: nfct_cmp: verify individual attr comparision
Date: Wed,  5 Jun 2013 22:30:43 +0200
Message-ID: <1370464243-8130-2-git-send-email-fw@strlen.de>
References: <1370464243-8130-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42171 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932065Ab3FEUcC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:32:02 -0400
In-Reply-To: <1370464243-8130-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

For each attribute:
 - copy ct2 attrs to ct1 (so they're the same)
 - change value of attr
 - call nfct_cmp to check of cmp now fails

Unfortunately, most attributes fail this test at this time, thus
added a TODO exclusion list to make the test pass for now.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
It would be nice if others could have a look at the
FIXME switch in the patch below, and perhaps add
comments for those attributes that are intentionally
omitted from comparisions.

diff --git a/qa/test_api.c b/qa/test_api.c
index aea4bc0..583feb8 100644
--- a/qa/test_api.c
+++ b/qa/test_api.c
@@ -36,6 +36,7 @@ static void test_nfct_bitmask(void)
 {
 	struct nfct_bitmask *a, *b;
 	unsigned short int maxb, i;
+	struct nf_conntrack *ct1, *ct2;
 
 	printf("== test nfct_bitmask_* API ==\n");
 
@@ -79,9 +80,168 @@ static void test_nfct_bitmask(void)
 	}
 
 	nfct_bitmask_destroy(b);
+
+	ct1 = nfct_new();
+	ct2 = nfct_new();
+
+	maxb = rand() & 0xff;
+	maxb += 128;
+	maxb /= 2;
+	a = nfct_bitmask_new(maxb * 2);
+	b = nfct_bitmask_new(maxb);
+	nfct_set_attr(ct1, ATTR_CONNLABELS, a);
+	nfct_set_attr(ct2, ATTR_CONNLABELS, b);
+
+	assert(nfct_cmp(ct1, ct2, NFCT_CMP_ALL) == 1);
+
+	nfct_bitmask_set_bit(a, maxb);
+	nfct_bitmask_set_bit(b, maxb);
+	assert(nfct_cmp(ct1, ct2, NFCT_CMP_ALL) == 1);
+
+	nfct_bitmask_set_bit(a, maxb * 2);
+	assert(nfct_cmp(ct1, ct2, NFCT_CMP_ALL) == 0);
+	nfct_destroy(ct1);
+	nfct_destroy(ct2);
 	printf("OK\n");
 }
 
+/* These attributes cannot be set, ignore them. */
+static int attr_is_readonly(int attr)
+{
+	switch (attr) {
+	case ATTR_ORIG_COUNTER_PACKETS:
+	case ATTR_REPL_COUNTER_PACKETS:
+	case ATTR_ORIG_COUNTER_BYTES:
+	case ATTR_REPL_COUNTER_BYTES:
+	case ATTR_USE:
+	case ATTR_SECCTX:
+	case ATTR_TIMESTAMP_START:
+	case ATTR_TIMESTAMP_STOP:
+		return 1;
+	}
+	return 0;
+}
+
+
+static int test_nfct_cmp_api_single(struct nf_conntrack *ct1,
+				struct nf_conntrack *ct2, int attr)
+{
+	char data[256];
+	struct nfct_bitmask *b;
+	int bit;
+
+	if (attr_is_readonly(attr))
+		return 0;
+
+	switch (attr) {
+	case ATTR_SECMARK: /* obsolete */
+		return 0;
+
+	/* FIXME: not implemented comparators: */
+	case ATTR_SNAT_IPV4:
+	case ATTR_DNAT_IPV4:
+	case ATTR_SNAT_PORT:
+	case ATTR_DNAT_PORT:
+
+	case ATTR_TCP_FLAGS_ORIG:
+	case ATTR_TCP_FLAGS_REPL:
+	case ATTR_TCP_MASK_ORIG:
+	case ATTR_TCP_MASK_REPL:
+
+	case ATTR_MASTER_IPV4_SRC:
+	case ATTR_MASTER_IPV4_DST:
+	case ATTR_MASTER_IPV6_SRC:
+	case ATTR_MASTER_IPV6_DST:
+	case ATTR_MASTER_PORT_SRC:
+	case ATTR_MASTER_PORT_DST:
+	case ATTR_MASTER_L3PROTO:
+	case ATTR_MASTER_L4PROTO:
+
+	case ATTR_ORIG_NAT_SEQ_CORRECTION_POS:
+	case ATTR_ORIG_NAT_SEQ_OFFSET_BEFORE:
+	case ATTR_ORIG_NAT_SEQ_OFFSET_AFTER:
+	case ATTR_REPL_NAT_SEQ_CORRECTION_POS:
+	case ATTR_REPL_NAT_SEQ_OFFSET_BEFORE:
+	case ATTR_REPL_NAT_SEQ_OFFSET_AFTER:
+
+	case ATTR_SCTP_VTAG_ORIG:
+	case ATTR_SCTP_VTAG_REPL:
+
+	case ATTR_HELPER_NAME:
+
+	case ATTR_DCCP_ROLE:
+	case ATTR_DCCP_HANDSHAKE_SEQ:
+
+	case ATTR_TCP_WSCALE_ORIG:
+	case ATTR_TCP_WSCALE_REPL:
+
+	case ATTR_HELPER_INFO:
+		return 0; /* XXX */
+
+	default:
+		break;
+	}
+
+	if (attr >= ATTR_SCTP_STATE) {
+		nfct_set_attr_u8(ct1, ATTR_REPL_L4PROTO, IPPROTO_SCTP);
+		nfct_set_attr_u8(ct1, ATTR_L4PROTO, IPPROTO_SCTP);
+	} else if (attr >= ATTR_TCP_FLAGS_ORIG) {
+		nfct_set_attr_u8(ct1, ATTR_REPL_L4PROTO, IPPROTO_TCP);
+		nfct_set_attr_u8(ct1, ATTR_L4PROTO, IPPROTO_TCP);
+	} else if (attr >= ATTR_ICMP_CODE) {
+		nfct_set_attr_u8(ct1, ATTR_REPL_L4PROTO, IPPROTO_ICMP);
+		nfct_set_attr_u8(ct1, ATTR_L4PROTO, IPPROTO_ICMP);
+	} else if (attr >= ATTR_ORIG_PORT_SRC) {
+		nfct_set_attr_u8(ct1, ATTR_REPL_L4PROTO, IPPROTO_TCP);
+		nfct_set_attr_u8(ct1, ATTR_L4PROTO, IPPROTO_TCP);
+	}
+
+	nfct_copy(ct2, ct1, NFCT_CP_OVERRIDE);
+	memset(data, 42, sizeof(data));
+
+	assert(nfct_attr_is_set(ct1, attr));
+	assert(nfct_attr_is_set(ct2, attr));
+
+	switch (attr) {
+	case ATTR_CONNLABELS:
+	case ATTR_CONNLABELS_MASK:
+		b = (void *) nfct_get_attr(ct1, attr);
+		assert(b);
+		b = nfct_bitmask_clone(b);
+		assert(b);
+		bit = nfct_bitmask_maxbit(b);
+		if (nfct_bitmask_test_bit(b, bit)) {
+			nfct_bitmask_unset_bit(b, bit);
+			assert(!nfct_bitmask_test_bit(b, bit));
+		} else {
+			nfct_bitmask_set_bit(b, bit);
+			assert(nfct_bitmask_test_bit(b, bit));
+		}
+		assert(nfct_cmp(ct1, ct2, NFCT_CMP_ALL) == 1);
+		nfct_set_attr(ct2, attr, b);
+		break;
+	case ATTR_HELPER_INFO:
+		nfct_set_attr_l(ct2, attr, "test", 4);
+		break;
+	default:
+		nfct_set_attr(ct2, attr, data);
+		break;
+	}
+
+	if (nfct_cmp(ct1, ct2, NFCT_CMP_ALL) != 0) {
+		fprintf(stderr, "nfct_cmp assert failure for attr %d\n", attr);
+		fprintf(stderr, "%p, %p, %x, %x\n", nfct_get_attr(ct1, attr),
+				nfct_get_attr(ct2, attr),
+				nfct_get_attr_u32(ct1, attr), nfct_get_attr_u32(ct2, attr));
+		return -1;
+	}
+	if (nfct_cmp(ct1, ct2, NFCT_CMP_ALL|NFCT_CMP_STRICT) != 0) {
+		fprintf(stderr, "nfct_cmp strict assert failure for attr %d\n", attr);
+		return -1;
+	}
+	return 0;
+}
+
 static void test_nfct_cmp_api(struct nf_conntrack *ct1, struct nf_conntrack *ct2)
 {
 	int i;
@@ -111,6 +271,10 @@ static void test_nfct_cmp_api(struct nf_conntrack *ct1, struct nf_conntrack *ct2
 		assert(nfct_cmp(ct1, ct2, NFCT_CMP_ALL|NFCT_CMP_STRICT) == 0);
 		assert(nfct_cmp(ct1, ct2, NFCT_CMP_ALL|NFCT_CMP_MASK) == 0);
 	}
+
+	for (i=0; i < ATTR_MAX ; i++)
+		assert(test_nfct_cmp_api_single(ct1, ct2, i) == 0);
+
 	nfct_copy(ct2, ct1, NFCT_CP_OVERRIDE);
 	for (i=0; i < ATTR_MAX ; i++) {
 		nfct_attr_unset(ct1, i);
@@ -240,17 +404,9 @@ int main(void)
 	ret = fork();
 	if (ret == 0) {
 		for (i=0; i<ATTR_MAX; i++) {
-			/* These attributes cannot be set, ignore them. */
-			switch(i) {
-			case ATTR_ORIG_COUNTER_PACKETS:
-			case ATTR_REPL_COUNTER_PACKETS:
-			case ATTR_ORIG_COUNTER_BYTES:
-			case ATTR_REPL_COUNTER_BYTES:
-			case ATTR_USE:
-			case ATTR_SECCTX:
-			case ATTR_TIMESTAMP_START:
-			case ATTR_TIMESTAMP_STOP:
+			if (attr_is_readonly(i))
 				continue;
+			switch(i) {
 			/* These attributes require special handling */
 			case ATTR_HELPER_INFO:
 				nfct_set_attr_l(ct, i, data, sizeof(data));
-- 
1.8.1.5

