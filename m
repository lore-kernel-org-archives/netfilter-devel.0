From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH] Fix possible oops in ipt_REDIRECT
Date: Sat, 25 Oct 2003 17:28:56 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200310251728.56938.bdschuym@pandora.be>
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

When a device doesn't have an IP address, as in ifconfig eth0 0.0.0.0, then
dev->ip_ptr->ifa_list == NULL.
It is then possible to craft a packet that oopses the kernel:
Suppose eth0 on box 1 was brought up with ifconfig eth0 0.0.0.0
Suppose the iptabes nat table on box 1 contains one rule:
box1# iptables -t nat -A PREROUTING -j REDIRECT

Use box 2, connected to box1 via box1's eth0 to oops the kernel:
box2# arp -s 192.168.123.166 $MAC_OF_ETH0_OF_BOX1
box2# ping 192.168.123.166
Oops on box 1.
(Change 192.168.123.166 into an IP address of the local network)

cheers,
Bart

--- linux-2.4.22/net/ipv4/netfilter/ipt_REDIRECT.c.old	2003-10-20 23:10:02.000000000 +0200
+++ linux-2.4.22/net/ipv4/netfilter/ipt_REDIRECT.c	2003-10-20 23:10:18.000000000 +0200
@@ -79,7 +79,7 @@ redirect_target(struct sk_buff **pskb,
 
 		/* Device might not have an associated in_device. */
 		indev = (struct in_device *)(*pskb)->dev->ip_ptr;
-		if (indev == NULL)
+		if (indev == NULL || indev->ifa_list == NULL)
 			return NF_DROP;
 
 		/* Grab first address on interface. */

--- linux-2.6.0-test8/net/ipv4/netfilter/ipt_REDIRECT.c.old	2003-10-20 22:30:53.000000000 +0200
+++ linux-2.6.0-test8/net/ipv4/netfilter/ipt_REDIRECT.c	2003-10-20 22:31:31.000000000 +0200
@@ -83,7 +83,7 @@ redirect_target(struct sk_buff **pskb,
 
 		/* Device might not have an associated in_device. */
 		indev = (struct in_device *)(*pskb)->dev->ip_ptr;
-		if (indev == NULL)
+		if (indev == NULL || indev->ifa_list == NULL)
 			return NF_DROP;
 
 		/* Grab first address on interface. */
