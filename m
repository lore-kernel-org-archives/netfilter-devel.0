From: Helge Deller <deller@gmx.de>
Subject: [PATCH] add netfilter gcc printf format checking
Date: Sun, 6 Jan 2008 14:45:52 +0100
Message-ID: <200801061445.53098.deller@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51545 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752382AbYAFNqH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Jan 2008 08:46:07 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[PATCH] add netfilter gcc printf format checking

Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 16adac6..a335bfc 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -181,7 +181,7 @@ void nf_log_packet(int pf,
 		   const struct net_device *in,
 		   const struct net_device *out,
 		   struct nf_loginfo *li,
-		   const char *fmt, ...);
+		   const char *fmt, ...) __printf(7,8);
 
 int nf_hook_slow(int pf, unsigned int hook, struct sk_buff *skb,
 		 struct net_device *indev, struct net_device *outdev,
