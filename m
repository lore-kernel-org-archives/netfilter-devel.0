From: Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH RFC 2/4] bpf: introduce bpfilter commands
Date: Fri, 16 Feb 2018 14:40:21 +0100
Message-ID: <20180216134023.15536-3-daniel@iogearbox.net>
References: <20180216134023.15536-1-daniel@iogearbox.net>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
        alexei.starovoitov@gmail.com, Alexei Starovoitov <ast@kernel.org>
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180216134023.15536-1-daniel@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/uapi/linux/bpf.h | 16 ++++++++++++++++
 kernel/bpf/syscall.c     | 41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index db6bdc3..ea977e9 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -94,6 +94,8 @@ enum bpf_cmd {
 	BPF_MAP_GET_FD_BY_ID,
 	BPF_OBJ_GET_INFO_BY_FD,
 	BPF_PROG_QUERY,
+	BPFILTER_GET_CMD,
+	BPFILTER_REPLY,
 };
 
 enum bpf_map_type {
@@ -231,6 +233,17 @@ enum bpf_attach_type {
 #define BPF_F_RDONLY		(1U << 3)
 #define BPF_F_WRONLY		(1U << 4)
 
+struct bpfilter_get_cmd {
+	__u32 pid;
+	__u32 cmd;
+	__u64 addr;
+	__u32 len;
+};
+
+struct bpfilter_reply {
+	__u32 status;
+};
+
 union bpf_attr {
 	struct { /* anonymous struct used by BPF_MAP_CREATE command */
 		__u32	map_type;	/* one of enum bpf_map_type */
@@ -320,6 +333,9 @@ union bpf_attr {
 		__aligned_u64	prog_ids;
 		__u32		prog_cnt;
 	} query;
+
+	struct bpfilter_get_cmd bpfilter_get_cmd;
+	struct bpfilter_reply bpfilter_reply;
 } __attribute__((aligned(8)));
 
 /* BPF helper function descriptions:
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e24aa32..e933bf9 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1840,6 +1840,41 @@ static int bpf_obj_get_info_by_fd(const union bpf_attr *attr,
 	return err;
 }
 
+DECLARE_WAIT_QUEUE_HEAD(bpfilter_get_cmd_wq);
+DECLARE_WAIT_QUEUE_HEAD(bpfilter_reply_wq);
+bool bpfilter_get_cmd_ready = false;
+bool bpfilter_reply_ready = false;
+struct bpfilter_get_cmd bpfilter_get_cmd_mbox;
+struct bpfilter_reply bpfilter_reply_mbox;
+
+#define BPFILTER_GET_CMD_LAST_FIELD bpfilter_get_cmd.len
+
+static int bpfilter_get_cmd(const union bpf_attr *attr,
+			    union bpf_attr __user *uattr)
+{
+	if (CHECK_ATTR(BPFILTER_GET_CMD))
+		return -EINVAL;
+	wait_event_killable(bpfilter_get_cmd_wq, bpfilter_get_cmd_ready);
+	bpfilter_get_cmd_ready = false;
+	if (copy_to_user(&uattr->bpfilter_get_cmd, &bpfilter_get_cmd_mbox,
+			 sizeof(bpfilter_get_cmd_mbox)))
+		return -EFAULT;
+	return 0;
+}
+
+#define BPFILTER_REPLY_LAST_FIELD bpfilter_reply.status
+
+static int bpfilter_reply(const union bpf_attr *attr,
+			  union bpf_attr __user *uattr)
+{
+	if (CHECK_ATTR(BPFILTER_REPLY))
+		return -EINVAL;
+	bpfilter_reply_mbox.status = attr->bpfilter_reply.status;
+	bpfilter_reply_ready = true;
+	wake_up(&bpfilter_reply_wq);
+	return 0;
+}
+
 SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, size)
 {
 	union bpf_attr attr = {};
@@ -1917,6 +1952,12 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 	case BPF_OBJ_GET_INFO_BY_FD:
 		err = bpf_obj_get_info_by_fd(&attr, uattr);
 		break;
+	case BPFILTER_GET_CMD:
+		err = bpfilter_get_cmd(&attr, uattr);
+		break;
+	case BPFILTER_REPLY:
+		err = bpfilter_reply(&attr, uattr);
+		break;
 	default:
 		err = -EINVAL;
 		break;
-- 
2.9.5
