From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 08/10] netfilter: ebtables: try native set/getsockopt handlers, too
Date: Thu, 11 Feb 2010 15:12:38 +0100
Message-ID: <1265897559-10610-9-git-send-email-fw@strlen.de>
References: <1265897559-10610-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>,
	Bart De Schuymer <bdschuym@pandora.be>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53725 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753054Ab0BKOMr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 09:12:47 -0500
In-Reply-To: <1265897559-10610-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ebtables can be compiled to perform userspace-side padding of
structures. In that case, all the structures are already in the
'native' format expected by the kernel.

This tries to determine what format the userspace program is
using.

For most set/getsockopts, this can be done by re-trying the
native handler once the compat_ version returns an error.

In case of EBT_SO_GET_ENTRIES, the native handler is tried first,
it should error out very early when checking the *len argument
(the compat version has to defer this check until after
 iterating over the kernel data set once, to adjust for all
 the structure size differences).

The (useful) error printk is suppressed in this case, as we
will try again in compat mode.

Cc: Bart De Schuymer <bdschuym@pandora.be>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/netfilter/ebtables.c |   28 ++++++++++++++++++----------
 1 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index f173362..0af641f 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1406,7 +1406,7 @@ static int copy_counters_to_user(struct ebt_table *t, struct ebt_counter *oldcou
 
 /* called with ebt_mutex locked */
 static int copy_everything_to_user(struct ebt_table *t, void __user *user,
-   int *len, int cmd)
+   int *len, int cmd, bool compat)
 {
 	struct ebt_replace tmp;
 	struct ebt_counter *oldcounters;
@@ -1426,14 +1426,13 @@ static int copy_everything_to_user(struct ebt_table *t, void __user *user,
 		oldcounters = t->table->counters;
 	}
 
-	if (copy_from_user(&tmp, user, sizeof(tmp))) {
-		BUGPRINT("Cfu didn't work\n");
+	if (copy_from_user(&tmp, user, sizeof(tmp)))
 		return -EFAULT;
-	}
 
 	if (*len != sizeof(struct ebt_replace) + entries_size +
 	   (tmp.num_counters? nentries * sizeof(struct ebt_counter): 0)) {
-		BUGPRINT("Wrong size\n");
+		if (!compat)
+			BUGPRINT("Wrong size\n");
 		return -EINVAL;
 	}
 
@@ -1526,7 +1525,7 @@ static int do_ebt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 
 	case EBT_SO_GET_ENTRIES:
 	case EBT_SO_GET_INIT_ENTRIES:
-		ret = copy_everything_to_user(t, user, len, cmd);
+		ret = copy_everything_to_user(t, user, len, cmd, false);
 		mutex_unlock(&ebt_mutex);
 		break;
 
@@ -2178,8 +2177,12 @@ static int compat_do_replace(struct net *net, void __user *user, unsigned int le
 	void *entries_tmp;
 
 	ret = compat_copy_ebt_replace_from_user(&tmp, user, len);
-	if (ret)
+	if (ret) {
+		/* try real handler in case userland supplied needed padding */
+		if (do_replace(net, user, len) == 0)
+			ret = 0;
 		return ret;
+	}
 
 	countersize = COUNTER_OFFSET(tmp.nentries) * nr_cpu_ids;
 	newinfo = vmalloc(sizeof(*newinfo) + countersize);
@@ -2268,8 +2271,9 @@ static int compat_update_counters(struct net *net, void __user *user, unsigned i
 	if (copy_from_user(&hlp, user, sizeof(hlp)))
 		return -EFAULT;
 
+	/* try real handler in case userland supplied needed padding */
 	if (len != sizeof(hlp) + hlp.num_counters * sizeof(struct ebt_counter))
-		return -EINVAL;
+		return update_counters(net, user, len);
 
 	return do_update_counters(net, hlp.name, compat_ptr(hlp.counters),
 					hlp.num_counters, user, len);
@@ -2305,9 +2309,10 @@ static int compat_do_ebt_get_ctl(struct sock *sk, int cmd, void __user *user, in
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
 
+	/* try real handler in case userland supplied needed padding */
 	if ((cmd == EBT_SO_GET_INFO ||
 	     cmd == EBT_SO_GET_INIT_INFO) && *len != sizeof(tmp))
-			return -EINVAL;
+			return do_ebt_get_ctl(sk, cmd, user, len);
 
 	if (copy_from_user(&tmp, user, sizeof(tmp)))
 		return -EFAULT;
@@ -2344,7 +2349,10 @@ static int compat_do_ebt_get_ctl(struct sock *sk, int cmd, void __user *user, in
 		break;
 	case EBT_SO_GET_ENTRIES:
 	case EBT_SO_GET_INIT_ENTRIES:
-		ret = compat_copy_everything_to_user(t, user, len, cmd);
+		if (copy_everything_to_user(t, user, len, cmd, true) == 0)
+			ret = 0;
+		else
+			ret = compat_copy_everything_to_user(t, user, len, cmd);
 		break;
 	default:
 		ret = -EINVAL;
-- 
1.6.3.3

