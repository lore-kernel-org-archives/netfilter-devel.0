From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: Missing owner-field initialization in iptable_raw
Date: Mon, 02 May 2005 22:24:03 +0200
Message-ID: <42768C63.2060104@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010802070306000503000107"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

This is a multi-part message in MIME format.
--------------010802070306000503000107
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

table->owner must be initialized so module references can be taken
by nf_queue().



--------------010802070306000503000107
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: Missing owner-field initialization in iptable_raw

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 480fc9b2802f2093e728567010506732e382b688
tree 97b316503a4524074c05d5fb4cab63264690d0d6
parent c4644e58c8b52dca9699e8ee0e975f5f13eb4d2c
author Patrick McHardy <kaber@trash.net> 1115054535 +0200
committer Patrick McHardy <kaber@trash.net> 1115054535 +0200

Index: net/ipv4/netfilter/iptable_raw.c
===================================================================
--- 35d8915a3fd6fa39a46d9b2e8e1fd272e82ea3af/net/ipv4/netfilter/iptable_raw.c  (mode:100644 sha1:01b4a3c814d398f21d29dec0f7d7bf1453b1ce7e)
+++ 97b316503a4524074c05d5fb4cab63264690d0d6/net/ipv4/netfilter/iptable_raw.c  (mode:100644 sha1:47449ba83eb9410280a8463b477501d839ff32bb)
@@ -103,13 +103,15 @@
 	  .hook = ipt_hook, 
 	  .pf = PF_INET, 
 	  .hooknum = NF_IP_PRE_ROUTING, 
-	  .priority = NF_IP_PRI_RAW
+	  .priority = NF_IP_PRI_RAW,
+	  .owner = THIS_MODULE,
 	},
 	{
 	  .hook = ipt_hook, 
 	  .pf = PF_INET, 
 	  .hooknum = NF_IP_LOCAL_OUT, 
-	  .priority = NF_IP_PRI_RAW
+	  .priority = NF_IP_PRI_RAW,
+	  .owner = THIS_MODULE,
 	},
 };
 

--------------010802070306000503000107--
