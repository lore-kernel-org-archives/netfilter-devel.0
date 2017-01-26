From: Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCH] iptables: fix the wrong appending of jump verdict after the comment.
Date: Thu, 26 Jan 2017 14:49:50 +0530
Message-ID: <1485422390-3938-1-git-send-email-mayhs11saini@gmail.com>
Cc: Shyam Saini <mayhs11saini@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:36112 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751964AbdAZJUU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Jan 2017 04:20:20 -0500
Received: by mail-pg0-f66.google.com with SMTP id 75so22004411pgf.3
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jan 2017 01:20:20 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix wrong appending of jump verdict after the comment

For example:
$ iptables-translate -A INPUT -p tcp -m tcp --sport http -s  192.168.0.0/16 -d 192.168.0.0/16 -j LONGNACCEPT -m comment --comment "foobar"
nft add rule ip filter INPUT ip saddr 192.168.0.0/16 ip daddr 192.168.0.0/16 tcp sport 80 counter comment \"foobar\"jump LONGNACCEPT

Note that even without comment with double-quotes (i.e. --comment
"foobar"), it will add quotes:

$ iptables-translate -A FORWARD -p tcp -m tcp --sport http -s 192.168.0.0/16 -d 192.168.0.0/16 -j DROP -m comment --comment singlecomment
nft add rule ip filter FORWARD ip saddr 192.168.0.0/16 ip daddr 192.168.0.0/16 tcp sport 80 counter comment \"singlecomment\"drop

Attempting to apply the translated/generated rule will result to:

$ nft add rule ip filter INPUT ip saddr 192.168.0.0/16 ip daddr  192.168.0.0/16 tcp sport 80 counter comment \"foobar\"jump LONGNACCEPT
<cmdline>:1:111-114: Error: syntax error, unexpected jump, expecting endof file or newline or semicolon
add rule ip filter INPUT ip saddr 192.168.0.0/16 ip daddr 192.168.0.0/16 tcp sport 80 counter comment "foobar"jump LONGNACCEPT

After this patch
$ iptables-translate -A INPUT -p tcp -m tcp --sport http -s 192.168.0.0/16 -d 192.168.0.0/16 -j LONGNACCEPT -m comment --comment "foobar"
nft add rule ip filter INPUT ip saddr 192.168.0.0/16 ip daddr 192.168.0.0/16 tcp sport 80 counter jump LONGNACCEPT comment \"foobar\"
which is correct translation

Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 iptables/nft-ipv4.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 52b1bed..e5947a7 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -489,12 +489,11 @@ static int nft_ipv4_xlate(const void *data, struct xt_xlate *xl)
 
 	/* Always add counters per rule, as in iptables */
 	xt_xlate_add(xl, "counter ");
+	ret = xlate_action(cs, !!(cs->fw.ip.flags & IPT_F_GOTO), xl);
 
 	comment = xt_xlate_get_comment(xl);
 	if (comment)
-		xt_xlate_add(xl, "comment %s", comment);
-
-	ret = xlate_action(cs, !!(cs->fw.ip.flags & IPT_F_GOTO), xl);
+		xt_xlate_add(xl, " comment %s", comment);
 
 	return ret;
 }
-- 
2.7.4

