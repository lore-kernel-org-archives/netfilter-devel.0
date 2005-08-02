From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH 1/7] Fix expectation leak
Date: Tue, 02 Aug 2005 14:39:58 +0200
Message-ID: <42EF699E.9060901@eurodev.net>
References: <42EE5633.9030307@eurodev.net> <42EE57EF.4070807@trash.net>
	<42EE5EC4.5090303@eurodev.net> <42EE7D92.5020401@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080201050609030405050109"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42EE7D92.5020401@trash.net>
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
--------------080201050609030405050109
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Pablo Neira wrote:
> 
>>Yes, but the refcount is incremented twice ;). Please apply.
> 
> There is one reference for the list and one for the timer. Both are
> needed since the timer deletion can race with the timer. The one
> for the list is dropped in __ip_ct_expect_unlink_destroy, the one
> for the timer after it has been successfully removed.

OK, in that case the following patch should fix the hung that I'm 
experimenting while trying to remove ip_conntrack. It happens if there's 
an expectation pending to be confirmed. It seems that we forgot to drop 
the refcount when removing a conntrack the list, unlink_expect doesn't 
actually do it. So, in this case the correct call must be 
__ip_conntrack_expect_unlink_destroy instead of unlink_expect.

--
Pablo

--------------080201050609030405050109
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- netfilter-2.6.14.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-08-02 12:47:39.000000000 +0200
+++ netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_core.c	2005-08-02 14:28:01.000000000 +0200
@@ -294,7 +294,7 @@
 
 	list_for_each_entry_safe(i, tmp, &ip_conntrack_expect_list, list) {
 		if (i->master == ct && del_timer(&i->timeout)) {
-			unlink_expect(i);
+			__ip_ct_expect_unlink_destroy(i);
 			ip_conntrack_expect_put(i);
 		}
 	}
@@ -936,7 +936,7 @@
 	/* choose the the oldest expectation to evict */
 	list_for_each_entry_reverse(i, &ip_conntrack_expect_list, list) {
 		if (expect_matches(i, exp) && del_timer(&i->timeout)) {
-			unlink_expect(i);
+			__ip_ct_expect_unlink_destroy(i);
 			write_unlock_bh(&ip_conntrack_lock);
 			ip_conntrack_expect_put(i);
 			return;
@@ -993,7 +993,7 @@
 	list_for_each_entry_reverse(i, &ip_conntrack_expect_list, list) {
 		if (i->master == master) {
 			if (del_timer(&i->timeout)) {
-				unlink_expect(i);
+				__ip_ct_expect_unlink_destroy(i);
 				ip_conntrack_expect_put(i);
 			}
 			break;
@@ -1110,7 +1110,7 @@
 	/* Get rid of expectations */
 	list_for_each_entry_safe(exp, tmp, &ip_conntrack_expect_list, list) {
 		if (exp->master->helper == me && del_timer(&exp->timeout)) {
-			unlink_expect(exp);
+			__ip_ct_expect_unlink_destroy(exp);
 			ip_conntrack_expect_put(exp);
 		}
 	}

--------------080201050609030405050109--
