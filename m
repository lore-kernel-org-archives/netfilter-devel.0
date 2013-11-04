From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: netfilter: nf_tables: add compatibility layer for x_tables
Date: Mon, 4 Nov 2013 15:58:00 +0300
Message-ID: <20131104125800.GA12213@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34058 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab3KDNBF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Nov 2013 08:01:05 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Pablo Neira Ayuso,

The patch 0ca743a55991: "netfilter: nf_tables: add compatibility 
layer for x_tables" from Oct 14, 2013, leads to the following Smatch
warning: "net/netfilter/nft_compat.c:140 nft_parse_compat()
	 warn: signedness bug returning '(-34)'"

net/netfilter/nft_compat.c
   131  static u8 nft_parse_compat(const struct nlattr *attr, bool *inv)
   132  {
   133          struct nlattr *tb[NFTA_RULE_COMPAT_MAX+1];
   134          u32 flags;
   135          int err;
   136  
   137          err = nla_parse_nested(tb, NFTA_RULE_COMPAT_MAX, attr,
   138                                 nft_rule_compat_policy);
   139          if (err < 0)
   140                  return err;
                        ^^^^^^^^^^
   141  
   142          if (!tb[NFTA_RULE_COMPAT_PROTO] || !tb[NFTA_RULE_COMPAT_FLAGS])
   143                  return -EINVAL;
                        ^^^^^^^^^^^^^^^
   144  
   145          flags = ntohl(nla_get_be32(tb[NFTA_RULE_COMPAT_FLAGS]));
   146          if (flags & ~NFT_RULE_COMPAT_F_MASK)
   147                  return -EINVAL;
                        ^^^^^^^^^^^^^^^

   148          if (flags & NFT_RULE_COMPAT_F_INV)
   149                  *inv = true;
   150  
   151          return ntohl(nla_get_be32(tb[NFTA_RULE_COMPAT_PROTO]));
   152  }

This function returns error codes but the return type is u8 so the error
codes are transformed into small positive values.  The callers don't
check the return.

regards,
dan carpenter

