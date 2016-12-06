From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] netfilter: nft_payload: layer 4 checksum adjustment for
 pseudoheader fields
Date: Tue, 6 Dec 2016 14:57:34 +0300
Message-ID: <20161206115734.GA30548@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31014 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751225AbcLFMGC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Dec 2016 07:06:02 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Pablo Neira Ayuso,

The patch 556c291b3a1b: "netfilter: nft_payload: layer 4 checksum
adjustment for pseudoheader fields" from Nov 24, 2016, leads to the
following static checker warning:

	net/netfilter/nft_payload.c:301 nft_payload_set_eval()
	error: uninitialized symbol 'fsum'.

net/netfilter/nft_payload.c
   253  static void nft_payload_set_eval(const struct nft_expr *expr,
   254                                   struct nft_regs *regs,
   255                                   const struct nft_pktinfo *pkt)
   256  {
   257          const struct nft_payload_set *priv = nft_expr_priv(expr);
   258          struct sk_buff *skb = pkt->skb;
   259          const u32 *src = &regs->data[priv->sreg];
   260          int offset, csum_offset;
   261          __wsum fsum, tsum;
   262          __sum16 sum;
   263  
   264          switch (priv->base) {
   265          case NFT_PAYLOAD_LL_HEADER:
   266                  if (!skb_mac_header_was_set(skb))
   267                          goto err;
   268                  offset = skb_mac_header(skb) - skb->data;
   269                  break;
   270          case NFT_PAYLOAD_NETWORK_HEADER:
   271                  offset = skb_network_offset(skb);
   272                  break;
   273          case NFT_PAYLOAD_TRANSPORT_HEADER:
   274                  if (!pkt->tprot_set)
   275                          goto err;
   276                  offset = pkt->xt.thoff;
   277                  break;
   278          default:
   279                  BUG();
   280          }
   281  
   282          csum_offset = offset + priv->csum_offset;
   283          offset += priv->offset;
   284  
   285          if (priv->csum_type == NFT_PAYLOAD_CSUM_INET &&
   286              (priv->base != NFT_PAYLOAD_TRANSPORT_HEADER ||
   287               skb->ip_summed != CHECKSUM_PARTIAL)) {
   288                  if (skb_copy_bits(skb, csum_offset, &sum, sizeof(sum)) < 0)
   289                          goto err;
   290  
   291                  fsum = skb_checksum(skb, offset, priv->len, 0);

fsum is only set inside this if statement.

   292                  tsum = csum_partial(src, priv->len, 0);
   293                  nft_csum_replace(&sum, fsum, tsum);
   294  
   295                  if (!skb_make_writable(skb, csum_offset + sizeof(sum)) ||
   296                      skb_store_bits(skb, csum_offset, &sum, sizeof(sum)) < 0)
   297                          goto err;
   298          }
   299  
   300          if (priv->csum_flags &&
   301              nft_payload_l4csum_update(pkt, skb, fsum, tsum) < 0)

but we use it here.  I don't know for sure this is a bug...

   302                  goto err;
   303  
   304          if (!skb_make_writable(skb, max(offset + priv->len, 0)) ||
   305              skb_store_bits(skb, offset, src, priv->len) < 0)
   306                  goto err;
   307  
   308          return;
   309  err:
   310          regs->verdict.code = NFT_BREAK;
   311  }

regards,
dan carpenter
