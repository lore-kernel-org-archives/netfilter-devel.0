From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] locking issue in __unexpect_related
Date: Thu, 22 Apr 2004 01:05:23 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4086FE33.3020804@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030104080903060602000401"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
 Harald Welte <laforge@netfilter.org>
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
--------------030104080903060602000401
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald and list,

In the function __unexpect_related:

         /* delete from global and local lists */
         list_del(&expect->list);
         list_del(&expect->expected_list);

If an entry of the global list of expectation is erased, shouldn't this 
operation be write_lock'ed? If missing something, please let me know.

regards,
Pablo

--------------030104080903060602000401
Content-Type: text/plain;
 name="unexpect_related-lock.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="unexpect_related-lock.patch"

--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_core.c	2004-04-14 21:32:58.000000000 +0200
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_core.c	2004-04-22 00:55:42.000000000 +0200
@@ -226,7 +226,9 @@
 	IP_NF_ASSERT(!expect->sibling);
 
 	/* delete from global and local lists */
+	WRITE_LOCK(&ip_conntrack_expect_list);
 	list_del(&expect->list);
+	WRITE_UNLOCK(&ip_conntrack_expect_list);
 	list_del(&expect->expected_list);
 
 	/* decrement expect-count of master conntrack */

--------------030104080903060602000401--
