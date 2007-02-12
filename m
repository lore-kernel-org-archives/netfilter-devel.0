From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/7] remove unrequired checking in nfnetlink_get_subsys
Date: Mon, 12 Feb 2007 23:46:33 +0100
Message-ID: <45D0EE49.8080203@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030305030006010701080607"
Cc: Patrick McHardy <kaber@trash.net>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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
--------------030305030006010701080607
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

subsys_table is initialized to NULL, therefore just returns NULL in case
that it is not set.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------030305030006010701080607
Content-Type: text/plain;
 name="07.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="07.patch"

[PATCH] remove unrequired checking in nfnetlink_get_subsys

subsys_table is initialized to NULL, therefore just returns NULL in case
that it is not set.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/net/netfilter/nfnetlink.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nfnetlink.c	2006-12-26 04:34:18.000000000 +0100
+++ net-2.6.git/net/netfilter/nfnetlink.c	2006-12-26 04:37:59.000000000 +0100
@@ -72,8 +72,7 @@ static inline struct nfnetlink_subsystem
 {
 	u_int8_t subsys_id = NFNL_SUBSYS_ID(type);
 
-	if (subsys_id >= NFNL_SUBSYS_COUNT
-	    || subsys_table[subsys_id] == NULL)
+	if (subsys_id >= NFNL_SUBSYS_COUNT)
 		return NULL;
 
 	return subsys_table[subsys_id];

--------------030305030006010701080607--
