From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 03/05: nf_conntrack: restrict runtime expect hashsize modifications
Date: Mon,  8 Feb 2010 18:10:29 +0100 (MET)
Message-ID: <20100208171028.15522.50410.sendpatchset@x2.localnet>
References: <20100208171024.15522.8136.sendpatchset@x2.localnet>
Cc: netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38908 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab0BHRKb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Feb 2010 12:10:31 -0500
In-Reply-To: <20100208171024.15522.8136.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 38c7233b287481dfb3327dde136801ce500aba58
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Thu Feb 4 18:24:06 2010 +0100

    netfilter: nf_conntrack: restrict runtime expect hashsize modifications
    
    Expectation hashtable size was simply glued to a variable with no code
    to rehash expectations, so it was a bug to allow writing to it.
    Make "expect_hashsize" readonly.
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Cc: stable@kernel.org
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index fdf5d2a..4ad7d1d 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -569,7 +569,7 @@ static void exp_proc_remove(struct net *net)
 #endif /* CONFIG_PROC_FS */
 }
 
-module_param_named(expect_hashsize, nf_ct_expect_hsize, uint, 0600);
+module_param_named(expect_hashsize, nf_ct_expect_hsize, uint, 0400);
 
 int nf_conntrack_expect_init(struct net *net)
 {
