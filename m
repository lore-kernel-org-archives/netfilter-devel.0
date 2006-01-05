From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 08/18]: ctnetlink: fix conntrack mark race
Date: Thu,  5 Jan 2006 05:06:40 +0100 (MET)
Message-ID: <20060105040605.23512.51271.sendpatchset@localhost.localdomain>
References: <20060105040554.23512.27346.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David S. Miller <davem@davemloft.net>
In-Reply-To: <20060105040554.23512.27346.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ctnetlink: fix conntrack mark race

Set conntrack mark before it is in hashes.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d83898b5b202d40e7ab16170143661d99b7f5a0e
tree ab89cb82ff71fdb801788aa5387f167c44b27c0f
parent d1e28c10106f0f49384d3f4e4303a2944d977e86
author Pablo Neira Ayuso <pablo@netfilter.org> Thu, 05 Jan 2006 02:55:36 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 05 Jan 2006 02:55:36 +0100

 net/ipv4/netfilter/ip_conntrack_netlink.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index 04137d0..589e9e7 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -1031,6 +1031,11 @@ ctnetlink_create_conntrack(struct nfattr
 			return err;
 	}
 
+#if defined(CONFIG_IP_NF_CONNTRACK_MARK)
+	if (cda[CTA_MARK-1])
+		ct->mark = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
+#endif
+
 	ct->helper = ip_conntrack_helper_find_get(rtuple);
 
 	add_timer(&ct->timeout);
@@ -1039,11 +1044,6 @@ ctnetlink_create_conntrack(struct nfattr
 	if (ct->helper)
 		ip_conntrack_helper_put(ct->helper);
 
-#if defined(CONFIG_IP_NF_CONNTRACK_MARK)
-	if (cda[CTA_MARK-1])
-		ct->mark = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
-#endif
-
 	DEBUGP("conntrack with id %u inserted\n", ct->id);
 	return 0;
 
