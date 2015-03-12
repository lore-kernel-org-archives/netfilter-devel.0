From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH lnf-ct 1/2] conntrack: add mark event filter
Date: Fri, 13 Mar 2015 07:21:40 +0900
Message-ID: <20150312222139.GB20782@gmail.com>
References: <20150312221826.GA20782@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:42074 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbbCLWVr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Mar 2015 18:21:47 -0400
Received: by padfa1 with SMTP id fa1so23954931pad.9
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2015 15:21:47 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150312221826.GA20782@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds mark filter for event listener, using same struct
nfct_filter_dump_mark at dump.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 include/internal/object.h                          |  7 +++
 .../libnetfilter_conntrack.h                       |  1 +
 src/conntrack/bsf.c                                | 73 ++++++++++++++++++++++
 src/conntrack/filter.c                             | 13 ++++
 4 files changed, 94 insertions(+)

diff --git a/include/internal/object.h b/include/internal/object.h
index 540ad0d..1259467 100644
--- a/include/internal/object.h
+++ b/include/internal/object.h
@@ -263,6 +263,13 @@ struct nfct_filter {
 		u_int32_t 	mask[4];
 	} l3proto_ipv6[2][__FILTER_IPV6_MAX];
 
+	u_int32_t 		mark_elems;
+	struct {
+#define __FILTER_MARK_MAX	127
+		u_int32_t 	val;
+		u_int32_t 	mask;
+	} mark[__FILTER_MARK_MAX];
+
 	u_int32_t 		set[1];
 };
 
diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
index d04a0c6..cea9a78 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
@@ -499,6 +499,7 @@ enum nfct_filter_attr {
 	NFCT_FILTER_DST_IPV4,		/* struct nfct_filter_ipv4 */
 	NFCT_FILTER_SRC_IPV6,		/* struct nfct_filter_ipv6 */
 	NFCT_FILTER_DST_IPV6,		/* struct nfct_filter_ipv6 */
+	NFCT_FILTER_MARK,		/* struct nfct_filter_dump_mark */
 	NFCT_FILTER_MAX
 };
 
diff --git a/src/conntrack/bsf.c b/src/conntrack/bsf.c
index 534202f..bc73369 100644
--- a/src/conntrack/bsf.c
+++ b/src/conntrack/bsf.c
@@ -55,6 +55,9 @@ static char *code2str(u_int16_t code)
 	case BPF_MISC|BPF_TAX:
 		return "BPF_MISC|BPF_TAX";
 		break;
+	case BPF_MISC|BPF_TXA:
+		return "BPF_MISC|BPF_TXA";
+		break;
 	case BPF_LD|BPF_B|BPF_IND:
 		return "BPF_LD|BPF_B|BPF_IND";
 		break;
@@ -228,6 +231,16 @@ nfct_bsf_x_equal_a(struct sock_filter *this, int pos)
 }
 
 static int
+nfct_bsf_a_equal_x(struct sock_filter *this, int pos)
+{
+	struct sock_filter __code = {
+		.code	= BPF_MISC|BPF_TXA,
+	};
+	memcpy(&this[pos], &__code, sizeof(__code));
+	return NEW_POS(__code);
+}
+
+static int
 nfct_bsf_load_attr(struct sock_filter *this, int word_size, int pos)
 {
 	struct sock_filter __code = {
@@ -663,6 +676,63 @@ bsf_add_daddr_ipv6_filter(const struct nfct_filter *f, struct sock_filter *this)
 	return bsf_add_addr_ipv6_filter(f, this, CTA_IP_V6_DST);
 }
 
+static int
+bsf_add_mark_filter(const struct nfct_filter *f, struct sock_filter *this)
+{
+	unsigned int i, j;
+	unsigned int jt;
+	struct stack *s;
+	struct jump jmp;
+	struct sock_filter __code = {
+		/* if (A == 0) skip next two */
+		.code = BPF_JMP|BPF_JEQ|BPF_K,
+		.k = 0,
+		.jt = 2,
+		.jf = 0,
+	};
+
+	/* nothing to filter, skip */
+	if (f->mark_elems == 0)
+		return 0;
+
+	/* XXX: see bsf_add_addr_ipv4_filter() */
+	s = stack_create(sizeof(struct jump), 3 + 127);
+	if (s == NULL) {
+		errno = ENOMEM;
+		return -1;
+	}
+
+	jt = 1;
+	j = 0;
+	j += nfct_bsf_load_payload_offset(this, j);	/* A = nla header offset 		*/
+	j += nfct_bsf_find_attr(this, CTA_MARK, j);	/* A = CTA_MARK offset, started from A	*/
+	memcpy(&this[j], &__code, sizeof(__code));	/* if A == 0 skip next two op		*/
+	j += NEW_POS(__code);
+	j += nfct_bsf_x_equal_a(this, j);		/* X = A <CTA_MARK offset>		*/
+	j += nfct_bsf_load_attr(this, BPF_W, j);	/* A = skb->data[X:X + BPF_W]		*/
+	j += nfct_bsf_x_equal_a(this, j);		/* X = A <CTA_MARK value>		*/
+
+	for (i = 0; i < f->mark_elems; i++) {
+		int mark = f->mark[i].val & f->mark[i].mask;
+
+		j += nfct_bsf_alu_and(this, f->mark[i].mask, j);
+		j += nfct_bsf_cmp_k_stack(this, mark, jt - j, j, s);
+		j += nfct_bsf_a_equal_x(this, j);
+	}
+
+	while (stack_pop(s, &jmp) != -1)
+		this[jmp.line].jt += jmp.jt + j;
+
+	if (f->logic[NFCT_FILTER_MARK] == NFCT_FILTER_LOGIC_NEGATIVE)
+		j += nfct_bsf_jump_to(this, 1, j);
+
+	j += nfct_bsf_ret_verdict(this, NFCT_FILTER_REJECT, j);
+
+	stack_destroy(s);
+
+	return j;
+}
+
 /* this buffer must be big enough to store all the autogenerated lines */
 #define BSF_BUFFER_SIZE 	2048
 
@@ -696,6 +766,9 @@ int __setup_netlink_socket_filter(int fd, struct nfct_filter *f)
 	j += bsf_add_state_filter(f, &bsf[j]);
 	show_filter(bsf, from, j, "---- check state ----");
 	from = j;
+	j += bsf_add_mark_filter(f, &bsf[j]);
+	show_filter(bsf, from, j, "---- check mark ----");
+	from = j;
 
 	/* nothing to filter, skip */
 	if (j == 0)
diff --git a/src/conntrack/filter.c b/src/conntrack/filter.c
index 026545a..78fbbc5 100644
--- a/src/conntrack/filter.c
+++ b/src/conntrack/filter.c
@@ -79,6 +79,18 @@ static void filter_attr_dst_ipv6(struct nfct_filter *filter, const void *value)
 	filter->l3proto_elems_ipv6[1]++;
 }
 
+static void filter_attr_mark(struct nfct_filter *filter, const void *value)
+{
+	const struct nfct_filter_dump_mark *this = value;
+
+	if (filter->mark_elems >= __FILTER_MARK_MAX)
+		return;
+
+	filter->mark[filter->mark_elems].val = this->val;
+	filter->mark[filter->mark_elems].mask = this->mask;
+	filter->mark_elems++;
+}
+
 const filter_attr filter_attr_array[NFCT_FILTER_MAX] = {
 	[NFCT_FILTER_L4PROTO]		= filter_attr_l4proto,
 	[NFCT_FILTER_L4PROTO_STATE]	= filter_attr_l4proto_state,
@@ -86,4 +98,5 @@ const filter_attr filter_attr_array[NFCT_FILTER_MAX] = {
 	[NFCT_FILTER_DST_IPV4]		= filter_attr_dst_ipv4,
 	[NFCT_FILTER_SRC_IPV6]		= filter_attr_src_ipv6,
 	[NFCT_FILTER_DST_IPV6]		= filter_attr_dst_ipv6,
+	[NFCT_FILTER_MARK]		= filter_attr_mark,
 };
-- 
2.1.4

