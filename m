From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [NETFILTER]: Account for IPv4 options in xt_TCPMSS
Date: Sat, 29 Mar 2008 16:57:37 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0803291652171.28605@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: davem@davemloft.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58128 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbYC2P5i (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Mar 2008 11:57:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


I am not exactly sure why 'minlen' only needed to be 40 bytes
sizeof(iph)+tcphdr; does not the IP header must fit entirely
into the MTU?

===
commit db400aa3480d466bc4f2d83f258a861657fc6619
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Sat Mar 29 16:51:01 2008 +0100

     [NETFILTER]: Account for IPv4 options in xt_TCPMSS

     Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
  net/netfilter/xt_TCPMSS.c |    4 ++--
  1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 217e2b6..1662d89 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -179,8 +179,8 @@ tcpmss_tg4(struct sk_buff *skb, const struct net_device *in,
  	int ret;

  	ret = tcpmss_mangle_packet(skb, targinfo, tcpmss_reverse_mtu4(iph),
-				   iph->ihl * 4,
-				   sizeof(*iph) + sizeof(struct tcphdr));
+				   ip_hdrlen(skb),
+				   ip_hdrlen(skb) + sizeof(struct tcphdr));
  	if (ret < 0)
  		return NF_DROP;
  	if (ret > 0) {

