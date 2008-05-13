From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2/2]: xt_iprange: module aliases for xt_iprange
Date: Tue, 13 May 2008 13:33:57 +0200
Message-ID: <48297CA5.6030309@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080403050504010200020106"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39641 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbYEMLee (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 May 2008 07:34:34 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080403050504010200020106
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit


--------------080403050504010200020106
Content-Type: text/x-diff;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

[NETFILTER]: xt_iprange: module aliases for xt_iprange

Using iptables 1.3.8 with kernel 2.6.25, rules which include '-m iprange'
don't automatically pull in xt_iprange module.  Below patch adds module
aliases to fix that.  Patch against latest -git, but seems like a good
candidate for -stable also.

Signed-off-by: Phil Oester <kernel@linuxace.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 289242ae97199103baf1254623a424f74601121a
tree 9bf1048f9327c482d6847ee0d840afb64e294918
parent fee65a663d85aa9af3b295064e974ccb692e2c9c
author Phil Oester <kernel@linuxace.com> Tue, 13 May 2008 13:21:48 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 13 May 2008 13:21:48 +0200

 net/netfilter/xt_iprange.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

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

--------------080403050504010200020106--
