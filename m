From: Max Kellermann <max@duempel.org>
Subject: [PATCH] 2.6.20-rc6-git2: error: 'struct nf_conn' has no member
	named 'mark'
Date: Wed, 31 Jan 2007 11:33:51 +0100
Message-ID: <20070131103351.GA7248@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="RnlQjJ0d97Da+TV1"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

on 2.6.20-rc6-git2, compilation fails when CONFIG_NF_CONNTRACK_MARK is
not enabled:

  CC      net/netfilter/nf_conntrack_netlink.o
net/netfilter/nf_conntrack_netlink.c: In function
'ctnetlink_conntrack_event':
net/netfilter/nf_conntrack_netlink.c:392: error: 'struct nf_conn' has
no member named 'mark'
make[3]: *** [net/netfilter/nf_conntrack_netlink.o] Error 1

My patch adds the proper #ifdef.

Max


--RnlQjJ0d97Da+TV1
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="fix_nf_conn_mark_without_NF_CONNTRACK_MARK.patch"

--- net/netfilter/nf_conntrack_netlink.c.orig	2007-01-31 11:30:29.257592604 +0100
+++ net/netfilter/nf_conntrack_netlink.c	2007-01-31 11:30:49.226730581 +0100
@@ -389,9 +389,11 @@
 		    && ctnetlink_dump_helpinfo(skb, ct) < 0)
 		    	goto nfattr_failure;
 
+#ifdef CONFIG_NF_CONNTRACK_MARK
 		if ((events & IPCT_MARK || ct->mark)
 		    && ctnetlink_dump_mark(skb, ct) < 0)
 		    	goto nfattr_failure;
+#endif
 
 		if (events & IPCT_COUNTER_FILLING &&
 		    (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||

--RnlQjJ0d97Da+TV1--
