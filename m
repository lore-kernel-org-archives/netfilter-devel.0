From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH 1/7] Fix expectation leak
Date: Mon, 01 Aug 2005 19:04:51 +0200
Message-ID: <42EE5633.9030307@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000505070702010202050702"
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------000505070702010202050702
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

expectation refcount is set to 1 in ip_conntrack_expect_alloc, and 
incremented again in ip_conntrack_expect_related. So once the 
ip_conntrack_expect_free is called, the expectation is never released.

--------------000505070702010202050702
Content-Type: text/x-patch;
 name="00fix-leak-expect.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="00fix-leak-expect.patch"

Index: netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- netfilter-2.6.14.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-08-01 16:20:26.000000000 +0200
+++ netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_core.c	2005-08-01 16:24:47.000000000 +0200
@@ -970,7 +970,6 @@
 
 static void ip_conntrack_expect_insert(struct ip_conntrack_expect *exp)
 {
-	atomic_inc(&exp->use);
 	exp->master->expecting++;
 	list_add(&exp->list, &ip_conntrack_expect_list);
 

--------------000505070702010202050702--
