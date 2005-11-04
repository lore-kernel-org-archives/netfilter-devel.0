From: Pablo Neira <pablo@netfilter.org>
Subject: [PATCH 6/7] add support for zeroing counters at getting
Date: Fri, 04 Nov 2005 19:00:42 +0100
Message-ID: <436BA1CA.4020601@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070806050202010908090908"
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
--------------070806050202010908090908
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Add support to zero counters conntrack at getting. Currently we can zero
all the conntracks via zero and dump, but it could be useful more fine
grain zeroing.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------070806050202010908090908
Content-Type: text/plain;
 name="09-get-zero.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="09-get-zero.patch"

Add support to zero counters conntrack at getting. Currently we can zero all
the conntracks via zero and dump, but it could be useful more fine grain 
zeroing.

Signed-by-off: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-04 18:11:06.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-04 18:30:59.000000000 +0100
@@ -788,6 +788,12 @@ ctnetlink_get_conntrack(struct sock *ctn
 
 	err = ctnetlink_fill_info(skb2, NETLINK_CB(skb).pid, nlh->nlmsg_seq, 
 				  IPCTNL_MSG_CT_NEW, 1, ct);
+
+#ifdef CONFIG_IP_NF_CT_ACCT
+	if (NFNL_MSG_TYPE(nlh->nlmsg_type) == IPCTNL_MSG_CT_GET_CTRZERO) 
+		memset(&ct->counters, 0, sizeof(ct->counters));
+#endif
+	
 	ip_conntrack_put(ct);
 	if (err <= 0)
 		goto free;

--------------070806050202010908090908--
