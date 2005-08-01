From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH 5/7] Fix a deadlock in new_conntrack
Date: Mon, 01 Aug 2005 19:05:18 +0200
Message-ID: <42EE564E.1090308@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090702010909040503090308"
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
--------------090702010909040503090308
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Fix a deadlock during conntrack creation. ip_conntrack_lock is unlocked 
twice.

--------------090702010909040503090308
Content-Type: text/x-patch;
 name="05fix-deadlock.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="05fix-deadlock.patch"

Index: netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- netfilter-2.6.14.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-08-01 18:21:13.000000000 +0200
+++ netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-08-01 18:21:18.000000000 +0200
@@ -1094,13 +1094,12 @@
 		err = -ENOENT;
 		if (nlh->nlmsg_flags & NLM_F_CREATE)
 			err = ctnetlink_create_conntrack(cda, &otuple, &rtuple);
+		return err;
+	}
+	/* we only allow nat config for new conntracks */
+	if (cda[CTA_NAT-1]) {
+		err = -EINVAL;
 		goto out_unlock;
-	} else {
-		/* we only allow nat config for new conntracks */
-		if (cda[CTA_NAT-1]) {
-			err = -EINVAL;
-			goto out_unlock;
-		}
 	}
 
 	/* We manipulate the conntrack inside the global conntrack table lock,

--------------090702010909040503090308--
