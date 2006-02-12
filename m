From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH] netfilter: fix build error due to missing has_bridge_parent macro
Date: Sun, 12 Feb 2006 03:20:36 +0100
Message-ID: <200602120320.37042.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Rusty Russell <rusty@rustcorp.com.au>, Marc Boucher <marc@mbsi.ca>,
	James Morris <jmorris@namei.org>,
	Harald Welte <laforge@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Jesper Juhl <jesper.juhl@gmail.com>, coreteam@netfilter.org,
	netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750939AbWBLCUe@vger.kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

I just did an allyesconfig test build of 2.6.16-rc2-git10 and found a build
problem.

commit 5dce971acf2ae20c80d5e9d1f6bbf17376870911 removed the 
"has_bridge_parent" macro from net/bridge/br_netfilter.c, resulting in the 
following warning at compile time:

 net/bridge/br_netfilter.c: In function `br_nf_post_routing':
 net/bridge/br_netfilter.c:808: warning: implicit declaration of function `has_bridge_parent'

and this error at link time:

 net/built-in.o(.text+0xeae28): In function `br_nf_post_routing':
 net/bridge/br_netfilter.c:808: undefined reference to `has_bridge_parent'
 make: *** [.tmp_vmlinux1] Error 1

The patch below fixes the problem.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 Patch is compile tested only but should be obviously correct.

 net/bridge/br_netfilter.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.16-rc2-git10/net/bridge/br_netfilter.c~	2006-02-12 03:03:29.000000000 +0100
+++ linux-2.6.16-rc2-git10/net/bridge/br_netfilter.c	2006-02-12 03:03:29.000000000 +0100
@@ -805,7 +805,7 @@ static unsigned int br_nf_post_routing(u
 print_error:
 	if (skb->dev != NULL) {
 		printk("[%s]", skb->dev->name);
-		if (has_bridge_parent(skb->dev))
+		if (bridge_parent(skb->dev))
 			printk("[%s]", bridge_parent(skb->dev)->name);
 	}
 	printk(" head:%p, raw:%p, data:%p\n", skb->head, skb->mac.raw,
