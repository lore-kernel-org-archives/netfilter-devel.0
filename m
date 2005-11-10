From: Pablo Neira <pablo@netfilter.org>
Subject: [PATCH -1/4] kill the slipped through patch
Date: Thu, 10 Nov 2005 02:04:00 +0100
Message-ID: <43729C80.7090306@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040806070602020707000109"
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
--------------040806070602020707000109
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Kill 'slipped through' patch from Harald's git tree:

[PATCH 6/7] add support for zeroing counters at getting (04/11/2005)

This is the same patch, but inverted.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------040806070602020707000109
Content-Type: text/plain;
 name="02slipped-through.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02slipped-through.patch"

Kill 'slipped through' patch from Harald's git tree ;)

[PATCH 6/7] add support for zeroing counters at getting (04/11/2005)

Index: netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- netfilter-2.6.14.git.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-09 19:13:35.000000000 +0100
+++ netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-09 19:15:25.000000000 +0100
@@ -788,12 +788,6 @@ ctnetlink_get_conntrack(struct sock *ctn
 
 	err = ctnetlink_fill_info(skb2, NETLINK_CB(skb).pid, nlh->nlmsg_seq, 
 				  IPCTNL_MSG_CT_NEW, 1, ct);
-
-#ifdef CONFIG_IP_NF_CT_ACCT
-	if (NFNL_MSG_TYPE(nlh->nlmsg_type) == IPCTNL_MSG_CT_GET_CTRZERO) 
-		memset(&ct->counters, 0, sizeof(ct->counters));
-#endif
-	
 	ip_conntrack_put(ct);
 	if (err <= 0)
 		goto free;

--------------040806070602020707000109--
