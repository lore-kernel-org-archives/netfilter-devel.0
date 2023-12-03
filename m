Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2627DE6
	for <netfilter-devel@vger.kernel.org>; Sun,  3 Dec 2023 05:13:47 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1r9mI4-0001sx-Lk; Sun, 03 Dec 2023 14:13:44 +0100
Date: Sun, 3 Dec 2023 14:13:44 +0100
From: Florian Westphal <fw@strlen.de>
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc: Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>
Subject: Re: does nft 'tcp option ... exists' work?
Message-ID: <20231203131344.GB5972@breakpoint.cc>
References: <CAHo-OozyEqHUjL2-ntATzeZOiuftLWZ_HU6TOM_js4qLfDEAJg@mail.gmail.com>
 <CAHo-Oow4CJGe-xfhweZWzWZ0kaJiwg7HOjKCU-r7HLV_TYGNLQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHo-Oow4CJGe-xfhweZWzWZ0kaJiwg7HOjKCU-r7HLV_TYGNLQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Maciej Żenczykowski <zenczykowski@gmail.com> wrote:
> FYI, I upgraded the router to OpenWrt 23.05.2 with 5.15.137 and it
> doesn't appear to have changed anything, ie. 'tcp option fastopen
> exists' still does not appear to match.
> 
> Also note that I'm putting this in table inet filter postrouting like
> below... but that shouldn't matter should it?

No, this is an endianess bug, on BE the compared byte is always 0.

I suspect this will fix it:

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
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
