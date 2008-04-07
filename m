From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2/2]: nf_nat: autoload IPv4 connection tracking
Date: Mon, 07 Apr 2008 13:57:38 +0200
Message-ID: <47FA0C32.80608@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010609020108000409000002"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65309 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757237AbYDGL5k (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Apr 2008 07:57:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010609020108000409000002
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit


--------------010609020108000409000002
Content-Type: text/x-diff;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

commit 61e0b36c7cf5ef4dd8efe4809d4fe09933ad535f
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Mon Apr 7 13:52:15 2008 +0200

    [NETFILTER]: nf_nat: autoload IPv4 connection tracking
    
    Without this patch, the generic L3 tracker would kick in
    if nf_conntrack_ipv4 was not loaded before nf_nat, which
    would lead to translation problems with ICMP errors.
    
    NAT does not make sense without IPv4 connection tracking
    anyway, so just add a call to need_ipv4_conntrack().
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 0d5fa3a..36b4e3b 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -629,6 +629,8 @@ static int __init nf_nat_init(void)
 	size_t i;
 	int ret;
 
+	need_ipv4_conntrack();
+
 	ret = nf_ct_extend_register(&nat_extend);
 	if (ret < 0) {
 		printk(KERN_ERR "nf_nat_core: Unable to register extension\n");

--------------010609020108000409000002--
