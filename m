From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] Drop expectation refcount after unlinking expectation
Date: Fri, 05 Aug 2005 02:38:31 +0200
Message-ID: <42F2B507.8070207@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040706070001010503090500"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
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
--------------040706070001010503090500
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch comes from the following thread:

[PATCH 6/7] Fix expectation creation

In unlink_expect, the expectation is removed from the list so the 
refcount must be dropped as well.

Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>

This fixes the problem although I think that there's something wrong 
with current refcounting. Every time an expectation is created, the 
refcount of the master conntrack is incremented. Then, if the master 
conntrack is destroyed, say the timeout has expired, 
ip_ct_remove_expectation will be called. So firstly, all expectations 
linked to such conntrack are destroyed and then the conntrack itself. 
OK, my question is: why do we need to increase the master conntrack 
refcount for expectations, if they are always killed first? Actually I 
think that the master conntrack refcount should be increased once the 
expectation is confirmed but not in ip_conntrack_expect_alloc.

--------------040706070001010503090500
Content-Type: text/x-patch;
 name="04fix-leak.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04fix-leak.patch"

Index: netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- netfilter-2.6.14.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-08-03 16:32:30.000000000 +0200
+++ netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_core.c	2005-08-03 16:39:36.000000000 +0200
@@ -215,6 +215,7 @@
 	list_del(&exp->list);
 	CONNTRACK_STAT_INC(expect_delete);
 	exp->master->expecting--;
+	ip_conntrack_expect_put(exp);
 }
 
 void __ip_ct_expect_unlink_destroy(struct ip_conntrack_expect *exp)

--------------040706070001010503090500--
