From: Vijay Subramanian <subramanian.vijay@gmail.com>
Subject: [PATCH libnftnl] Add support to print netdev family
Date: Sat, 24 Oct 2015 19:50:33 -0700
Message-ID: <1445741433-20203-1-git-send-email-subramanian.vijay@gmail.com>
Cc: pablo@netfilter.org,
	Vijay Subramanian <subramanian.vijay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:36833 "EHLO
	mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbbJYCuu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Oct 2015 22:50:50 -0400
Received: by qkfq3 with SMTP id q3so1493057qkf.3
        for <netfilter-devel@vger.kernel.org>; Sat, 24 Oct 2015 19:50:49 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When we lookup the family, return "netdev" for NFPROTO_NETDEV instead of
"unknown".

Signed-off-by: Vijay Subramanian <subramanian.vijay@gmail.com>
---
 src/utils.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/src/utils.c b/src/utils.c
index c241e5f..84fbe94 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -26,6 +26,7 @@ static const char *const nftnl_family_str[NFPROTO_NUMPROTO] = {
 	[NFPROTO_INET]		= "inet",
 	[NFPROTO_IPV4]		= "ip",
 	[NFPROTO_ARP]		= "arp",
+	[NFPROTO_NETDEV]	= "netdev",
 	[NFPROTO_BRIDGE]	= "bridge",
 	[NFPROTO_IPV6]		= "ip6",
 };
-- 
1.7.9.5

