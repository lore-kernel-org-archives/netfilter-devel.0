From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: netfilter: nft_reject: introduce icmp code abstraction for inet
 and bridge
Date: Tue, 7 Oct 2014 17:26:51 +0300
Message-ID: <20141007142651.GA29598@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20746 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaJGO1H (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:27:07 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Pablo Neira Ayuso,

The patch 51b0a5d8c21a: "netfilter: nft_reject: introduce icmp code
abstraction for inet and bridge" from Sep 26, 2014, leads to the
following static checker warning:

	net/netfilter/nft_reject.c:87 nft_reject_icmp_code()
	error: buffer overflow 'icmp_code_v4' 5 <= 5

net/netfilter/nft_reject.c
    75  static u8 icmp_code_v4[NFT_REJECT_ICMPX_MAX] = {
    76          [NFT_REJECT_ICMPX_NO_ROUTE]             = ICMP_NET_UNREACH,
    77          [NFT_REJECT_ICMPX_PORT_UNREACH]         = ICMP_PORT_UNREACH,
    78          [NFT_REJECT_ICMPX_HOST_UNREACH]         = ICMP_HOST_UNREACH,
    79          [NFT_REJECT_ICMPX_ADMIN_PROHIBITED]     = ICMP_PKT_FILTERED,
    80  };
    81  
    82  int nft_reject_icmp_code(u8 code)
    83  {
    84          if (code > NFT_REJECT_ICMPX_MAX)
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^
Obviously this should be >= instead of >, but I also had a question
about NFT_REJECT_ICMPX_MAX.

#define NFT_REJECT_ICMPX_MAX   (__NFT_REJECT_ICMPX_MAX + 1)

__NFT_REJECT_ICMPX_MAX is already plus one so it feels like
NFT_REJECT_ICMPX_MAX is one higher than needed.  (But it also has been a
long day and I'm no longer sure I know how to add 1 + 4).

    85                  return -EINVAL;
    86  
    87          return icmp_code_v4[code];
    88  }
    89  
    90  EXPORT_SYMBOL_GPL(nft_reject_icmp_code);
    91  
    92  
    93  static u8 icmp_code_v6[NFT_REJECT_ICMPX_MAX] = {
    94          [NFT_REJECT_ICMPX_NO_ROUTE]             = ICMPV6_NOROUTE,
    95          [NFT_REJECT_ICMPX_PORT_UNREACH]         = ICMPV6_PORT_UNREACH,
    96          [NFT_REJECT_ICMPX_HOST_UNREACH]         = ICMPV6_ADDR_UNREACH,
    97          [NFT_REJECT_ICMPX_ADMIN_PROHIBITED]     = ICMPV6_ADM_PROHIBITED,
    98  };
    99  
   100  int nft_reject_icmpv6_code(u8 code)
   101  {
   102          if (code > NFT_REJECT_ICMPX_MAX)
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^
Same thing.

   103                  return -EINVAL;
   104  
   105          return icmp_code_v6[code];
   106  }

regards,
dan carpenter
