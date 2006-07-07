From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/10][CTNETLINK] Fix race condition on conntrack creation
Date: Fri, 07 Jul 2006 04:13:10 +0200
Message-ID: <44ADC336.1060004@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040703090200000204070109"
Cc: Patrick McHardy <kaber@trash.net>
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
--------------040703090200000204070109
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Current conntrack creation path can run into rare race conditions, make
the creation process atomic.

As side-effect, this patch simplifies the conntrack core API.

This patch depends on [PATCH 4/10] and [PATCH 5/10]

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------040703090200000204070109
Content-Type: text/plain;
 name="03racy.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03racy.patch"

[CTNETLINK] Fix race condition on conntrack creation

Current conntrack creation path can run into rare race conditions, make
the creation process atomic.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- net-2.6.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-07-07 00:15:14.000000000 +0200
+++ net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-07-07 01:52:14.000000000 +0200
@@ -1059,13 +1059,12 @@ ctnetlink_create_conntrack(struct nfattr
 		ct->mark = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
 #endif
 
-	ct->helper = ip_conntrack_helper_find_get(rtuple);
-
-	add_timer(&ct->timeout);
+	/* we do no want any races on hash insertion */
+	write_lock_bh(&ip_conntrack_lock);
+	ct->helper = ip_conntrack_helper_find(rtuple);
 	ip_conntrack_hash_insert(ct);
-
-	if (ct->helper)
-		ip_conntrack_helper_put(ct->helper);
+	add_timer(&ct->timeout);
+	write_unlock_bh(&ip_conntrack_lock);
 
 	DEBUGP("conntrack with id %u inserted\n", ct->id);
 	return 0;
Index: net-2.6/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-2.6.orig/net/netfilter/nf_conntrack_netlink.c	2006-07-07 00:15:14.000000000 +0200
+++ net-2.6/net/netfilter/nf_conntrack_netlink.c	2006-07-07 01:52:32.000000000 +0200
@@ -1079,8 +1079,12 @@ ctnetlink_create_conntrack(struct nfattr
 		ct->mark = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
 #endif
 
-	add_timer(&ct->timeout);
+	/* we do no want any races on hash insertion */
+	write_lock_bh(&nf_conntrack_lock);
+	ct->helper = nf_conntrack_helper_find(rtuple);
 	nf_conntrack_hash_insert(ct);
+	add_timer(&ct->timeout);
+	write_unlock_bh(&nf_conntrack_lock);
 
 	DEBUGP("conntrack with id %u inserted\n", ct->id);
 	return 0;

--------------040703090200000204070109--
