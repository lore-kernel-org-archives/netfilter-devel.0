From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: [PATCH]  dead code elimination in ip6_queue.c
Date: Sat, 15 Mar 2003 13:01:05 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E736A61.6020907@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_7bQoxFBy/2LxElLQe4vU/A)"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

--Boundary_(ID_7bQoxFBy/2LxElLQe4vU/A)
Content-type: text/plain; charset=us-ascii; format=flowed
Content-transfer-encoding: 7BIT

Folks,

   the following patch removes dead code in ip6_queue.c

Stephane Ouellette.


--Boundary_(ID_7bQoxFBy/2LxElLQe4vU/A)
Content-type: text/plain; name=ip6_queue.c.patch; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=ip6_queue.c.patch

--- linux-2.4.21-pre5-ac3/net/ipv6/netfilter/ip6_queue.c	Fri Mar 14 15:16:44 2003
+++ linux-2.4.21-pre5-ac3-fixed/net/ipv6/netfilter/ip6_queue.c	Sat Mar 15 12:58:50 2003
@@ -265,8 +265,6 @@
 	return skb;
 
 nlmsg_failure:
-	if (skb)
-		kfree_skb(skb);
 	*errp = -EINVAL;
 	printk(KERN_ERR "ip6_queue: error creating packet message\n");
 	return NULL;
@@ -730,7 +728,6 @@
 
 static int __init init(void)
 {
-	
 	return init_or_cleanup(1);
 }
 

--Boundary_(ID_7bQoxFBy/2LxElLQe4vU/A)--
