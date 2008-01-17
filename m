From: Helge Deller <deller@gmx.de>
Subject: Re: [PATCH] add netfilter gcc printf format checking
Date: Thu, 17 Jan 2008 22:37:20 +0100
Message-ID: <200801172237.20884.deller@gmx.de>
References: <200801061445.53098.deller@gmx.de> <200801062116.38955.deller@gmx.de> <478C5BCA.8070900@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34463 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752687AbYAQVhs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:37:48 -0500
In-Reply-To: <478C5BCA.8070900@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

updated patch against net-2.6.25 git tree below
=============================

[PATCH] add netfilter gcc printf format checking

Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/include/net/netfilter/nf_log.h b/include/net/netfilter/nf_log.h
index 037e824..8c6b5ae 100644
--- a/include/net/netfilter/nf_log.h
+++ b/include/net/netfilter/nf_log.h
@@ -54,6 +54,6 @@ void nf_log_packet(int pf,
 		   const struct net_device *in,
 		   const struct net_device *out,
 		   const struct nf_loginfo *li,
-		   const char *fmt, ...);
+		   const char *fmt, ...) __attribute__ ((format(printf,7,8)));
 
 #endif /* _NF_LOG_H */
