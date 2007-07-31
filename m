From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: [PATCH 58] net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c:
	kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 23:32:04 +0200
Message-ID: <200707312332.05176.m.kozlowski@tuxland.pl>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	netfilter-devel@lists.netfilter.org,
	kernel-janitors@vger.kernel.org, coreteam@netfilter.org
To: linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
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

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c | 10333 -> 10273 (-60 bytes)
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.o | 116092 -> 115996 (-96 bytes)

 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-2.6.23-rc1-mm1-a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c	2007-07-26 13:07:44.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c	2007-07-31 15:18:28.000000000 +0200
@@ -294,15 +294,14 @@ static int exp_open(struct inode *inode,
 	struct ct_expect_iter_state *st;
 	int ret;

-	st = kmalloc(sizeof(struct ct_expect_iter_state), GFP_KERNEL);
-	if (st == NULL)
+	st = kzalloc(sizeof(struct ct_expect_iter_state), GFP_KERNEL);
+	if (!st)
 		return -ENOMEM;
 	ret = seq_open(file, &exp_seq_ops);
 	if (ret)
 		goto out_free;
 	seq          = file->private_data;
 	seq->private = st;
-	memset(st, 0, sizeof(struct ct_expect_iter_state));
 	return ret;
 out_free:
 	kfree(st);
