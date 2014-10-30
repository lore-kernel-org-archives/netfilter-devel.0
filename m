From: Ana Rey <anarey@gmail.com>
Subject: [PATCH] extensions: devgroup: fix showing and saving of dst-group
Date: Thu, 30 Oct 2014 17:26:26 +0100
Message-ID: <1414686386-7681-1-git-send-email-anarey@gmail.com>
Cc: axinchan@cnrouter.com, Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:61055 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbaJ3Q0V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:26:21 -0400
Received: by mail-wi0-f176.google.com with SMTP id h11so5040591wiw.9
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2014 09:26:19 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Closes bugzilla: https://bugzilla.netfilter.org/show_bug.cgi?id=985

The --dst-group parameter in devgroup extensions lists and saves
incorrectly its value. --dst-group always shows "0x0/0x0".

This is an example:

 # iptables -I FORWARD -m devgroup --dst-group 200 -j ACCEPT

 # iptables -L FORWARD
 Chain FORWARD (policy ACCEPT)
 target     prot opt source               destination
 ACCEPT     all  --  anywhere             anywhere     src-group 0x64 dst-group 0x0/0x0

 # iptables -S FORWARD
 -P FORWARD ACCEPT
 -A FORWARD -m devgroup --dst-group 0x0/0x0 -j ACCEPT

Reporte-by: Axinchan <axinchan@cnrouter.com>
Signed-off-by: Ana Rey <anarey@gmail.com>
---
 extensions/libxt_devgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_devgroup.c b/extensions/libxt_devgroup.c
index fb1fcb5..1a52627 100644
--- a/extensions/libxt_devgroup.c
+++ b/extensions/libxt_devgroup.c
@@ -124,7 +124,7 @@ static void devgroup_show(const char *pfx, const struct xt_devgroup_info *info,
 		if (info->flags & XT_DEVGROUP_INVERT_DST)
 			printf(" !");
 		printf(" %sdst-group ", pfx);
-		print_devgroup(info->src_group, info->src_mask, numeric);
+		print_devgroup(info->dst_group, info->dst_mask, numeric);
 	}
 }
 
-- 
1.7.10.4

