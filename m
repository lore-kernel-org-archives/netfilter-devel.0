From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/04]: fix ifdef for connmark support in
	nf_conntrack_netlink
Date: Fri, 31 Mar 2006 03:09:08 +0200 (MEST)
Message-ID: <20060331010908.20401.89289.sendpatchset@localhost.localdomain>
References: <20060331010905.20401.80847.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060331010905.20401.80847.sendpatchset@localhost.localdomain>
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

[NETFILTER]: fix ifdef for connmark support in nf_conntrack_netlink

When ctnetlink was ported from ip_conntrack to nf_conntrack two #ifdef's
for connmark support were left unchanged and this code was never
compiled.

Problem noticed by Daniel De Graaf.

Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ea8b4b5661cae27fae57fc5b992730ec2e44d21c
tree 09e7996acf5faa03f42616b2bc46f90365e9fe12
parent 4d5ee8549d2385d700967246fb8ff6cc1828ceb1
author Martin Josefsson <gandalf@wlug.westbo.se> Wed, 29 Mar 2006 10:08:03 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 29 Mar 2006 10:08:03 +0200

 net/netfilter/nf_conntrack_netlink.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 0e0e9d7..3138ae7 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1022,7 +1022,7 @@ ctnetlink_change_conntrack(struct nf_con
 			return err;
 	}
 
-#if defined(CONFIG_IP_NF_CONNTRACK_MARK)
+#if defined(CONFIG_NF_CONNTRACK_MARK)
 	if (cda[CTA_MARK-1])
 		ct->mark = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
 #endif
@@ -1062,7 +1062,7 @@ ctnetlink_create_conntrack(struct nfattr
 			return err;
 	}
 
-#if defined(CONFIG_IP_NF_CONNTRACK_MARK)
+#if defined(CONFIG_NF_CONNTRACK_MARK)
 	if (cda[CTA_MARK-1])
 		ct->mark = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
 #endif
