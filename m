From: Florian Westphal <fw@strlen.de>
Subject: [RFC nf-next 5/5] netfilter: nf_tables_jit: add userspace nft to ebpf translator
Date: Fri,  1 Jun 2018 17:32:16 +0200
Message-ID: <20180601153216.10901-6-fw@strlen.de>
References: <20180601153216.10901-1-fw@strlen.de>
Cc: ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180601153216.10901-1-fw@strlen.de>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

currently rather limited.

It supports:
 * payload expression for network and transport header
 * meta mark, nfproto, l4proto
 * 32 bit immediates
 * 32 bit bitmask ops
 * accept/drop verdicts

Currently kernel will emit each rule on its own.
However, jitter is (eventually) supposed to also cope with complete
chains (including goto/jump).

It also lacks support for any kind of sets; anonymous sets would
be a good initial target as they can't change.

As this uses netlink, there is also no technical requirement for
libnftnl, its simply used for convienience.

This doesn't need any userspace changes to work, however,
a libnftnl and nft patch will make debug info available
(e.g. to match a rule with its bpf program id).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables_core.h           |    1 +
 net/netfilter/nf_tables_core.c                   |    1 +
 net/netfilter/nf_tables_jit/Makefile             |    3 +-
 net/netfilter/nf_tables_jit/imr.c                | 1401 ++++++++++++++++++++++
 net/netfilter/nf_tables_jit/imr.h                |   96 ++
 net/netfilter/nf_tables_jit/main.c               |  582 ++++++++-
 net/netfilter/nf_tables_jit/nf_tables_jit_kern.c |  146 ++-
 7 files changed, 2215 insertions(+), 15 deletions(-)
 create mode 100644 net/netfilter/nf_tables_jit/imr.c
 create mode 100644 net/netfilter/nf_tables_jit/imr.h

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index e9b5cc20ec45..f3e85e6c8cc6 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -82,6 +82,7 @@ int nft_jit_commit(struct net *net);
 static inline int nft_jit_commit(struct net *net) { return 0; }
 #endif
 int nf_tables_jit_work(const struct sk_buff *nlskb, struct nft_ebpf *e);
+void nft_jit_stop_umh(void);
 
 extern struct static_key_false nft_counters_enabled;
 extern struct static_key_false nft_trace_enabled;
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 5557b2709f98..8956f873a8cb 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -319,4 +319,5 @@ void nf_tables_core_module_exit(void)
 	i = ARRAY_SIZE(nft_basic_types);
 	while (i-- > 0)
 		nft_unregister_expr(nft_basic_types[i]);
+	nft_jit_stop_umh();
 }
diff --git a/net/netfilter/nf_tables_jit/Makefile b/net/netfilter/nf_tables_jit/Makefile
index aa7509e49589..a1b8eb5a4c45 100644
--- a/net/netfilter/nf_tables_jit/Makefile
+++ b/net/netfilter/nf_tables_jit/Makefile
@@ -2,8 +2,9 @@
 #
 
 hostprogs-y := nf_tables_jit_umh
-nf_tables_jit_umh-objs := main.o
+nf_tables_jit_umh-objs := main.o imr.o
 HOSTCFLAGS += -I. -Itools/include/
+HOSTLOADLIBES_nf_tables_jit_umh = `pkg-config --libs libnftnl libmnl`
 
 quiet_cmd_copy_umh = GEN $@
       cmd_copy_umh = echo ':' > $(obj)/.nf_tables_jit_umh.o.cmd; \
diff --git a/net/netfilter/nf_tables_jit/imr.c b/net/netfilter/nf_tables_jit/imr.c
new file mode 100644
index 000000000000..2242bc7379ee
--- /dev/null
+++ b/net/netfilter/nf_tables_jit/imr.c
@@ -0,0 +1,1401 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <stdbool.h>
+#include <stdio.h>
+#include <stddef.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <limits.h>
+
+#include <linux/bpf.h>
+#include <linux/filter.h>
+
+#include <linux/if_ether.h>
+#include <arpa/inet.h>
+#include <linux/netfilter.h>
+
+#include <netinet/ip.h>
+#include <netinet/ip6.h>
+
+#include "imr.h"
+
+#define div_round_up(n, d)      (((n) + (d) - 1) / (d))
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
+#define EMIT(ctx, x)							\
+	do {								\
+		struct bpf_insn __tmp[] = { x };			\
+		if ((ctx)->len_cur + ARRAY_SIZE(__tmp) > BPF_MAXINSNS)	\
+			return -ENOMEM;					\
+		memcpy((ctx)->img + (ctx)->len_cur, &__tmp, sizeof(__tmp));		\
+		(ctx)->len_cur += ARRAY_SIZE(__tmp);			\
+	} while (0)
+
+struct imr_object {
+	enum imr_obj_type type:8;
+	uint8_t len;
+	uint8_t refcnt;
+
+	union {
+		struct {
+			union {
+				uint64_t value_large[8];
+				uint64_t value64;
+				uint32_t value32;
+			};
+		} imm;
+		struct {
+			uint16_t offset;
+			enum imr_payload_base base:8;
+		} payload;
+		struct {
+			enum imr_verdict verdict;
+		} verdict;
+		struct {
+			enum imr_meta_key key:8;
+		} meta;
+		struct {
+			struct imr_object *left;
+			struct imr_object *right;
+			enum imr_alu_op op:8;
+		} alu;
+	};
+};
+
+struct imr_state {
+	struct bpf_insn	*img;
+	uint16_t	len_cur;
+	uint16_t	num_objects;
+	uint8_t		nfproto;
+	uint8_t		regcount;
+
+	/* payload access <= headlen will use direct skb->data access.
+	 * Normally set to either sizeof(iphdr) or sizeof(ipv6hdr).
+	 *
+	 * Access >= headlen will need to go through skb_header_pointer().
+	 */
+	uint8_t		headlen;
+
+	/* where skb->data points to at start
+	 * of program.  Usually this is IMR_PAYLOAD_BASE_NH.
+	 */
+	enum imr_payload_base base:8;
+
+	/* hints to emitter */
+	bool reload_r2;
+
+	struct imr_object *registers[IMR_REG_COUNT];
+
+	struct imr_object **objects;
+};
+
+static int imr_jit_object(struct imr_state *, const struct imr_object *o);
+
+static void internal_error(const char *s)
+{
+	fprintf(stderr, "FIXME: internal error %s\n", s);
+	exit(1);
+}
+
+static unsigned int imr_regs_needed(unsigned int len)
+{
+	return div_round_up(len, sizeof(uint64_t));
+}
+
+static int imr_register_alloc(struct imr_state *s, uint32_t len)
+{
+	unsigned int regs_needed = imr_regs_needed(len);
+	uint8_t reg = s->regcount;
+
+	if (s->regcount + regs_needed >= IMR_REG_COUNT) {
+		internal_error("out of BPF registers");
+		return -1;
+	}
+
+	s->regcount += regs_needed;
+
+	return reg;
+}
+
+static int imr_register_get(const struct imr_state *s, uint32_t len)
+{
+	unsigned int regs_needed = imr_regs_needed(len);
+
+	if (s->regcount < regs_needed)
+		internal_error("not enough registers in use");
+
+	return s->regcount - regs_needed;
+}
+
+static int bpf_reg_width(unsigned int len)
+{
+	switch (len) {
+	case sizeof(uint8_t): return BPF_B;
+	case sizeof(uint16_t): return BPF_H;
+	case sizeof(uint32_t): return BPF_W;
+	case sizeof(uint64_t): return BPF_DW;
+	default:
+		internal_error("reg size not supported");
+	}
+
+	return -EINVAL;
+}
+
+/* map op to negated bpf opcode.
+ * This is because if we want to check 'eq', we need
+ * to jump to end of rule ('break') on inequality, i.e.
+ * 'branch if NOT equal'.
+ */
+static int alu_jmp_get_negated_bpf_opcode(enum imr_alu_op op)
+{
+	switch (op) {
+	case IMR_ALU_OP_EQ:
+		return BPF_JNE;
+	case IMR_ALU_OP_NE:
+		return BPF_JEQ;
+	case IMR_ALU_OP_LT:
+		return BPF_JGE;
+	case IMR_ALU_OP_LTE:
+		return BPF_JGT;
+	case IMR_ALU_OP_GT:
+		return BPF_JLE;
+	case IMR_ALU_OP_GTE:
+		return BPF_JLT;
+	case IMR_ALU_OP_LSHIFT:
+	case IMR_ALU_OP_AND:
+		break;
+        }
+
+	internal_error("invalid imr alu op");
+	return -EINVAL;
+}
+
+static void imr_register_release(struct imr_state *s, uint32_t len)
+{
+	unsigned int regs_needed = imr_regs_needed(len);
+
+	if (s->regcount < regs_needed)
+		internal_error("regcount underflow");
+	s->regcount -= regs_needed;
+}
+
+void imr_register_store(struct imr_state *s, enum imr_reg_num reg, struct imr_object *o)
+{
+	struct imr_object *old;
+
+	old = s->registers[reg];
+	if (old)
+		imr_object_free(old);
+
+	s->registers[reg] = o;
+}
+
+struct imr_object *imr_register_load(const struct imr_state *s, enum imr_reg_num reg)
+{
+	struct imr_object *o = s->registers[reg];
+
+	if (!o)
+		internal_error("empty register");
+
+	if (!o->refcnt)
+		internal_error("already free'd object in register");
+
+	o->refcnt++;
+	return o;
+}
+
+struct imr_state *imr_state_alloc(void)
+{
+	struct imr_state *s = calloc(1, sizeof(*s));
+
+	return s;
+}
+
+void imr_state_free(struct imr_state *s)
+{
+	int i;
+
+	for (i = 0; i < s->num_objects; i++)
+		imr_object_free(s->objects[i]);
+
+	free(s->objects);
+	free(s->img);
+	free(s);
+}
+
+struct imr_object *imr_object_alloc(enum imr_obj_type t)
+{
+	struct imr_object *o = calloc(1, sizeof(*o));
+
+	if (!o)
+		return NULL;
+
+	o->refcnt = 1;
+	o->type = t;
+	return o;
+}
+
+static struct imr_object *imr_object_copy(const struct imr_object *old)
+{
+	struct imr_object *o = imr_object_alloc(old->type);
+
+	if (!o)
+		return NULL;
+
+	switch (o->type) {
+	case IMR_OBJ_TYPE_VERDICT:
+	case IMR_OBJ_TYPE_IMMEDIATE:
+	case IMR_OBJ_TYPE_PAYLOAD:
+	case IMR_OBJ_TYPE_META:
+		memcpy(o, old, sizeof(*o));
+		o->refcnt = 1;
+		break;
+	case IMR_OBJ_TYPE_ALU:
+		o->alu.left = imr_object_copy(old->alu.left);
+		o->alu.right = imr_object_copy(old->alu.right);
+		if (!o->alu.left || !o->alu.right) {
+			imr_object_free(o);
+			return NULL;
+		}
+		break;
+	}
+
+	o->len = old->len;
+	return o;
+}
+
+static struct imr_object *imr_object_split64(struct imr_object *to_split)
+{
+	struct imr_object *o = NULL;
+
+	if (to_split->len < sizeof(uint64_t))
+		internal_error("bogus split of size <= uint64_t");
+
+	to_split->len -= sizeof(uint64_t);
+
+	switch (to_split->type) {
+	case IMR_OBJ_TYPE_IMMEDIATE: {
+		uint64_t tmp;
+
+		o = imr_object_copy(to_split);
+		o->imm.value64 = to_split->imm.value_large[0];
+
+		switch (to_split->len) {
+		case 0:
+			break;
+		case sizeof(uint32_t):
+			tmp = to_split->imm.value_large[1];
+			to_split->imm.value32 = tmp;
+			break;
+		case sizeof(uint64_t):
+			tmp = to_split->imm.value_large[1];
+			to_split->imm.value64 = tmp;
+			break;
+		default:
+			memmove(to_split->imm.value_large, &to_split->imm.value_large[1],
+				sizeof(to_split->imm.value_large) - sizeof(to_split->imm.value_large[0]));
+			break;
+		}
+		}
+		break;
+	case IMR_OBJ_TYPE_PAYLOAD:
+		o = imr_object_copy(to_split);
+		to_split->payload.offset += sizeof(uint64_t);
+		break;
+	case IMR_OBJ_TYPE_META:
+		internal_error("can't split meta");
+		break;
+	case IMR_OBJ_TYPE_ALU:
+		o = imr_object_alloc(to_split->type);
+		o->alu.left = imr_object_split64(to_split->alu.left);
+		o->alu.right = imr_object_split64(to_split->alu.right);
+
+		if (!o->alu.left || !o->alu.right) {
+			imr_object_free(o);
+			return NULL; /* Can't recover */
+
+		}
+		break;
+	case IMR_OBJ_TYPE_VERDICT:
+		internal_error("can't split type");
+	}
+
+	if (o)
+		o->len = sizeof(uint64_t);
+	return o;
+}
+
+void imr_object_free(struct imr_object *o)
+{
+	if (!o)
+		return;
+
+	if (o->refcnt == 0) {
+		internal_error("double-free, refcnt already zero");
+		o->refcnt--;
+	}
+	switch (o->type) {
+	case IMR_OBJ_TYPE_VERDICT:
+	case IMR_OBJ_TYPE_IMMEDIATE:
+	case IMR_OBJ_TYPE_PAYLOAD:
+	case IMR_OBJ_TYPE_META:
+		break;
+	case IMR_OBJ_TYPE_ALU:
+		imr_object_free(o->alu.left);
+		imr_object_free(o->alu.right);
+		break;
+	}
+
+	o->refcnt--;
+	if (o->refcnt > 0)
+		return;
+
+	free(o);
+}
+
+struct imr_object *imr_object_alloc_imm32(uint32_t value)
+{
+	struct imr_object *o = imr_object_alloc(IMR_OBJ_TYPE_IMMEDIATE);
+
+	if (o) {
+		o->imm.value32 = value;
+		o->len = sizeof(value);
+	}
+	return o;
+}
+
+struct imr_object *imr_object_alloc_imm64(uint64_t value)
+{
+	struct imr_object *o = imr_object_alloc(IMR_OBJ_TYPE_IMMEDIATE);
+
+	if (o) {
+		o->imm.value64 = value;
+		o->len = sizeof(value);
+	}
+	return o;
+}
+
+struct imr_object *imr_object_alloc_imm(const uint32_t *data, unsigned int len)
+{
+	struct imr_object *o = imr_object_alloc(IMR_OBJ_TYPE_IMMEDIATE);
+	unsigned int left = len;
+	int i = 0;
+
+	if (!o)
+		return NULL;
+
+	while (left >= sizeof(uint64_t)) {
+		uint64_t value = *data;
+
+		left -= sizeof(uint64_t);
+
+		value <<= 32;
+		data++;
+		value |= *data;
+		data++;
+
+		if (i >= ARRAY_SIZE(o->imm.value_large)) {
+			internal_error("value too large");
+			imr_object_free(o);
+			return NULL;
+		}
+		o->imm.value_large[i++] = value;
+	}
+
+	if (left) {
+		if (left != sizeof(uint32_t))
+			internal_error("values are expected in 4-byte chunks at least");
+
+		if (i >= ARRAY_SIZE(o->imm.value_large)) {
+			internal_error("value too large");
+			imr_object_free(o);
+			return NULL;
+		}
+		o->imm.value_large[i] = *data;
+	}
+
+	o->len = len;
+	return o;
+}
+
+struct imr_object *imr_object_alloc_verdict(enum imr_verdict v)
+{
+	struct imr_object *o = imr_object_alloc(IMR_OBJ_TYPE_VERDICT);
+
+	if (!o)
+		return NULL;
+
+	o->verdict.verdict = v;
+	o->len = sizeof(v);
+
+	return o;
+}
+
+static const char * alu_op_to_str(enum imr_alu_op op)
+{
+	switch (op) {
+	case IMR_ALU_OP_EQ: return "eq";
+	case IMR_ALU_OP_NE: return "ne";
+	case IMR_ALU_OP_LT: return "<";
+	case IMR_ALU_OP_LTE: return "<=";
+	case IMR_ALU_OP_GT: return ">";
+	case IMR_ALU_OP_GTE: return ">=";
+	case IMR_ALU_OP_AND: return "&";
+	case IMR_ALU_OP_LSHIFT: return "<<";
+	}
+
+	return "?";
+}
+
+static const char *verdict_to_str(enum imr_verdict v)
+{
+	switch (v) {
+	case IMR_VERDICT_NONE: return "none";
+	case IMR_VERDICT_NEXT: return "next";
+	case IMR_VERDICT_PASS: return "pass";
+	case IMR_VERDICT_DROP: return "drop";
+	}
+
+	return "invalid";
+}
+
+static int imr_object_print_imm(FILE *fp, const struct imr_object *o)
+{
+	switch (o->len) {
+	case sizeof(uint64_t):
+		return fprintf(fp, "(0x%16llx)", (unsigned long long)o->imm.value64);
+	case sizeof(uint32_t):
+		return fprintf(fp, "(0x%08x)", (unsigned int)o->imm.value32);
+	default:
+		return fprintf(fp, "(0x%llx?)", (unsigned long long)o->imm.value64);
+	}
+}
+
+static const char *meta_to_str(enum imr_meta_key k)
+{
+	switch (k) {
+	case IMR_META_NFMARK:
+		return "nfmark";
+	case IMR_META_NFPROTO:
+		return "nfproto";
+	case IMR_META_L4PROTO:
+		return "l4proto";
+	}
+
+	return "unknown";
+}
+
+static const char *type_to_str(enum imr_obj_type t)
+{
+	switch (t) {
+	case IMR_OBJ_TYPE_VERDICT: return "verdict";
+	case IMR_OBJ_TYPE_IMMEDIATE: return "imm";
+	case IMR_OBJ_TYPE_PAYLOAD: return "payload";
+	case IMR_OBJ_TYPE_ALU: return "alu";
+	case IMR_OBJ_TYPE_META: return "meta";
+	}
+
+	return "unknown";
+}
+
+static int imr_object_print(FILE *fp, const struct imr_object *o)
+{
+	int ret, total = 0;
+
+	ret = fprintf(fp, "%s", type_to_str(o->type));
+	if (ret < 0)
+		return ret;
+	total += ret;
+	switch (o->type) {
+	case IMR_OBJ_TYPE_VERDICT:
+		ret = fprintf(fp, "(%s)", verdict_to_str(o->verdict.verdict));
+		if (ret < 0)
+			break;
+		total += ret;
+		break;
+	case IMR_OBJ_TYPE_PAYLOAD:
+		ret = fprintf(fp, "(base %d, off %d, len %d)",
+				o->payload.base, o->payload.offset, o->len);
+		if (ret < 0)
+			break;
+		total += ret;
+		break;
+	case IMR_OBJ_TYPE_IMMEDIATE:
+		ret = imr_object_print_imm(fp, o);
+		if (ret < 0)
+			break;
+		total += ret;
+		break;
+	case IMR_OBJ_TYPE_ALU:
+		ret = fprintf(fp, "(");
+		if (ret < 0)
+			break;
+		total += ret;
+		ret = imr_object_print(fp, o->alu.left);
+		if (ret < 0)
+			break;
+		total += ret;
+
+		ret = fprintf(fp , " %s ", alu_op_to_str(o->alu.op));
+		if (ret < 0)
+			break;
+		total += ret;
+
+		ret = imr_object_print(fp, o->alu.right);
+		if (ret < 0)
+			break;
+		total += ret;
+
+		ret = fprintf(fp, ") ");
+		if (ret < 0)
+			break;
+		total += ret;
+		break;
+	case IMR_OBJ_TYPE_META:
+		ret = fprintf(fp , " %s ", meta_to_str(o->meta.key));
+		if (ret < 0)
+			break;
+		total += ret;
+		break;
+	default:
+		internal_error("missing print support");
+		break;
+	}
+
+	return total;
+}
+
+void imr_state_print(FILE *fp, struct imr_state *s)
+{
+	int i;
+
+	for (i = 0; i < s->num_objects; i++) {
+		imr_object_print(fp, s->objects[i]);
+		putc('\n', fp);
+	}
+}
+
+struct imr_object *imr_object_alloc_meta(enum imr_meta_key k)
+{
+	struct imr_object *o = imr_object_alloc(IMR_OBJ_TYPE_META);
+
+	o->meta.key = k;
+
+	switch (k) {
+	case IMR_META_L4PROTO:
+		o->len = sizeof(uint16_t);
+		break;
+	case IMR_META_NFPROTO:
+		o->len = sizeof(uint8_t);
+		break;
+	case IMR_META_NFMARK:
+		o->len = sizeof(uint32_t);
+		break;
+	}
+
+	return o;
+}
+
+struct imr_object *imr_object_alloc_payload(enum imr_payload_base b, uint16_t off, uint16_t len)
+{
+	struct imr_object *o = imr_object_alloc(IMR_OBJ_TYPE_PAYLOAD);
+
+	if (!o)
+		return NULL;
+
+	o->payload.base = b;
+	o->payload.offset = off;
+	if (len > 16)
+		return NULL;
+
+	if (len == 0)
+		internal_error("payload length is 0");
+	if (len > 16)
+		internal_error("payload length exceeds 16 byte");
+
+	o->len = len;
+
+	return o;
+}
+
+struct imr_object *imr_object_alloc_alu(enum imr_alu_op op, struct imr_object *l, struct imr_object *r)
+{
+	struct imr_object *o = imr_object_alloc(IMR_OBJ_TYPE_ALU);
+
+	if (!o)
+		return NULL;
+
+	if (l == r)
+		internal_error("same operands");
+
+	o->alu.op = op;
+	o->alu.left = l;
+	o->alu.right = r;
+
+	if (l->len == 0 || r->len == 0)
+		internal_error("alu op with 0 op length");
+
+	o->len = l->len;
+	if (r->len > o->len)
+		o->len = r->len;
+
+	return o;
+}
+
+static int imr_state_add_obj_alu(struct imr_state *s, struct imr_object *o)
+{
+	struct imr_object *old;
+
+	if (s->num_objects == 0 || o->len > sizeof(uint64_t))
+		return -EINVAL;
+
+	old = s->objects[s->num_objects - 1];
+
+	if (old->type != IMR_OBJ_TYPE_ALU)
+		return -EINVAL;
+	if (old->alu.left != o->alu.left)
+		return -EINVAL;
+
+	imr_object_free(o->alu.left);
+	o->alu.left = old;
+	s->objects[s->num_objects - 1] = o;
+
+	if (old->len != o->len)
+		internal_error("different op len but same src");
+	return 0;
+}
+
+int imr_state_add_obj(struct imr_state *s, struct imr_object *o)
+{
+	struct imr_object **new;
+	uint32_t slot = s->num_objects;
+
+	if (s->num_objects >= 0xffff / sizeof(*o))
+		return -1;
+
+	if (o->type == IMR_OBJ_TYPE_ALU &&
+	    imr_state_add_obj_alu(s, o) == 0)
+		return 0;
+
+	s->num_objects++;
+
+	new = realloc(s->objects, sizeof(o) * s->num_objects);
+	if (!new) {
+		imr_object_free(o);
+		return -1;
+	}
+
+	new[slot] = o;
+	if (new != s->objects)
+		s->objects = new;
+
+	return 0;
+}
+
+int imr_state_rule_end(struct imr_state *s)
+{
+	uint32_t slot = s->num_objects;
+	struct imr_object *last;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(s->registers); i++) {
+		last = s->registers[i];
+		if (last)
+			imr_register_store(s, i, NULL);
+	}
+
+	if (slot == 0)
+		internal_error("rule end, but no objects present\n");
+	last = s->objects[slot - 1];
+
+	if (last->type == IMR_OBJ_TYPE_VERDICT)
+		return 0;
+
+	return imr_state_add_obj(s, imr_object_alloc_verdict(IMR_VERDICT_NEXT));
+}
+
+static int imr_jit_obj_immediate(struct imr_state *s,
+				 const struct imr_object *o)
+{
+	int bpf_reg = imr_register_get(s, o->len);
+
+	switch (o->len) {
+	case sizeof(uint32_t):
+		EMIT(s, BPF_MOV32_IMM(bpf_reg, o->imm.value32));
+		return 0;
+	case sizeof(uint64_t):
+		EMIT(s, BPF_LD_IMM64(bpf_reg, o->imm.value64));
+		return 0;
+	default:
+		break;
+	}
+
+	internal_error("unhandled immediate size");
+	return -EINVAL;
+}
+
+static int imr_jit_verdict(struct imr_state *s, int verdict)
+{
+	EMIT(s, BPF_MOV32_IMM(BPF_REG_0, verdict));
+	EMIT(s, BPF_EXIT_INSN());
+	return 0;
+}
+
+static int imr_jit_obj_verdict(struct imr_state *s,
+			       const struct imr_object *o)
+{
+	int verdict = o->verdict.verdict;
+
+	switch (o->verdict.verdict) {
+	case IMR_VERDICT_NEXT: /* no-op: continue with next rule */
+		return 0;
+	case IMR_VERDICT_PASS:
+		verdict = NF_ACCEPT;
+		break;
+	case IMR_VERDICT_DROP:
+		verdict = NF_DROP;
+		break;
+	case IMR_VERDICT_NONE:
+		verdict = -1; /* NFT_CONTINUE */
+		break;
+	default:
+		internal_error("unhandled verdict");
+	}
+
+	return imr_jit_verdict(s, verdict);
+}
+
+static unsigned int align_for_stack(uint16_t len)
+{
+	return div_round_up(len, sizeof(uint64_t)) * sizeof(uint64_t);
+}
+
+static int imr_reload_skb_data(struct imr_state *state)
+{
+	int tmp_reg = imr_register_alloc(state, sizeof(uint64_t));
+
+	/* headlen tells how much bytes we can expect to reside
+	 * in the skb linear area.
+	 *
+	 * Used to decide when to prefer direct access vs.
+	 * bpf equivalent of skb_header_pointer().
+	 */
+	EMIT(state, BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,
+			 offsetof(struct __sk_buff, data)));
+	EMIT(state, BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
+			 offsetof(struct __sk_buff, data_end)));
+
+	EMIT(state, BPF_MOV64_REG(tmp_reg, BPF_REG_2));
+	EMIT(state, BPF_ALU64_IMM(BPF_ADD, tmp_reg, state->headlen));
+
+	/* This is so that verifier can mark accesses to
+	 * skb->data as safe provided they don't exceed data_end (R3).
+	 *
+	 * IMR makes sure it switches to bpf_skb_load_bytes helper for
+	 * accesses that are larger, else verifier rejects program.
+	 *
+	 * R3 and R4 are only used temporarily here, no need to preserve them.
+	 */
+	EMIT(state, BPF_JMP_REG(BPF_JLE, tmp_reg, BPF_REG_3, 2));
+
+	imr_register_release(state, sizeof(uint64_t));
+
+	/*
+	 * ((R2 (data) + headlen) > R3 data_end.
+	 * Should never happen for nf hook points, ip/ipv6 stack pulls
+	 * at least ip(6) header into linear area, and caller will
+	 * pass this header size as headlen.
+	 */
+	EMIT(state, BPF_MOV32_IMM(BPF_REG_0, NF_DROP));
+	EMIT(state, BPF_EXIT_INSN());
+	return 0;
+}
+
+static int imr_load_thoff(struct imr_state *s, int bpfreg)
+{
+	/* fetch 16bit off cb[0] */
+	EMIT(s, BPF_LDX_MEM(BPF_H, bpfreg, BPF_REG_1, offsetof(struct __sk_buff, cb[0])));
+	return 0;
+}
+
+static int imr_maybe_reload_skb_data(struct imr_state *state)
+{
+	if (state->reload_r2) {
+		state->reload_r2 = false;
+		return imr_reload_skb_data(state);
+	}
+
+	return 0;
+}
+
+/*
+ * Though R10 is correct read-only register and has type PTR_TO_STACK
+ * and R10 - 4 is within stack bounds, there were no stores into that location.
+ */
+static int bpf_skb_load_bytes(struct imr_state *state,
+			      uint16_t offset, uint16_t olen,
+			      int bpf_reg_hdr_off)
+{
+	int len = align_for_stack(olen);
+	int tmp_reg;
+
+	tmp_reg = imr_register_alloc(state, sizeof(uint64_t));
+	if (tmp_reg < 0)
+		return -ENOSPC;
+
+	EMIT(state, BPF_MOV64_IMM(BPF_REG_2, offset));
+	state->reload_r2 = true;
+
+	EMIT(state, BPF_ALU64_REG(BPF_ADD, BPF_REG_2, bpf_reg_hdr_off));
+
+	EMIT(state, BPF_ALU64_REG(BPF_MOV, BPF_REG_3, BPF_REG_10));
+	EMIT(state, BPF_ALU64_IMM(BPF_ADD, BPF_REG_3, -len));
+
+	EMIT(state, BPF_MOV64_IMM(BPF_REG_4, olen));
+
+	EMIT(state, BPF_MOV64_REG(tmp_reg, BPF_REG_1));
+
+	EMIT(state, BPF_EMIT_CALL(BPF_FUNC_skb_load_bytes));
+
+	/* 0: ok, so move to next rule on error */
+	EMIT(state, BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 0));
+
+	EMIT(state, BPF_MOV64_REG(BPF_REG_1, tmp_reg));
+	imr_register_release(state, sizeof(uint64_t));
+	return 0;
+}
+
+static int imr_jit_obj_payload(struct imr_state *state,
+			       const struct imr_object *o)
+{
+	int base = o->payload.base;
+	int offset = o->payload.offset;
+	int bpf_width = bpf_reg_width(o->len);
+	int bpf_reg = imr_register_get(state, o->len);
+	int ret, bpf_reg_hdr_off;
+
+	switch (base) {
+	case IMR_PAYLOAD_BASE_LL: /* XXX: */
+		internal_error("can't handle ll yet");
+		return -ENOTSUP;
+	case IMR_PAYLOAD_BASE_NH:
+		if (state->base == base &&
+		    offset <= state->headlen) {
+			ret = imr_maybe_reload_skb_data(state);
+			if (ret < 0)
+				return ret;
+			EMIT(state, BPF_LDX_MEM(bpf_width, bpf_reg, BPF_REG_2, offset));
+			return 0;
+		}
+		/* XXX: use bpf_load_bytes helper if offset is too big */
+		internal_error("can't handle nonlinear yet");
+		return -ENOTSUP;
+	case IMR_PAYLOAD_BASE_TH:
+		if (o->len > sizeof(uint64_t))
+			internal_error("can't handle size exceeding 8 bytes");
+
+		bpf_reg_hdr_off = imr_register_alloc(state, sizeof(uint16_t));
+		if (bpf_reg_hdr_off < 0)
+			return -ENOSPC;
+
+		ret = imr_load_thoff(state, bpf_reg_hdr_off);
+		if (ret < 0) {
+			imr_register_release(state, sizeof(uint16_t));
+			return ret;
+		}
+
+		ret = bpf_skb_load_bytes(state, offset,
+						o->len, bpf_reg_hdr_off);
+		imr_register_release(state, sizeof(uint16_t));
+
+		if (ret)
+			return ret;
+
+		EMIT(state, BPF_LDX_MEM(bpf_width, bpf_reg, BPF_REG_10,
+		     - align_for_stack(o->len)));
+		return 0;
+	}
+
+	internal_error("invalid base");
+	return -ENOTSUP;
+}
+
+static void imr_fixup_jumps(struct imr_state *state, unsigned int poc_start)
+{
+	unsigned int pc, pc_end, i;
+
+	if (poc_start >= state->len_cur)
+		internal_error("old poc >= current one");
+
+	pc = 0;
+	pc_end = state->len_cur - poc_start;
+
+	for (i = poc_start; pc < pc_end; pc++, i++) {
+		if (BPF_CLASS(state->img[i].code) == BPF_JMP) {
+			if (state->img[i].code == (BPF_EXIT | BPF_JMP))
+				continue;
+			if (state->img[i].code == (BPF_CALL | BPF_JMP))
+				continue;
+
+			if (state->img[i].off)
+				continue;
+			state->img[i].off = pc_end - pc - 1;
+		}
+	}
+}
+
+
+#if 0
+static void nft_cmp_eval(const struct nft_expr *expr,
+                         struct nft_regs *regs,
+                         const struct nft_pktinfo *pkt)
+{
+        const struct nft_cmp_expr *priv = nft_expr_priv(expr);
+        int d;
+
+        d = memcmp(&regs->data[priv->sreg], &priv->data, priv->len);
+        switch (priv->op) {
+        case NFT_CMP_EQ:
+                if (d != 0)
+                        goto mismatch;
+                break;
+        case NFT_CMP_NEQ:
+                if (d == 0)
+                        goto mismatch;
+                break;
+        case NFT_CMP_LT:
+                if (d == 0)
+                        goto mismatch;
+                /* fall through */
+        case NFT_CMP_LTE:
+                if (d > 0)
+                        goto mismatch;
+                break;
+        case NFT_CMP_GT:
+                if (d == 0)
+                        goto mismatch;
+                /* fall through */
+        case NFT_CMP_GTE:
+                if (d < 0)
+                        goto mismatch;
+                break;
+        }
+        return;
+
+mismatch:
+        regs->verdict.code = NFT_BREAK;
+}
+#endif
+
+static int __imr_jit_memcmp_sub64(struct imr_state *state,
+				  struct imr_object *sub,
+				  int regl)
+{
+	int ret = imr_jit_object(state, sub->alu.left);
+	int regr = imr_register_alloc(state, sizeof(uint64_t));
+
+	if (ret < 0)
+		return ret;
+
+	ret = imr_jit_object(state, sub->alu.right);
+
+	EMIT(state, BPF_ALU64_REG(BPF_SUB, regl, regr));
+
+	imr_register_release(state, sizeof(uint64_t));
+	return 0;
+}
+
+static int __imr_jit_memcmp_sub32(struct imr_state *state,
+				  struct imr_object *sub,
+				  int regl)
+{
+	const struct imr_object *right = sub->alu.right;
+	int regr, ret = imr_jit_object(state, sub->alu.left);
+
+	if (right->type == IMR_OBJ_TYPE_IMMEDIATE && right->len) {
+		EMIT(state, BPF_ALU32_IMM(BPF_SUB, regl, right->imm.value32));
+		return 0;
+	}
+
+	regr = imr_register_alloc(state, sizeof(uint32_t));
+	if (ret < 0)
+		return ret;
+
+	ret = imr_jit_object(state, right);
+	if (ret < 0) {
+		imr_register_release(state, sizeof(uint32_t));
+		return ret;
+	}
+
+	EMIT(state, BPF_ALU32_REG(BPF_SUB, regl, regr));
+	return 0;
+}
+
+static int imr_jit_alu_bigcmp(struct imr_state *state, const struct imr_object *o)
+{
+	struct imr_object *copy = imr_object_copy(o);
+	unsigned int start_insn = state->len_cur;
+	int regl, ret;
+
+	if (!copy)
+		return -ENOMEM;
+
+	regl = imr_register_alloc(state, sizeof(uint64_t));
+	do {
+		struct imr_object *tmp;
+
+		tmp = imr_object_split64(copy);
+		if (!tmp) {
+			imr_register_release(state, sizeof(uint64_t));
+			imr_object_free(copy);
+			return -ENOMEM;
+		}
+
+		ret = __imr_jit_memcmp_sub64(state, tmp, regl);
+		imr_object_free(tmp);
+		if (ret < 0) {
+			imr_register_release(state, sizeof(uint64_t));
+			imr_object_free(copy);
+			return ret;
+		}
+		/* XXX: 64bit */
+		EMIT(state, BPF_JMP_IMM(BPF_JNE, regl, 0, 0));
+	} while (copy->len >= sizeof(uint64_t));
+
+	if (copy->len && copy->len != sizeof(uint64_t)) {
+		ret = __imr_jit_memcmp_sub32(state, copy, regl);
+
+		if (ret < 0) {
+			imr_object_free(copy);
+			imr_register_release(state, sizeof(uint64_t));
+			return ret;
+		}
+	}
+
+	imr_object_free(copy);
+	imr_fixup_jumps(state, start_insn);
+
+	switch (o->alu.op) {
+	case IMR_ALU_OP_AND:
+	case IMR_ALU_OP_LSHIFT:
+		internal_error("not a jump");
+	case IMR_ALU_OP_EQ:
+	case IMR_ALU_OP_NE:
+	case IMR_ALU_OP_LT:
+	case IMR_ALU_OP_LTE:
+	case IMR_ALU_OP_GT:
+	case IMR_ALU_OP_GTE:
+		EMIT(state, BPF_JMP_IMM(alu_jmp_get_negated_bpf_opcode(o->alu.op), regl, 0, 0));
+		break;
+        }
+
+	imr_register_release(state, sizeof(uint64_t));
+	return 0;
+}
+
+static int __imr_jit_obj_alu_jmp(struct imr_state *state,
+			         const struct imr_object *o,
+				 int regl)
+{
+	const struct imr_object *right;
+	enum imr_reg_num regr;
+	int op, ret;
+
+	right = o->alu.right;
+
+	op = alu_jmp_get_negated_bpf_opcode(o->alu.op);
+
+	/* avoid 2nd register if possible */
+	if (right->type == IMR_OBJ_TYPE_IMMEDIATE) {
+		switch (right->len) {
+		case sizeof(uint32_t):
+			EMIT(state, BPF_JMP_IMM(op, regl, right->imm.value32, 0));
+			return 0;
+		}
+	}
+
+	regr = imr_register_alloc(state, right->len);
+	if (regr < 0)
+		return -ENOSPC;
+
+	ret = imr_jit_object(state, right);
+	if (ret == 0) {
+		EMIT(state, BPF_MOV32_IMM(BPF_REG_0, -2)); /* NFT_BREAK */
+		EMIT(state, BPF_JMP_REG(op, regl, regr, 0));
+	}
+
+	imr_register_release(state, right->len);
+	return ret;
+}
+
+static int imr_jit_obj_alu_jmp(struct imr_state *state,
+			       const struct imr_object *o,
+			       int regl)
+
+{
+	int ret;
+
+	/* multiple tests on same source? */
+	if (o->alu.left->type == IMR_OBJ_TYPE_ALU) {
+		ret = imr_jit_obj_alu_jmp(state, o->alu.left, regl);
+		if (ret < 0)
+			return ret;
+	} else {
+		ret = imr_jit_object(state, o->alu.left);
+		if (ret < 0)
+			return ret;
+	}
+
+	ret = __imr_jit_obj_alu_jmp(state, o, regl);
+
+	return ret;
+}
+
+static int imr_jit_obj_alu(struct imr_state *state, const struct imr_object *o)
+{
+	const struct imr_object *right;
+	enum imr_reg_num regl;
+	int ret, op;
+
+
+	switch (o->alu.op) {
+	case IMR_ALU_OP_AND:
+		op = BPF_AND;
+		break;
+	case IMR_ALU_OP_LSHIFT:
+		op = BPF_LSH;
+		break;
+	case IMR_ALU_OP_EQ:
+	case IMR_ALU_OP_NE:
+	case IMR_ALU_OP_LT:
+	case IMR_ALU_OP_LTE:
+	case IMR_ALU_OP_GT:
+	case IMR_ALU_OP_GTE:
+		if (o->len > sizeof(uint64_t))
+			return imr_jit_alu_bigcmp(state, o);
+
+		regl = imr_register_alloc(state, o->len);
+		if (regl < 0)
+			return -ENOSPC;
+
+		ret = imr_jit_obj_alu_jmp(state, o, regl);
+		imr_register_release(state, o->len);
+		return ret;
+	}
+
+	ret = imr_jit_object(state, o->alu.left);
+	if (ret)
+		return ret;
+
+	regl = imr_register_get(state, o->len);
+	if (regl < 0)
+		return -EINVAL;
+
+	right = o->alu.right;
+
+	/* avoid 2nd register if possible */
+	if (right->type == IMR_OBJ_TYPE_IMMEDIATE) {
+		switch (right->len) {
+		case sizeof(uint32_t):
+			EMIT(state, BPF_ALU32_IMM(op, regl, right->imm.value32));
+			return 0;
+		}
+	}
+
+	internal_error("alu bitops only handle 32bit immediate RHS");
+	return -EINVAL;
+}
+
+static int imr_jit_obj_meta(struct imr_state *state, const struct imr_object *o)
+{
+	int bpf_reg = imr_register_get(state, o->len);
+	int bpf_width = bpf_reg_width(o->len);
+	int ret;
+
+	switch (o->meta.key) {
+	case IMR_META_NFMARK:
+		EMIT(state, BPF_LDX_MEM(bpf_width, bpf_reg, BPF_REG_1,
+					 offsetof(struct __sk_buff, mark)));
+		break;
+	case IMR_META_L4PROTO:
+		ret = imr_load_thoff(state, bpf_reg);
+		if (ret < 0)
+			return ret;
+
+		EMIT(state, BPF_JMP_IMM(BPF_JEQ, bpf_reg, 0, 0)); /* th == 0? L4PROTO undefined. */
+		EMIT(state, BPF_LDX_MEM(bpf_width, bpf_reg, BPF_REG_1,
+					 offsetof(struct __sk_buff, cb[1])));
+		break;
+	case IMR_META_NFPROTO:
+		switch (state->nfproto) {
+		case NFPROTO_IPV4:
+		case NFPROTO_IPV6:
+			EMIT(state, BPF_MOV32_IMM(bpf_reg, state->nfproto));
+			break;
+		case NFPROTO_INET:	/* first need to check ihl->version */
+			ret = imr_maybe_reload_skb_data(state);
+			if (ret < 0)
+				return ret;
+
+			/* bpf_reg = iph->version & 0xf0 */
+			EMIT(state, BPF_LDX_MEM(BPF_B, bpf_reg, BPF_REG_2, 0));		/* ihl->version/hdrlen */
+			EMIT(state, BPF_ALU32_IMM(BPF_AND, bpf_reg, 0xf0));		/* retain version */
+
+			EMIT(state, BPF_JMP_IMM(BPF_JNE, bpf_reg, 4 << 4, 2));		/* ipv4? */
+			EMIT(state, BPF_MOV32_IMM(bpf_reg, NFPROTO_IPV4));
+			EMIT(state, BPF_JMP_IMM(BPF_JA, 0, 0, 5));			/* skip NF_DROP */
+
+			EMIT(state, BPF_JMP_IMM(BPF_JNE, bpf_reg, 6 << 4, 4));		/* ipv6? */
+			EMIT(state, BPF_MOV32_IMM(bpf_reg, NFPROTO_IPV6));
+			EMIT(state, BPF_JMP_IMM(BPF_JA, 0, 0, 2));			/* skip NF_DROP */
+
+			EMIT(state, BPF_MOV32_IMM(BPF_REG_0, NF_DROP));
+			EMIT(state, BPF_EXIT_INSN());
+			/* Not ipv4, not ipv6? Should not happen: INET hooks from ipv4/ipv6 stack */
+			break;
+		default:
+			internal_error("unsupported family");
+		}
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int imr_jit_object(struct imr_state *s, const struct imr_object *o)
+{
+	switch (o->type) {
+	case IMR_OBJ_TYPE_VERDICT:
+		return imr_jit_obj_verdict(s, o);
+	case IMR_OBJ_TYPE_PAYLOAD:
+		return imr_jit_obj_payload(s, o);
+	case IMR_OBJ_TYPE_IMMEDIATE:
+		return imr_jit_obj_immediate(s, o);
+	case IMR_OBJ_TYPE_ALU:
+		return imr_jit_obj_alu(s, o);
+	case IMR_OBJ_TYPE_META:
+		return imr_jit_obj_meta(s, o);
+	}
+
+	return -EINVAL;
+}
+
+static int imr_jit_rule(struct imr_state *state, int i)
+{
+	unsigned int start, end, count, len_cur;
+
+	end = state->num_objects;
+	if (i >= end)
+		return -EINVAL;
+
+	len_cur = state->len_cur;
+
+	start = i;
+	count = 0;
+
+	for (i = start; start < end; i++) {
+		int ret = imr_jit_object(state, state->objects[i]);
+
+		if (ret < 0) {
+			fprintf(stderr, "failed to JIT object type %d\n",  state->objects[i]->type);
+			return ret;
+		}
+
+		count++;
+
+		if (state->objects[i]->type == IMR_OBJ_TYPE_VERDICT)
+			break;
+	}
+
+	if (i == end)
+		internal_error("no verdict found in rule");
+
+	imr_fixup_jumps(state, len_cur);
+
+	return count;
+}
+
+/* R0: return value.
+ * R1: __sk_buff (BPF_RUN_PROG() argument).
+ * R2-R5 are unused, (caller saved registers).
+ *   imr_state_init sets R2 to be start of skb->data.
+ * R2-R5 are invalidated after BPF function calls.
+ *
+ * R6-R9 are callee saved registers.
+ */
+int imr_state_init(struct imr_state *state, int family)
+{
+	if (!state->img) {
+		state->img = calloc(BPF_MAXINSNS, sizeof(struct bpf_insn));
+		if (!state->img)
+			return -ENOMEM;
+	}
+
+	state->len_cur = 0;
+	state->nfproto = family;
+
+	switch (family) {
+	case NFPROTO_INET:
+	case NFPROTO_IPV4:
+		state->headlen = sizeof(struct iphdr);
+		state->base = IMR_PAYLOAD_BASE_NH;
+		break;
+	case NFPROTO_IPV6:
+		state->headlen = sizeof(struct ip6_hdr);
+		state->base = IMR_PAYLOAD_BASE_NH;
+		break;
+	default:
+		state->base = IMR_PAYLOAD_BASE_NH;
+		break;
+	}
+
+	if (state->headlen) {
+		int ret = imr_reload_skb_data(state);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+struct bpf_insn	*imr_translate(struct imr_state *s, unsigned int *insn_count)
+{
+	struct bpf_insn *img;
+	int ret = 0, i = 0;
+
+	if (!s->img) {
+		ret = imr_state_init(s, s->nfproto);
+		if (ret < 0)
+			return NULL;
+	}
+
+	/* Only use R6..R9 for now to simplify helper calls (R1..R5 will be clobbered) */
+	s->regcount = 6;
+
+	do {
+		int insns = imr_jit_rule(s, i);
+		if (insns < 0) {
+			ret = insns;
+			break;
+		}
+		if (insns == 0)
+			internal_error("rule jit yields 0 insns");
+
+		i += insns;
+	} while (i < s->num_objects);
+
+	if (ret != 0)
+		return NULL;
+
+	ret = imr_jit_verdict(s, -2); /* XXX: policy support. -2: NFT_BREAK */
+	if (ret < 0)
+		return NULL;
+
+	*insn_count = s->len_cur;
+	img = s->img;
+
+	s->img = NULL;
+	s->len_cur = 0;
+
+	return img;
+}
diff --git a/net/netfilter/nf_tables_jit/imr.h b/net/netfilter/nf_tables_jit/imr.h
new file mode 100644
index 000000000000..7ebbf78526f9
--- /dev/null
+++ b/net/netfilter/nf_tables_jit/imr.h
@@ -0,0 +1,96 @@
+#ifndef IMR_HDR
+#define IMR_HDR
+#include <stdint.h>
+#include <stdio.h>
+
+/* map 1:1 to BPF regs. */
+enum imr_reg_num {
+	IMR_REG_0,
+	IMR_REG_1,
+	IMR_REG_2,
+	IMR_REG_3,
+	IMR_REG_4,
+	IMR_REG_5,
+	IMR_REG_6,
+	IMR_REG_7,
+	IMR_REG_8,
+	IMR_REG_9,
+	/* R10 is frame pointer */
+	IMR_REG_COUNT,
+};
+
+struct imr_state;
+struct imr_object;
+
+enum imr_obj_type {
+	IMR_OBJ_TYPE_VERDICT,
+	IMR_OBJ_TYPE_IMMEDIATE,
+	IMR_OBJ_TYPE_PAYLOAD,
+	IMR_OBJ_TYPE_ALU,
+	IMR_OBJ_TYPE_META,
+};
+
+enum imr_alu_op {
+	IMR_ALU_OP_EQ,
+	IMR_ALU_OP_NE,
+	IMR_ALU_OP_LT,
+	IMR_ALU_OP_LTE,
+	IMR_ALU_OP_GT,
+	IMR_ALU_OP_GTE,
+	IMR_ALU_OP_AND,
+	IMR_ALU_OP_LSHIFT,
+};
+
+enum imr_verdict {
+	IMR_VERDICT_NONE,	/* partially translated rule, no verdict */
+	IMR_VERDICT_NEXT,	/* move to next rule */
+	IMR_VERDICT_PASS,	/* end processing, accept packet */
+	IMR_VERDICT_DROP,	/* end processing, drop packet */
+};
+
+enum imr_payload_base {
+	IMR_PAYLOAD_BASE_INVALID,
+	IMR_PAYLOAD_BASE_LL,
+	IMR_PAYLOAD_BASE_NH,
+	IMR_PAYLOAD_BASE_TH,
+};
+
+enum imr_meta_key {
+	IMR_META_L4PROTO,
+	IMR_META_NFPROTO,
+	IMR_META_NFMARK,
+};
+
+struct imr_state *imr_state_alloc(void);
+void imr_state_free(struct imr_state *s);
+void imr_state_print(FILE *fp, struct imr_state *s);
+
+static inline int imr_state_rule_begin(struct imr_state *s)
+{
+	/* nothing for now */
+	return 0;
+}
+
+int imr_state_rule_end(struct imr_state *s);
+
+void imr_register_store(struct imr_state *s, enum imr_reg_num r, struct imr_object *o);
+struct imr_object *imr_register_load(const struct imr_state *s, enum imr_reg_num r);
+
+struct imr_object *imr_object_alloc(enum imr_obj_type t);
+void imr_object_free(struct imr_object *o);
+
+struct imr_object *imr_object_alloc_imm32(uint32_t value);
+struct imr_object *imr_object_alloc_imm64(uint64_t value);
+struct imr_object *imr_object_alloc_imm(const uint32_t *data, unsigned int len);
+struct imr_object *imr_object_alloc_verdict(enum imr_verdict v);
+
+struct imr_object *imr_object_alloc_payload(enum imr_payload_base b, uint16_t off, uint16_t len);
+struct imr_object *imr_object_alloc_alu(enum imr_alu_op op, struct imr_object *l, struct imr_object *r);
+struct imr_object *imr_object_alloc_meta(enum imr_meta_key k);
+
+int imr_state_add_obj(struct imr_state *s, struct imr_object *o);
+
+int imr_state_init(struct imr_state *state, int family);
+struct bpf_insn	*imr_translate(struct imr_state *s, unsigned int *insn_count);
+
+#endif /* IMR_HDR */
diff --git a/net/netfilter/nf_tables_jit/main.c b/net/netfilter/nf_tables_jit/main.c
index 6f6a4423c2e4..42b9d6d5d1fb 100644
--- a/net/netfilter/nf_tables_jit/main.c
+++ b/net/netfilter/nf_tables_jit/main.c
@@ -1,20 +1,578 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <unistd.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <stddef.h>
+#include <time.h>
+#include <string.h>
+#include <netinet/in.h>
+#include <errno.h>
 
-int main(void)
+#include <netinet/ip.h>
+#include <netinet/ip6.h>
+
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <linux/netfilter/nfnetlink.h>
+
+#include <libmnl/libmnl.h>
+#include <libnftnl/common.h>
+#include <libnftnl/ruleset.h>
+#include <libnftnl/table.h>
+#include <libnftnl/chain.h>
+#include <libnftnl/set.h>
+#include <libnftnl/expr.h>
+#include <libnftnl/rule.h>
+
+#include <linux/if_ether.h>
+#include <linux/bpf.h>
+#include <linux/netlink.h>
+
+#include "imr.h"
+
+struct nft_jit_data_from_user {
+ int ebpf_fd;            /* fd to get program from, or < 0 if jitter error */
+ uint32_t expr_count;    /* number of translated expressions */
+};
+
+static FILE *log_file;
+#define NFTNL_EXPR_EBPF_FD      NFTNL_EXPR_BASE
+
+static int bpf(int cmd, union bpf_attr *attr, unsigned int size)
 {
-	static struct {
-		int fd, count;
-	} response;
+#ifndef __NR_bpf
+#define __NR_bpf 321 /* x86_64 */
+#endif
+        return syscall(__NR_bpf, cmd, attr, size);
+}
 
-	response.fd = -1;
-	for (;;) {
-		char buf[8192];
+struct nft_ebpf_prog {
+	enum bpf_prog_type type;
+	const struct bpf_insn *insn;
+	unsigned int len;
+};
+
+struct cb_args {
+	unsigned int buflen;
+	uint32_t exprs_seen;
+	uint32_t stmt_exprs;
+	struct imr_state *s;
+	int fd;
+};
+
+static void memory_allocation_error(void) { perror("allocation failed"); exit(1); }
+
+static int bpf_prog_load(const struct nft_ebpf_prog *prog)
+{
+	union bpf_attr attr = {};
+	char *log;
+	int ret;
+
+	attr.prog_type  = prog->type;
+	attr.insns      = (uint64_t)prog->insn;
+	attr.insn_cnt   = prog->len;
+	attr.license    = (uint64_t)("GPL");
+
+	log = malloc(8192);
+	attr.log_buf = (uint64_t)log;
+	attr.log_size = 8192;
+	attr.log_level = 1;
+
+	ret = bpf(BPF_PROG_LOAD, &attr, sizeof(attr));
+	if (ret < 0)
+		fprintf(log_file, "bpf errlog: %s\n", log);
+	free(log);
+	return ret;
+}
+
+
+static int nft_reg_to_imr_reg(int nfreg)
+{
+	switch (nfreg) {
+	case NFT_REG_VERDICT:
+		return IMR_REG_0;
+	/* old register numbers, 4 128 bit registers. */
+	case NFT_REG_1:
+		return IMR_REG_4;
+	case NFT_REG_2:
+		return IMR_REG_6;
+	case NFT_REG_3:
+		return IMR_REG_8;
+	case NFT_REG_4:
+		break;
+#ifdef NFT_REG32_SIZE
+	/* new register numbers, 16 32 bit registers, map to old ones */
+	case NFT_REG32_00:
+		return IMR_REG_4;
+	case NFT_REG32_01:
+		return IMR_REG_5;
+	case NFT_REG32_02:
+		return IMR_REG_6;
+#endif
+	default:
+		return -1;
+	}
+	return -1;
+}
+
+static int netlink_parse_immediate(const struct nftnl_expr *nle, void *out)
+{
+	struct imr_state *state = out;
+	struct imr_object *o = NULL;
+
+	if (nftnl_expr_is_set(nle, NFTNL_EXPR_IMM_DATA)) {
+		uint32_t len;
+		int reg;
+
+		nftnl_expr_get(nle, NFTNL_EXPR_IMM_DATA, &len);
+
+		switch (len) {
+		case sizeof(uint32_t):
+			o = imr_object_alloc_imm32(nftnl_expr_get_u32(nle, NFTNL_EXPR_IMM_DATA));
+			break;
+		case sizeof(uint64_t):
+			o = imr_object_alloc_imm64(nftnl_expr_get_u64(nle, NFTNL_EXPR_IMM_DATA));
+			break;
+		default:
+			return -ENOTSUP;
+		}
+		reg = nft_reg_to_imr_reg(nftnl_expr_get_u32(nle,
+					     NFTNL_EXPR_IMM_DREG));
+		if (reg < 0) {
+			imr_object_free(o);
+			return reg;
+		}
+
+		imr_register_store(state, reg, o);
+		return 0;
+	} else if (nftnl_expr_is_set(nle, NFTNL_EXPR_IMM_VERDICT)) {
+		uint32_t verdict;
+		int ret;
+
+		if (nftnl_expr_is_set(nle, NFTNL_EXPR_IMM_CHAIN))
+			return -ENOTSUP;
+
+                verdict = nftnl_expr_get_u32(nle, NFTNL_EXPR_IMM_VERDICT);
+
+		switch (verdict) {
+		case NF_ACCEPT:
+			o = imr_object_alloc_verdict(IMR_VERDICT_PASS);
+			break;
+		case NF_DROP:
+			o = imr_object_alloc_verdict(IMR_VERDICT_DROP);
+			break;
+		default:
+			fprintf(log_file, "Unhandled verdict %d\n", verdict);
+			o = imr_object_alloc_verdict(IMR_VERDICT_DROP);
+			break;
+		}
+
+		ret = imr_state_add_obj(state, o);
+		if (ret < 0)
+			imr_object_free(o);
+
+		return ret;
+	}
+
+	return -ENOTSUP;
+}
+
+static int netlink_parse_cmp(const struct nftnl_expr *nle, void *out)
+{
+	struct imr_object *o, *imm, *left;
+	const uint32_t *raw;
+	uint32_t tmp, len;
+	struct imr_state *state = out;
+	enum imr_alu_op op;
+	int ret;
+	op = nftnl_expr_get_u32(nle, NFTNL_EXPR_CMP_OP);
+
+	switch (op) {
+        case NFT_CMP_EQ:
+		op = IMR_ALU_OP_EQ;
+		break;
+        case NFT_CMP_NEQ:
+		op = IMR_ALU_OP_NE;
+		break;
+	case NFT_CMP_LT:
+		op = IMR_ALU_OP_LT;
+		break;
+	case NFT_CMP_LTE:
+		op = IMR_ALU_OP_LTE;
+		break;
+	case NFT_CMP_GT:
+		op = IMR_ALU_OP_GT;
+		break;
+	case NFT_CMP_GTE:
+		op = IMR_ALU_OP_GTE;
+		break;
+	default:
+		return -ENOTSUP;
+	}
+
+	raw = nftnl_expr_get(nle, NFTNL_EXPR_CMP_DATA, &len);
+	switch (len) {
+	case sizeof(uint64_t):
+		imm = imr_object_alloc_imm64(nftnl_expr_get_u64(nle, NFTNL_EXPR_CMP_DATA));
+		break;
+	case sizeof(uint32_t):
+		imm = imr_object_alloc_imm32(nftnl_expr_get_u32(nle, NFTNL_EXPR_CMP_DATA));
+		break;
+	case sizeof(uint16_t):
+		tmp = nftnl_expr_get_u16(nle, NFTNL_EXPR_CMP_DATA);
+
+		imm = imr_object_alloc_imm32(tmp);
+		break;
+	case sizeof(uint8_t):
+		tmp = nftnl_expr_get_u8(nle, NFTNL_EXPR_CMP_DATA);
+
+		imm = imr_object_alloc_imm32(tmp);
+		break;
+	default:
+		imm = imr_object_alloc_imm(raw, len);
+		break;
+	}
+
+	if (!imm)
+		return -ENOMEM;
+
+	ret = nft_reg_to_imr_reg(nftnl_expr_get_u32(nle, NFTNL_EXPR_CMP_SREG));
+	if (ret < 0) {
+		imr_object_free(imm);
+		return ret;
+	}
+
+	left = imr_register_load(state, ret);
+	if (!left) {
+		fprintf(log_file, "%s:%d\n", __FILE__, __LINE__);
+		return -EINVAL;
+	}
+
+	o = imr_object_alloc_alu(op, left, imm);
+
+	return imr_state_add_obj(state, o);
+}
+
+static int netlink_parse_meta(const struct nftnl_expr *nle, void *out)
+{
+	struct imr_state *state = out;
+	struct imr_object *meta;
+	enum imr_meta_key key;
+	int ret;
+
+	if (nftnl_expr_is_set(nle, NFTNL_EXPR_META_SREG))
+		return -EOPNOTSUPP;
+
+	ret = nft_reg_to_imr_reg(nftnl_expr_get_u32(nle, NFTNL_EXPR_META_DREG));
+	if (ret < 0)
+		return ret;
+
+	switch (nftnl_expr_get_u32(nle, NFTNL_EXPR_META_KEY)) {
+	case NFT_META_NFPROTO:
+		key = IMR_META_NFPROTO;
+		break;
+	case NFT_META_L4PROTO:
+		key = IMR_META_L4PROTO;
+		break;
+	case NFT_META_MARK:
+		key = IMR_META_NFMARK;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	meta = imr_object_alloc_meta(key);
+	if (!meta)
+		return -ENOMEM;
+
+	imr_register_store(state, ret, meta);
+	return 0;
+}
+
+static int netlink_parse_payload(const struct nftnl_expr *nle, void *out)
+{
+	struct imr_state *state = out;
+	enum imr_payload_base imr_base;
+	uint32_t base, offset, len;
+	struct imr_object *payload;
+	int ret;
+
+	if (nftnl_expr_is_set(nle, NFTNL_EXPR_PAYLOAD_SREG) ||
+	    nftnl_expr_is_set(nle, NFTNL_EXPR_PAYLOAD_FLAGS))
+		return -EOPNOTSUPP;
+
+	base = nftnl_expr_get_u32(nle, NFTNL_EXPR_PAYLOAD_BASE);
+	offset = nftnl_expr_get_u32(nle, NFTNL_EXPR_PAYLOAD_OFFSET);
+	len = nftnl_expr_get_u32(nle, NFTNL_EXPR_PAYLOAD_LEN);
+
+	ret = nft_reg_to_imr_reg(nftnl_expr_get_u32(nle, NFTNL_EXPR_PAYLOAD_DREG));
+	if (ret < 0)
+		return ret;
+
+	switch (base) {
+	case NFT_PAYLOAD_LL_HEADER:
+		imr_base = IMR_PAYLOAD_BASE_LL;
+		break;
+	case NFT_PAYLOAD_NETWORK_HEADER:
+		imr_base = IMR_PAYLOAD_BASE_NH;
+		break;
+	case NFT_PAYLOAD_TRANSPORT_HEADER:
+		imr_base = IMR_PAYLOAD_BASE_TH;
+		break;
+	default:
+		fprintf(log_file, "%s:%d\n", __FILE__, __LINE__);
+		return -EINVAL;
+	}
+
+	payload = imr_object_alloc_payload(imr_base, offset, len);
+	if (!payload)
+		return -ENOMEM;
+
+	imr_register_store(state, ret, payload);
+	return 0;
+}
+
+static int netlink_parse_bitwise(const struct nftnl_expr *nle, void *out)
+{
+	struct imr_object *imm, *alu, *left;
+	struct imr_state *state = out;
+	uint32_t len_mask, len_xor;
+	int reg;
+
+	reg = nft_reg_to_imr_reg(nftnl_expr_get_u32(nle, NFTNL_EXPR_BITWISE_SREG));
+	if (reg < 0)
+		return reg;
+
+	left = imr_register_load(state, reg);
+	if (!left) {
+		fprintf(log_file, "%s:%d\n", __FILE__, __LINE__);
+		return -EINVAL;
+	}
+
+        nftnl_expr_get(nle, NFTNL_EXPR_BITWISE_XOR, &len_xor);
+	switch (len_xor) {
+	case sizeof(uint32_t):
+		if (nftnl_expr_get_u32(nle, NFTNL_EXPR_BITWISE_XOR) != 0)
+			return -EOPNOTSUPP;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	nftnl_expr_get(nle, NFTNL_EXPR_BITWISE_MASK, &len_mask);
+	switch (len_mask) {
+	case sizeof(uint32_t):
+		imm = imr_object_alloc_imm32(nftnl_expr_get_u32(nle, NFTNL_EXPR_BITWISE_MASK));
+		if (!imm)
+			return -ENOMEM;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	alu = imr_object_alloc_alu(IMR_ALU_OP_AND, left, imm);
+	if (!alu) {
+		imr_object_free(imm);
+		return -ENOMEM;
+	}
+
+	imr_register_store(state, reg, alu);
+	return 0;
+}
+
+static const struct {
+	const char *name;
+	int (*parse)(const struct nftnl_expr *nle,
+				 void *);
+} netlink_parsers[] = {
+	{ .name = "immediate",	.parse = netlink_parse_immediate },
+	{ .name = "cmp",	.parse = netlink_parse_cmp },
+	{ .name = "payload",	.parse = netlink_parse_payload },
+	{ .name = "bitwise",	.parse = netlink_parse_bitwise },
+	{ .name = "meta",	.parse = netlink_parse_meta },
+};
+
+static int expr_parse_cb(struct nftnl_expr *expr, void *data)
+{
+	const char *name = nftnl_expr_get_str(expr, NFTNL_EXPR_NAME);
+	struct cb_args *args = data;
+	struct imr_state *state = args->s;
+	unsigned int i;
+
+	if (!name)
+		return -1;
+
+	for (i = 0; i < MNL_ARRAY_SIZE(netlink_parsers); i++) {
+		int ret;
+
+		if (strcmp(netlink_parsers[i].name, name))
+			continue;
+
+		ret = netlink_parsers[i].parse(expr, state);
+		if (ret == 0) {
+			args->exprs_seen++;
+
+			if (strcmp(netlink_parsers[i].name, "cmp") == 0 ||
+			    strcmp(netlink_parsers[i].name, "immediate") == 0) {
+
+				args->stmt_exprs += args->exprs_seen;
+				args->exprs_seen = 0;
+			}
+		}
+
+		fprintf(log_file, "parse: %s got %d\n", name, ret);
+		return ret;
+	}
+
+	fprintf(log_file, "cannot handle expression %s\n", name);
+	return -EOPNOTSUPP;
+}
+
+static int nlmsg_parse_newrule(const struct nlmsghdr *nlh, struct cb_args *args)
+{
+	struct nft_ebpf_prog prog;
+	struct imr_state *state;
+	struct nftnl_rule *rule;
+	int ret = -ENOMEM;
+
+	rule = nftnl_rule_alloc();
+	if (!rule)
+		memory_allocation_error();
+
+	if (nftnl_rule_nlmsg_parse(nlh, rule) < 0)
+		goto err_free;
+
+	state = imr_state_alloc();
+	if (!state)
+		goto err_free;
+
+	ret = imr_state_init(state,
+			     nftnl_rule_get_u32(rule, NFTNL_RULE_FAMILY));
+	if (ret < 0) {
+		imr_state_free(state);
+		goto err_free;
+	}
 
-		if (read(0, buf, sizeof(buf)) < 0)
-			return 1;
-		if (write(1, &response, sizeof(response)) != sizeof(response))
-			return 2;
+	ret = imr_state_rule_begin(state);
+	if (ret < 0) {
+		imr_state_free(state);
+		goto err_free;
+	}
+
+	args->s = state;
+	ret = nftnl_expr_foreach(rule, expr_parse_cb, args);
+	if (ret == 0) {
+		fprintf(log_file, "completed tranlsation, %d stmt_exprs and %d partial\n",
+				  args->stmt_exprs, args->exprs_seen);
+	} else {
+		fprintf(log_file, "failed translation, %d stmt_exprs and %d partial\n",
+				  args->stmt_exprs, args->exprs_seen);
+		if (args->stmt_exprs) {
+			ret = imr_state_add_obj(state, imr_object_alloc_verdict(IMR_VERDICT_NONE));
+			if (ret < 0) {
+				imr_state_free(state);
+				goto err_free;
+			}
+		}
+	}
+
+	ret = imr_state_rule_end(state);
+	if (ret < 0) {
+		imr_state_free(state);
+		goto err_free;
+	}
+
+	imr_state_print(log_file, state);
+
+	if (args->stmt_exprs) {
+		prog.type = BPF_PROG_TYPE_SCHED_CLS;
+		prog.insn = imr_translate(state, &prog.len);
+
+		imr_state_free(state);
+		if (!prog.insn)
+			goto err_free;
+
+		args->fd = bpf_prog_load(&prog);
+		free((void*)prog.insn);
+		if (args->fd < 0)
+			goto err_free;
+		ret = 0;
+	} else {
+		imr_state_free(state);
+	}
+
+err_free:
+	nftnl_rule_free(rule);
+	return ret;
+}
+
+static int nlmsg_parse(const struct nlmsghdr *nlh, void *data)
+{
+	struct cb_args *args = data;
+
+	fprintf(log_file, "%s:%d, buflen %d, nlh %d, nl len %d\n", __FILE__, __LINE__,
+		(int)args->buflen, (int)sizeof(*nlh) , (int) nlh->nlmsg_len);
+	if (args->buflen < sizeof(*nlh) || args->buflen < nlh->nlmsg_len) {
+		// nftjit.c:517, buflen 428, nlh 16, nl len 20
+		fprintf(log_file, "%s:%d- ERROR: buflen %d, nlh %d, nl len %d\n", __FILE__, __LINE__,
+		(int)args->buflen, (int)sizeof(*nlh) , (int) nlh->nlmsg_len);
+		return -EINVAL;
+	}
+
+	switch (NFNL_MSG_TYPE(nlh->nlmsg_type)) {
+	case NFT_MSG_NEWRULE:
+		return nlmsg_parse_newrule(nlh, args);
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int doit(void)
+{
+	struct cb_args args;
+	struct nft_jit_data_from_user to_kernel = { .ebpf_fd = -1 };
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	ssize_t len;
+	int ret;
+
+	fprintf(log_file, "block in read, pid %d\n", (int) getpid());
+	len = read(0, buf, sizeof(buf));
+	if (len <= 0)
+		return 1;
+
+	memset(&args, 0, sizeof(args));
+	args.buflen = len;
+	args.fd = -1;
+
+	ret = len;
+	ret = mnl_cb_run(buf, ret, 0, 0, nlmsg_parse, &args);
+	to_kernel.ebpf_fd = args.fd;
+	to_kernel.expr_count = args.stmt_exprs;
+	if (ret < 0)
+		fprintf(log_file, "%s: mnl_cb_run: %d\n", __func__, ret);
+
+	if (write(1, &to_kernel, sizeof(to_kernel)) != (int)sizeof(to_kernel))
+		return 2;
+
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	int fd;
+
+	log_file = fopen("/tmp/debug.log", "a");
+	if (!log_file)
+		return 1;
+
+	fd = -1;
+	for (;;) {
+		int ret = doit();
+		if (ret != 0)
+			return ret;
+		close(fd);
+		fd = ret;
 	}
 
 	return 0;
diff --git a/net/netfilter/nf_tables_jit/nf_tables_jit_kern.c b/net/netfilter/nf_tables_jit/nf_tables_jit_kern.c
index 4778f53b2683..bd319d41e2d1 100644
--- a/net/netfilter/nf_tables_jit/nf_tables_jit_kern.c
+++ b/net/netfilter/nf_tables_jit/nf_tables_jit_kern.c
@@ -1,6 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/umh.h>
+#include <linux/sched.h>
+#include <linux/sched/signal.h>
+#include <linux/fs.h>
+#include <linux/fdtable.h>
+#include <linux/file.h>
+#include <linux/skbuff.h>
+#include <linux/bpf.h>
+
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
@@ -18,8 +26,54 @@ static int nft_jit_load_umh(void)
 	return fork_usermode_blob(&UMH_start, &UMH_end - &UMH_start, &info);
 }
 
-int nf_tables_jit_work(const struct sk_buff *nlskb, struct nft_ebpf *e)
+static void nft_jit_fd_to_prog(struct nft_ebpf *e, int fd, u32 expr_count)
+{
+	struct task_struct *task = pid_task(find_vpid(info.pid), PIDTYPE_PID);
+	struct files_struct *files;
+	struct bpf_prog *p;
+	struct file *file;
+
+	if (WARN_ON_ONCE(!task) || expr_count > 128) {
+		nft_jit_stop_umh();
+		return;
+	}
+
+	if (expr_count == 0) /* could not translate */
+		return;
+
+	task_lock(task);
+	files = task->files;
+	if (!files)
+		goto out_unlock;
+
+	file = fcheck_files(files, fd);
+	if (file && !get_file_rcu(file))
+		file = NULL;
+
+	if (!file)
+		goto out_unlock;
+
+	p = bpf_prog_get_type_dev_file(file, BPF_PROG_TYPE_SCHED_CLS, false);
+
+	task_unlock(task);
+
+	if (!IS_ERR(p)) {
+		e->prog = p;
+		e->expressions = expr_count;
+	}
+
+	fput(file);
+	return;
+out_unlock:
+	task_unlock(task);
+	nft_jit_stop_umh();
+}
+
+static int nft_jit_write_rule_info(const struct sk_buff *nlskb)
 {
+	const char *addr = nlskb->data;
+	ssize_t w, n, nr = nlskb->len;
+
 	if (!info.pipe_to_umh) {
 		int ret = nft_jit_load_umh();
 		if (ret)
@@ -29,5 +83,93 @@ int nf_tables_jit_work(const struct sk_buff *nlskb, struct nft_ebpf *e)
 			return -EINVAL;
 	}
 
-	return 0;
+	w = 0;
+	do {
+		loff_t pos = 0;
+
+		n = __kernel_write(info.pipe_to_umh, addr, nr, &pos);
+		if (n < 0)
+			return n;
+		w += n;
+		nr -= n;
+		if (nr == 0)
+			break;
+		addr += n;
+	} while (!signal_pending(current));
+
+	if (w == nlskb->len)
+		return 0;
+
+	return -EINTR;
+}
+
+static int nft_jit_read_result(struct nft_jit_data_from_user *res)
+{
+	ssize_t r, n, nr = sizeof(*res);
+
+	r = 0;
+
+	do {
+		loff_t pos = 0;
+
+		n = kernel_read(info.pipe_from_umh, res, nr, &pos);
+		if (n < 0)
+			return n;
+		if (n == 0)
+			return -EPIPE;
+		r += n;
+		nr -= n;
+		if (nr == 0)
+			break;
+	} while (!signal_pending(current));
+
+	if (r == (ssize_t)sizeof(*res))
+		return 0;
+
+	return -EINTR;
+}
+
+int nf_tables_jit_work(const struct sk_buff *nlskb, struct nft_ebpf *e)
+{
+	struct nft_jit_data_from_user from_usr;
+	int ret;
+
+	ret = nft_jit_write_rule_info(nlskb);
+	if (ret < 0) {
+		nft_jit_stop_umh();
+		pr_info("write rule info: ret %d\n", ret);
+		return ret;
+	}
+
+	ret = nft_jit_read_result(&from_usr);
+	if (ret < 0) {
+		pr_info("read rule info: ret %d\n", ret);
+		nft_jit_stop_umh();
+		return ret;
+	}
+
+	if (from_usr.ebpf_fd >= 0) {
+		rcu_read_lock();
+		nft_jit_fd_to_prog(e, from_usr.ebpf_fd, from_usr.expr_count);
+		rcu_read_unlock();
+		return 0;
+	}
+
+	return ret;
+}
+
+void nft_jit_stop_umh(void)
+{
+	struct task_struct *tsk;
+
+	rcu_read_lock();
+	tsk = pid_task(find_vpid(info.pid), PIDTYPE_PID);
+	if (tsk)
+		force_sig(SIGKILL, tsk);
+	rcu_read_unlock();
+	fput(info.pipe_to_umh);
+	fput(info.pipe_from_umh);
+	memset(&info, 0, sizeof(info));
+
+	info.pid = -1;
 }
-- 
2.16.4
