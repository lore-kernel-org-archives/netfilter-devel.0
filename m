From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [OOPS,xt_owner,V2]: Oops accessing socket in owner_mt()
Date: Mon, 11 Aug 2014 14:40:36 +0200
Message-ID: <20140811124035.GP3549@imap.eitzenberger.org>
References: <20140415133220.GG6576@imap.eitzenberger.org>
 <20140428155731.GA29816@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nFreZHaLTZJo0R7j"
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:51733 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaHKMkk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Aug 2014 08:40:40 -0400
Content-Disposition: inline
In-Reply-To: <20140428155731.GA29816@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Pablo,

> Not your fault, but I think we should also check for ...
> 
>         ... || skb->sk->sk_state == TCP_TIME_WAIT)
> 
> since early demux was introduced, we may have skb->sk pointing to a
> timewait socket.

the following patch is still in my patch queue.  I have updated
it to handle TIME_WAIT sockets, like you requested.

In the meantime I have had some more systems requiring this
patch, issue didn't occur afterwards.   Please apply.

Thanks!

/Holger


--nFreZHaLTZJo0R7j
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="xt_owner-fix.diff"

xt_owner: fix race with sock_orphan()

By using a read_lock on sk->sk_callback_lock we can avoid Oops
due to someone else calling sock_orphan() at same time on
another CPU, e. g. when using TPROXY.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: linux-3.8.y/net/netfilter/xt_owner.c
===================================================================
--- linux-3.8.y.orig/net/netfilter/xt_owner.c
+++ linux-3.8.y/net/netfilter/xt_owner.c
@@ -14,6 +14,7 @@
 #include <linux/skbuff.h>
 #include <linux/file.h>
 #include <net/sock.h>
+#include <net/tcp.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_owner.h>
 
@@ -32,21 +33,32 @@ static bool
 owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_owner_match_info *info = par->matchinfo;
+	struct sock *sk = skb->sk;
 	const struct file *filp;
 
-	if (skb->sk == NULL || skb->sk->sk_socket == NULL)
+	if (sk == NULL || sk->sk_state == TCP_TIME_WAIT)
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
@@ -54,7 +66,7 @@ owner_mt(const struct sk_buff *skb, stru
 		if ((uid_gte(filp->f_cred->fsuid, uid_min) &&
 		     uid_lte(filp->f_cred->fsuid, uid_max)) ^
 		    !(info->invert & XT_OWNER_UID))
-			return false;
+			goto out_false;
 	}
 
 	if (info->match & XT_OWNER_GID) {
@@ -63,10 +75,16 @@ owner_mt(const struct sk_buff *skb, stru
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

--nFreZHaLTZJo0R7j--
