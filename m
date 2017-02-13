From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] netfilter: nft_ct: add zone id set support
Date: Mon, 13 Feb 2017 22:13:54 +0300
Message-ID: <20170213191354.GA5325@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21912 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751712AbdBMTOQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Feb 2017 14:14:16 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Florian Westphal,

The patch edee4f1e9245: "netfilter: nft_ct: add zone id set support"
from Feb 3, 2017, leads to the following static checker warning:

	net/netfilter/nft_ct.c:549 nft_ct_set_init()
	error: uninitialized symbol 'len'.

net/netfilter/nft_ct.c
   498  static int nft_ct_set_init(const struct nft_ctx *ctx,
   499                             const struct nft_expr *expr,
   500                             const struct nlattr * const tb[])
   501  {
   502          struct nft_ct *priv = nft_expr_priv(expr);
   503          unsigned int len;
                ^^^^^^^^^^^^^^^^

   504          int err;
   505  
   506          priv->dir = IP_CT_DIR_MAX;
   507          priv->key = ntohl(nla_get_be32(tb[NFTA_CT_KEY]));
   508          switch (priv->key) {
   509  #ifdef CONFIG_NF_CONNTRACK_MARK
   510          case NFT_CT_MARK:
   511                  if (tb[NFTA_CT_DIRECTION])
   512                          return -EINVAL;
   513                  len = FIELD_SIZEOF(struct nf_conn, mark);
   514                  break;
   515  #endif
   516  #ifdef CONFIG_NF_CONNTRACK_LABELS
   517          case NFT_CT_LABELS:
   518                  if (tb[NFTA_CT_DIRECTION])
   519                          return -EINVAL;
   520                  len = NF_CT_LABELS_MAX_SIZE;
   521                  err = nf_connlabels_get(ctx->net, (len * BITS_PER_BYTE) - 1);
   522                  if (err)
   523                          return err;
   524                  break;
   525  #endif
   526  #ifdef CONFIG_NF_CONNTRACK_ZONES
   527          case NFT_CT_ZONE:
                ^^^^^^^^^^^^^^^^
"len" not set for this case statement.

   528                  if (!nft_ct_tmpl_alloc_pcpu())
   529                          return -ENOMEM;
   530                  nft_ct_pcpu_template_refcnt++;
   531                  break;
   532  #endif
   533          default:
   534                  return -EOPNOTSUPP;
   535          }
   536  
   537          if (tb[NFTA_CT_DIRECTION]) {
   538                  priv->dir = nla_get_u8(tb[NFTA_CT_DIRECTION]);
   539                  switch (priv->dir) {
   540                  case IP_CT_DIR_ORIGINAL:
   541                  case IP_CT_DIR_REPLY:
   542                          break;
   543                  default:
   544                          return -EINVAL;
   545                  }
   546          }
   547  
   548          priv->sreg = nft_parse_register(tb[NFTA_CT_SREG]);
   549          err = nft_validate_register_load(priv->sreg, len);
                                                             ^^^
Which seems probably bad.

   550          if (err < 0)
   551                  goto err1;
   552  
   553          err = nft_ct_netns_get(ctx->net, ctx->afi->family);
   554          if (err < 0)
   555                  goto err1;

regards,
dan carpenter
