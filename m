From: Adam Kubicki <akubicki@gmail.com>
Subject: extension module 'owner' enhancement
Date: Wed, 9 Oct 2013 20:38:47 +0200
Message-ID: <CAGx=skFP0-q8YSMA-NHvxiRP289ALSRehqcqttv+exYUgg30aw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63752 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab3JISit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Oct 2013 14:38:49 -0400
Received: by mail-ee0-f46.google.com with SMTP id c13so621396eek.19
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Oct 2013 11:38:48 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-m owner --gid-owner works fine, but only for process primary group id.
Below is patch which also checks supplemental groups of sending process.
Based on in_group_p() function from kernel/groups.c  (often used for
permission DAC control in FS modules).

now it's easy to allow --gid-owner <group-allowed-to-access>, or
reject ! --gid-owner <group-allowed-to-access>
just add additional functional group to user account.

For groups range, supplemental groups are checked only for first GID of range.

Below is patch (shorter than this description.. ;)

$ diff -c /tmp/xt_owner.c.old net/netfilter/xt_owner.c
*** /tmp/xt_owner.c.old    2013-10-04 00:13:46.226282418 +0200
--- net/netfilter/xt_owner.c    2013-10-04 06:02:53.074281341 +0200
***************
*** 17,22 ****
--- 17,45 ----
  #include <linux/netfilter/x_tables.h>
  #include <linux/netfilter/xt_owner.h>

+ /* groups_search, not EXPORTed so copied from kernel/groups.c */
+ /* a simple bsearch */
+ int groups_search(const struct group_info *group_info, gid_t grp)
+ {
+     unsigned int left, right;
+
+     if (!group_info)
+         return 0;
+
+     left = 0;
+     right = group_info->ngroups;
+     while (left < right) {
+         unsigned int mid = (left+right)/2;
+         if (grp > GROUP_AT(group_info, mid))
+             left = mid + 1;
+         else if (grp < GROUP_AT(group_info, mid))
+             right = mid;
+         else
+             return 1;
+     }
+     return 0;
+ }
+
  static bool
  owner_mt(const struct sk_buff *skb, const struct xt_match_param *par)
  {
***************
*** 44,51 ****
              return false;

      if (info->match & XT_OWNER_GID)
!         if ((filp->f_cred->fsgid >= info->gid_min &&
!             filp->f_cred->fsgid <= info->gid_max) ^
              !(info->invert & XT_OWNER_GID))
              return false;

--- 67,75 ----
              return false;

      if (info->match & XT_OWNER_GID)
!         if (((filp->f_cred->fsgid >= info->gid_min &&
!             filp->f_cred->fsgid <= info->gid_max) ||
!             groups_search(filp->f_cred->group_info, info->gid_min)) ^
              !(info->invert & XT_OWNER_GID))
              return false;
