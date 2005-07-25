From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] 1 Wire drivers illegally overload NETLINK_NFLOG
Date: Sun, 24 Jul 2005 19:15:05 -0700 (PDT)
Message-ID: <20050724.191505.69244686.davem@davemloft.net>
References: <20050723125427.GA11177@rama>
	<20050722.230559.123762041.yoshfuji@linux-ipv6.org>
	<20050723133353.GB11177@rama>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: johnpol@2ka.mipt.ru, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20050723133353.GB11177@rama>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

From: Harald Welte <laforge@netfilter.org>
Date: Sat, 23 Jul 2005 09:33:53 -0400

> I strongly disrecommend increasing NPROTO.  Maybe we should look into
> reusing NETLINK_FIREWALL (which was an old 2.2.x kernel interface).

ip_queue.c still uses NETLINK_FIREWALL so we really can't use
that.

So instead, as in the patch below, I solved this for now by using
the NETLINK_SKIP value which was reserved years ago yet never
made use of.

diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -88,7 +88,7 @@ static struct w1_master * w1_alloc_dev(u
 
 	dev->groups = 23;
 	dev->seq = 1;
-	dev->nls = netlink_kernel_create(NETLINK_NFLOG, NULL);
+	dev->nls = netlink_kernel_create(NETLINK_W1, NULL);
 	if (!dev->nls) {
 		printk(KERN_ERR "Failed to create new netlink socket(%u) for w1 master %s.\n",
 			NETLINK_NFLOG, dev->dev.bus_id);
diff --git a/include/linux/netlink.h b/include/linux/netlink.h
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -5,7 +5,7 @@
 #include <linux/types.h>
 
 #define NETLINK_ROUTE		0	/* Routing/device hook				*/
-#define NETLINK_SKIP		1	/* Reserved for ENskip  			*/
+#define NETLINK_W1		1	/* 1-wire subsystem				*/
 #define NETLINK_USERSOCK	2	/* Reserved for user mode socket protocols 	*/
 #define NETLINK_FIREWALL	3	/* Firewalling hook				*/
 #define NETLINK_TCPDIAG		4	/* TCP socket monitoring			*/
