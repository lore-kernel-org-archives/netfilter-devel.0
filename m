From: Patrick McHardy <kaber@trash.net>
Subject: ipvs 07/62: use standardized format in sprintf
Date: Tue, 16 Feb 2010 15:55:29 +0100 (MET)
Message-ID: <20100216145526.2796.17000.sendpatchset@x2.localnet>
References: <20100216145517.2796.40634.sendpatchset@x2.localnet>
Cc: netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51957 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514Ab0BPOza (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2010 09:55:30 -0500
In-Reply-To: <20100216145517.2796.40634.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit a79e7ac4ad77e1833e8f69e99113204d03018255
Author: Joe Perches <joe@perches.com>
Date:   Mon Jan 11 11:53:31 2010 +0100

    ipvs: use standardized format in sprintf
    
    Use the same format string as net/ipv4/netfilter/nf_nat_ftp.c
    to encode an ipv4 address and port.
    
    Both uses should be a single common function.
    
    Signed-off-by: Joe Perches <joe@perches.com>
    Acked-by: Simon Horman <horms@verge.net.au>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
index 33e2c79..73f38ea 100644
--- a/net/netfilter/ipvs/ip_vs_ftp.c
+++ b/net/netfilter/ipvs/ip_vs_ftp.c
@@ -208,7 +208,7 @@ static int ip_vs_ftp_out(struct ip_vs_app *app, struct ip_vs_conn *cp,
 		 */
 		from.ip = n_cp->vaddr.ip;
 		port = n_cp->vport;
-		sprintf(buf, "%d,%d,%d,%d,%d,%d", NIPQUAD(from.ip),
+		sprintf(buf, "%u,%u,%u,%u,%u,%u", NIPQUAD(from.ip),
 			(ntohs(port)>>8)&255, ntohs(port)&255);
 		buf_len = strlen(buf);
 
