From: Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH RFC 1/4] modules: allow insmod load regular elf binaries
Date: Fri, 16 Feb 2018 14:40:20 +0100
Message-ID: <20180216134023.15536-2-daniel@iogearbox.net>
References: <20180216134023.15536-1-daniel@iogearbox.net>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
        alexei.starovoitov@gmail.com, Alexei Starovoitov <ast@kernel.org>
To: netdev@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:39981 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031758AbeBPNkm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Feb 2018 08:40:42 -0500
In-Reply-To: <20180216134023.15536-1-daniel@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Alexei Starovoitov <ast@kernel.org>

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 fs/exec.c               | 40 +++++++++++++++++++++++++++++++---------
 include/linux/binfmts.h |  1 +
 include/linux/umh.h     |  4 ++++
 kernel/module.c         | 33 ++++++++++++++++++++++++++++-----
 kernel/umh.c            | 24 +++++++++++++++++++++---
 5 files changed, 85 insertions(+), 17 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 7eb8d21..0483c43 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1691,14 +1691,13 @@ static int exec_binprm(struct linux_binprm *bprm)
 /*
  * sys_execve() executes a new program.
  */
-static int do_execveat_common(int fd, struct filename *filename,
-			      struct user_arg_ptr argv,
-			      struct user_arg_ptr envp,
-			      int flags)
+static int __do_execve_file(int fd, struct filename *filename,
+			    struct user_arg_ptr argv,
+			    struct user_arg_ptr envp,
+			    int flags, struct file *file)
 {
 	char *pathbuf = NULL;
 	struct linux_binprm *bprm;
-	struct file *file;
 	struct files_struct *displaced;
 	int retval;
 
@@ -1737,7 +1736,8 @@ static int do_execveat_common(int fd, struct filename *filename,
 	check_unsafe_exec(bprm);
 	current->in_execve = 1;
 
-	file = do_open_execat(fd, filename, flags);
+	if (!file)
+		file = do_open_execat(fd, filename, flags);
 	retval = PTR_ERR(file);
 	if (IS_ERR(file))
 		goto out_unmark;
@@ -1745,7 +1745,9 @@ static int do_execveat_common(int fd, struct filename *filename,
 	sched_exec();
 
 	bprm->file = file;
-	if (fd == AT_FDCWD || filename->name[0] == '/') {
+	if (!filename) {
+		bprm->filename = "/dev/null";
+	} else if (fd == AT_FDCWD || filename->name[0] == '/') {
 		bprm->filename = filename->name;
 	} else {
 		if (filename->name[0] == '\0')
@@ -1811,7 +1813,8 @@ static int do_execveat_common(int fd, struct filename *filename,
 	task_numa_free(current);
 	free_bprm(bprm);
 	kfree(pathbuf);
-	putname(filename);
+	if (filename)
+		putname(filename);
 	if (displaced)
 		put_files_struct(displaced);
 	return retval;
@@ -1834,10 +1837,29 @@ static int do_execveat_common(int fd, struct filename *filename,
 	if (displaced)
 		reset_files_struct(displaced);
 out_ret:
-	putname(filename);
+	if (filename)
+		putname(filename);
 	return retval;
 }
 
+static int do_execveat_common(int fd, struct filename *filename,
+			      struct user_arg_ptr argv,
+			      struct user_arg_ptr envp,
+			      int flags)
+{
+	struct file *file = NULL;
+
+	return __do_execve_file(fd, filename, argv, envp, flags, file);
+}
+
+int do_execve_file(struct file *file, void *__argv, void *__envp)
+{
+	struct user_arg_ptr argv = { .ptr.native = __argv };
+	struct user_arg_ptr envp = { .ptr.native = __envp };
+
+	return __do_execve_file(AT_FDCWD, NULL, argv, envp, 0, file);
+}
+
 int do_execve(struct filename *filename,
 	const char __user *const __user *__argv,
 	const char __user *const __user *__envp)
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index b0abe21..c783a7b 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -147,5 +147,6 @@ extern int do_execveat(int, struct filename *,
 		       const char __user * const __user *,
 		       const char __user * const __user *,
 		       int);
+int do_execve_file(struct file *file, void *__argv, void *__envp);
 
 #endif /* _LINUX_BINFMTS_H */
diff --git a/include/linux/umh.h b/include/linux/umh.h
index 244aff6..68ddd4f 100644
--- a/include/linux/umh.h
+++ b/include/linux/umh.h
@@ -22,6 +22,7 @@ struct subprocess_info {
 	const char *path;
 	char **argv;
 	char **envp;
+	struct file *file;
 	int wait;
 	int retval;
 	int (*init)(struct subprocess_info *info, struct cred *new);
@@ -38,6 +39,9 @@ call_usermodehelper_setup(const char *path, char **argv, char **envp,
 			  int (*init)(struct subprocess_info *info, struct cred *new),
 			  void (*cleanup)(struct subprocess_info *), void *data);
 
+extern struct subprocess_info *
+call_usermodehelper_setup_file(struct file *file);
+
 extern int
 call_usermodehelper_exec(struct subprocess_info *info, int wait);
 
diff --git a/kernel/module.c b/kernel/module.c
index 1d65b2c..b0febe3 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -325,6 +325,7 @@ struct load_info {
 	struct {
 		unsigned int sym, str, mod, vers, info, pcpu;
 	} index;
+	struct file *file;
 };
 
 /*
@@ -2801,6 +2802,15 @@ static int module_sig_check(struct load_info *info, int flags)
 }
 #endif /* !CONFIG_MODULE_SIG */
 
+static int run_umh(struct file *file)
+{
+	struct subprocess_info *sub_info = call_usermodehelper_setup_file(file);
+
+	if (!file)
+		return -ENOMEM;
+	return call_usermodehelper_exec(sub_info, UMH_WAIT_EXEC);
+}
+
 /* Sanity checks against invalid binaries, wrong arch, weird elf version. */
 static int elf_header_check(struct load_info *info)
 {
@@ -2808,7 +2818,6 @@ static int elf_header_check(struct load_info *info)
 		return -ENOEXEC;
 
 	if (memcmp(info->hdr->e_ident, ELFMAG, SELFMAG) != 0
-	    || info->hdr->e_type != ET_REL
 	    || !elf_check_arch(info->hdr)
 	    || info->hdr->e_shentsize != sizeof(Elf_Shdr))
 		return -ENOEXEC;
@@ -2818,6 +2827,11 @@ static int elf_header_check(struct load_info *info)
 		info->len - info->hdr->e_shoff))
 		return -ENOEXEC;
 
+	if (info->hdr->e_type == ET_EXEC)
+		return run_umh(info->file);
+
+	if (info->hdr->e_type != ET_REL)
+		return -ENOEXEC;
 	return 0;
 }
 
@@ -3861,6 +3875,7 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
 SYSCALL_DEFINE3(finit_module, int, fd, const char __user *, uargs, int, flags)
 {
 	struct load_info info = { };
+	struct fd f;
 	loff_t size;
 	void *hdr;
 	int err;
@@ -3875,14 +3890,22 @@ SYSCALL_DEFINE3(finit_module, int, fd, const char __user *, uargs, int, flags)
 		      |MODULE_INIT_IGNORE_VERMAGIC))
 		return -EINVAL;
 
-	err = kernel_read_file_from_fd(fd, &hdr, &size, INT_MAX,
-				       READING_MODULE);
+	err = -EBADF;
+	f = fdget(fd);
+	if (!f.file)
+		goto out;
+
+	err = kernel_read_file(f.file, &hdr, &size, INT_MAX, READING_MODULE);
 	if (err)
-		return err;
+		goto out;
 	info.hdr = hdr;
 	info.len = size;
+	info.file = f.file;
 
-	return load_module(&info, uargs, flags);
+	err = load_module(&info, uargs, flags);
+out:
+	fdput(f);
+	return err;
 }
 
 static inline int within(unsigned long addr, void *start, unsigned long size)
diff --git a/kernel/umh.c b/kernel/umh.c
index 18e5fa4..073a686 100644
--- a/kernel/umh.c
+++ b/kernel/umh.c
@@ -97,9 +97,12 @@ static int call_usermodehelper_exec_async(void *data)
 
 	commit_creds(new);
 
-	retval = do_execve(getname_kernel(sub_info->path),
-			   (const char __user *const __user *)sub_info->argv,
-			   (const char __user *const __user *)sub_info->envp);
+	if (sub_info->file)
+		retval = do_execve_file(sub_info->file, sub_info->argv, sub_info->envp);
+	else
+		retval = do_execve(getname_kernel(sub_info->path),
+				   (const char __user *const __user *)sub_info->argv,
+				   (const char __user *const __user *)sub_info->envp);
 out:
 	sub_info->retval = retval;
 	/*
@@ -393,6 +396,21 @@ struct subprocess_info *call_usermodehelper_setup(const char *path, char **argv,
 }
 EXPORT_SYMBOL(call_usermodehelper_setup);
 
+struct subprocess_info *call_usermodehelper_setup_file(struct file *file)
+{
+	struct subprocess_info *sub_info;
+	sub_info = kzalloc(sizeof(struct subprocess_info), GFP_KERNEL);
+	if (!sub_info)
+		goto out;
+
+	INIT_WORK(&sub_info->work, call_usermodehelper_exec_work);
+
+	sub_info->path = "/dev/null";
+	sub_info->file = file;
+  out:
+	return sub_info;
+}
+
 /**
  * call_usermodehelper_exec - start a usermode application
  * @sub_info: information about the subprocessa
-- 
2.9.5

