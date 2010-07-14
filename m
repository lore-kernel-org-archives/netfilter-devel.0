From: Dan Carpenter <error27@gmail.com>
Subject: [rfc] netfilter: copy less data to the user
Date: Wed, 14 Jul 2010 23:04:30 +0200
Message-ID: <20100714210430.GB5164@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: ebtables-devel@lists.sourceforge.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41812 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757889Ab0GNVFz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Jul 2010 17:05:55 -0400
Received: by ewy23 with SMTP id 23so53710ewy.19
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Jul 2010 14:05:52 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Smatch complains that we copy too much data to the user in ebtables.
We copied EBT_FUNCTION_MAXNAMELEN (32) characters to the user here, but 
"m->u.match->name" has XT_EXTENSION_MAXNAMELEN (29) characters.

I'm not sure if this is a bug where someone got confused with m->u.name
which has 32 characters or if this is done for backwards compatability.

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 59ca00e..6bcb31d 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1323,7 +1323,7 @@ static inline int ebt_make_matchname(const struct ebt_entry_match *m,
     const char *base, char __user *ubase)
 {
 	char __user *hlp = ubase + ((char *)m - base);
-	if (copy_to_user(hlp, m->u.match->name, EBT_FUNCTION_MAXNAMELEN))
+	if (copy_to_user(hlp, m->u.match->name, XT_EXTENSION_MAXNAMELEN))
 		return -EFAULT;
 	return 0;
 }
@@ -1332,7 +1332,7 @@ static inline int ebt_make_watchername(const struct ebt_entry_watcher *w,
     const char *base, char __user *ubase)
 {
 	char __user *hlp = ubase + ((char *)w - base);
-	if (copy_to_user(hlp , w->u.watcher->name, EBT_FUNCTION_MAXNAMELEN))
+	if (copy_to_user(hlp , w->u.watcher->name, XT_EXTENSION_MAXNAMELEN))
 		return -EFAULT;
 	return 0;
 }
@@ -1356,7 +1356,7 @@ ebt_make_names(struct ebt_entry *e, const char *base, char __user *ubase)
 	ret = EBT_WATCHER_ITERATE(e, ebt_make_watchername, base, ubase);
 	if (ret != 0)
 		return ret;
-	if (copy_to_user(hlp, t->u.target->name, EBT_FUNCTION_MAXNAMELEN))
+	if (copy_to_user(hlp, t->u.target->name, XT_EXTENSION_MAXNAMELEN))
 		return -EFAULT;
 	return 0;
 }
