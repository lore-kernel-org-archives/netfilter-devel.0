From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [patch] netfilter: xt_LOG: do print MAC header on FORWARD
Date: Mon, 15 Nov 2010 02:30:22 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011150229410.13295@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1011141901020.21430@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42000 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757242Ab0KOBaX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Nov 2010 20:30:23 -0500
In-Reply-To: <alpine.LNX.2.01.1011141901020.21430@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2010-11-14 19:01, Jan Engelhardt wrote:
>netfilter: xt_LOG: do print MAC header on FORWARD
>---
> net/ipv4/netfilter/ipt_LOG.c |    3 +--
> 1 files changed, 1 insertions(+), 2 deletions(-)

And here's a patch that does both v4 and v6.


parent 4e2861b87e1ee692bb02a5e54b1e530c6e319668 (v2.6.37-rc1-191-g4e2861b)
commit 5c6c157ce41af5566baf472782948e38c8d5d83f
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sun Nov 14 17:35:40 2010 +0100

netfilter: xt_LOG: do print MAC header on FORWARD

I am observing consistent behavior even with bridges, so let's unlock
this. xt_mac is already usable in FORWARD, too. Section 9 of
http://ebtables.sourceforge.net/br_fw_ia/br_fw_ia.html#section9 says
the MAC source address is changed, but my observation does not match
that claim -- the MAC header is retained.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/ipt_LOG.c  |    3 +--
 net/ipv6/netfilter/ip6t_LOG.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index 72ffc8f..d76d6c9 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -442,8 +442,7 @@ ipt_log_packet(u_int8_t pf,
 	}
 #endif
 
-	/* MAC logging for input path only. */
-	if (in && !out)
+	if (in != NULL)
 		dump_mac_header(m, loginfo, skb);
 
 	dump_packet(m, loginfo, skb, 0);
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index 09c8889..05027b7 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -452,8 +452,7 @@ ip6t_log_packet(u_int8_t pf,
 	       in ? in->name : "",
 	       out ? out->name : "");
 
-	/* MAC logging for input path only. */
-	if (in && !out)
+	if (in != NULL)
 		dump_mac_header(m, loginfo, skb);
 
 	dump_packet(m, loginfo, skb, skb_network_offset(skb), 1);
-- 
# Created with git-export-patch
