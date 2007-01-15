From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/02]: ctnetlink: check for status attribute existence
	on conntrack creation
Date: Mon, 15 Jan 2007 10:28:27 +0100 (MET)
Message-ID: <20070115092826.23343.50962.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ctnetlink: check for status attribute existence on conntrack creation

Check that status flags are available in the netlink message received
to create a new conntrack.

Fixes a crash in ctnetlink_create_conntrack when the CTA_STATUS attribute
is not present.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 667fca411a3edaf30f98f3f7aaf0c1be8d0e7cc2
tree 0a0026ce63097bcb1c7bf6780cd89a21395b67ca
parent 3ac4e26b2cc43180661453851174f40a1292da09
author Pablo Neira Ayuso <pablo@netfilter.org> Mon, 15 Jan 2007 10:16:22 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 15 Jan 2007 10:16:22 +0100

 net/ipv4/netfilter/ip_conntrack_netlink.c |    8 +++++---
 net/netfilter/nf_conntrack_netlink.c      |    8 +++++---
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index 55f0ae6..39f23f4 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -946,9 +946,11 @@ ctnetlink_create_conntrack(struct nfattr
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
index ab67c2b..c650ccc 100644
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
