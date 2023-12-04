Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819AFA8
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Dec 2023 03:30:08 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rA79J-0007VN-1j; Mon, 04 Dec 2023 12:30:05 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH nf] netfilter: nf_tables: fix 'exist' matching on bigendian arches
Date: Mon,  4 Dec 2023 12:29:54 +0100
Message-ID: <20231204112958.10706-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Maze reports "tcp option fastopen exists" fails to match on
OpenWrt 22.03.5, r20134-5f15225c1e (5.10.176) router.

"tcp option fastopen exists" translates to:
inet
  [ exthdr load tcpopt 1b @ 34 + 0 present => reg 1 ]
  [ cmp eq reg 1 0x00000001 ]

.. but existing nft userspace generates a 1-byte compare.

On LSB (x86), "*reg32 = 1" is identical to nft_reg_store8(reg32, 1), but
not on MSB, which will place the 1 last. IOW, on bigendian aches the cmp8
is awalys false.

Make sure we store this in a consistent fashion, so existing userspace
will also work on MSB (bigendian).

Regardless of this patch we can also change nft userspace to generate
'reg32 == 0' and 'reg32 != 0' instead of u8 == 0 // u8 == 1 when
adding 'option x missing/exists' expressions as well.

Fixes: 3c1fece8819e ("netfilter: nft_exthdr: Allow checking TCP option presence, too")
Fixes: b9f9a485fb0e ("netfilter: nft_exthdr: add boolean DCCP option matching")
Fixes: 055c4b34b94f ("netfilter: nft_fib: Support existence check")
Reported-by: Maciej Żenczykowski <zenczykowski@gmail.com>
Closes: https://lore.kernel.org/netfilter-devel/CAHo-OozyEqHUjL2-ntATzeZOiuftLWZ_HU6TOM_js4qLfDEAJg@mail.gmail.com/
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_exthdr.c | 4 ++--
 net/netfilter/nft_fib.c    | 8 ++++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 3fbaa7bf41f9..6eb571d0c3fd 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -214,7 +214,7 @@ static void nft_exthdr_tcp_eval(const struct nft_expr *expr,
 
 		offset = i + priv->offset;
 		if (priv->flags & NFT_EXTHDR_F_PRESENT) {
-			*dest = 1;
+			nft_reg_store8(dest, 1);
 		} else {
 			if (priv->len % NFT_REG32_SIZE)
 				dest[priv->len / NFT_REG32_SIZE] = 0;
@@ -461,7 +461,7 @@ static void nft_exthdr_dccp_eval(const struct nft_expr *expr,
 		type = bufp[0];
 
 		if (type == priv->type) {
-			*dest = 1;
+			nft_reg_store8(dest, 1);
 			return;
 		}
 
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index 1bfe258018da..37cfe6dd712d 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -145,11 +145,15 @@ void nft_fib_store_result(void *reg, const struct nft_fib *priv,
 	switch (priv->result) {
 	case NFT_FIB_RESULT_OIF:
 		index = dev ? dev->ifindex : 0;
-		*dreg = (priv->flags & NFTA_FIB_F_PRESENT) ? !!index : index;
+		if (priv->flags & NFTA_FIB_F_PRESENT)
+			nft_reg_store8(dreg, !!index);
+		else
+			*dreg = index;
+
 		break;
 	case NFT_FIB_RESULT_OIFNAME:
 		if (priv->flags & NFTA_FIB_F_PRESENT)
-			*dreg = !!dev;
+			nft_reg_store8(dreg, !!dev);
 		else
 			strscpy_pad(reg, dev ? dev->name : "", IFNAMSIZ);
 		break;
-- 
2.41.0

