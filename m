From: Patrick McHardy <kaber@trash.net>
Subject: netfilter -stable: xt_iprange: module aliases for xt_iprange
Date: Tue, 20 May 2008 14:13:52 +0200
Message-ID: <4832C080.4030203@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010306040009030804030601"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37550 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbYETMN4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 May 2008 08:13:56 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010306040009030804030601
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Another small netfilter fix for -stable to add missing module
aliases to xt_iprange that were forgotten when moving the module
to x_tables.

Please apply, thanks.


--------------010306040009030804030601
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

commit 3d7169b2fdbda9954a4c9026b6f6a78ff8cc64a9
Author: Patrick McHardy <kaber@trash.net>
Date:   Tue May 20 14:08:12 2008 +0200

    netfilter: xt_iprange: module aliases for xt_iprange
    
    Upstream commit 01b7a314:
    
    Using iptables 1.3.8 with kernel 2.6.25, rules which include '-m
    iprange' don't automatically pull in xt_iprange module.  Below patch
    adds module aliases to fix that.  Patch against latest -git, but seems
    like a good candidate for -stable also.
    
    Signed-off-by: Phil Oester <kernel@linuxace.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/netfilter/xt_iprange.c b/net/netfilter/xt_iprange.c
index 500528d..c63e933 100644
--- a/net/netfilter/xt_iprange.c
+++ b/net/netfilter/xt_iprange.c
@@ -179,3 +179,5 @@ module_exit(iprange_mt_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, Jan Engelhardt <jengelh@computergmbh.de>");
 MODULE_DESCRIPTION("Xtables: arbitrary IPv4 range matching");
+MODULE_ALIAS("ipt_iprange");
+MODULE_ALIAS("ip6t_iprange");

--------------010306040009030804030601--
