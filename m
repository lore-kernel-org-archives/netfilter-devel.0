From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH] fix copyright in arpt_mangle
Date: Sun, 9 Nov 2003 18:14:35 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200311091814.35050.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David S.Miller <davem@redhat.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Dave,

The patch below fixes the author and description of the arpt_mangle target.

cheers,
Bart

--- linux-2.6.0-test9/net/ipv4/netfilter/arpt_mangle.c.old	2003-11-09 18:10:14.000000000 +0100
+++ linux-2.6.0-test9/net/ipv4/netfilter/arpt_mangle.c	2003-11-09 18:11:29.000000000 +0100
@@ -4,8 +4,8 @@
 #include <net/sock.h>
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("David S. Miller <davem@redhat.com>");
-MODULE_DESCRIPTION("arptables mangle table");
+MODULE_AUTHOR("Bart De Schuymer <bdschuym@pandora.be>");
+MODULE_DESCRIPTION("arptables arp payload mangle target");
 
 static unsigned int
 target(struct sk_buff **pskb, unsigned int hooknum, const struct net_device *in,
