From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: [OOPS,TPROXY,xt_owner]: Oops accessing socket in owner_mt()
Date: Tue, 15 Apr 2014 15:32:20 +0200
Message-ID: <20140415133220.GG6576@imap.eitzenberger.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="1yeeQ81UyVL57Vl7"
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.13]:51973 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaDOR2I (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:28:08 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

using kernel v8.8.13.15 I see a kernel oops happening in a setup where
a HTTP using TPROXY is used on a bridge interface.  Also NFQUEUE
is involved:

[ 379.046358] Pid: 5847, comm: afcd/258 Tainted: G O
3.8.13.15-110.g4be5643-smp64 001 Astaro AG ASG/NSB2189
[ 379.046358] RIP: 0010:[<ffffffffa0269034>] [<ffffffffa0269034>] owner_mt+0x31/0xad [xt_owner]
[ 379.046358] RSP: 0018:ffff88016b05b5f0 EFLAGS: 00210246
[ 379.046358] RAX: 0000000000002000 RBX: ffffc90014306ca8 RCX: ffffc90014306cc8
[ 379.046358] RDX: ffffc90014306c01 RSI: ffff88016b05b600 RDI: c9443747ad79b9de
[ 379.046358] RBP: ffffc90014306c38 R08: ffffc90014306b68 R09: ffff88010069b0e0
[ 379.046358] R10: 0000000000000002 R11: 0000000000001000 R12: ffff8801980f9810
[ 379.046358] R13: 0000000000000004 R14: ffff8800d4022f00 R15: ffffffff8147faa0
[ 379.046358] FS: 0000000000000000(0000) GS:ffff88019fc80000(0063)
knlGS:00000000f5983b70
[ 379.046358] CS: 0010 DS: 002b ES: 002b CR0: 0000000080050033
[ 379.046358] CR2: 00000000f5b34fa8 CR3: 000000016b115000 CR4: 00000000000007e0
[ 379.046358] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 379.046358] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 379.046358] Process afcd/258 (pid: 5847, threadinfo ffff88016b05a000, task
ffff880196292520)
[ 379.046358] Stack:
[ 379.046358] ffffffffa015a3f1 0000000100000001 ffff880101dda1c0
00000000000005c8
[ 379.046358] ffff880101dda1c0 ffff8800db9b1e00 ffffffff812b5f73
000000000000000c
[ 379.046358] 0000000000000004 ffff88019627c000 0000000000000000
0000000400000000
[ 379.046358] Call Trace:
[ 379.046358] [<ffffffffa015a3f1>] ? ipt_do_table+0x286/0x5f8 [ip_tables]
[ 379.046358] [<ffffffff812b5f73>] ? tcp_rcv_established+0x594/0x685
[ 379.046358] [<ffffffff8129b502>] ? nf_iterate+0x42/0x7d
[ 379.046358] [<ffffffff810b5141>] ? virt_to_head_page+0x9/0x30
[ 379.046358] [<ffffffff8129c304>] ? nf_reinject+0x9c/0x131
[ 379.046358] [<ffffffff812a5576>] ? ip_finish_output2+0x2b1/0x2b1
[ 379.046358] [<ffffffffa03337e0>] ? nfqnl_recv_verdict+0x68/0x2b2

Actual OOPS is at the time owner match access VFS file on socket, from
xt_owner.c:owner_mt():

	filp = sk->sk_socket->file;
		if (filp == NULL) {

And I think that owner match races with TPROXY calling sock_orphan()
eventually, e. g. if system is low on memory.  To be verified.

I think I have fixed the issue by using a read_lock on 
sk->sk_callback_lock, same lock is used in sock_orphan().

Also I found xt_LOG.c:dump_sk_uid_gid() to be similar, also
using sk->sk_callback_lock.

I have attached the patch I am currently using.  Please check, it
seems to fix the issue seen.  But still unsure, as not occuring
often.

 /Holger


--1yeeQ81UyVL57Vl7
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="xt_owner-fix.diff"

xt_owner: fix race with sock_orphan()

By using a read_lock on sk->sk_callback_lock we can avoid Oops
due to someone else calling sock_orphan() at same time on
another CPU, e. g. when using TPROXY.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: net-next/net/netfilter/xt_owner.c
===================================================================
--- net-next.orig/net/netfilter/xt_owner.c
+++ net-next/net/netfilter/xt_owner.c
@@ -32,21 +32,32 @@ static bool
 owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_owner_match_info *info = par->matchinfo;
+	struct sock *sk = skb->sk;
 	const struct file *filp;
 
-	if (skb->sk == NULL || skb->sk->sk_socket == NULL)
+	if (sk == NULL)
 		return (info->match ^ info->invert) == 0;
-	else if (info->match & info->invert & XT_OWNER_SOCKET)
+
+	read_lock_bh(&sk->sk_callback_lock);
+
+	if (sk->sk_socket == NULL) {
+		read_unlock_bh(&sk->sk_callback_lock);
+		return (info->match ^ info->invert) == 0;
+	}
+
+	if (info->match & info->invert & XT_OWNER_SOCKET)
 		/*
 		 * Socket exists but user wanted ! --socket-exists.
 		 * (Single ampersands intended.)
 		 */
-		return false;
+		goto out_false;
 
-	filp = skb->sk->sk_socket->file;
-	if (filp == NULL)
+	filp = sk->sk_socket->file;
+	if (filp == NULL) {
+		read_unlock_bh(&sk->sk_callback_lock);
 		return ((info->match ^ info->invert) &
 		       (XT_OWNER_UID | XT_OWNER_GID)) == 0;
+	}
 
 	if (info->match & XT_OWNER_UID) {
 		kuid_t uid_min = make_kuid(&init_user_ns, info->uid_min);
@@ -54,7 +65,7 @@ owner_mt(const struct sk_buff *skb, stru
 		if ((uid_gte(filp->f_cred->fsuid, uid_min) &&
 		     uid_lte(filp->f_cred->fsuid, uid_max)) ^
 		    !(info->invert & XT_OWNER_UID))
-			return false;
+			goto out_false;
 	}
 
 	if (info->match & XT_OWNER_GID) {
@@ -63,10 +74,16 @@ owner_mt(const struct sk_buff *skb, stru
 		if ((gid_gte(filp->f_cred->fsgid, gid_min) &&
 		     gid_lte(filp->f_cred->fsgid, gid_max)) ^
 		    !(info->invert & XT_OWNER_GID))
-			return false;
+			goto out_false;
 	}
 
+	read_unlock_bh(&sk->sk_callback_lock);
+
 	return true;
+
+out_false:
+	read_unlock_bh(&sk->sk_callback_lock);
+	return false;
 }
 
 static struct xt_match owner_mt_reg __read_mostly = {

--1yeeQ81UyVL57Vl7--
