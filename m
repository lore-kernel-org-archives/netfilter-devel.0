From: Hein Tibosch <hein_tibosch@yahoo.es>
Subject: [PATCH] net/ipv6/netfilter: solve section mismatch in nf_conntrack_reasm
Date: Sat, 27 Oct 2012 17:49:26 +0800
Message-ID: <508BAE26.6010104@yahoo.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	Cong Wang <amwang@redhat.com>,
	=?UTF-8?B?TWljaGFsIEt1YmXEjWVr?= <mkubecek@suse.cz>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bosmailout19.eigbox.net ([66.96.189.19]:57457 "EHLO
	bosmailout19.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab2J0KcZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Oct 2012 06:32:25 -0400
Received: from bosmailscan12.eigbox.net ([10.20.15.12])
	by bosmailout19.eigbox.net with esmtp (Exim)
	id 1TS34P-0006Uz-9e
	for netfilter-devel@vger.kernel.org; Sat, 27 Oct 2012 05:52:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Hein Tibosch <hein_tibosch@yahoo.es>
Subject: net/ipv6/netfilter: solve section mismatch in nf_conntrack_reasm

WARNING: net/ipv6/netfilter/nf_defrag_ipv6.o(.text+0xe0): Section mismatch in
reference from the function nf_ct_net_init() to the function
.init.text:nf_ct_frag6_sysctl_register()
The function nf_ct_net_init() references
the function __init nf_ct_frag6_sysctl_register().
etc

In case nf_conntrack_ipv6 is compiled as a module, nf_ct_net_init could be
called after the init code and data are unloaded.
Therefore remove the "__net_init" annotation from nf_ct_frag6_sysctl_register()

Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>

---
 net/ipv6/netfilter/nf_conntrack_reasm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 18bd9bb..22c8ea9 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -85,7 +85,7 @@ static struct ctl_table nf_ct_frag6_sysctl_table[] = {
 	{ }
 };
 
-static int __net_init nf_ct_frag6_sysctl_register(struct net *net)
+static int nf_ct_frag6_sysctl_register(struct net *net)
 {
 	struct ctl_table *table;
 	struct ctl_table_header *hdr;
@@ -127,7 +127,7 @@ static void __net_exit nf_ct_frags6_sysctl_unregister(struct net *net)
 }
 
 #else
-static int __net_init nf_ct_frag6_sysctl_register(struct net *net)
+static int nf_ct_frag6_sysctl_register(struct net *net)
 {
 	return 0;
 }
-- 
1.7.8.0


