From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] Iterate lists from the tail to the head
Date: Fri, 05 Aug 2005 02:36:58 +0200
Message-ID: <42F2B4AA.6090905@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080102000601030304050206"
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
--------------080102000601030304050206
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Currently conntracks are inserted after the head. That means that 
conntracks are sorted from the biggest to the smallest id. This happens 
because we use list_prepend (list_add) instead list_add_tail. This can 
result in problems during the list iteration.

                 list_for_each(i, &ip_conntrack_hash[cb->args[0]]) {
                         h = (struct ip_conntrack_tuple_hash *) i;
                         if (DIRECTION(h) != IP_CT_DIR_ORIGINAL)
                                 continue;
                         ct = tuplehash_to_ctrack(h);
                         if (ct->id <= *id)
                                 continue;

In that case just the first conntrack in the bucket will be dumped. To 
fix this, we iterate the list from the tail to the head via 
list_for_each_prev. Same thing for the list of expectations.

Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>

--------------080102000601030304050206
Content-Type: text/x-patch;
 name="02list-prev.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02list-prev.patch"

Index: netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- netfilter-2.6.14.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-08-03 14:48:04.000000000 +0200
+++ netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-08-04 15:24:26.000000000 +0200
@@ -404,7 +404,7 @@
 
 	read_lock_bh(&ip_conntrack_lock);
 	for (; cb->args[0] < ip_conntrack_htable_size; cb->args[0]++, *id = 0) {
-		list_for_each(i, &ip_conntrack_hash[cb->args[0]]) {
+		list_for_each_prev(i, &ip_conntrack_hash[cb->args[0]]) {
 			h = (struct ip_conntrack_tuple_hash *) i;
 			if (DIRECTION(h) != IP_CT_DIR_ORIGINAL)
 				continue;
@@ -441,7 +441,7 @@
 
 	write_lock_bh(&ip_conntrack_lock);
 	for (; cb->args[0] < ip_conntrack_htable_size; cb->args[0]++, *id = 0) {
-		list_for_each(i, &ip_conntrack_hash[cb->args[0]]) {
+		list_for_each_prev(i, &ip_conntrack_hash[cb->args[0]]) {
 			h = (struct ip_conntrack_tuple_hash *) i;
 			if (DIRECTION(h) != IP_CT_DIR_ORIGINAL)
 				continue;
@@ -1214,7 +1214,7 @@
 	DEBUGP("entered %s, last id=%llu\n", __FUNCTION__, *id);
 
 	read_lock_bh(&ip_conntrack_lock);
-	list_for_each(i, &ip_conntrack_expect_list) {
+	list_for_each_prev(i, &ip_conntrack_expect_list) {
 		exp = (struct ip_conntrack_expect *) i;
 		if (exp->id <= *id)
 			continue;

--------------080102000601030304050206--
