From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/02]: ctnetlink: fix leak in
	ctnetlink_create_conntrack error path
Date: Mon, 15 Jan 2007 10:28:28 +0100 (MET)
Message-ID: <20070115092828.23343.32771.sendpatchset@localhost.localdomain>
References: <20070115092825.23343.67537.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: stable@kernel.org
In-Reply-To: <20070115092825.23343.67537.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ctnetlink: fix leak in ctnetlink_create_conntrack error path

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b653efffdc1e260fbb446298fd3fa231f4193cdf
tree a36dd3e3a47b2dc02efb2eea9a98fc63b41260f9
parent 667fca411a3edaf30f98f3f7aaf0c1be8d0e7cc2
author Patrick McHardy <kaber@trash.net> Mon, 15 Jan 2007 10:16:35 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 15 Jan 2007 10:16:35 +0100

 net/ipv4/netfilter/ip_conntrack_netlink.c |    2 +-
 net/netfilter/nf_conntrack_netlink.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index 39f23f4..424f2fc 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -955,7 +955,7 @@ ctnetlink_create_conntrack(struct nfattr
 	if (cda[CTA_PROTOINFO-1]) {
 		err = ctnetlink_change_protoinfo(ct, cda);
 		if (err < 0)
-			return err;
+			goto err;
 	}
 
 #if defined(CONFIG_IP_NF_CONNTRACK_MARK)
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index c650ccc..4c2e69a 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -972,7 +972,7 @@ ctnetlink_create_conntrack(struct nfattr
 	if (cda[CTA_PROTOINFO-1]) {
 		err = ctnetlink_change_protoinfo(ct, cda);
 		if (err < 0)
-			return err;
+			goto err;
 	}
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)
