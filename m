From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next] netfilter: nf_conntrack: restore nf_conntrack_htable_size as exported symbol
Date: Thu, 18 Aug 2016 15:10:34 +0200
Message-ID: <1471525834-3692-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:37660 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbcHRN2T (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Aug 2016 09:28:19 -0400
Received: from 129.166.216.87.static.jazztel.es ([87.216.166.129] helo=salvia.here)
	by ganesha.gnumonks.org with esmtpsa (TLS1.0:RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <pablo@netfilter.org>)
	id 1baN5r-0007Qf-0i
	for netfilter-devel@vger.kernel.org; Thu, 18 Aug 2016 15:10:49 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is required to iterate over the hash table in cttimeout, ctnetlink
and nf_conntrack_ipv4.

>> ERROR: "nf_conntrack_htable_size" [net/netfilter/nfnetlink_cttimeout.ko] undefined!
   ERROR: "nf_conntrack_htable_size" [net/netfilter/nf_conntrack_netlink.ko] undefined!
   ERROR: "nf_conntrack_htable_size" [net/ipv4/netfilter/nf_conntrack_ipv4.ko] undefined!

Fixes: adf0516845bcd0 ("netfilter: remove ip_conntrack* sysctl compat code")
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Sorry for this, Liping already reported this but I have applied v1
instead of v2.

 net/netfilter/nf_conntrack_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index aeba28c..7d90a5d 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -160,6 +160,8 @@ static void nf_conntrack_all_unlock(void)
 }
 
 unsigned int nf_conntrack_htable_size __read_mostly;
+EXPORT_SYMBOL_GPL(nf_conntrack_htable_size);
+
 unsigned int nf_conntrack_max __read_mostly;
 seqcount_t nf_conntrack_generation __read_mostly;
 
-- 
2.1.4

