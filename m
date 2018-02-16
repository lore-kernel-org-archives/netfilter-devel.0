From: Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH RFC 3/4] net: initial bpfilter skeleton
Date: Fri, 16 Feb 2018 14:40:22 +0100
Message-ID: <20180216134023.15536-4-daniel@iogearbox.net>
References: <20180216134023.15536-1-daniel@iogearbox.net>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
        alexei.starovoitov@gmail.com, Alexei Starovoitov <ast@kernel.org>
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180216134023.15536-1-daniel@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: "David S. Miller" <davem@davemloft.net>

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpfilter.h      |  13 +++
 include/uapi/linux/bpfilter.h | 200 ++++++++++++++++++++++++++++++++++++++++++
 net/Kconfig                   |   2 +
 net/Makefile                  |   1 +
 net/bpfilter/Kconfig          |   7 ++
 net/bpfilter/Makefile         |   9 ++
 net/bpfilter/bpfilter.c       |  89 +++++++++++++++++++
 net/bpfilter/bpfilter_mod.h   |  96 ++++++++++++++++++++
 net/bpfilter/ctor.c           |  80 +++++++++++++++++
 net/bpfilter/init.c           |  33 +++++++
 net/bpfilter/sockopt.c        | 153 ++++++++++++++++++++++++++++++++
 net/bpfilter/tables.c         |  70 +++++++++++++++
 net/bpfilter/targets.c        |  51 +++++++++++
 net/bpfilter/tgts.c           |  25 ++++++
 net/ipv4/Makefile             |   2 +
 net/ipv4/bpfilter/Makefile    |   2 +
 net/ipv4/bpfilter/sockopt.c   |  49 +++++++++++
 net/ipv4/ip_sockglue.c        |  17 ++++
 18 files changed, 899 insertions(+)
 create mode 100644 include/linux/bpfilter.h
 create mode 100644 include/uapi/linux/bpfilter.h
 create mode 100644 net/bpfilter/Kconfig
 create mode 100644 net/bpfilter/Makefile
 create mode 100644 net/bpfilter/bpfilter.c
 create mode 100644 net/bpfilter/bpfilter_mod.h
 create mode 100644 net/bpfilter/ctor.c
 create mode 100644 net/bpfilter/init.c
 create mode 100644 net/bpfilter/sockopt.c
 create mode 100644 net/bpfilter/tables.c
 create mode 100644 net/bpfilter/targets.c
 create mode 100644 net/bpfilter/tgts.c
 create mode 100644 net/ipv4/bpfilter/Makefile
 create mode 100644 net/ipv4/bpfilter/sockopt.c

diff --git a/include/linux/bpfilter.h b/include/linux/bpfilter.h
new file mode 100644
index 0000000..26adad1
--- /dev/null
+++ b/include/linux/bpfilter.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_BPFILTER_H
+#define _LINUX_BPFILTER_H
+
+#include <uapi/linux/bpfilter.h>
+
+struct sock;
+int bpfilter_ip_set_sockopt(struct sock *sk, int optname, char *optval,
+			    unsigned int optlen);
+int bpfilter_ip_get_sockopt(struct sock *sk, int optname, char *optval,
+			    int *optlen);
+#endif
+
diff --git a/include/uapi/linux/bpfilter.h b/include/uapi/linux/bpfilter.h
new file mode 100644
index 0000000..38d54e9
--- /dev/null
+++ b/include/uapi/linux/bpfilter.h
@@ -0,0 +1,200 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _UAPI_LINUX_BPFILTER_H
+#define _UAPI_LINUX_BPFILTER_H
+
+#include <linux/if.h>
+
+enum {
+	BPFILTER_IPT_SO_SET_REPLACE = 64,
+	BPFILTER_IPT_SO_SET_ADD_COUNTERS = 65,
+	BPFILTER_IPT_SET_MAX,
+};
+
+enum {
+	BPFILTER_IPT_SO_GET_INFO = 64,
+	BPFILTER_IPT_SO_GET_ENTRIES = 65,
+	BPFILTER_IPT_SO_GET_REVISION_MATCH = 66,
+	BPFILTER_IPT_SO_GET_REVISION_TARGET = 67,
+	BPFILTER_IPT_GET_MAX,
+};
+
+enum {
+	BPFILTER_XT_TABLE_MAXNAMELEN = 32,
+};
+
+enum {
+	BPFILTER_NF_DROP = 0,
+	BPFILTER_NF_ACCEPT = 1,
+	BPFILTER_NF_STOLEN = 2,
+	BPFILTER_NF_QUEUE = 3,
+	BPFILTER_NF_REPEAT = 4,
+	BPFILTER_NF_STOP = 5,
+	BPFILTER_NF_MAX_VERDICT = BPFILTER_NF_STOP,
+};
+
+enum {
+	BPFILTER_INET_HOOK_PRE_ROUTING	= 0,
+	BPFILTER_INET_HOOK_LOCAL_IN	= 1,
+	BPFILTER_INET_HOOK_FORWARD	= 2,
+	BPFILTER_INET_HOOK_LOCAL_OUT	= 3,
+	BPFILTER_INET_HOOK_POST_ROUTING	= 4,
+	BPFILTER_INET_HOOK_MAX,
+};
+
+enum {
+	BPFILTER_PROTO_UNSPEC	= 0,
+	BPFILTER_PROTO_INET	= 1,
+	BPFILTER_PROTO_IPV4	= 2,
+	BPFILTER_PROTO_ARP	= 3,
+	BPFILTER_PROTO_NETDEV	= 5,
+	BPFILTER_PROTO_BRIDGE	= 7,
+	BPFILTER_PROTO_IPV6	= 10,
+	BPFILTER_PROTO_DECNET	= 12,
+	BPFILTER_PROTO_NUMPROTO,
+};
+
+#ifndef INT_MAX
+#define INT_MAX		((int)(~0U>>1))
+#endif
+#ifndef INT_MIN
+#define INT_MIN         (-INT_MAX - 1)
+#endif
+
+enum {
+	BPFILTER_IP_PRI_FIRST			= INT_MIN,
+	BPFILTER_IP_PRI_CONNTRACK_DEFRAG	= -400,
+	BPFILTER_IP_PRI_RAW			= -300,
+	BPFILTER_IP_PRI_SELINUX_FIRST		= -225,
+	BPFILTER_IP_PRI_CONNTRACK		= -200,
+	BPFILTER_IP_PRI_MANGLE			= -150,
+	BPFILTER_IP_PRI_NAT_DST			= -100,
+	BPFILTER_IP_PRI_FILTER			= 0,
+	BPFILTER_IP_PRI_SECURITY		= 50,
+	BPFILTER_IP_PRI_NAT_SRC			= 100,
+	BPFILTER_IP_PRI_SELINUX_LAST		= 225,
+	BPFILTER_IP_PRI_CONNTRACK_HELPER	= 300,
+	BPFILTER_IP_PRI_CONNTRACK_CONFIRM	= INT_MAX,
+	BPFILTER_IP_PRI_LAST			= INT_MAX,
+};
+
+#define BPFILTER_FUNCTION_MAXNAMELEN	30
+#define BPFILTER_EXTENSION_MAXNAMELEN	29
+#define BPFILTER_TABLE_MAXNAMELEN	32
+
+struct bpfilter_match;
+struct bpfilter_entry_match {
+	union {
+		struct {
+			__u16		match_size;
+			char		name[BPFILTER_EXTENSION_MAXNAMELEN];
+			__u8		revision;
+		} user;
+		struct {
+			__u16			match_size;
+			struct bpfilter_match	*match;
+		} kernel;
+		__u16		match_size;
+	} u;
+	unsigned char	data[0];
+};
+
+struct bpfilter_target;
+struct bpfilter_entry_target {
+	union {
+		struct {
+			__u16		target_size;
+			char		name[BPFILTER_EXTENSION_MAXNAMELEN];
+			__u8		revision;
+		} user;
+		struct {
+			__u16			target_size;
+			struct bpfilter_target	*target;
+		} kernel;
+		__u16		target_size;
+	} u;
+	unsigned char	data[0];
+};
+
+struct bpfilter_standard_target {
+	struct bpfilter_entry_target	target;
+	int				verdict;
+};
+
+struct bpfilter_error_target {
+	struct bpfilter_entry_target	target;
+	char				error_name[BPFILTER_FUNCTION_MAXNAMELEN];
+};
+
+#define __ALIGN_KERNEL(x, a)            __ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
+#define __ALIGN_KERNEL_MASK(x, mask)    (((x) + (mask)) & ~(mask))
+
+#define BPFILTER_ALIGN(__X)	\
+	__ALIGN_KERNEL(__X, __alignof__(__u64))
+
+#define BPFILTER_TARGET_INIT(__name, __size)			\
+{								\
+	.target.u.user = {					\
+		.target_size	= BPFILTER_ALIGN(__size),	\
+		.name		= (__name),			\
+	},							\
+}
+#define BPFILTER_STANDARD_TARGET	""
+#define BPFILTER_ERROR_TARGET		"ERROR"
+
+struct bpfilter_xt_counters {
+	__u64	packet_cnt;
+	__u64	byte_cnt;
+};
+
+struct bpfilter_ipt_ip {
+	__u32	src;
+	__u32	dst;
+	__u32	src_mask;
+	__u32	dst_mask;
+	char	in_iface[IFNAMSIZ];
+	char	out_iface[IFNAMSIZ];
+	__u8	in_iface_mask[IFNAMSIZ];
+	__u8	out_iface_mask[IFNAMSIZ];
+	__u16	protocol;
+	__u8	flags;
+	__u8	inv_flags;
+};
+
+struct bpfilter_ipt_entry {
+	struct bpfilter_ipt_ip		ip;
+	__u32				bfcache;
+	__u16				target_offset;
+	__u16				next_offset;
+	__u32				camefrom;
+	struct bpfilter_xt_counters	cntrs;
+	__u8				elems[0];
+};
+
+struct bpfilter_ipt_get_info {
+	char				name[BPFILTER_XT_TABLE_MAXNAMELEN];
+	__u32				valid_hooks;
+	__u32				hook_entry[BPFILTER_INET_HOOK_MAX];
+	__u32				underflow[BPFILTER_INET_HOOK_MAX];
+	__u32				num_entries;
+	__u32				size;
+};
+
+struct bpfilter_ipt_get_entries {
+	char				name[BPFILTER_XT_TABLE_MAXNAMELEN];
+	__u32				size;
+	struct bpfilter_ipt_entry	entries[0];
+};
+
+struct bpfilter_ipt_replace {
+	char				name[BPFILTER_XT_TABLE_MAXNAMELEN];
+	__u32				valid_hooks;
+	__u32				num_entries;
+	__u32				size;
+	__u32				hook_entry[BPFILTER_INET_HOOK_MAX];
+	__u32				underflow[BPFILTER_INET_HOOK_MAX];
+	__u32				num_counters;
+	struct bpfilter_xt_counters	*cntrs;
+	struct bpfilter_ipt_entry	entries[0];
+};
+
+#endif /* _UAPI_LINUX_BPFILTER_H */
diff --git a/net/Kconfig b/net/Kconfig
index 37ec8e6..ec96506 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -201,6 +201,8 @@ source "net/bridge/netfilter/Kconfig"
 
 endif
 
+source "net/bpfilter/Kconfig"
+
 source "net/dccp/Kconfig"
 source "net/sctp/Kconfig"
 source "net/rds/Kconfig"
diff --git a/net/Makefile b/net/Makefile
index 14fede5..c388b3d 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_TLS)		+= tls/
 obj-$(CONFIG_XFRM)		+= xfrm/
 obj-$(CONFIG_UNIX)		+= unix/
 obj-$(CONFIG_NET)		+= ipv6/
+obj-$(CONFIG_BPFILTER)		+= bpfilter/
 obj-$(CONFIG_PACKET)		+= packet/
 obj-$(CONFIG_NET_KEY)		+= key/
 obj-$(CONFIG_BRIDGE)		+= bridge/
diff --git a/net/bpfilter/Kconfig b/net/bpfilter/Kconfig
new file mode 100644
index 0000000..d29b5cb
--- /dev/null
+++ b/net/bpfilter/Kconfig
@@ -0,0 +1,7 @@
+menuconfig BPFILTER
+	bool "BPF Filter Configuration"
+	depends on NET && BPF
+
+if BPFILTER
+
+endif
diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
new file mode 100644
index 0000000..5e05505
--- /dev/null
+++ b/net/bpfilter/Makefile
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for the Linux BPFILTER layer.
+#
+
+hostprogs-y := bpfilter.ko
+always := $(hostprogs-y)
+bpfilter.ko-objs := bpfilter.o tgts.o targets.o tables.o init.o ctor.o sockopt.o
+HOSTCFLAGS += -I. -Itools/include/
diff --git a/net/bpfilter/bpfilter.c b/net/bpfilter/bpfilter.c
new file mode 100644
index 0000000..445ae65
--- /dev/null
+++ b/net/bpfilter/bpfilter.c
@@ -0,0 +1,89 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <sys/uio.h>
+#include <errno.h>
+#include <stdio.h>
+#include <sys/socket.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include "include/uapi/linux/bpf.h"
+#include <asm/unistd.h>
+#include "bpfilter_mod.h"
+
+extern long int syscall (long int __sysno, ...);
+
+static inline int sys_bpf(enum bpf_cmd cmd, union bpf_attr *attr,
+			  unsigned int size)
+{
+	return syscall(321, cmd, attr, size);
+}
+
+int pid;
+int debug_fd;
+
+int copy_from_user(void *dst, void *addr, int len)
+{
+	struct iovec local;
+	struct iovec remote;
+
+	local.iov_base = dst;
+	local.iov_len = len;
+	remote.iov_base = addr;
+	remote.iov_len = len;
+	return process_vm_readv(pid, &local, 1, &remote, 1, 0) != len;
+}
+
+int copy_to_user(void *addr, const void *src, int len)
+{
+	struct iovec local;
+	struct iovec remote;
+
+	local.iov_base = (void *) src;
+	local.iov_len = len;
+	remote.iov_base = addr;
+	remote.iov_len = len;
+	return process_vm_writev(pid, &local, 1, &remote, 1, 0) != len;
+}
+
+static int handle_cmd(struct bpfilter_get_cmd *cmd)
+{
+	pid = cmd->pid;
+	switch (cmd->cmd) {
+	case BPFILTER_IPT_SO_GET_INFO:
+		return bpfilter_get_info((void *) (long) cmd->addr, cmd->len);
+	case BPFILTER_IPT_SO_GET_ENTRIES:
+		return bpfilter_get_entries((void *) (long) cmd->addr, cmd->len);
+	default:
+		break;
+	}
+	return -ENOPROTOOPT;
+}
+
+static void loop(void)
+{
+	bpfilter_tables_init();
+	bpfilter_ipv4_init();
+
+	while (1) {
+		union bpf_attr get_cmd = {};
+		union bpf_attr reply = {};
+		struct bpfilter_get_cmd *cmd;
+
+		sys_bpf(BPFILTER_GET_CMD, &get_cmd, sizeof(get_cmd));
+		cmd = &get_cmd.bpfilter_get_cmd;
+
+		dprintf(debug_fd, "pid %d cmd %d addr %llx len %d\n",
+			cmd->pid, cmd->cmd, cmd->addr, cmd->len);
+
+		reply.bpfilter_reply.status = handle_cmd(cmd);
+		sys_bpf(BPFILTER_REPLY, &reply, sizeof(reply));
+	}
+}
+
+int main(void)
+{
+	debug_fd = open("/tmp/aa", 00000002 | 00000100);
+	loop();
+	close(debug_fd);
+	return 0;
+}
diff --git a/net/bpfilter/bpfilter_mod.h b/net/bpfilter/bpfilter_mod.h
new file mode 100644
index 0000000..f0de41b
--- /dev/null
+++ b/net/bpfilter/bpfilter_mod.h
@@ -0,0 +1,96 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_BPFILTER_INTERNAL_H
+#define _LINUX_BPFILTER_INTERNAL_H
+
+#include "include/uapi/linux/bpfilter.h"
+#include <linux/list.h>
+
+struct bpfilter_table {
+	struct hlist_node	hash;
+	u32			valid_hooks;
+	struct			bpfilter_table_info *info;
+	int			hold;
+	u8			family;
+	int			priority;
+	const char		name[BPFILTER_XT_TABLE_MAXNAMELEN];
+};
+
+struct bpfilter_table_info {
+	unsigned int		size;
+	u32			num_entries;
+	unsigned int		initial_entries;
+	unsigned int		hook_entry[BPFILTER_INET_HOOK_MAX];
+	unsigned int		underflow[BPFILTER_INET_HOOK_MAX];
+	unsigned int		stacksize;
+	void			***jumpstack;
+	unsigned char		entries[0] __aligned(8);
+};
+
+struct bpfilter_table *bpfilter_table_get_by_name(const char *name, int name_len);
+void bpfilter_table_put(struct bpfilter_table *tbl);
+int bpfilter_table_add(struct bpfilter_table *tbl);
+
+struct bpfilter_ipt_standard {
+	struct bpfilter_ipt_entry	entry;
+	struct bpfilter_standard_target	target;
+};
+
+struct bpfilter_ipt_error {
+	struct bpfilter_ipt_entry	entry;
+	struct bpfilter_error_target	target;
+};
+
+#define BPFILTER_IPT_ENTRY_INIT(__sz) 				\
+{								\
+	.target_offset = sizeof(struct bpfilter_ipt_entry),	\
+	.next_offset = (__sz),					\
+}
+
+#define BPFILTER_IPT_STANDARD_INIT(__verdict) 					\
+{										\
+	.entry = BPFILTER_IPT_ENTRY_INIT(sizeof(struct bpfilter_ipt_standard)),	\
+	.target = BPFILTER_TARGET_INIT(BPFILTER_STANDARD_TARGET,		\
+				       sizeof(struct bpfilter_standard_target)),\
+	.target.verdict = -(__verdict) - 1,					\
+}
+
+#define BPFILTER_IPT_ERROR_INIT							\
+{										\
+	.entry = BPFILTER_IPT_ENTRY_INIT(sizeof(struct bpfilter_ipt_error)),	\
+	.target = BPFILTER_TARGET_INIT(BPFILTER_ERROR_TARGET,			\
+				       sizeof(struct bpfilter_error_target)),	\
+	.target.error_name = "ERROR",						\
+}
+
+struct bpfilter_target {
+	struct list_head	all_target_list;
+	const char		name[BPFILTER_EXTENSION_MAXNAMELEN];
+	unsigned int		size;
+	int			hold;
+	u16			family;
+	u8			rev;
+};
+
+struct bpfilter_target *bpfilter_target_get_by_name(const char *name);
+void bpfilter_target_put(struct bpfilter_target *tgt);
+int bpfilter_target_add(struct bpfilter_target *tgt);
+
+struct bpfilter_table_info *bpfilter_ipv4_table_ctor(struct bpfilter_table *tbl);
+int bpfilter_ipv4_register_targets(void);
+void bpfilter_tables_init(void);
+int bpfilter_get_info(void *addr, int len);
+int bpfilter_get_entries(void *cmd, int len);
+int bpfilter_ipv4_init(void);
+
+int copy_from_user(void *dst, void *addr, int len);
+int copy_to_user(void *addr, const void *src, int len);
+#define put_user(x, ptr) \
+({ \
+	__typeof__(*(ptr)) __x = (x); \
+	copy_to_user(ptr, &__x, sizeof(*(ptr))); \
+})
+extern int pid;
+extern int debug_fd;
+#define ENOTSUPP        524
+
+#endif
diff --git a/net/bpfilter/ctor.c b/net/bpfilter/ctor.c
new file mode 100644
index 0000000..efb7fee
--- /dev/null
+++ b/net/bpfilter/ctor.c
@@ -0,0 +1,80 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <sys/socket.h>
+#include <linux/bitops.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include "bpfilter_mod.h"
+
+unsigned int __sw_hweight32(unsigned int w)
+{
+	w -= (w >> 1) & 0x55555555;
+	w =  (w & 0x33333333) + ((w >> 2) & 0x33333333);
+	w =  (w + (w >> 4)) & 0x0f0f0f0f;
+	return (w * 0x01010101) >> 24;
+}
+
+struct bpfilter_table_info *bpfilter_ipv4_table_ctor(struct bpfilter_table *tbl)
+{
+	unsigned int num_hooks = hweight32(tbl->valid_hooks);
+	struct bpfilter_ipt_standard *tgts;
+	struct bpfilter_table_info *info;
+	struct bpfilter_ipt_error *term;
+	unsigned int mask, offset, h, i;
+	unsigned int size, alloc_size;
+
+	size  = sizeof(struct bpfilter_ipt_standard) * num_hooks;
+	size += sizeof(struct bpfilter_ipt_error);
+
+	alloc_size = size + sizeof(struct bpfilter_table_info);
+
+	info = malloc(alloc_size);
+	if (!info)
+		return NULL;
+
+	info->num_entries = num_hooks + 1;
+	info->size = size;
+
+	tgts = (struct bpfilter_ipt_standard *) (info + 1);
+	term = (struct bpfilter_ipt_error *) (tgts + num_hooks);
+
+	mask = tbl->valid_hooks;
+	offset = 0;
+	h = 0;
+	i = 0;
+	dprintf(debug_fd, "mask %x num_hooks %d\n", mask, num_hooks);
+	while (mask) {
+		struct bpfilter_ipt_standard *t;
+
+		if (!(mask & 1))
+			goto next;
+
+		info->hook_entry[h] = offset;
+		info->underflow[h] = offset;
+		t = &tgts[i++];
+		*t = (struct bpfilter_ipt_standard)
+			BPFILTER_IPT_STANDARD_INIT(BPFILTER_NF_ACCEPT);
+		t->target.target.u.kernel.target =
+			bpfilter_target_get_by_name(t->target.target.u.user.name);
+		dprintf(debug_fd, "user.name %s\n", t->target.target.u.user.name);
+		if (!t->target.target.u.kernel.target)
+			goto out_fail;
+
+		offset += sizeof(struct bpfilter_ipt_standard);
+	next:
+		mask >>= 1;
+		h++;
+	}
+	*term = (struct bpfilter_ipt_error) BPFILTER_IPT_ERROR_INIT;
+	term->target.target.u.kernel.target =
+		bpfilter_target_get_by_name(term->target.target.u.user.name);
+	dprintf(debug_fd, "user.name %s\n", term->target.target.u.user.name);
+	if (!term->target.target.u.kernel.target)
+		goto out_fail;
+
+	dprintf(debug_fd, "info %p\n", info);
+	return info;
+
+out_fail:
+	free(info);
+	return NULL;
+}
diff --git a/net/bpfilter/init.c b/net/bpfilter/init.c
new file mode 100644
index 0000000..699f3f6
--- /dev/null
+++ b/net/bpfilter/init.c
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <sys/socket.h>
+#include <errno.h>
+#include "bpfilter_mod.h"
+
+static struct bpfilter_table filter_table_ipv4 = {
+	.name		= "filter",
+	.valid_hooks	= ((1<<BPFILTER_INET_HOOK_LOCAL_IN) |
+			   (1<<BPFILTER_INET_HOOK_FORWARD) |
+			   (1<<BPFILTER_INET_HOOK_LOCAL_OUT)),
+	.family		= BPFILTER_PROTO_IPV4,
+	.priority	= BPFILTER_IP_PRI_FILTER,
+};
+
+int bpfilter_ipv4_init(void)
+{
+	struct bpfilter_table *t = &filter_table_ipv4;
+	struct bpfilter_table_info *info;
+	int err;
+
+	err = bpfilter_ipv4_register_targets();
+	if (err)
+		return err;
+
+	info = bpfilter_ipv4_table_ctor(t);
+	if (!info)
+		return -ENOMEM;
+
+	t->info = info;
+
+	return bpfilter_table_add(&filter_table_ipv4);
+}
+
diff --git a/net/bpfilter/sockopt.c b/net/bpfilter/sockopt.c
new file mode 100644
index 0000000..43687da
--- /dev/null
+++ b/net/bpfilter/sockopt.c
@@ -0,0 +1,153 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <sys/socket.h>
+#include <errno.h>
+#include <string.h>
+#include <stdio.h>
+#include "bpfilter_mod.h"
+
+static int fetch_name(void *addr, int len, char *name, int name_len)
+{
+	if (copy_from_user(name, addr, name_len))
+		return -EFAULT;
+
+	name[BPFILTER_XT_TABLE_MAXNAMELEN-1] = '\0';
+	return 0;
+}
+
+int bpfilter_get_info(void *addr, int len)
+{
+	char name[BPFILTER_XT_TABLE_MAXNAMELEN];
+	struct bpfilter_ipt_get_info resp;
+	struct bpfilter_table_info *info;
+	struct bpfilter_table *tbl;
+	int err;
+
+	if (len != sizeof(struct bpfilter_ipt_get_info))
+		return -EINVAL;
+
+	err = fetch_name(addr, len, name, sizeof(name));
+	if (err)
+		return err;
+
+	tbl = bpfilter_table_get_by_name(name, strlen(name));
+	if (!tbl)
+		return -ENOENT;
+
+	info = tbl->info;
+	if (!info) {
+		err = -ENOENT;
+		goto out_put;
+	}
+
+	memset(&resp, 0, sizeof(resp));
+	memcpy(resp.name, name, sizeof(resp.name));
+	resp.valid_hooks = tbl->valid_hooks;
+	memcpy(&resp.hook_entry, info->hook_entry, sizeof(resp.hook_entry));
+	memcpy(&resp.underflow, info->underflow, sizeof(resp.underflow));
+	resp.num_entries = info->num_entries;
+	resp.size = info->size;
+
+	err = 0;
+	if (copy_to_user(addr, &resp, len))
+		err = -EFAULT;
+out_put:
+	bpfilter_table_put(tbl);
+	return err;
+}
+
+static int copy_target(struct bpfilter_standard_target *ut,
+		       struct bpfilter_standard_target *kt)
+{
+	struct bpfilter_target *tgt;
+	int sz;
+
+
+	if (put_user(kt->target.u.target_size,
+		     &ut->target.u.target_size))
+		return -EFAULT;
+
+	tgt = kt->target.u.kernel.target;
+	if (copy_to_user(ut->target.u.user.name, tgt->name, strlen(tgt->name)))
+		return -EFAULT;
+
+	if (put_user(tgt->rev, &ut->target.u.user.revision))
+		return -EFAULT;
+
+	sz = tgt->size;
+	if (copy_to_user(ut->target.data, kt->target.data, sz))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int do_get_entries(void *up,
+			  struct bpfilter_table *tbl,
+			  struct bpfilter_table_info *info)
+{
+	unsigned int total_size = info->size;
+	const struct bpfilter_ipt_entry *ent;
+	unsigned int off;
+	void *base;
+
+	base = info->entries;
+
+	for (off = 0; off < total_size; off += ent->next_offset) {
+		struct bpfilter_xt_counters *cntrs;
+		struct bpfilter_standard_target *tgt;
+
+		ent = base + off;
+		if (copy_to_user(up + off, ent, sizeof(*ent)))
+			return -EFAULT;
+
+		/* XXX Just clear counters for now. XXX */
+		cntrs = up + off + offsetof(struct bpfilter_ipt_entry, cntrs);
+		if (put_user(0, &cntrs->packet_cnt) ||
+		    put_user(0, &cntrs->byte_cnt))
+			return -EINVAL;
+
+		tgt = (void *) ent + ent->target_offset;
+		dprintf(debug_fd, "target.verdict %d\n", tgt->verdict);
+		if (copy_target(up + off + ent->target_offset, tgt))
+			return -EFAULT;
+	}
+	return 0;
+}
+
+int bpfilter_get_entries(void *cmd, int len)
+{
+	struct bpfilter_ipt_get_entries *uptr = cmd;
+	struct bpfilter_ipt_get_entries req;
+	struct bpfilter_table_info *info;
+	struct bpfilter_table *tbl;
+	int err;
+
+	if (len < sizeof(struct bpfilter_ipt_get_entries))
+		return -EINVAL;
+
+	if (copy_from_user(&req, cmd, sizeof(req)))
+		return -EFAULT;
+
+	tbl = bpfilter_table_get_by_name(req.name, strlen(req.name));
+	if (!tbl)
+		return -ENOENT;
+
+	info = tbl->info;
+	if (!info) {
+		err = -ENOENT;
+		goto out_put;
+	}
+
+	if (info->size != req.size) {
+		err = -EINVAL;
+		goto out_put;
+	}
+
+	err = do_get_entries(uptr->entries, tbl, info);
+	dprintf(debug_fd, "do_get_entries %d req.size %d\n", err, req.size);
+
+out_put:
+	bpfilter_table_put(tbl);
+
+	return err;
+}
+
diff --git a/net/bpfilter/tables.c b/net/bpfilter/tables.c
new file mode 100644
index 0000000..9a96599
--- /dev/null
+++ b/net/bpfilter/tables.c
@@ -0,0 +1,70 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <sys/socket.h>
+#include <errno.h>
+#include <string.h>
+#include <linux/hashtable.h>
+#include "bpfilter_mod.h"
+
+static unsigned int full_name_hash(const void *salt, const char *name, unsigned int len)
+{
+	unsigned int hash = 0;
+	int i;
+
+	for (i = 0; i < len; i++)
+		hash ^= *(name + i);
+	return hash;
+}
+
+DEFINE_HASHTABLE(bpfilter_tables, 4);
+//DEFINE_MUTEX(bpfilter_table_mutex);
+
+struct bpfilter_table *bpfilter_table_get_by_name(const char *name, int name_len)
+{
+	unsigned int hval = full_name_hash(NULL, name, name_len);
+	struct bpfilter_table *tbl;
+
+//	mutex_lock(&bpfilter_table_mutex);
+	hash_for_each_possible(bpfilter_tables, tbl, hash, hval) {
+		if (!strcmp(name, tbl->name)) {
+			tbl->hold++;
+			goto out;
+		}
+	}
+	tbl = NULL;
+out:
+//	mutex_unlock(&bpfilter_table_mutex);
+	return tbl;
+}
+
+void bpfilter_table_put(struct bpfilter_table *tbl)
+{
+//	mutex_lock(&bpfilter_table_mutex);
+	tbl->hold--;
+//	mutex_unlock(&bpfilter_table_mutex);
+}
+
+int bpfilter_table_add(struct bpfilter_table *tbl)
+{
+	unsigned int hval = full_name_hash(NULL, tbl->name, strlen(tbl->name));
+	struct bpfilter_table *srch;
+
+//	mutex_lock(&bpfilter_table_mutex);
+	hash_for_each_possible(bpfilter_tables, srch, hash, hval) {
+		if (!strcmp(srch->name, tbl->name))
+			goto exists;
+	}
+	hash_add(bpfilter_tables, &tbl->hash, hval);
+//	mutex_unlock(&bpfilter_table_mutex);
+
+	return 0;
+
+exists:
+//	mutex_unlock(&bpfilter_table_mutex);
+	return -EEXIST;
+}
+
+void bpfilter_tables_init(void)
+{
+	hash_init(bpfilter_tables);
+}
+
diff --git a/net/bpfilter/targets.c b/net/bpfilter/targets.c
new file mode 100644
index 0000000..4086ac8
--- /dev/null
+++ b/net/bpfilter/targets.c
@@ -0,0 +1,51 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <sys/socket.h>
+#include <errno.h>
+#include <string.h>
+#include "bpfilter_mod.h"
+
+//DEFINE_MUTEX(bpfilter_target_mutex);
+static LIST_HEAD(bpfilter_targets);
+
+struct bpfilter_target *bpfilter_target_get_by_name(const char *name)
+{
+	struct bpfilter_target *tgt;
+
+//	mutex_lock(&bpfilter_target_mutex);
+	list_for_each_entry(tgt, &bpfilter_targets, all_target_list) {
+		if (!strcmp(tgt->name, name)) {
+			tgt->hold++;
+			goto out;
+		}
+	}
+	tgt = NULL;
+out:
+//	mutex_unlock(&bpfilter_target_mutex);
+	return tgt;
+}
+
+void bpfilter_target_put(struct bpfilter_target *tgt)
+{
+//	mutex_lock(&bpfilter_target_mutex);
+	tgt->hold--;
+//	mutex_unlock(&bpfilter_target_mutex);
+}
+
+int bpfilter_target_add(struct bpfilter_target *tgt)
+{
+	struct bpfilter_target *srch;
+
+//	mutex_lock(&bpfilter_target_mutex);
+	list_for_each_entry(srch, &bpfilter_targets, all_target_list) {
+		if (!strcmp(srch->name, tgt->name))
+			goto exists;
+	}
+	list_add_tail(&tgt->all_target_list, &bpfilter_targets);
+//	mutex_unlock(&bpfilter_target_mutex);
+	return 0;
+
+exists:
+//	mutex_unlock(&bpfilter_target_mutex);
+	return -EEXIST;
+}
+
diff --git a/net/bpfilter/tgts.c b/net/bpfilter/tgts.c
new file mode 100644
index 0000000..eac5e8a
--- /dev/null
+++ b/net/bpfilter/tgts.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <sys/socket.h>
+#include "bpfilter_mod.h"
+
+struct bpfilter_target std_tgt = {
+	.name = BPFILTER_STANDARD_TARGET,
+	.family = BPFILTER_PROTO_IPV4,
+	.size = sizeof(int),
+};
+
+struct bpfilter_target err_tgt = {
+	.name = BPFILTER_ERROR_TARGET,
+	.family = BPFILTER_PROTO_IPV4,
+	.size = BPFILTER_FUNCTION_MAXNAMELEN,
+};
+
+int bpfilter_ipv4_register_targets(void)
+{
+	int err = bpfilter_target_add(&std_tgt);
+
+	if (err)
+		return err;
+	return bpfilter_target_add(&err_tgt);
+}
+
diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index 47a0a66..ed5f53b 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -15,6 +15,8 @@ obj-y     := route.o inetpeer.o protocol.o \
 	     fib_frontend.o fib_semantics.o fib_trie.o fib_notifier.o \
 	     inet_fragment.o ping.o ip_tunnel_core.o gre_offload.o
 
+obj-$(CONFIG_BPFILTER) += bpfilter/
+
 obj-$(CONFIG_NET_IP_TUNNEL) += ip_tunnel.o
 obj-$(CONFIG_SYSCTL) += sysctl_net_ipv4.o
 obj-$(CONFIG_PROC_FS) += proc.o
diff --git a/net/ipv4/bpfilter/Makefile b/net/ipv4/bpfilter/Makefile
new file mode 100644
index 0000000..ce262d7
--- /dev/null
+++ b/net/ipv4/bpfilter/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_BPFILTER) += sockopt.o
+
diff --git a/net/ipv4/bpfilter/sockopt.c b/net/ipv4/bpfilter/sockopt.c
new file mode 100644
index 0000000..26e544f
--- /dev/null
+++ b/net/ipv4/bpfilter/sockopt.c
@@ -0,0 +1,49 @@
+#include <linux/uaccess.h>
+#include <linux/bpfilter.h>
+#include <uapi/linux/bpf.h>
+#include <linux/wait.h>
+#include <linux/kmod.h>
+struct sock;
+
+extern struct wait_queue_head bpfilter_get_cmd_wq;
+extern struct wait_queue_head bpfilter_reply_wq;
+extern bool bpfilter_get_cmd_ready;
+extern bool bpfilter_reply_ready;
+extern struct bpfilter_get_cmd bpfilter_get_cmd_mbox;
+extern struct bpfilter_reply bpfilter_reply_mbox;
+
+bool loaded = false;
+
+int bpfilter_ip_set_sockopt(struct sock *sk, int optname, char __user *optval,
+			    unsigned int optlen)
+{
+	int err;
+
+	if (!loaded) {
+		err = request_module("bpfilter");
+		printk("request_module %d\n", err);
+//		if (err)
+//			return err;
+		loaded = true;
+	}
+	bpfilter_get_cmd_mbox.pid = current->pid;
+	bpfilter_get_cmd_mbox.cmd = optname;
+	bpfilter_get_cmd_mbox.addr = (long) optval;
+	bpfilter_get_cmd_mbox.len = optlen;
+	bpfilter_get_cmd_ready = true;
+	wake_up(&bpfilter_get_cmd_wq);
+	wait_event_killable(bpfilter_reply_wq, bpfilter_reply_ready);
+	bpfilter_reply_ready = false;
+	return bpfilter_reply_mbox.status;
+}
+
+int bpfilter_ip_get_sockopt(struct sock *sk, int optname, char __user *optval,
+			    int __user *optlen)
+{
+	int len;
+
+	if (get_user(len, optlen))
+		return -EFAULT;
+
+	return bpfilter_ip_set_sockopt(sk, optname, optval, len);
+}
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 6cc70fa..439c1b9 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -47,6 +47,8 @@
 #include <linux/errqueue.h>
 #include <linux/uaccess.h>
 
+#include <linux/bpfilter.h>
+
 /*
  *	SOL_IP control messages.
  */
@@ -1250,6 +1252,11 @@ int ip_setsockopt(struct sock *sk, int level,
 		return -ENOPROTOOPT;
 
 	err = do_ip_setsockopt(sk, level, optname, optval, optlen);
+#ifdef CONFIG_BPFILTER
+	if (optname >= BPFILTER_IPT_SO_SET_REPLACE &&
+	    optname < BPFILTER_IPT_SET_MAX)
+		err = bpfilter_ip_set_sockopt(sk, optname, optval, optlen);
+#endif
 #ifdef CONFIG_NETFILTER
 	/* we need to exclude all possible ENOPROTOOPTs except default case */
 	if (err == -ENOPROTOOPT && optname != IP_HDRINCL &&
@@ -1564,6 +1571,11 @@ int ip_getsockopt(struct sock *sk, int level,
 	int err;
 
 	err = do_ip_getsockopt(sk, level, optname, optval, optlen, 0);
+#ifdef CONFIG_BPFILTER
+	if (optname >= BPFILTER_IPT_SO_GET_INFO &&
+	    optname < BPFILTER_IPT_GET_MAX)
+		err = bpfilter_ip_get_sockopt(sk, optname, optval, optlen);
+#endif
 #ifdef CONFIG_NETFILTER
 	/* we need to exclude all possible ENOPROTOOPTs except default case */
 	if (err == -ENOPROTOOPT && optname != IP_PKTOPTIONS &&
@@ -1599,6 +1611,11 @@ int compat_ip_getsockopt(struct sock *sk, int level, int optname,
 	err = do_ip_getsockopt(sk, level, optname, optval, optlen,
 		MSG_CMSG_COMPAT);
 
+#ifdef CONFIG_BPFILTER
+	if (optname >= BPFILTER_IPT_SO_GET_INFO &&
+	    optname < BPFILTER_IPT_GET_MAX)
+		err = bpfilter_ip_get_sockopt(sk, optname, optval, optlen);
+#endif
 #ifdef CONFIG_NETFILTER
 	/* we need to exclude all possible ENOPROTOOPTs except default case */
 	if (err == -ENOPROTOOPT && optname != IP_PKTOPTIONS &&
-- 
2.9.5
