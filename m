From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: Fix nf_conntrack compilation with
	CONFIG_NETFILTER_DEBUG
Date: Thu, 17 Nov 2005 04:23:51 +0100
Message-ID: <437BF7C7.4030900@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="x"
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

[NETFILTER]: Fix nf_conntrack compilation with CONFIG_NETFILTER_DEBUG

CC [M]  net/netfilter/nf_conntrack_core.o
net/netfilter/nf_conntrack_core.c: In function 'nf_ct_unlink_expect':
net/netfilter/nf_conntrack_core.c:390: error: 'exp_timeout' undeclared (first use in this function)
net/netfilter/nf_conntrack_core.c:390: error: (Each undeclared identifier is reported only once
net/netfilter/nf_conntrack_core.c:390: error: for each function it appears in.)

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 666e7efd137d0751f27e7305a719349b5324cc0e
tree 675a8ce7c9c8fd0b9e5a9569122d4fd108da884e
parent f6ff56cd56b83d8edf4b3cffc5c53c56b37a5081
author Patrick McHardy <kaber@trash.net> Thu, 17 Nov 2005 04:22:48 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 17 Nov 2005 04:22:48 +0100

 net/netfilter/nf_conntrack_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index ea094b2..1da6783 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -387,7 +387,7 @@ nf_ct_invert_tuple(struct nf_conntrack_t
 static void nf_ct_unlink_expect(struct nf_conntrack_expect *exp)
 {
 	ASSERT_WRITE_LOCK(&nf_conntrack_lock);
-	NF_CT_ASSERT(!timer_pending(&exp_timeout));
+	NF_CT_ASSERT(!timer_pending(&exp->timeout));
 	list_del(&exp->list);
 	NF_CT_STAT_INC(expect_delete);
 	exp->master->expecting--;
