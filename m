From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables 1.4.1 + iprange fails for me
Date: Fri, 13 Jun 2008 10:47:40 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806131047070.23098@fbirervta.pbzchgretzou.qr>
References: <20080613090236.417411cd@maxim.office.modum.by>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Maxim Britov <maxim.britov@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20080613090236.417411cd@maxim.office.modum.by>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Friday 2008-06-13 08:02, Maxim Britov wrote:

>I updated yesterday kernel + iptables on my router (into Internet) box.
>Kernel from kernel.org 2.6.25.6 + iptables 1.4.1-1 from fedora rawhide.
>I'm use kernel without modules on that box.
>
>I found troubles with iprange:
># iptables -A INPUT -m iprange --src-range 1.1.1.1-2.2.2.2 -j DROP
># iptables-save |fgrep range
>-A INPUT -m iprange -j DROP
>
>iptables -L -n show it as:
>DROP       all  --  0.0.0.0/0            0.0.0.0/0           
>

commit 5aba9d57d07b3f5474f3c0e71e9309a841e932ae
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Fri Jun 13 10:43:01 2008 +0200

iprange: kernel flags were not set
    
The --src-range and --dst-range parameters did not set the IPRANGE_*
flags in struct xt_iprange_mtinfo.
    
Reported-by: Maxim Britov <maxim.britov@gmail.com>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_iprange.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index 70fcc57..8c8521e 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -119,6 +119,9 @@ iprange_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (ia == NULL)
 			param_act(P_BAD_VALUE, "iprange", "--src-ip", end + 1);
 		memcpy(&info->src_max.in, ia, sizeof(*ia));
+		info->flags |= IPRANGE_SRC;
+		if (invert)
+			info->flags |= IPRANGE_SRC_INV;
 		*flags |= F_SRCIP;
 		return true;
 
@@ -135,6 +138,9 @@ iprange_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (ia == NULL)
 			param_act(P_BAD_VALUE, "iprange", "--dst-ip", end + 1);
 		memcpy(&info->dst_max.in, ia, sizeof(*ia));
+		info->flags |= IPRANGE_DST;
+		if (invert)
+			info->flags |= IPRANGE_DST_INV;
 		*flags |= F_DSTIP;
 		return true;
 	}
