From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] locking issue in alter_reply
Date: Thu, 05 Aug 2004 15:32:42 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <411236FA.5080909@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020908080906070302020503"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
 Patrick McHardy <kaber@trash.net>, Harald Welte <laforge@netfilter.org>
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
--------------020908080906070302020503
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This the first of a set of patches. Actually this patch is a resend, I 
think that it got lost. Actually, we don't need to write lock the 
conntrack table because we always call alter_reply with a non-confirmed 
conntrack.

regards,
Pablo

--------------020908080906070302020503
Content-Type: text/x-patch;
 name="lock-alter-reply.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lock-alter-reply.patch"

diff -u -r1.2 ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	4 Aug 2004 15:26:55 -0000	1.2
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	4 Aug 2004 16:46:10 -0000
@@ -1075,9 +1075,9 @@
 int ip_conntrack_alter_reply(struct ip_conntrack *conntrack,
 			     const struct ip_conntrack_tuple *newreply)
 {
-	WRITE_LOCK(&ip_conntrack_lock);
+	READ_LOCK(&ip_conntrack_lock);
 	if (__ip_conntrack_find(newreply, conntrack)) {
-		WRITE_UNLOCK(&ip_conntrack_lock);
+		READ_UNLOCK(&ip_conntrack_lock);
 		return 0;
 	}
 	/* Should be unconfirmed, so not in hash table yet */
@@ -1089,7 +1089,7 @@
 	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
 	if (!conntrack->master && list_empty(&conntrack->sibling_list))
 		conntrack->helper = ip_ct_find_helper(newreply);
-	WRITE_UNLOCK(&ip_conntrack_lock);
+	READ_UNLOCK(&ip_conntrack_lock);
 
 	return 1;
 }

--------------020908080906070302020503--
