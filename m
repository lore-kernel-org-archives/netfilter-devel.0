From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 24/33]: ctnetlink: check for status attribute existence
	on conntrack creation
Date: Wed, 29 Nov 2006 03:09:21 +0100 (MET)
Message-ID: <20061129020921.21082.65516.sendpatchset@localhost.localdomain>
References: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ctnetlink: check for status attribute existence on conntrack creation

Check that status flags are available in the netlink message received
to create a new conntrack.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9f1f643dcb442e2bd19afd3fec8d1a3958cf5629
tree d3cb5590466126d7d97a89a5dfdaff242dce7ad9
parent f344b5c94ce31b63c1c2c31ea04512bc9e3929c5
author Pablo Neira Ayuso <pablo@netfilter.org> Tue, 28 Nov 2006 23:13:14 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 29 Nov 2006 02:32:51 +0100

 net/ipv4/netfilter/ip_conntrack_netlink.c |    8 +++++---
 net/netfilter/nf_conntrack_netlink.c      |    8 +++++---
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index 3d277aa..d5d2efd 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -945,9 +945,11 @@ ctnetlink_create_conntrack(struct nfattr
 	ct->timeout.expires = jiffies + ct->timeout.expires * HZ;
 	ct->status |= IPS_CONFIRMED;
 
-	err = ctnetlink_change_status(ct, cda);
-	if (err < 0)
-		goto err;
+	if (cda[CTA_STATUS-1]) {
+		err = ctnetlink_change_status(ct, cda);
+		if (err < 0)
+			goto err;
+	}
 
 	if (cda[CTA_PROTOINFO-1]) {
 		err = ctnetlink_change_protoinfo(ct, cda);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 7357b8f..ba77183 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -963,9 +963,11 @@ ctnetlink_create_conntrack(struct nfattr
 	ct->timeout.expires = jiffies + ct->timeout.expires * HZ;
 	ct->status |= IPS_CONFIRMED;
 
-	err = ctnetlink_change_status(ct, cda);
-	if (err < 0)
-		goto err;
+	if (cda[CTA_STATUS-1]) {
+		err = ctnetlink_change_status(ct, cda);
+		if (err < 0)
+			goto err;
+	}
 
 	if (cda[CTA_PROTOINFO-1]) {
 		err = ctnetlink_change_protoinfo(ct, cda);
