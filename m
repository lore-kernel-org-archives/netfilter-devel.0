Return-Path: <SRS0=YvWH=YU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 925DECA9EAF
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Oct 2019 10:33:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63A742067B
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Oct 2019 10:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfJ0KdP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 27 Oct 2019 06:33:15 -0400
Received: from mga06.intel.com ([134.134.136.31]:61847 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbfJ0KdO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Oct 2019 06:33:14 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Oct 2019 03:33:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,235,1569308400"; 
   d="scan'208";a="211172605"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 27 Oct 2019 03:33:12 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iOfrE-000If8-9w; Sun, 27 Oct 2019 18:33:12 +0800
Date:   Sun, 27 Oct 2019 18:32:43 +0800
From:   kbuild test robot <lkp@intel.com>
To:     wenxu@ucloud.cn
Cc:     kbuild-all@lists.01.org, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 2/5] netfilter: nft_tunnel: support
 NFT_TUNNEL_IPV4_SRC/DST match
Message-ID: <201910271840.MV2CnqwN%lkp@intel.com>
References: <1571913336-13431-3-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571913336-13431-3-git-send-email-wenxu@ucloud.cn>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on nf-next/master]

url:    https://github.com/0day-ci/linux/commits/wenxu-ucloud-cn/netfilter-nft_tunnel-support-tunnel-match-expr-offload/20191027-152013
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> net/netfilter/nft_tunnel.c:71:31: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] @@    got restrunsigned int [usertype] @@
>> net/netfilter/nft_tunnel.c:71:31: sparse:    expected unsigned int [usertype]
>> net/netfilter/nft_tunnel.c:71:31: sparse:    got restricted __be32 [usertype] src
   net/netfilter/nft_tunnel.c:81:31: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] @@    got restrunsigned int [usertype] @@
   net/netfilter/nft_tunnel.c:81:31: sparse:    expected unsigned int [usertype]
>> net/netfilter/nft_tunnel.c:81:31: sparse:    got restricted __be32 [usertype] dst
   net/netfilter/nft_tunnel.c:531:54: sparse: sparse: cast from restricted __be16
   net/netfilter/nft_tunnel.c:531:54: sparse: sparse: incorrect type in argument 1 (different base types) @@    expected unsigned short [usertype] val @@    got resunsigned short [usertype] val @@
   net/netfilter/nft_tunnel.c:531:54: sparse:    expected unsigned short [usertype] val
   net/netfilter/nft_tunnel.c:531:54: sparse:    got restricted __be16 [usertype] tp_src
   net/netfilter/nft_tunnel.c:531:54: sparse: sparse: cast from restricted __be16
   net/netfilter/nft_tunnel.c:531:54: sparse: sparse: cast from restricted __be16
   net/netfilter/nft_tunnel.c:532:54: sparse: sparse: cast from restricted __be16
   net/netfilter/nft_tunnel.c:532:54: sparse: sparse: incorrect type in argument 1 (different base types) @@    expected unsigned short [usertype] val @@    got resunsigned short [usertype] val @@
   net/netfilter/nft_tunnel.c:532:54: sparse:    expected unsigned short [usertype] val
   net/netfilter/nft_tunnel.c:532:54: sparse:    got restricted __be16 [usertype] tp_dst
   net/netfilter/nft_tunnel.c:532:54: sparse: sparse: cast from restricted __be16
   net/netfilter/nft_tunnel.c:532:54: sparse: sparse: cast from restricted __be16

vim +71 net/netfilter/nft_tunnel.c

    33	
    34	static void nft_tunnel_get_eval(const struct nft_expr *expr,
    35					struct nft_regs *regs,
    36					const struct nft_pktinfo *pkt)
    37	{
    38		const struct nft_tunnel *priv = nft_expr_priv(expr);
    39		u32 *dest = &regs->data[priv->dreg];
    40		struct ip_tunnel_info *tun_info;
    41	
    42		tun_info = skb_tunnel_info(pkt->skb);
    43	
    44		switch (priv->key) {
    45		case NFT_TUNNEL_PATH:
    46			if (!tun_info) {
    47				nft_reg_store8(dest, false);
    48				return;
    49			}
    50			if (nft_tunnel_mode_validate(priv->mode, tun_info->mode))
    51				nft_reg_store8(dest, true);
    52			else
    53				nft_reg_store8(dest, false);
    54			break;
    55		case NFT_TUNNEL_ID:
    56			if (!tun_info) {
    57				regs->verdict.code = NFT_BREAK;
    58				return;
    59			}
    60			if (nft_tunnel_mode_validate(priv->mode, tun_info->mode))
    61				*dest = ntohl(tunnel_id_to_key32(tun_info->key.tun_id));
    62			else
    63				regs->verdict.code = NFT_BREAK;
    64			break;
    65		case NFT_TUNNEL_IPV4_SRC:
    66			if (!tun_info) {
    67				regs->verdict.code = NFT_BREAK;
    68				return;
    69			}
    70			if (nft_tunnel_mode_validate(priv->mode, tun_info->mode))
  > 71				*dest = tun_info->key.u.ipv4.src;
    72			else
    73				regs->verdict.code = NFT_BREAK;
    74			break;
    75		case NFT_TUNNEL_IPV4_DST:
    76			if (!tun_info) {
    77				regs->verdict.code = NFT_BREAK;
    78				return;
    79			}
    80			if (nft_tunnel_mode_validate(priv->mode, tun_info->mode))
  > 81				*dest = tun_info->key.u.ipv4.dst;
    82			else
    83				regs->verdict.code = NFT_BREAK;
    84			break;
    85		default:
    86			WARN_ON(1);
    87			regs->verdict.code = NFT_BREAK;
    88		}
    89	}
    90	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
