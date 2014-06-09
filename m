From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH libnetfilter_conntrack v2 2/2] conntrack: add zone event
 filter
Date: Mon, 9 Jun 2014 19:04:04 +0900
Message-ID: <20140609100404.GC28658@gmail.com>
References: <20140609095948.GA28658@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:57658 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbaFIKEL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Jun 2014 06:04:11 -0400
Received: by mail-pb0-f47.google.com with SMTP id rp16so4753155pbb.6
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Jun 2014 03:04:10 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140609095948.GA28658@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds zone filter for event listener.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 include/internal/object.h                          |  4 ++
 .../libnetfilter_conntrack.h                       |  1 +
 src/conntrack/bsf.c                                | 71 +++++++++++++++++++---
 src/conntrack/filter.c                             | 10 +++
 4 files changed, 77 insertions(+), 9 deletions(-)

diff --git a/include/internal/object.h b/include/internal/object.h
index 1259467..83d9010 100644
--- a/include/internal/object.h
+++ b/include/internal/object.h
@@ -270,6 +270,10 @@ struct nfct_filter {
 		u_int32_t 	mask;
 	} mark[__FILTER_MARK_MAX];
 
+	u_int32_t 		zone_elems;
+#define __FILTER_ZONE_MAX	511
+	u_int16_t		zone[__FILTER_ZONE_MAX];
+
 	u_int32_t 		set[1];
 };
 
diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
index 03bf3ca..52fee85 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
@@ -499,6 +499,7 @@ enum nfct_filter_attr {
 	NFCT_FILTER_SRC_IPV6,		/* struct nfct_filter_ipv6 */
 	NFCT_FILTER_DST_IPV6,		/* struct nfct_filter_ipv6 */
 	NFCT_FILTER_MARK,		/* struct nfct_filter_dump_mark */
+	NFCT_FILTER_ZONE,		/* u_int16_t */
 	NFCT_FILTER_MAX
 };
 
diff --git a/src/conntrack/bsf.c b/src/conntrack/bsf.c
index d4dfaec..2a46d4d 100644
--- a/src/conntrack/bsf.c
+++ b/src/conntrack/bsf.c
@@ -316,6 +316,20 @@ bsf_cmp_subsys(struct sock_filter *this, int pos, u_int8_t subsys)
 }
 
 static int
+nfct_bsf_skip_if_a(struct sock_filter *this, int pos,
+		   u_int32_t aval, u_int8_t nskip)
+{
+	struct sock_filter __code = {
+		.code = BPF_JMP|BPF_JEQ|BPF_K,
+		.k = aval,
+		.jt = nskip,
+		.jf = 0,
+	};
+	memcpy(&this[pos], &__code, sizeof(__code));
+	return NEW_POS(__code);
+}
+
+static int
 add_state_filter_cta(struct sock_filter *this,
 		     unsigned int cta_protoinfo_proto,
 		     unsigned int cta_protoinfo_state,
@@ -683,13 +697,6 @@ bsf_add_mark_filter(const struct nfct_filter *f, struct sock_filter *this)
 	unsigned int jt;
 	struct stack *s;
 	struct jump jmp;
-	struct sock_filter __code = {
-		/* if (A == 0) skip next two */
-		.code = BPF_JMP|BPF_JEQ|BPF_K,
-		.k = 0,
-		.jt = 2,
-		.jf = 0,
-	};
 
 	/* nothing to filter, skip */
 	if (f->mark_elems == 0)
@@ -706,8 +713,7 @@ bsf_add_mark_filter(const struct nfct_filter *f, struct sock_filter *this)
 	j = 0;
 	j += nfct_bsf_load_payload_offset(this, j);
 	j += nfct_bsf_find_attr(this, CTA_MARK, j);
-	memcpy(&this[j], &__code, sizeof(__code));
-	j += NEW_POS(__code);
+	j += nfct_bsf_skip_if_a(this, j, 0, 2);
 	j += nfct_bsf_x_equal_a(this, j);
 	j += nfct_bsf_load_attr(this, BPF_W, j);
 	j += nfct_bsf_x_equal_a(this, j);
@@ -733,6 +739,50 @@ bsf_add_mark_filter(const struct nfct_filter *f, struct sock_filter *this)
 	return j;
 }
 
+static int
+bsf_add_zone_filter(const struct nfct_filter *f, struct sock_filter *this)
+{
+	unsigned int i, j;
+	unsigned int jt;
+	struct stack *s;
+	struct jump jmp;
+
+	/* nothing to filter, skip */
+	if (f->zone_elems == 0)
+		return 0;
+
+	s = stack_create(sizeof(struct jump), 3 + 511);
+	if (s == NULL) {
+		errno = ENOMEM;
+		return -1;
+	}
+
+	jt = 1;
+	j = 0;
+	j += nfct_bsf_load_payload_offset(this, j);
+	j += nfct_bsf_find_attr(this, CTA_ZONE, j);
+	/* A message which does not contain CTA_ZONE is regarded
+	 * as its value is 0. */
+	j += nfct_bsf_skip_if_a(this, j, 0, 2);
+	j += nfct_bsf_x_equal_a(this, j);
+	j += nfct_bsf_load_attr(this, BPF_H, j);
+
+	for (i = 0; i < f->zone_elems; i++)
+		j += nfct_bsf_cmp_k_stack(this, f->zone[i], jt - j, j, s);
+
+	while (stack_pop(s, &jmp) != -1)
+		this[jmp.line].jt += jmp.jt + j;
+
+	if (f->logic[NFCT_FILTER_ZONE] == NFCT_FILTER_LOGIC_NEGATIVE)
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
 
@@ -769,6 +819,9 @@ int __setup_netlink_socket_filter(int fd, struct nfct_filter *f)
 	j += bsf_add_mark_filter(f, &bsf[j]);
 	show_filter(bsf, from, j, "---- check mark ----");
 	from = j;
+	j += bsf_add_zone_filter(f, &bsf[j]);
+	show_filter(bsf, from, j, "---- check zone ----");
+	from = j;
 
 	/* nothing to filter, skip */
 	if (j == 0)
diff --git a/src/conntrack/filter.c b/src/conntrack/filter.c
index 78fbbc5..34be99b 100644
--- a/src/conntrack/filter.c
+++ b/src/conntrack/filter.c
@@ -91,6 +91,15 @@ static void filter_attr_mark(struct nfct_filter *filter, const void *value)
 	filter->mark_elems++;
 }
 
+static void filter_attr_zone(struct nfct_filter *filter, const void *value)
+{
+	if (filter->zone_elems >= __FILTER_ZONE_MAX)
+		return;
+
+	filter->zone[filter->zone_elems] = *(u_int16_t *)value;
+	filter->zone_elems++;
+}
+
 const filter_attr filter_attr_array[NFCT_FILTER_MAX] = {
 	[NFCT_FILTER_L4PROTO]		= filter_attr_l4proto,
 	[NFCT_FILTER_L4PROTO_STATE]	= filter_attr_l4proto_state,
@@ -99,4 +108,5 @@ const filter_attr filter_attr_array[NFCT_FILTER_MAX] = {
 	[NFCT_FILTER_SRC_IPV6]		= filter_attr_src_ipv6,
 	[NFCT_FILTER_DST_IPV6]		= filter_attr_dst_ipv6,
 	[NFCT_FILTER_MARK]		= filter_attr_mark,
+	[NFCT_FILTER_ZONE]		= filter_attr_zone,
 };
-- 
1.9.1

