From: Florian Westphal <fw@strlen.de>
Subject: [RFC nf-next 1/5] bpf: add bpf_prog_get_type_dev_file
Date: Fri,  1 Jun 2018 17:32:12 +0200
Message-ID: <20180601153216.10901-2-fw@strlen.de>
References: <20180601153216.10901-1-fw@strlen.de>
Cc: ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180601153216.10901-1-fw@strlen.de>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Same as bpf_prog_get_type_dev, but gets struct file* instead of fd.

In case of nf_tables jit, a file descriptor representing the ebpf program
gets passed to kernel via a pipe from the (userspace) jit helper,
not 'current', so existing bpf_prog_get_type_dev() doesn't work.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/bpf.h  | 11 +++++++++++
 kernel/bpf/syscall.c | 18 ++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index bbe297436e5d..be7796ac48ac 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -24,6 +24,7 @@ struct bpf_map;
 struct sock;
 struct seq_file;
 struct btf;
+struct file;
 
 /* map is generic key/value storage optionally accesible by eBPF programs */
 struct bpf_map_ops {
@@ -417,6 +418,9 @@ extern const struct bpf_verifier_ops xdp_analyzer_ops;
 struct bpf_prog *bpf_prog_get(u32 ufd);
 struct bpf_prog *bpf_prog_get_type_dev(u32 ufd, enum bpf_prog_type type,
 				       bool attach_drv);
+struct bpf_prog *bpf_prog_get_type_dev_file(struct file *,
+					    enum bpf_prog_type type,
+					    bool attach_drv);
 struct bpf_prog * __must_check bpf_prog_add(struct bpf_prog *prog, int i);
 void bpf_prog_sub(struct bpf_prog *prog, int i);
 struct bpf_prog * __must_check bpf_prog_inc(struct bpf_prog *prog);
@@ -523,6 +527,13 @@ static inline struct bpf_prog *bpf_prog_get_type_dev(u32 ufd,
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
+static inline struct bpf_prog *bpf_prog_get_type_dev_file(struct file *f,
+							  enum bpf_prog_type type,
+							  bool b)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
 static inline struct bpf_prog * __must_check bpf_prog_add(struct bpf_prog *prog,
 							  int i)
 {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 388d4feda348..3fcfd26f0290 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1203,6 +1203,24 @@ struct bpf_prog *bpf_prog_get_type_dev(u32 ufd, enum bpf_prog_type type,
 }
 EXPORT_SYMBOL_GPL(bpf_prog_get_type_dev);
 
+struct bpf_prog *bpf_prog_get_type_dev_file(struct file *f,
+					    enum bpf_prog_type type,
+					    bool attach_drv)
+{
+	struct bpf_prog *prog;
+
+	if (f->f_op != &bpf_prog_fops)
+		return ERR_PTR(-EINVAL);
+
+	prog = f->private_data;
+
+	if (!bpf_prog_get_ok(prog, &type, attach_drv))
+		return ERR_PTR(-EINVAL);
+
+	return bpf_prog_inc(prog);
+}
+EXPORT_SYMBOL_GPL(bpf_prog_get_type_dev_file);
+
 /* Initially all BPF programs could be loaded w/o specifying
  * expected_attach_type. Later for some of them specifying expected_attach_type
  * at load time became required so that program could be validated properly.
-- 
2.16.4
