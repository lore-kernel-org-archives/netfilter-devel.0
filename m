From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] netfilter: ipset: off by one in ip_set_nfnl_get_byindex()
Date: Tue, 21 Oct 2014 11:28:12 +0300
Message-ID: <20141021082812.GB28426@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"David S. Miller" <davem@davemloft.net>,
	Jiri Kosina <jkosina@suse.cz>,
	Ilia Mirkin <imirkin@alum.mit.edu>,
	Sergey Popovich <popovich_sergei@mail.ru>,
	Joe Perches <joe@perches.com>,
	Anton Danilov <littlesmilingcloud@gmail.com>,
	stephen hemminger <stephen@networkplumber.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	kernel-janitors@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30966 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaJUI3g (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:29:36 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The ->ip_set_list[] array is initialized in ip_set_net_init() and it
has ->ip_set_max elements so this check should be >= instead of >
otherwise we are off by one.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I am not very familiar with this code, so please review cautiously.
This is an old bug which should go to -stable.

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 912e5a0..86f9d76 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -659,7 +659,7 @@ ip_set_nfnl_get_byindex(struct net *net, ip_set_id_t index)
 	struct ip_set *set;
 	struct ip_set_net *inst = ip_set_pernet(net);
 
-	if (index > inst->ip_set_max)
+	if (index >= inst->ip_set_max)
 		return IPSET_INVALID_ID;
 
 	nfnl_lock(NFNL_SUBSYS_IPSET);
