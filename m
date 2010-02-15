From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 5/7] netfilter: ebtables: try native set/getsockopt handlers, too
Date: Mon, 15 Feb 2010 22:05:37 +0100
Message-ID: <1266267939-7736-6-git-send-email-fw@strlen.de>
References: <1266267939-7736-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:33315 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932123Ab0BOVGy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Feb 2010 16:06:54 -0500
In-Reply-To: <1266267939-7736-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ebtables can be compiled to perform userspace-side padding of
structures. In that case, all the structures are already in the
'native' format expected by the kernel.

This tries to determine what format the userspace program is
using.

For most set/getsockopts, this can be done by checking
the len argument for sizeof(compat_ebt_replace) and
re-trying the native handler on error.

In case of EBT_SO_GET_ENTRIES, the native handler is tried first,
it will error out early when checking the *len argument
(the compat version has to defer this check until after
 iterating over the kernel data set once, to adjust for all
 the structure size differences).

As this would cause error printks, remove those as well, as
recommended by Bart de Schuymer.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/netfilter/ebtables.c |   34 ++++++++++++++++++++++++----------
 1 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 3586228..1a540ef 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1424,16 +1424,12 @@ static int copy_everything_to_user(struct ebt_table *t, void __user *user,
 		oldcounters = t->table->counters;
 	}
 
-	if (copy_from_user(&tmp, user, sizeof(tmp))) {
-		BUGPRINT("Cfu didn't work\n");
+	if (copy_from_user(&tmp, user, sizeof(tmp)))
 		return -EFAULT;
-	}
 
 	if (*len != sizeof(struct ebt_replace) + entries_size +
-	   (tmp.num_counters? nentries * sizeof(struct ebt_counter): 0)) {
-		BUGPRINT("Wrong size\n");
+	   (tmp.num_counters? nentries * sizeof(struct ebt_counter): 0))
 		return -EINVAL;
-	}
 
 	if (tmp.nentries != nentries) {
 		BUGPRINT("Nentries wrong\n");
@@ -2173,8 +2169,12 @@ static int compat_do_replace(struct net *net, void __user *user, unsigned int le
 	void *entries_tmp;
 
 	ret = compat_copy_ebt_replace_from_user(&tmp, user, len);
-	if (ret)
+	if (ret) {
+		/* try real handler in case userland supplied needed padding */
+		if (ret == -EINVAL && do_replace(net, user, len) == 0)
+			ret = 0;
 		return ret;
+	}
 
 	countersize = COUNTER_OFFSET(tmp.nentries) * nr_cpu_ids;
 	newinfo = vmalloc(sizeof(*newinfo) + countersize);
@@ -2263,8 +2263,9 @@ static int compat_update_counters(struct net *net, void __user *user, unsigned i
 	if (copy_from_user(&hlp, user, sizeof(hlp)))
 		return -EFAULT;
 
+	/* try real handler in case userland supplied needed padding */
 	if (len != sizeof(hlp) + hlp.num_counters * sizeof(struct ebt_counter))
-		return -EINVAL;
+		return update_counters(net, user, len);
 
 	return do_update_counters(net, hlp.name, compat_ptr(hlp.counters),
 					hlp.num_counters, user, len);
@@ -2300,9 +2301,10 @@ static int compat_do_ebt_get_ctl(struct sock *sk, int cmd, void __user *user, in
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
 
+	/* try real handler in case userland supplied needed padding */
 	if ((cmd == EBT_SO_GET_INFO ||
 	     cmd == EBT_SO_GET_INIT_INFO) && *len != sizeof(tmp))
-			return -EINVAL;
+			return do_ebt_get_ctl(sk, cmd, user, len);
 
 	if (copy_from_user(&tmp, user, sizeof(tmp)))
 		return -EFAULT;
@@ -2339,7 +2341,19 @@ static int compat_do_ebt_get_ctl(struct sock *sk, int cmd, void __user *user, in
 		break;
 	case EBT_SO_GET_ENTRIES:
 	case EBT_SO_GET_INIT_ENTRIES:
-		ret = compat_copy_everything_to_user(t, user, len, cmd);
+		/*
+		 * try real handler first in case userland supplied needed padding.
+		 * in case we are dealing with an 'ordinary' 32 bit binary without
+		 * 64bit compatibility padding, this will fail right after copy_from_user
+		 * when the *len argument is validated.
+		 *
+		 * the compat_ variant needs to do one pass over the kernel data set
+		 * to adjust for size differences before it can do the same check.
+		 */
+		if (copy_everything_to_user(t, user, len, cmd) == 0)
+			ret = 0;
+		else
+			ret = compat_copy_everything_to_user(t, user, len, cmd);
 		break;
 	default:
 		ret = -EINVAL;
-- 
1.6.4.4

