From: Mark Leander <mark.leander@topicbranch.net>
Subject: [PATCH] Clear ulog message to prevent leaking uninitializied memory to user
Date: Tue, 10 Aug 2010 20:22:31 +0000
Message-ID: <1281471751-3397-1-git-send-email-mark.leander@topicbranch.net>
Cc: netfilter-devel@vger.kernel.org,
	Mark Leander <mark.leander@topicbranch.net>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33890 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757840Ab0HJUXJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Aug 2010 16:23:09 -0400
Received: by ewy23 with SMTP id 23so4072576ewy.19
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Aug 2010 13:23:07 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ipt_ulog_packet() did not properly blank the char[] members
indev_name, outdev_name, prefix and mac of struct ulog_packet_msg.
This leaks uninitialized kernel memory to user space in the form
of netlink NFLOG broadcasts. This change clears the whole structure
initially to avoid this.

Signed-off-by: Mark Leander <mark.leander@topicbranch.net>
---
 net/ipv4/netfilter/ipt_ULOG.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index 446e0f4..07b36b0 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -204,6 +204,7 @@ static void ipt_ulog_packet(unsigned int hooknum,
 	ub->qlen++;
 
 	pm = NLMSG_DATA(nlh);
+	memset(pm, 0, sizeof(*pm));
 
 	/* We might not have a timestamp, get one */
 	if (skb->tstamp.tv64 == 0)
-- 
1.7.0.4

