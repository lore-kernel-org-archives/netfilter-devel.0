From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/02]: ctnetlink: fix leak in
	ctnetlink_create_conntrack error path
Date: Mon, 15 Jan 2007 10:22:52 +0100 (MET)
Message-ID: <20070115092252.22775.28870.sendpatchset@localhost.localdomain>
References: <20070115092251.22775.89608.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20070115092251.22775.89608.sendpatchset@localhost.localdomain>
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
commit 2725df007db9ffd520ce9be463e1d73202709d9b
tree a94f13912dc2f5703e29a8335b025d775d6121a6
parent 8bebd24221e4690f6fd9d5158c42cf59cf2422ab
author Patrick McHardy <kaber@trash.net> Mon, 15 Jan 2007 09:25:33 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 15 Jan 2007 09:25:33 +0100

 net/ipv4/netfilter/ip_conntrack_netlink.c |    2 +-
 net/netfilter/nf_conntrack_netlink.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index 5fcf91d..6f31fad 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -959,7 +959,7 @@ ctnetlink_create_conntrack(struct nfattr
 	if (cda[CTA_PROTOINFO-1]) {
 		err = ctnetlink_change_protoinfo(ct, cda);
 		if (err < 0)
-			return err;
+			goto err;
 	}
 
 #if defined(CONFIG_IP_NF_CONNTRACK_MARK)
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index bd1d2de..811e3e7 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -981,7 +981,7 @@ ctnetlink_create_conntrack(struct nfattr
 	if (cda[CTA_PROTOINFO-1]) {
 		err = ctnetlink_change_protoinfo(ct, cda);
 		if (err < 0)
-			return err;
+			goto err;
 	}
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)
