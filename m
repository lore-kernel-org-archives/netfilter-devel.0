From: kbuild test robot <fengguang.wu@intel.com>
Subject: [RFC PATCH nf-next] netfilter: core: __nf_unregister_net_hook() can
 be static
Date: Wed, 20 Dec 2017 01:25:40 +0800
Message-ID: <20171219172540.GA56682@lkp-sb05>
References: <201712200120.UwkYYVXx%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:44783 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750825AbdLSR0d (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Dec 2017 12:26:33 -0500
Content-Disposition: inline
In-Reply-To: <201712200120.UwkYYVXx%fengguang.wu@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Fixes: ac119d8cd089 ("netfilter: core: support for NFPROTO_INET hook registration")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 606efc9..9ace162 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -400,8 +400,8 @@ static void nf_remove_net_hook(struct nf_hook_entries *old,
 	}
 }
 
-void __nf_unregister_net_hook(struct net *net, int pf,
-			      const struct nf_hook_ops *reg)
+static void __nf_unregister_net_hook(struct net *net, int pf,
+				     const struct nf_hook_ops *reg)
 {
 	struct nf_hook_entries __rcu **pp;
 	struct nf_hook_entries *p;
