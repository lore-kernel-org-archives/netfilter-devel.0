From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 13/27] xt_helper: Do not bypass RCU
Date: Wed, 2 Jan 2008 21:29:12 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801022128550.14900@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56928 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbYABU3N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:29:13 -0500
In-Reply-To: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 6c922317906546b99afe859faa0c15d46d79dd37
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 2 18:00:29 2008 +0100

    [NETFILTER]: xt_helper: Do not bypass RCU
    
    Use the @helper variable that was just obtained.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

 net/netfilter/xt_helper.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index 8e06ca1..5d063e5 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -52,8 +52,8 @@ helper_mt(const struct sk_buff *skb, const struct net_device *in,
 	if (info->name[0] == '\0')
 		ret = !ret;
 	else
-		ret ^= !strncmp(master_help->helper->name, info->name,
-				strlen(master_help->helper->name));
+		ret ^= !strncmp(helper->name, info->name,
+				strlen(helper->name));
 	return ret;
 }
 
