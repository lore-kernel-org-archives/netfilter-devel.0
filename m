From: "Bob Hockney" <bhockney@ix.netcom.com>
Subject: [PATCH] nfnetlink_log mac address for 6in4 tunnels
Date: Thu, 13 Dec 2012 10:37:02 -0700
Message-ID: <000601cdd958$76ea7a00$64bf6e00$@ix.netcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:59277 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755767Ab2LMRhE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Dec 2012 12:37:04 -0500
Received: from [24.49.174.127] (helo=DESKTOPBOB)
	by elasmtp-dupuy.atl.sa.earthlink.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.67)
	(envelope-from <bhockney@ix.netcom.com>)
	id 1TjCiV-0006GX-SD
	for netfilter-devel@vger.kernel.org; Thu, 13 Dec 2012 12:37:04 -0500
Content-Language: en-us
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


For tunneled ipv6in4 packets, the LOG target (xt_LOG.c) adjusts the start of
the mac field to start at the ethernet header instead of the ipv4 header for
the tunnel.  This patch conforms what is passed by the NFLOG target through
nfnetlink to what the LOG target does.  Code borrowed from xt_LOG.c.

Here are before and after log lines.  The kernel: lines are with the LOG
target, the ulogd lines are with NFLOG, ulogd and its SYSLOG  plugin:

Log lines for the same packet, before patch:

Dec  3 09:07:22 gateway kernel: [   69.268396] INVALID IN=he-ipv6 OUT=eth1
MAC=00:50:8d:bf:02:01:68:ef:bd:f0:7d:d9:08:00:45:00:00:5c:00:00:40:00:fa:29:
64:c2:42:dc:12:2a:18:31:ae:7f TUNNEL=66.220.18.42->w.x.y.z SRC= ...
Dec  3 09:07:22 gateway ulogd[1628]: INVALID  IN=he-ipv6 OUT=eth1
MAC=45:00:00:5c:00:00:40:00:fa:29:64:c2:42:dc:12:2a:18:31:ae:7f:68:00:00:00:
00:20:06:35:2a:03:28:80:00:10 SRC= ...

Log lines after patch:

Dec  3 09:08:44 gateway kernel: [   32.998288] INVALID IN=he-ipv6 OUT=eth1
MAC=00:50:8d:bf:02:01:68:ef:bd:f0:7d:d9:08:00:45:00:00:5c:00:00:40:00:fa:29:
64:c2:42:dc:12:2a:18:31:ae:7f TUNNEL=66.220.18.42->w.x.y.z SRC= ...
Dec  3 09:08:45 gateway ulogd[1488]: INVALID  IN=he-ipv6 OUT=eth1
MAC=00:50:8d:bf:02:01:68:ef:bd:f0:7d:d9:08:00:45:00:00:5c:00:00:40:00:fa:29:
64:c2:42:dc:12:2a:18:31:ae:7f SRC= ...

Signed-off-by: Bob Hockney <bhockney@ix.netcom.com>

===

--- a/net/netfilter/nfnetlink_log.c        2012-11-28 17:11:02.285514325
-0700
+++ b/net/netfilter/nfnetlink_log.c 2012-11-28 17:10:38.551830948 -0700
@@ -382,6 +382,7 @@
        struct nfgenmsg *nfmsg;
        sk_buff_data_t old_tail = inst->skb->tail;
        struct sock *sk;
+       const unsigned char *hwhdrp;

        nlh = nlmsg_put(inst->skb, 0, 0,
                        NFNL_SUBSYS_ULOG << 8 | NFULNL_MSG_PACKET,
@@ -483,9 +484,16 @@
        if (indev && skb_mac_header_was_set(skb)) {
                if (nla_put_be16(inst->skb, NFULA_HWTYPE,
htons(skb->dev->type)) ||
                    nla_put_be16(inst->skb, NFULA_HWLEN,
-                                htons(skb->dev->hard_header_len)) ||
-                   nla_put(inst->skb, NFULA_HWHEADER,
skb->dev->hard_header_len,
-                           skb_mac_header(skb)))
+                                htons(skb->dev->hard_header_len)))
+                       goto nla_put_failure;
+
+               hwhdrp = skb_mac_header(skb);
+
+               if (skb->dev->type == ARPHRD_SIT)
+                       hwhdrp -= ETH_HLEN;
+
+               if (!(hwhdrp < skb->head) && nla_put(inst->skb,
NFULA_HWHEADER,
+                           skb->dev->hard_header_len, hwhdrp))
                        goto nla_put_failure;
        }


