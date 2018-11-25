From: Aaron Conole <aconole@bytheb.org>
Subject: [RFC -next v0 1/3] bpf: modular maps
Date: Sun, 25 Nov 2018 13:09:17 -0500
Message-ID: <20181125180919.13996-2-aconole@bytheb.org>
References: <20181125180919.13996-1-aconole@bytheb.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Brouer <brouer@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Andy Gospodarek <andy@greyhouse.net>,
        Rony Efraim <ronye@mellanox.com>,
        Simon Horman <horms@verge.net>,
        Marcelo Leitner <marcelo.leitner@gmail.com>
To: netdev@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181125180919.13996-1-aconole@bytheb.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This commit allows for map operations to be loaded by an lkm, rather than
needing to be baked into the kernel at compile time.

Signed-off-by: Aaron Conole <aconole@bytheb.org>
---
 include/linux/bpf.h  |  6 +++++
 init/Kconfig         |  8 +++++++
 kernel/bpf/syscall.c | 57 +++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 33014ae73103..bf4531f076ca 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -553,6 +553,7 @@ static inline int bpf_map_attr_numa_node(const union bpf_attr *attr)
 
 struct bpf_prog *bpf_prog_get_type_path(const char *name, enum bpf_prog_type type);
 int array_map_alloc_check(union bpf_attr *attr);
+void bpf_map_insert_ops(size_t id, const struct bpf_map_ops *ops);
 
 #else /* !CONFIG_BPF_SYSCALL */
 static inline struct bpf_prog *bpf_prog_get(u32 ufd)
@@ -665,6 +666,11 @@ static inline struct bpf_prog *bpf_prog_get_type_path(const char *name,
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
+
+static inline void bpf_map_insert_ops(size_t id,
+				      const struct bpf_map_ops *ops)
+{
+}
 #endif /* CONFIG_BPF_SYSCALL */
 
 static inline struct bpf_prog *bpf_prog_get_type(u32 ufd,
diff --git a/init/Kconfig b/init/Kconfig
index a4112e95724a..aa4eb98af656 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1489,6 +1489,14 @@ config BPF_JIT_ALWAYS_ON
 	  Enables BPF JIT and removes BPF interpreter to avoid
 	  speculative execution of BPF instructions by the interpreter
 
+config BPF_LOADABLE_MAPS
+	bool "Allow map types to be loaded with modules"
+	depends on BPF_SYSCALL && MODULES
+	help
+	  Enables BPF map types to be provided by loadable modules
+	  instead of always compiled in.  Maps provided dynamically
+	  may only be used by super users.
+
 config USERFAULTFD
 	bool "Enable userfaultfd() system call"
 	select ANON_INODES
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index cf5040fd5434..fa1db9ab81e1 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -49,6 +49,8 @@ static DEFINE_SPINLOCK(map_idr_lock);
 
 int sysctl_unprivileged_bpf_disabled __read_mostly;
 
+const struct bpf_map_ops loadable_map = {};
+
 static const struct bpf_map_ops * const bpf_map_types[] = {
 #define BPF_PROG_TYPE(_id, _ops)
 #define BPF_MAP_TYPE(_id, _ops) \
@@ -58,6 +60,15 @@ static const struct bpf_map_ops * const bpf_map_types[] = {
 #undef BPF_MAP_TYPE
 };
 
+static const struct bpf_map_ops * bpf_loadable_map_types[] = {
+#define BPF_PROG_TYPE(_id, _ops)
+#define BPF_MAP_TYPE(_id, _ops) \
+	[_id] = NULL,
+#include <linux/bpf_types.h>
+#undef BPF_PROG_TYPE
+#undef BPF_MAP_TYPE
+};
+
 /*
  * If we're handed a bigger struct than we know of, ensure all the unknown bits
  * are 0 - i.e. new user-space does not rely on any kernel feature extensions
@@ -105,6 +116,48 @@ const struct bpf_map_ops bpf_map_offload_ops = {
 	.map_check_btf = map_check_no_btf,
 };
 
+/*
+ * Fills in the modular ops map, provided that the entry is not already
+ * filled, and that the caller has CAP_SYS_ADMIN.  */
+void bpf_map_insert_ops(size_t id, const struct bpf_map_ops *ops)
+{
+#ifdef CONFIG_BPF_LOADABLE_MAPS
+	if (!capable(CAP_SYS_ADMIN))
+		return;
+
+	if (id >= ARRAY_SIZE(bpf_loadable_map_types))
+		return;
+
+	id = array_index_nospec(id, ARRAY_SIZE(bpf_loadable_map_types));
+	if (bpf_loadable_map_types[id] == NULL)
+		bpf_loadable_map_types[id] = ops;
+#endif
+}
+EXPORT_SYMBOL_GPL(bpf_map_insert_ops);
+
+static const struct bpf_map_ops *find_loadable_ops(u32 type)
+{
+	struct user_struct *user = get_current_user();
+	const struct bpf_map_ops *ops = NULL;
+
+	if (user->uid.val)
+		goto done;
+
+#ifdef CONFIG_BPF_LOADABLE_MAPS
+	if (!capable(CAP_SYS_ADMIN))
+		goto done;
+
+	if (type >= ARRAY_SIZE(bpf_loadable_map_types))
+		goto done;
+	type = array_index_nospec(type, ARRAY_SIZE(bpf_loadable_map_types));
+	ops = bpf_loadable_map_types[type];
+#endif
+
+done:
+	free_uid(user);
+	return ops;
+}
+
 static struct bpf_map *find_and_alloc_map(union bpf_attr *attr)
 {
 	const struct bpf_map_ops *ops;
@@ -115,7 +168,8 @@ static struct bpf_map *find_and_alloc_map(union bpf_attr *attr)
 	if (type >= ARRAY_SIZE(bpf_map_types))
 		return ERR_PTR(-EINVAL);
 	type = array_index_nospec(type, ARRAY_SIZE(bpf_map_types));
-	ops = bpf_map_types[type];
+	ops = (bpf_map_types[type] != &loadable_map) ? bpf_map_types[type] :
+		find_loadable_ops(type);
 	if (!ops)
 		return ERR_PTR(-EINVAL);
 
@@ -180,6 +234,7 @@ int bpf_map_precharge_memlock(u32 pages)
 		return -EPERM;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(bpf_map_precharge_memlock);
 
 static int bpf_charge_memlock(struct user_struct *user, u32 pages)
 {
-- 
2.19.1
