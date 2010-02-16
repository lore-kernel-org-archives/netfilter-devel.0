From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 5/7] netfilter: ebtables: try native set/getsockopt handlers, too
Date: Tue, 16 Feb 2010 17:39:06 +0100
Message-ID: <1266338348-6233-6-git-send-email-fw@strlen.de>
References: <1266338348-6233-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:40249 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933075Ab0BPQi7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2010 11:38:59 -0500
In-Reply-To: <1266338348-6233-1-git-send-email-fw@strlen.de>
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
index fcaefdd..dfb5805 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1428,16 +1428,12 @@ static int copy_everything_to_user(struct ebt_table *t, void __user *user,
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
@@ -2213,8 +2209,12 @@ static int compat_do_replace(struct net *net, void __user *user,
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
@@ -2303,8 +2303,9 @@ static int compat_update_counters(struct net *net, void __user *user,
 	if (copy_from_user(&hlp, user, sizeof(hlp)))
 		return -EFAULT;
 
+	/* try real handler in case userland supplied needed padding */
 	if (len != sizeof(hlp) + hlp.num_counters * sizeof(struct ebt_counter))
-		return -EINVAL;
+		return update_counters(net, user, len);
 
 	return do_update_counters(net, hlp.name, compat_ptr(hlp.counters),
 					hlp.num_counters, user, len);
@@ -2341,9 +2342,10 @@ static int compat_do_ebt_get_ctl(struct sock *sk, int cmd,
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
 
+	/* try real handler in case userland supplied needed padding */
 	if ((cmd == EBT_SO_GET_INFO ||
 	     cmd == EBT_SO_GET_INIT_INFO) && *len != sizeof(tmp))
-			return -EINVAL;
+			return do_ebt_get_ctl(sk, cmd, user, len);
 
 	if (copy_from_user(&tmp, user, sizeof(tmp)))
 		return -EFAULT;
@@ -2380,7 +2382,19 @@ static int compat_do_ebt_get_ctl(struct sock *sk, int cmd,
 		break;
 	case EBT_SO_GET_ENTRIES:
 	case EBT_SO_GET_INIT_ENTRIES:
-		ret = compat_copy_everything_to_user(t, user, len, cmd);
+		/*
+		 * try real handler first in case of userland-side padding.
+		 * in case we are dealing with an 'ordinary' 32 bit binary
+		 * without 64bit compatibility padding, this will fail right
+		 * after copy_from_user when the *len argument is validated.
+		 *
+		 * the compat_ variant needs to do one pass over the kernel
+		 * data set to adjust for size differences before it the check.
+		 */
+		if (copy_everything_to_user(t, user, len, cmd) == 0)
+			ret = 0;
+		else
+			ret = compat_copy_everything_to_user(t, user, len, cmd);
 		break;
 	default:
 		ret = -EINVAL;
-- 
1.6.3.3

