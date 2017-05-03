From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 04/16] netfilter: nft_set_bitmap: free dummy elements when destroy the set
Date: Wed,  3 May 2017 11:31:59 +0200
Message-ID: <1493803931-2837-5-git-send-email-pablo@netfilter.org>
References: <1493803931-2837-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1493803931-2837-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Liping Zhang <zlpnobody@gmail.com>

We forget to free dummy elements when deleting the set. So when I was
running nft-test.py, I saw many kmemleak warnings:
  kmemleak: 1344 new suspected memory leaks ...
  # cat /sys/kernel/debug/kmemleak
  unreferenced object 0xffff8800631345c8 (size 32):
  comm "nft", pid 9075, jiffies 4295743309 (age 1354.815s)
  hex dump (first 32 bytes):
    f8 63 13 63 00 88 ff ff 88 79 13 63 00 88 ff ff  .c.c.....y.c....
    04 0c 00 00 00 00 00 00 00 00 00 00 08 03 00 00  ................
  backtrace:
    [<ffffffff819059da>] kmemleak_alloc+0x4a/0xa0
    [<ffffffff81288174>] __kmalloc+0x164/0x310
    [<ffffffffa061269d>] nft_set_elem_init+0x3d/0x1b0 [nf_tables]
    [<ffffffffa06130da>] nft_add_set_elem+0x45a/0x8c0 [nf_tables]
    [<ffffffffa0613645>] nf_tables_newsetelem+0x105/0x1d0 [nf_tables]
    [<ffffffffa05fe6d4>] nfnetlink_rcv+0x414/0x770 [nfnetlink]
    [<ffffffff817f0ca6>] netlink_unicast+0x1f6/0x310
    [<ffffffff817f10c6>] netlink_sendmsg+0x306/0x3b0
  ...

Fixes: e920dde516088 ("netfilter: nft_set_bitmap: keep a list of dummy elements")
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_bitmap.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index 8ebbc2940f4c..b988162b5b15 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -257,6 +257,11 @@ static int nft_bitmap_init(const struct nft_set *set,
 
 static void nft_bitmap_destroy(const struct nft_set *set)
 {
+	struct nft_bitmap *priv = nft_set_priv(set);
+	struct nft_bitmap_elem *be, *n;
+
+	list_for_each_entry_safe(be, n, &priv->list, head)
+		nft_set_elem_destroy(set, be, true);
 }
 
 static bool nft_bitmap_estimate(const struct nft_set_desc *desc, u32 features,
-- 
2.1.4
