From: Kirill Tkhai <ktkhai@parallels.com>
Subject: [PATCH] netfilter: Add {ipt,ip6t}_osf aliases for xt_osf
Date: Wed, 26 Mar 2014 14:37:59 +0400
Message-ID: <1395830279.3601.2.camel@tkhai>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay.parallels.com ([195.214.232.42]:49438 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaCZKiN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2014 06:38:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There are no these aliases, so kernel can not request appropriate
match table:

$ iptables -I INPUT -p tcp -m osf --genre Windows --ttl 2 -j DROP
iptables: No chain/target/match by that name.

setsockopt() requests ipt_osf module, which is not present. Add
the aliases.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 net/netfilter/xt_osf.c | 2 ++
 1 file changed, 2 insertions(+)
diff --git a/net/netfilter/xt_osf.c b/net/netfilter/xt_osf.c
index 7174611..c529161 100644
--- a/net/netfilter/xt_osf.c
+++ b/net/netfilter/xt_osf.c
@@ -422,4 +422,6 @@ module_exit(xt_osf_fini);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Evgeniy Polyakov <zbr@ioremap.net>");
 MODULE_DESCRIPTION("Passive OS fingerprint matching.");
+MODULE_ALIAS("ipt_osf");
+MODULE_ALIAS("ip6t_osf");
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_OSF);


