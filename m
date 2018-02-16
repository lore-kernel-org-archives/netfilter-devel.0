From: Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH RFC 4/4] bpf: rough bpfilter codegen example hack
Date: Fri, 16 Feb 2018 14:40:23 +0100
Message-ID: <20180216134023.15536-5-daniel@iogearbox.net>
References: <20180216134023.15536-1-daniel@iogearbox.net>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
        alexei.starovoitov@gmail.com,
        Daniel Borkmann <daniel@iogearbox.net>
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180216134023.15536-1-daniel@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 include/uapi/linux/bpf.h    |  31 +++--
 kernel/bpf/syscall.c        |  39 +++---
 net/bpfilter/Makefile       |   2 +-
 net/bpfilter/bpfilter.c     |  59 +++++----
 net/bpfilter/bpfilter_mod.h | 285 ++++++++++++++++++++++++++++++++++++++++++-
 net/bpfilter/ctor.c         |  57 +++++----
 net/bpfilter/gen.c          | 290 ++++++++++++++++++++++++++++++++++++++++++++
 net/bpfilter/init.c         |  11 +-
 net/bpfilter/sockopt.c      | 137 ++++++++++++++++-----
 net/bpfilter/tables.c       |   5 +-
 net/bpfilter/tgts.c         |   1 +
 net/ipv4/bpfilter/sockopt.c |  25 +++-
 13 files changed, 835 insertions(+), 109 deletions(-)
 create mode 100644 net/bpfilter/gen.c

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index ea977e9..066d76b 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -94,8 +94,8 @@ enum bpf_cmd {
 	BPF_MAP_GET_FD_BY_ID,
 	BPF_OBJ_GET_INFO_BY_FD,
 	BPF_PROG_QUERY,
-	BPFILTER_GET_CMD,
-	BPFILTER_REPLY,
+	BPF_MBOX_REQUEST,
+	BPF_MBOX_REPLY,
 };
 
 enum bpf_map_type {
@@ -233,14 +233,29 @@ enum bpf_attach_type {
 #define BPF_F_RDONLY		(1U << 3)
 #define BPF_F_WRONLY		(1U << 4)
 
-struct bpfilter_get_cmd {
-	__u32 pid;
-	__u32 cmd;
+enum bpf_mbox_subsys {
+	BPF_MBOX_SUBSYS_BPFILTER,
+#define BPF_MBOX_SUBSYS_BPFILTER	BPF_MBOX_SUBSYS_BPFILTER
+};
+
+enum bpf_mbox_kind {
+	BPF_MBOX_KIND_SET,
+#define BPF_MBOX_KIND_SET		BPF_MBOX_KIND_SET
+	BPF_MBOX_KIND_GET,
+#define BPF_MBOX_KIND_GET		BPF_MBOX_KIND_GET
+};
+
+struct bpf_mbox_request {
 	__u64 addr;
 	__u32 len;
+	__u32 subsys;
+	__u32 kind;
+	__u32 cmd;
+	__u32 pid;
 };
 
-struct bpfilter_reply {
+struct bpf_mbox_reply {
+	__u32 subsys;
 	__u32 status;
 };
 
@@ -334,8 +349,8 @@ union bpf_attr {
 		__u32		prog_cnt;
 	} query;
 
-	struct bpfilter_get_cmd bpfilter_get_cmd;
-	struct bpfilter_reply bpfilter_reply;
+	struct bpf_mbox_request	mbox_request;
+	struct bpf_mbox_reply 	mbox_reply;
 } __attribute__((aligned(8)));
 
 /* BPF helper function descriptions:
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e933bf9..2feb438 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1842,36 +1842,47 @@ static int bpf_obj_get_info_by_fd(const union bpf_attr *attr,
 
 DECLARE_WAIT_QUEUE_HEAD(bpfilter_get_cmd_wq);
 DECLARE_WAIT_QUEUE_HEAD(bpfilter_reply_wq);
+
 bool bpfilter_get_cmd_ready = false;
 bool bpfilter_reply_ready = false;
-struct bpfilter_get_cmd bpfilter_get_cmd_mbox;
-struct bpfilter_reply bpfilter_reply_mbox;
 
-#define BPFILTER_GET_CMD_LAST_FIELD bpfilter_get_cmd.len
+struct bpf_mbox_request bpfilter_get_cmd_mbox;
+struct bpf_mbox_reply   bpfilter_reply_mbox;
+
+#define BPF_MBOX_REQUEST_LAST_FIELD	mbox_request.pid
 
-static int bpfilter_get_cmd(const union bpf_attr *attr,
+static int bpf_mbox_request(const union bpf_attr *attr,
 			    union bpf_attr __user *uattr)
 {
-	if (CHECK_ATTR(BPFILTER_GET_CMD))
+	if (CHECK_ATTR(BPF_MBOX_REQUEST))
 		return -EINVAL;
+	if (attr->mbox_request.subsys != BPF_MBOX_SUBSYS_BPFILTER)
+		return -ENOTSUPP;
+
 	wait_event_killable(bpfilter_get_cmd_wq, bpfilter_get_cmd_ready);
 	bpfilter_get_cmd_ready = false;
-	if (copy_to_user(&uattr->bpfilter_get_cmd, &bpfilter_get_cmd_mbox,
+
+	if (copy_to_user(&uattr->mbox_request, &bpfilter_get_cmd_mbox,
 			 sizeof(bpfilter_get_cmd_mbox)))
 		return -EFAULT;
 	return 0;
 }
 
-#define BPFILTER_REPLY_LAST_FIELD bpfilter_reply.status
+#define BPF_MBOX_REPLY_LAST_FIELD	mbox_reply.status
 
-static int bpfilter_reply(const union bpf_attr *attr,
+static int bpf_mbox_reply(const union bpf_attr *attr,
 			  union bpf_attr __user *uattr)
 {
-	if (CHECK_ATTR(BPFILTER_REPLY))
+	if (CHECK_ATTR(BPF_MBOX_REPLY))
 		return -EINVAL;
-	bpfilter_reply_mbox.status = attr->bpfilter_reply.status;
+	if (attr->mbox_reply.subsys != BPF_MBOX_SUBSYS_BPFILTER)
+		return -ENOTSUPP;
+
+	bpfilter_reply_mbox.subsys = attr->mbox_reply.subsys;
+	bpfilter_reply_mbox.status = attr->mbox_reply.status;
 	bpfilter_reply_ready = true;
 	wake_up(&bpfilter_reply_wq);
+
 	return 0;
 }
 
@@ -1952,11 +1963,11 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 	case BPF_OBJ_GET_INFO_BY_FD:
 		err = bpf_obj_get_info_by_fd(&attr, uattr);
 		break;
-	case BPFILTER_GET_CMD:
-		err = bpfilter_get_cmd(&attr, uattr);
+	case BPF_MBOX_REQUEST:
+		err = bpf_mbox_request(&attr, uattr);
 		break;
-	case BPFILTER_REPLY:
-		err = bpfilter_reply(&attr, uattr);
+	case BPF_MBOX_REPLY:
+		err = bpf_mbox_reply(&attr, uattr);
 		break;
 	default:
 		err = -EINVAL;
diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
index 5e05505..5a85ef7 100644
--- a/net/bpfilter/Makefile
+++ b/net/bpfilter/Makefile
@@ -5,5 +5,5 @@
 
 hostprogs-y := bpfilter.ko
 always := $(hostprogs-y)
-bpfilter.ko-objs := bpfilter.o tgts.o targets.o tables.o init.o ctor.o sockopt.o
+bpfilter.ko-objs := bpfilter.o tgts.o targets.o tables.o init.o ctor.o sockopt.o gen.o
 HOSTCFLAGS += -I. -Itools/include/
diff --git a/net/bpfilter/bpfilter.c b/net/bpfilter/bpfilter.c
index 445ae65..364c66a 100644
--- a/net/bpfilter/bpfilter.c
+++ b/net/bpfilter/bpfilter.c
@@ -1,19 +1,22 @@
 // SPDX-License-Identifier: GPL-2.0
 #define _GNU_SOURCE
-#include <sys/uio.h>
 #include <errno.h>
 #include <stdio.h>
-#include <sys/socket.h>
 #include <fcntl.h>
 #include <unistd.h>
-#include "include/uapi/linux/bpf.h"
+
+#include <sys/uio.h>
+#include <sys/socket.h>
+
 #include <asm/unistd.h>
+
+#include "include/uapi/linux/bpf.h"
+
 #include "bpfilter_mod.h"
 
 extern long int syscall (long int __sysno, ...);
 
-static inline int sys_bpf(enum bpf_cmd cmd, union bpf_attr *attr,
-			  unsigned int size)
+int sys_bpf(int cmd, union bpf_attr *attr, unsigned int size)
 {
 	return syscall(321, cmd, attr, size);
 }
@@ -38,21 +41,35 @@ int copy_to_user(void *addr, const void *src, int len)
 	struct iovec local;
 	struct iovec remote;
 
-	local.iov_base = (void *) src;
+	local.iov_base = (void *)src;
 	local.iov_len = len;
 	remote.iov_base = addr;
 	remote.iov_len = len;
 	return process_vm_writev(pid, &local, 1, &remote, 1, 0) != len;
 }
 
-static int handle_cmd(struct bpfilter_get_cmd *cmd)
+static int handle_get_cmd(struct bpf_mbox_request *cmd)
 {
 	pid = cmd->pid;
 	switch (cmd->cmd) {
 	case BPFILTER_IPT_SO_GET_INFO:
-		return bpfilter_get_info((void *) (long) cmd->addr, cmd->len);
+		return bpfilter_get_info((void *)(long)cmd->addr, cmd->len);
 	case BPFILTER_IPT_SO_GET_ENTRIES:
-		return bpfilter_get_entries((void *) (long) cmd->addr, cmd->len);
+		return bpfilter_get_entries((void *)(long)cmd->addr, cmd->len);
+	default:
+		break;
+	}
+	return -ENOPROTOOPT;
+}
+
+static int handle_set_cmd(struct bpf_mbox_request *cmd)
+{
+	pid = cmd->pid;
+	switch (cmd->cmd) {
+	case BPFILTER_IPT_SO_SET_REPLACE:
+		return bpfilter_set_replace((void *)(long)cmd->addr, cmd->len);
+	case BPFILTER_IPT_SO_SET_ADD_COUNTERS:
+		return bpfilter_set_add_counters((void *)(long)cmd->addr, cmd->len);
 	default:
 		break;
 	}
@@ -65,24 +82,24 @@ static void loop(void)
 	bpfilter_ipv4_init();
 
 	while (1) {
-		union bpf_attr get_cmd = {};
-		union bpf_attr reply = {};
-		struct bpfilter_get_cmd *cmd;
-
-		sys_bpf(BPFILTER_GET_CMD, &get_cmd, sizeof(get_cmd));
-		cmd = &get_cmd.bpfilter_get_cmd;
-
-		dprintf(debug_fd, "pid %d cmd %d addr %llx len %d\n",
-			cmd->pid, cmd->cmd, cmd->addr, cmd->len);
+		union bpf_attr req = {};
+		union bpf_attr rep = {};
+		struct bpf_mbox_request *cmd;
 
-		reply.bpfilter_reply.status = handle_cmd(cmd);
-		sys_bpf(BPFILTER_REPLY, &reply, sizeof(reply));
+		req.mbox_request.subsys = BPF_MBOX_SUBSYS_BPFILTER;
+		sys_bpf(BPF_MBOX_REQUEST, &req, sizeof(req));
+		cmd = &req.mbox_request;
+		rep.mbox_reply.subsys = BPF_MBOX_SUBSYS_BPFILTER;
+		rep.mbox_reply.status = cmd->kind == BPF_MBOX_KIND_SET ?
+					handle_set_cmd(cmd) :
+					handle_get_cmd(cmd);
+		sys_bpf(BPF_MBOX_REPLY, &rep, sizeof(rep));
 	}
 }
 
 int main(void)
 {
-	debug_fd = open("/tmp/aa", 00000002 | 00000100);
+	debug_fd = open("/dev/pts/1" /* /tmp/aa */, 00000002 | 00000100);
 	loop();
 	close(debug_fd);
 	return 0;
diff --git a/net/bpfilter/bpfilter_mod.h b/net/bpfilter/bpfilter_mod.h
index f0de41b..b420998 100644
--- a/net/bpfilter/bpfilter_mod.h
+++ b/net/bpfilter/bpfilter_mod.h
@@ -21,8 +21,8 @@ struct bpfilter_table_info {
 	unsigned int		initial_entries;
 	unsigned int		hook_entry[BPFILTER_INET_HOOK_MAX];
 	unsigned int		underflow[BPFILTER_INET_HOOK_MAX];
-	unsigned int		stacksize;
-	void			***jumpstack;
+//	unsigned int		stacksize;
+//	void			***jumpstack;
 	unsigned char		entries[0] __aligned(8);
 };
 
@@ -64,22 +64,55 @@ struct bpfilter_ipt_error {
 
 struct bpfilter_target {
 	struct list_head	all_target_list;
-	const char		name[BPFILTER_EXTENSION_MAXNAMELEN];
+	char			name[BPFILTER_EXTENSION_MAXNAMELEN];
 	unsigned int		size;
 	int			hold;
 	u16			family;
 	u8			rev;
 };
 
+struct bpfilter_gen_ctx {
+	struct bpf_insn		*img;
+	u32			len_cur;
+	u32			len_max;
+	u32			default_verdict;
+	int			fd;
+	int			ifindex;
+	bool			offloaded;
+};
+
+union bpf_attr;
+int sys_bpf(int cmd, union bpf_attr *attr, unsigned int size);
+
+int bpfilter_gen_init(struct bpfilter_gen_ctx *ctx);
+int bpfilter_gen_prologue(struct bpfilter_gen_ctx *ctx);
+int bpfilter_gen_epilogue(struct bpfilter_gen_ctx *ctx);
+int bpfilter_gen_append(struct bpfilter_gen_ctx *ctx,
+			struct bpfilter_ipt_ip *ent, int verdict);
+int bpfilter_gen_commit(struct bpfilter_gen_ctx *ctx);
+void bpfilter_gen_destroy(struct bpfilter_gen_ctx *ctx);
+
 struct bpfilter_target *bpfilter_target_get_by_name(const char *name);
 void bpfilter_target_put(struct bpfilter_target *tgt);
 int bpfilter_target_add(struct bpfilter_target *tgt);
 
-struct bpfilter_table_info *bpfilter_ipv4_table_ctor(struct bpfilter_table *tbl);
+struct bpfilter_table_info *
+bpfilter_ipv4_table_alloc(struct bpfilter_table *tbl, __u32 size_ents);
+struct bpfilter_table_info *
+bpfilter_ipv4_table_finalize(struct bpfilter_table *tbl,
+			     struct bpfilter_table_info *info,
+			     __u32 size_ents, __u32 num_ents);
+struct bpfilter_table_info *
+bpfilter_ipv4_table_finalize2(struct bpfilter_table *tbl,
+			      struct bpfilter_table_info *info,
+			      __u32 size_ents, __u32 num_ents);
+
 int bpfilter_ipv4_register_targets(void);
 void bpfilter_tables_init(void);
 int bpfilter_get_info(void *addr, int len);
 int bpfilter_get_entries(void *cmd, int len);
+int bpfilter_set_replace(void *cmd, int len);
+int bpfilter_set_add_counters(void *cmd, int len);
 int bpfilter_ipv4_init(void);
 
 int copy_from_user(void *dst, void *addr, int len);
@@ -93,4 +126,248 @@ extern int pid;
 extern int debug_fd;
 #define ENOTSUPP        524
 
+/* Helper macros for filter block array initializers. */
+
+/* ALU ops on registers, bpf_add|sub|...: dst_reg += src_reg */
+
+#define BPF_ALU64_REG(OP, DST, SRC)				\
+	((struct bpf_insn) {					\
+		.code  = BPF_ALU64 | BPF_OP(OP) | BPF_X,	\
+		.dst_reg = DST,					\
+		.src_reg = SRC,					\
+		.off   = 0,					\
+		.imm   = 0 })
+
+#define BPF_ALU32_REG(OP, DST, SRC)				\
+	((struct bpf_insn) {					\
+		.code  = BPF_ALU | BPF_OP(OP) | BPF_X,		\
+		.dst_reg = DST,					\
+		.src_reg = SRC,					\
+		.off   = 0,					\
+		.imm   = 0 })
+
+/* ALU ops on immediates, bpf_add|sub|...: dst_reg += imm32 */
+
+#define BPF_ALU64_IMM(OP, DST, IMM)				\
+	((struct bpf_insn) {					\
+		.code  = BPF_ALU64 | BPF_OP(OP) | BPF_K,	\
+		.dst_reg = DST,					\
+		.src_reg = 0,					\
+		.off   = 0,					\
+		.imm   = IMM })
+
+#define BPF_ALU32_IMM(OP, DST, IMM)				\
+	((struct bpf_insn) {					\
+		.code  = BPF_ALU | BPF_OP(OP) | BPF_K,		\
+		.dst_reg = DST,					\
+		.src_reg = 0,					\
+		.off   = 0,					\
+		.imm   = IMM })
+
+/* Endianess conversion, cpu_to_{l,b}e(), {l,b}e_to_cpu() */
+
+#define BPF_ENDIAN(TYPE, DST, LEN)				\
+	((struct bpf_insn) {					\
+		.code  = BPF_ALU | BPF_END | BPF_SRC(TYPE),	\
+		.dst_reg = DST,					\
+		.src_reg = 0,					\
+		.off   = 0,					\
+		.imm   = LEN })
+
+/* Short form of mov, dst_reg = src_reg */
+
+#define BPF_MOV64_REG(DST, SRC)					\
+	((struct bpf_insn) {					\
+		.code  = BPF_ALU64 | BPF_MOV | BPF_X,		\
+		.dst_reg = DST,					\
+		.src_reg = SRC,					\
+		.off   = 0,					\
+		.imm   = 0 })
+
+#define BPF_MOV32_REG(DST, SRC)					\
+	((struct bpf_insn) {					\
+		.code  = BPF_ALU | BPF_MOV | BPF_X,		\
+		.dst_reg = DST,					\
+		.src_reg = SRC,					\
+		.off   = 0,					\
+		.imm   = 0 })
+
+/* Short form of mov, dst_reg = imm32 */
+
+#define BPF_MOV64_IMM(DST, IMM)					\
+	((struct bpf_insn) {					\
+		.code  = BPF_ALU64 | BPF_MOV | BPF_K,		\
+		.dst_reg = DST,					\
+		.src_reg = 0,					\
+		.off   = 0,					\
+		.imm   = IMM })
+
+#define BPF_MOV32_IMM(DST, IMM)					\
+	((struct bpf_insn) {					\
+		.code  = BPF_ALU | BPF_MOV | BPF_K,		\
+		.dst_reg = DST,					\
+		.src_reg = 0,					\
+		.off   = 0,					\
+		.imm   = IMM })
+
+/* BPF_LD_IMM64 macro encodes single 'load 64-bit immediate' insn */
+#define BPF_LD_IMM64(DST, IMM)					\
+	BPF_LD_IMM64_RAW(DST, 0, IMM)
+
+#define BPF_LD_IMM64_RAW(DST, SRC, IMM)				\
+	((struct bpf_insn) {					\
+		.code  = BPF_LD | BPF_DW | BPF_IMM,		\
+		.dst_reg = DST,					\
+		.src_reg = SRC,					\
+		.off   = 0,					\
+		.imm   = (__u32) (IMM) }),			\
+	((struct bpf_insn) {					\
+		.code  = 0, /* zero is reserved opcode */	\
+		.dst_reg = 0,					\
+		.src_reg = 0,					\
+		.off   = 0,					\
+		.imm   = ((__u64) (IMM)) >> 32 })
+
+/* pseudo BPF_LD_IMM64 insn used to refer to process-local map_fd */
+#define BPF_LD_MAP_FD(DST, MAP_FD)				\
+	BPF_LD_IMM64_RAW(DST, BPF_PSEUDO_MAP_FD, MAP_FD)
+
+/* Short form of mov based on type, BPF_X: dst_reg = src_reg, BPF_K: dst_reg = imm32 */
+
+#define BPF_MOV64_RAW(TYPE, DST, SRC, IMM)			\
+	((struct bpf_insn) {					\
+		.code  = BPF_ALU64 | BPF_MOV | BPF_SRC(TYPE),	\
+		.dst_reg = DST,					\
+		.src_reg = SRC,					\
+		.off   = 0,					\
+		.imm   = IMM })
+
+#define BPF_MOV32_RAW(TYPE, DST, SRC, IMM)			\
+	((struct bpf_insn) {					\
+		.code  = BPF_ALU | BPF_MOV | BPF_SRC(TYPE),	\
+		.dst_reg = DST,					\
+		.src_reg = SRC,					\
+		.off   = 0,					\
+		.imm   = IMM })
+
+/* Direct packet access, R0 = *(uint *) (skb->data + imm32) */
+
+#define BPF_LD_ABS(SIZE, IMM)					\
+	((struct bpf_insn) {					\
+		.code  = BPF_LD | BPF_SIZE(SIZE) | BPF_ABS,	\
+		.dst_reg = 0,					\
+		.src_reg = 0,					\
+		.off   = 0,					\
+		.imm   = IMM })
+
+/* Indirect packet access, R0 = *(uint *) (skb->data + src_reg + imm32) */
+
+#define BPF_LD_IND(SIZE, SRC, IMM)				\
+	((struct bpf_insn) {					\
+		.code  = BPF_LD | BPF_SIZE(SIZE) | BPF_IND,	\
+		.dst_reg = 0,					\
+		.src_reg = SRC,					\
+		.off   = 0,					\
+		.imm   = IMM })
+
+/* Memory load, dst_reg = *(uint *) (src_reg + off16) */
+
+#define BPF_LDX_MEM(SIZE, DST, SRC, OFF)			\
+	((struct bpf_insn) {					\
+		.code  = BPF_LDX | BPF_SIZE(SIZE) | BPF_MEM,	\
+		.dst_reg = DST,					\
+		.src_reg = SRC,					\
+		.off   = OFF,					\
+		.imm   = 0 })
+
+/* Memory store, *(uint *) (dst_reg + off16) = src_reg */
+
+#define BPF_STX_MEM(SIZE, DST, SRC, OFF)			\
+	((struct bpf_insn) {					\
+		.code  = BPF_STX | BPF_SIZE(SIZE) | BPF_MEM,	\
+		.dst_reg = DST,					\
+		.src_reg = SRC,					\
+		.off   = OFF,					\
+		.imm   = 0 })
+
+/* Atomic memory add, *(uint *)(dst_reg + off16) += src_reg */
+
+#define BPF_STX_XADD(SIZE, DST, SRC, OFF)			\
+	((struct bpf_insn) {					\
+		.code  = BPF_STX | BPF_SIZE(SIZE) | BPF_XADD,	\
+		.dst_reg = DST,					\
+		.src_reg = SRC,					\
+		.off   = OFF,					\
+		.imm   = 0 })
+
+/* Memory store, *(uint *) (dst_reg + off16) = imm32 */
+
+#define BPF_ST_MEM(SIZE, DST, OFF, IMM)				\
+	((struct bpf_insn) {					\
+		.code  = BPF_ST | BPF_SIZE(SIZE) | BPF_MEM,	\
+		.dst_reg = DST,					\
+		.src_reg = 0,					\
+		.off   = OFF,					\
+		.imm   = IMM })
+
+/* Conditional jumps against registers, if (dst_reg 'op' src_reg) goto pc + off16 */
+
+#define BPF_JMP_REG(OP, DST, SRC, OFF)				\
+	((struct bpf_insn) {					\
+		.code  = BPF_JMP | BPF_OP(OP) | BPF_X,		\
+		.dst_reg = DST,					\
+		.src_reg = SRC,					\
+		.off   = OFF,					\
+		.imm   = 0 })
+
+/* Conditional jumps against immediates, if (dst_reg 'op' imm32) goto pc + off16 */
+
+#define BPF_JMP_IMM(OP, DST, IMM, OFF)				\
+	((struct bpf_insn) {					\
+		.code  = BPF_JMP | BPF_OP(OP) | BPF_K,		\
+		.dst_reg = DST,					\
+		.src_reg = 0,					\
+		.off   = OFF,					\
+		.imm   = IMM })
+
+/* Unconditional jumps, goto pc + off16 */
+
+#define BPF_JMP_A(OFF)						\
+	((struct bpf_insn) {					\
+		.code  = BPF_JMP | BPF_JA,			\
+		.dst_reg = 0,					\
+		.src_reg = 0,					\
+		.off   = OFF,					\
+		.imm   = 0 })
+
+/* Function call */
+
+#define BPF_EMIT_CALL(FUNC)					\
+	((struct bpf_insn) {					\
+		.code  = BPF_JMP | BPF_CALL,			\
+		.dst_reg = 0,					\
+		.src_reg = 0,					\
+		.off   = 0,					\
+		.imm   = ((FUNC) - __bpf_call_base) })
+
+/* Raw code statement block */
+
+#define BPF_RAW_INSN(CODE, DST, SRC, OFF, IMM)			\
+	((struct bpf_insn) {					\
+		.code  = CODE,					\
+		.dst_reg = DST,					\
+		.src_reg = SRC,					\
+		.off   = OFF,					\
+		.imm   = IMM })
+
+/* Program exit */
+
+#define BPF_EXIT_INSN()						\
+	((struct bpf_insn) {					\
+		.code  = BPF_JMP | BPF_EXIT,			\
+		.dst_reg = 0,					\
+		.src_reg = 0,					\
+		.off   = 0,					\
+		.imm   = 0 })
+
 #endif
diff --git a/net/bpfilter/ctor.c b/net/bpfilter/ctor.c
index efb7fee..ba44c21 100644
--- a/net/bpfilter/ctor.c
+++ b/net/bpfilter/ctor.c
@@ -1,8 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <sys/socket.h>
-#include <linux/bitops.h>
 #include <stdlib.h>
 #include <stdio.h>
+#include <string.h>
+
+#include <sys/socket.h>
+
+#include <linux/bitops.h>
+
 #include "bpfilter_mod.h"
 
 unsigned int __sw_hweight32(unsigned int w)
@@ -13,35 +17,47 @@ unsigned int __sw_hweight32(unsigned int w)
 	return (w * 0x01010101) >> 24;
 }
 
-struct bpfilter_table_info *bpfilter_ipv4_table_ctor(struct bpfilter_table *tbl)
+struct bpfilter_table_info *bpfilter_ipv4_table_alloc(struct bpfilter_table *tbl,
+						      __u32 size_ents)
 {
 	unsigned int num_hooks = hweight32(tbl->valid_hooks);
-	struct bpfilter_ipt_standard *tgts;
 	struct bpfilter_table_info *info;
-	struct bpfilter_ipt_error *term;
-	unsigned int mask, offset, h, i;
 	unsigned int size, alloc_size;
 
 	size  = sizeof(struct bpfilter_ipt_standard) * num_hooks;
 	size += sizeof(struct bpfilter_ipt_error);
+	size += size_ents;
 
 	alloc_size = size + sizeof(struct bpfilter_table_info);
 
 	info = malloc(alloc_size);
-	if (!info)
-		return NULL;
+	if (info) {
+		memset(info, 0, alloc_size);
+		info->size = size;
+	}
+	return info;
+}
+
+struct bpfilter_table_info *bpfilter_ipv4_table_finalize(struct bpfilter_table *tbl,
+							 struct bpfilter_table_info *info,
+							 __u32 size_ents, __u32 num_ents)
+{
+	unsigned int num_hooks = hweight32(tbl->valid_hooks);
+	struct bpfilter_ipt_standard *tgts;
+	struct bpfilter_ipt_error *term;
+	struct bpfilter_ipt_entry *ent;
+	unsigned int mask, offset, h, i;
 
-	info->num_entries = num_hooks + 1;
-	info->size = size;
+	info->num_entries = num_ents + num_hooks + 1;
 
-	tgts = (struct bpfilter_ipt_standard *) (info + 1);
-	term = (struct bpfilter_ipt_error *) (tgts + num_hooks);
+	ent  = (struct bpfilter_ipt_entry *)(info + 1);
+	tgts = (struct bpfilter_ipt_standard *)((u8 *)ent + size_ents);
+	term = (struct bpfilter_ipt_error *)(tgts + num_hooks);
 
 	mask = tbl->valid_hooks;
 	offset = 0;
 	h = 0;
 	i = 0;
-	dprintf(debug_fd, "mask %x num_hooks %d\n", mask, num_hooks);
 	while (mask) {
 		struct bpfilter_ipt_standard *t;
 
@@ -55,7 +71,6 @@ struct bpfilter_table_info *bpfilter_ipv4_table_ctor(struct bpfilter_table *tbl)
 			BPFILTER_IPT_STANDARD_INIT(BPFILTER_NF_ACCEPT);
 		t->target.target.u.kernel.target =
 			bpfilter_target_get_by_name(t->target.target.u.user.name);
-		dprintf(debug_fd, "user.name %s\n", t->target.target.u.user.name);
 		if (!t->target.target.u.kernel.target)
 			goto out_fail;
 
@@ -67,14 +82,10 @@ struct bpfilter_table_info *bpfilter_ipv4_table_ctor(struct bpfilter_table *tbl)
 	*term = (struct bpfilter_ipt_error) BPFILTER_IPT_ERROR_INIT;
 	term->target.target.u.kernel.target =
 		bpfilter_target_get_by_name(term->target.target.u.user.name);
-	dprintf(debug_fd, "user.name %s\n", term->target.target.u.user.name);
-	if (!term->target.target.u.kernel.target)
-		goto out_fail;
-
-	dprintf(debug_fd, "info %p\n", info);
-	return info;
-
+	if (!term->target.target.u.kernel.target) {
 out_fail:
-	free(info);
-	return NULL;
+		free(info);
+		return NULL;
+	}
+	return info;
 }
diff --git a/net/bpfilter/gen.c b/net/bpfilter/gen.c
new file mode 100644
index 0000000..8e08561
--- /dev/null
+++ b/net/bpfilter/gen.c
@@ -0,0 +1,290 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <errno.h>
+#include <string.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+
+#include <linux/if_ether.h>
+#include <linux/if_link.h>
+#include <linux/rtnetlink.h>
+#include <linux/bpf.h>
+typedef __u16 __bitwise __sum16; /* hack */
+#include <linux/ip.h>
+
+#include <arpa/inet.h>
+
+#include "bpfilter_mod.h"
+
+unsigned int if_nametoindex(const char *ifname);
+
+static inline __u64 bpf_ptr_to_u64(const void *ptr)
+{
+	return (__u64)(unsigned long)ptr;
+}
+
+static int bpf_prog_load(enum bpf_prog_type type,
+			 const struct bpf_insn *insns,
+			 unsigned int insn_num,
+			 __u32 offload_ifindex)
+{
+	union bpf_attr attr = {};
+
+	attr.prog_type		= type;
+	attr.insns		= bpf_ptr_to_u64(insns);
+	attr.insn_cnt		= insn_num;
+	attr.license		= bpf_ptr_to_u64("GPL");
+	attr.prog_ifindex	= offload_ifindex;
+
+	return sys_bpf(BPF_PROG_LOAD, &attr, sizeof(attr));
+}
+
+static int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
+{
+	struct sockaddr_nl sa;
+	int sock, seq = 0, len, ret = -1;
+	char buf[4096];
+	struct nlattr *nla, *nla_xdp;
+	struct {
+		struct nlmsghdr  nh;
+		struct ifinfomsg ifinfo;
+		char             attrbuf[64];
+	} req;
+	struct nlmsghdr *nh;
+	struct nlmsgerr *err;
+
+	memset(&sa, 0, sizeof(sa));
+	sa.nl_family = AF_NETLINK;
+
+	sock = socket(AF_NETLINK, SOCK_RAW, NETLINK_ROUTE);
+	if (sock < 0) {
+		printf("open netlink socket: %s\n", strerror(errno));
+		return -1;
+	}
+
+	if (bind(sock, (struct sockaddr *)&sa, sizeof(sa)) < 0) {
+		printf("bind to netlink: %s\n", strerror(errno));
+		goto cleanup;
+	}
+
+	memset(&req, 0, sizeof(req));
+	req.nh.nlmsg_len = NLMSG_LENGTH(sizeof(struct ifinfomsg));
+	req.nh.nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK;
+	req.nh.nlmsg_type = RTM_SETLINK;
+	req.nh.nlmsg_pid = 0;
+	req.nh.nlmsg_seq = ++seq;
+	req.ifinfo.ifi_family = AF_UNSPEC;
+	req.ifinfo.ifi_index = ifindex;
+
+	/* started nested attribute for XDP */
+	nla = (struct nlattr *)(((char *)&req)
+				+ NLMSG_ALIGN(req.nh.nlmsg_len));
+	nla->nla_type = NLA_F_NESTED | 43/*IFLA_XDP*/;
+	nla->nla_len = NLA_HDRLEN;
+
+	/* add XDP fd */
+	nla_xdp = (struct nlattr *)((char *)nla + nla->nla_len);
+	nla_xdp->nla_type = 1/*IFLA_XDP_FD*/;
+	nla_xdp->nla_len = NLA_HDRLEN + sizeof(int);
+	memcpy((char *)nla_xdp + NLA_HDRLEN, &fd, sizeof(fd));
+	nla->nla_len += nla_xdp->nla_len;
+
+	/* if user passed in any flags, add those too */
+	if (flags) {
+		nla_xdp = (struct nlattr *)((char *)nla + nla->nla_len);
+		nla_xdp->nla_type = 3/*IFLA_XDP_FLAGS*/;
+		nla_xdp->nla_len = NLA_HDRLEN + sizeof(flags);
+		memcpy((char *)nla_xdp + NLA_HDRLEN, &flags, sizeof(flags));
+		nla->nla_len += nla_xdp->nla_len;
+	}
+
+	req.nh.nlmsg_len += NLA_ALIGN(nla->nla_len);
+
+	if (send(sock, &req, req.nh.nlmsg_len, 0) < 0) {
+		printf("send to netlink: %s\n", strerror(errno));
+		goto cleanup;
+	}
+
+	len = recv(sock, buf, sizeof(buf), 0);
+	if (len < 0) {
+		printf("recv from netlink: %s\n", strerror(errno));
+		goto cleanup;
+	}
+
+	for (nh = (struct nlmsghdr *)buf; NLMSG_OK(nh, len);
+	     nh = NLMSG_NEXT(nh, len)) {
+		if (nh->nlmsg_pid != getpid()) {
+			printf("Wrong pid %d, expected %d\n",
+			       nh->nlmsg_pid, getpid());
+			goto cleanup;
+		}
+		if (nh->nlmsg_seq != seq) {
+			printf("Wrong seq %d, expected %d\n",
+			       nh->nlmsg_seq, seq);
+			goto cleanup;
+		}
+		switch (nh->nlmsg_type) {
+		case NLMSG_ERROR:
+			err = (struct nlmsgerr *)NLMSG_DATA(nh);
+			if (!err->error)
+				continue;
+			printf("nlmsg error %s\n", strerror(-err->error));
+			goto cleanup;
+		case NLMSG_DONE:
+			break;
+		}
+	}
+
+	ret = 0;
+
+cleanup:
+	close(sock);
+	return ret;
+}
+
+static int bpfilter_load_dev(struct bpfilter_gen_ctx *ctx)
+{
+	u32 xdp_flags = 0;
+
+	if (ctx->offloaded)
+		xdp_flags |= XDP_FLAGS_HW_MODE;
+	return bpf_set_link_xdp_fd(ctx->ifindex, ctx->fd, xdp_flags);
+}
+
+int bpfilter_gen_init(struct bpfilter_gen_ctx *ctx)
+{
+	unsigned int len_max = BPF_MAXINSNS;
+
+	memset(ctx, 0, sizeof(*ctx));
+	ctx->img = calloc(len_max, sizeof(struct bpf_insn));
+	if (!ctx->img)
+		return -ENOMEM;
+	ctx->len_max = len_max;
+	ctx->fd = -1;
+	ctx->default_verdict = XDP_PASS;
+
+	return 0;
+}
+
+#define EMIT(x)						\
+	do {						\
+		if (ctx->len_cur + 1 > ctx->len_max)	\
+			return -ENOMEM;			\
+		ctx->img[ctx->len_cur++] = x;		\
+	} while (0)
+
+int bpfilter_gen_prologue(struct bpfilter_gen_ctx *ctx)
+{
+	EMIT(BPF_MOV64_REG(BPF_REG_9, BPF_REG_1));
+	EMIT(BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_9,
+			 offsetof(struct xdp_md, data)));
+	EMIT(BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_9,
+			 offsetof(struct xdp_md, data_end)));
+	EMIT(BPF_MOV64_REG(BPF_REG_1, BPF_REG_2));
+	EMIT(BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, ETH_HLEN));
+	EMIT(BPF_JMP_REG(BPF_JLE, BPF_REG_1, BPF_REG_3, 2));
+	EMIT(BPF_MOV32_IMM(BPF_REG_0, ctx->default_verdict));
+	EMIT(BPF_EXIT_INSN());
+	return 0;
+}
+
+int bpfilter_gen_epilogue(struct bpfilter_gen_ctx *ctx)
+{
+	EMIT(BPF_MOV32_IMM(BPF_REG_0, ctx->default_verdict));
+	EMIT(BPF_EXIT_INSN());
+	return 0;
+}
+
+static int bpfilter_gen_check_entry(const struct bpfilter_ipt_ip *ent)
+{
+#define M_FF	"\xff\xff\xff\xff"
+	static const __u8 mask1[IFNAMSIZ] = M_FF M_FF M_FF M_FF;
+	static const __u8 mask0[IFNAMSIZ] = { };
+	int ones = strlen(ent->in_iface); ones += ones > 0;
+#undef M_FF
+	if (strlen(ent->out_iface) > 0)
+		return -ENOTSUPP;
+	if (memcmp(ent->in_iface_mask, mask1, ones) ||
+	    memcmp(&ent->in_iface_mask[ones], mask0, sizeof(mask0) - ones))
+		return -ENOTSUPP;
+	if ((ent->src_mask != 0 && ent->src_mask != 0xffffffff) ||
+	    (ent->dst_mask != 0 && ent->dst_mask != 0xffffffff))
+		return -ENOTSUPP;
+
+	return 0;
+}
+
+int bpfilter_gen_append(struct bpfilter_gen_ctx *ctx,
+			struct bpfilter_ipt_ip *ent, int verdict)
+{
+	u32 match_xdp = verdict == -1 ? XDP_DROP : XDP_PASS;
+	int ret, ifindex, match_state = 0;
+
+	/* convention R1: tmp, R2: data, R3: data_end, R9: xdp_buff */
+	ret = bpfilter_gen_check_entry(ent);
+	if (ret < 0)
+		return ret;
+	if (ent->src_mask == 0 && ent->dst_mask == 0)
+		return 0;
+
+	ifindex = if_nametoindex(ent->in_iface);
+	if (!ifindex)
+		return 0;
+	if (ctx->ifindex && ctx->ifindex != ifindex)
+		return -ENOTSUPP;
+
+	ctx->ifindex = ifindex;
+	match_state = !!ent->src_mask + !!ent->dst_mask;
+
+	EMIT(BPF_MOV64_REG(BPF_REG_1, BPF_REG_2));
+	EMIT(BPF_MOV32_IMM(BPF_REG_5, 0));
+	EMIT(BPF_LDX_MEM(BPF_H, BPF_REG_4, BPF_REG_1,
+			 offsetof(struct ethhdr, h_proto)));
+	EMIT(BPF_JMP_IMM(BPF_JNE, BPF_REG_4, htons(ETH_P_IP),
+			 3 + match_state * 3));
+	EMIT(BPF_ALU64_IMM(BPF_ADD, BPF_REG_1,
+			   sizeof(struct ethhdr) + sizeof(struct iphdr)));
+	EMIT(BPF_JMP_REG(BPF_JGT, BPF_REG_1, BPF_REG_3, 1 + match_state * 3));
+	EMIT(BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -(int)sizeof(struct iphdr)));
+	if (ent->src_mask) {
+		EMIT(BPF_LDX_MEM(BPF_W, BPF_REG_4, BPF_REG_1,
+				 offsetof(struct iphdr, saddr)));
+		EMIT(BPF_JMP_IMM(BPF_JNE, BPF_REG_4, ent->src, 1));
+		EMIT(BPF_ALU32_IMM(BPF_ADD, BPF_REG_5, 1));
+	}
+	if (ent->dst_mask) {
+		EMIT(BPF_LDX_MEM(BPF_W, BPF_REG_4, BPF_REG_1,
+				 offsetof(struct iphdr, daddr)));
+		EMIT(BPF_JMP_IMM(BPF_JNE, BPF_REG_4, ent->dst, 1));
+		EMIT(BPF_ALU32_IMM(BPF_ADD, BPF_REG_5, 1));
+	}
+	EMIT(BPF_JMP_IMM(BPF_JNE, BPF_REG_5, match_state, 2));
+	EMIT(BPF_MOV32_IMM(BPF_REG_0, match_xdp));
+	EMIT(BPF_EXIT_INSN());
+	return 0;
+}
+
+int bpfilter_gen_commit(struct bpfilter_gen_ctx *ctx)
+{
+	int ret;
+
+	ret = bpf_prog_load(BPF_PROG_TYPE_XDP, ctx->img,
+			    ctx->len_cur, ctx->ifindex);
+	if (ret > 0)
+		ctx->offloaded = true;
+	if (ret < 0)
+		ret = bpf_prog_load(BPF_PROG_TYPE_XDP, ctx->img,
+				    ctx->len_cur, 0);
+	if (ret > 0) {
+		ctx->fd = ret;
+		ret = bpfilter_load_dev(ctx);
+	}
+
+	return ret < 0 ? ret : 0;
+}
+
+void bpfilter_gen_destroy(struct bpfilter_gen_ctx *ctx)
+{
+	free(ctx->img);
+	close(ctx->fd);
+}
diff --git a/net/bpfilter/init.c b/net/bpfilter/init.c
index 699f3f6..14e621a 100644
--- a/net/bpfilter/init.c
+++ b/net/bpfilter/init.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <sys/socket.h>
 #include <errno.h>
+
+#include <sys/socket.h>
+
 #include "bpfilter_mod.h"
 
 static struct bpfilter_table filter_table_ipv4 = {
@@ -22,12 +24,13 @@ int bpfilter_ipv4_init(void)
 	if (err)
 		return err;
 
-	info = bpfilter_ipv4_table_ctor(t);
+	info = bpfilter_ipv4_table_alloc(t, 0);
+	if (!info)
+		return -ENOMEM;
+	info = bpfilter_ipv4_table_finalize(t, info, 0, 0);
 	if (!info)
 		return -ENOMEM;
-
 	t->info = info;
-
 	return bpfilter_table_add(&filter_table_ipv4);
 }
 
diff --git a/net/bpfilter/sockopt.c b/net/bpfilter/sockopt.c
index 43687da..26ad12a 100644
--- a/net/bpfilter/sockopt.c
+++ b/net/bpfilter/sockopt.c
@@ -1,10 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <sys/socket.h>
 #include <errno.h>
 #include <string.h>
 #include <stdio.h>
+#include <stdlib.h>
+
+#include <sys/socket.h>
+
 #include "bpfilter_mod.h"
 
+/* TODO: Get all of this in here properly done in encoding/decoding layer. */
 static int fetch_name(void *addr, int len, char *name, int name_len)
 {
 	if (copy_from_user(name, addr, name_len))
@@ -55,12 +59,17 @@ int bpfilter_get_info(void *addr, int len)
 	return err;
 }
 
-static int copy_target(struct bpfilter_standard_target *ut,
-		       struct bpfilter_standard_target *kt)
+static int target_u2k(struct bpfilter_standard_target *kt)
 {
-	struct bpfilter_target *tgt;
-	int sz;
+	kt->target.u.kernel.target =
+		bpfilter_target_get_by_name(kt->target.u.user.name);
+	return kt->target.u.kernel.target ? 0 : -EINVAL;
+}
 
+static int target_k2u(struct bpfilter_standard_target *ut,
+		      struct bpfilter_standard_target *kt)
+{
+	struct bpfilter_target *tgt;
 
 	if (put_user(kt->target.u.target_size,
 		     &ut->target.u.target_size))
@@ -69,12 +78,9 @@ static int copy_target(struct bpfilter_standard_target *ut,
 	tgt = kt->target.u.kernel.target;
 	if (copy_to_user(ut->target.u.user.name, tgt->name, strlen(tgt->name)))
 		return -EFAULT;
-
 	if (put_user(tgt->rev, &ut->target.u.user.revision))
 		return -EFAULT;
-
-	sz = tgt->size;
-	if (copy_to_user(ut->target.data, kt->target.data, sz))
+	if (copy_to_user(ut->target.data, kt->target.data, tgt->size))
 		return -EFAULT;
 
 	return 0;
@@ -84,30 +90,25 @@ static int do_get_entries(void *up,
 			  struct bpfilter_table *tbl,
 			  struct bpfilter_table_info *info)
 {
-	unsigned int total_size = info->size;
 	const struct bpfilter_ipt_entry *ent;
+	unsigned int total_size = info->size;
+	void *base = info->entries;
 	unsigned int off;
-	void *base;
-
-	base = info->entries;
 
 	for (off = 0; off < total_size; off += ent->next_offset) {
-		struct bpfilter_xt_counters *cntrs;
 		struct bpfilter_standard_target *tgt;
+		struct bpfilter_xt_counters *cntrs;
 
 		ent = base + off;
 		if (copy_to_user(up + off, ent, sizeof(*ent)))
 			return -EFAULT;
-
-		/* XXX Just clear counters for now. XXX */
+		/* XXX: Just clear counters for now. */
 		cntrs = up + off + offsetof(struct bpfilter_ipt_entry, cntrs);
 		if (put_user(0, &cntrs->packet_cnt) ||
 		    put_user(0, &cntrs->byte_cnt))
 			return -EINVAL;
-
-		tgt = (void *) ent + ent->target_offset;
-		dprintf(debug_fd, "target.verdict %d\n", tgt->verdict);
-		if (copy_target(up + off + ent->target_offset, tgt))
+		tgt = (void *)ent + ent->target_offset;
+		if (target_k2u(up + off + ent->target_offset, tgt))
 			return -EFAULT;
 	}
 	return 0;
@@ -123,31 +124,113 @@ int bpfilter_get_entries(void *cmd, int len)
 
 	if (len < sizeof(struct bpfilter_ipt_get_entries))
 		return -EINVAL;
-
 	if (copy_from_user(&req, cmd, sizeof(req)))
 		return -EFAULT;
-
 	tbl = bpfilter_table_get_by_name(req.name, strlen(req.name));
 	if (!tbl)
 		return -ENOENT;
-
 	info = tbl->info;
 	if (!info) {
 		err = -ENOENT;
 		goto out_put;
 	}
-
 	if (info->size != req.size) {
 		err = -EINVAL;
 		goto out_put;
 	}
-
 	err = do_get_entries(uptr->entries, tbl, info);
-	dprintf(debug_fd, "do_get_entries %d req.size %d\n", err, req.size);
-
 out_put:
 	bpfilter_table_put(tbl);
+	return err;
+}
 
+static int do_set_replace(struct bpfilter_ipt_replace *req, void *base,
+			  struct bpfilter_table *tbl)
+{
+	unsigned int total_size = req->size;
+	struct bpfilter_table_info *info;
+	struct bpfilter_ipt_entry *ent;
+	struct bpfilter_gen_ctx ctx;
+	unsigned int off, sents = 0, ents = 0;
+	int ret;
+
+	ret = bpfilter_gen_init(&ctx);
+	if (ret < 0)
+		return ret;
+	ret = bpfilter_gen_prologue(&ctx);
+	if (ret < 0)
+		return ret;
+	info = bpfilter_ipv4_table_alloc(tbl, total_size);
+	if (!info)
+		return -ENOMEM;
+	if (copy_from_user(&info->entries[0], base, req->size)) {
+		free(info);
+		return -EFAULT;
+	}
+	base = &info->entries[0];
+	for (off = 0; off < total_size; off += ent->next_offset) {
+		struct bpfilter_standard_target *tgt;
+		ent = base + off;
+		ents++;
+		sents += ent->next_offset;
+		tgt = (void *) ent + ent->target_offset;
+		target_u2k(tgt);
+		ret = bpfilter_gen_append(&ctx, &ent->ip, tgt->verdict);
+                if (ret < 0)
+                        goto err;
+	}
+	info->num_entries = ents;
+	info->size = sents;
+	memcpy(info->hook_entry, req->hook_entry, sizeof(info->hook_entry));
+	memcpy(info->underflow, req->underflow, sizeof(info->hook_entry));
+	ret = bpfilter_gen_epilogue(&ctx);
+	if (ret < 0)
+		goto err;
+	ret = bpfilter_gen_commit(&ctx);
+	if (ret < 0)
+		goto err;
+	free(tbl->info);
+	tbl->info = info;
+	bpfilter_gen_destroy(&ctx);
+	dprintf(debug_fd, "offloaded %u\n", ctx.offloaded);
+	return ret;
+err:
+	free(info);
+	return ret;
+}
+
+int bpfilter_set_replace(void *cmd, int len)
+{
+	struct bpfilter_ipt_replace *uptr = cmd;
+	struct bpfilter_ipt_replace req;
+	struct bpfilter_table_info *info;
+	struct bpfilter_table *tbl;
+	int err;
+
+	if (len < sizeof(req))
+		return -EINVAL;
+	if (copy_from_user(&req, cmd, sizeof(req)))
+		return -EFAULT;
+	if (req.num_counters >= INT_MAX / sizeof(struct bpfilter_xt_counters))
+		return -ENOMEM;
+	if (req.num_counters == 0)
+		return -EINVAL;
+	req.name[sizeof(req.name) - 1] = 0;
+	tbl = bpfilter_table_get_by_name(req.name, strlen(req.name));
+	if (!tbl)
+		return -ENOENT;
+	info = tbl->info;
+	if (!info) {
+		err = -ENOENT;
+		goto out_put;
+	}
+	err = do_set_replace(&req, uptr->entries, tbl);
+out_put:
+	bpfilter_table_put(tbl);
 	return err;
 }
 
+int bpfilter_set_add_counters(void *cmd, int len)
+{
+	return 0;
+}
diff --git a/net/bpfilter/tables.c b/net/bpfilter/tables.c
index 9a96599..e0dab28 100644
--- a/net/bpfilter/tables.c
+++ b/net/bpfilter/tables.c
@@ -1,8 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <sys/socket.h>
 #include <errno.h>
 #include <string.h>
+
+#include <sys/socket.h>
+
 #include <linux/hashtable.h>
+
 #include "bpfilter_mod.h"
 
 static unsigned int full_name_hash(const void *salt, const char *name, unsigned int len)
diff --git a/net/bpfilter/tgts.c b/net/bpfilter/tgts.c
index eac5e8a..0a00bc28 100644
--- a/net/bpfilter/tgts.c
+++ b/net/bpfilter/tgts.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <sys/socket.h>
+
 #include "bpfilter_mod.h"
 
 struct bpfilter_target std_tgt = {
diff --git a/net/ipv4/bpfilter/sockopt.c b/net/ipv4/bpfilter/sockopt.c
index 26e544f..159a64580 100644
--- a/net/ipv4/bpfilter/sockopt.c
+++ b/net/ipv4/bpfilter/sockopt.c
@@ -7,15 +7,17 @@ struct sock;
 
 extern struct wait_queue_head bpfilter_get_cmd_wq;
 extern struct wait_queue_head bpfilter_reply_wq;
+
 extern bool bpfilter_get_cmd_ready;
 extern bool bpfilter_reply_ready;
-extern struct bpfilter_get_cmd bpfilter_get_cmd_mbox;
-extern struct bpfilter_reply bpfilter_reply_mbox;
+
+extern struct bpf_mbox_request bpfilter_get_cmd_mbox;
+extern struct bpf_mbox_reply bpfilter_reply_mbox;
 
 bool loaded = false;
 
-int bpfilter_ip_set_sockopt(struct sock *sk, int optname, char __user *optval,
-			    unsigned int optlen)
+int bpfilter_mbox_request(struct sock *sk, int optname, char __user *optval,
+			  unsigned int optlen, int kind)
 {
 	int err;
 
@@ -26,17 +28,29 @@ int bpfilter_ip_set_sockopt(struct sock *sk, int optname, char __user *optval,
 //			return err;
 		loaded = true;
 	}
+
+	bpfilter_get_cmd_mbox.subsys = BPF_MBOX_SUBSYS_BPFILTER;
+	bpfilter_get_cmd_mbox.kind = kind;
 	bpfilter_get_cmd_mbox.pid = current->pid;
 	bpfilter_get_cmd_mbox.cmd = optname;
 	bpfilter_get_cmd_mbox.addr = (long) optval;
 	bpfilter_get_cmd_mbox.len = optlen;
 	bpfilter_get_cmd_ready = true;
+
 	wake_up(&bpfilter_get_cmd_wq);
 	wait_event_killable(bpfilter_reply_wq, bpfilter_reply_ready);
 	bpfilter_reply_ready = false;
+
 	return bpfilter_reply_mbox.status;
 }
 
+int bpfilter_ip_set_sockopt(struct sock *sk, int optname, char __user *optval,
+			    unsigned int optlen)
+{
+	return bpfilter_mbox_request(sk, optname, optval, optlen,
+				     BPF_MBOX_KIND_SET);
+}
+
 int bpfilter_ip_get_sockopt(struct sock *sk, int optname, char __user *optval,
 			    int __user *optlen)
 {
@@ -45,5 +59,6 @@ int bpfilter_ip_get_sockopt(struct sock *sk, int optname, char __user *optval,
 	if (get_user(len, optlen))
 		return -EFAULT;
 
-	return bpfilter_ip_set_sockopt(sk, optname, optval, len);
+	return bpfilter_mbox_request(sk, optname, optval, len,
+				     BPF_MBOX_KIND_GET);
 }
-- 
2.9.5
