Return-Path: <SRS0=LKiS=YY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A980CA9EC3
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 10:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65BC020862
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 10:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfJaKpp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Oct 2019 06:45:45 -0400
Received: from bmailout1.hostsharing.net ([83.223.95.100]:57989 "EHLO
        bmailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726922AbfJaKpo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Oct 2019 06:45:44 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id 84305300002D8;
        Thu, 31 Oct 2019 11:45:42 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 5C25EEDB; Thu, 31 Oct 2019 11:45:42 +0100 (CET)
Date:   Thu, 31 Oct 2019 11:45:42 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: Align nft_expr private data to
 64-bit
Message-ID: <20191031104542.3pu222n2wlpkhygw@wunner.de>
References: <cd8564ffa3d8254cce8995c95c218a56a6bd8797.1572516054.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd8564ffa3d8254cce8995c95c218a56a6bd8797.1572516054.git.lukas@wunner.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 31, 2019 at 11:06:24AM +0100, Lukas Wunner wrote:
> Invoking the following commands on a 32-bit architecture with strict
> alignment requirements (such as an ARMv7-based Raspberry Pi) results
> in an alignment exception:

Ugh, looks like "git commit" ate the commands as they were prefixed by a
hash mark (i.e. intended for execution as root):

# nft add table ip test-ip4
# nft add chain ip test-ip4 output { type filter hook output priority 0; }
# nft add rule  ip test-ip4 output quota 1025 bytes


> Alignment trap: not handling instruction e1b26f9f at [<7f4473f8>]
> Unhandled fault: alignment exception (0x001) at 0xb832e824
> Internal error: : 1 [#1] PREEMPT SMP ARM
> Hardware name: BCM2835
> [<7f4473fc>] (nft_quota_do_init [nft_quota])
> [<7f447448>] (nft_quota_init [nft_quota])
> [<7f4260d0>] (nf_tables_newrule [nf_tables])
> [<7f4168dc>] (nfnetlink_rcv_batch [nfnetlink])
> [<7f416bd0>] (nfnetlink_rcv [nfnetlink])
> [<8078b334>] (netlink_unicast)
> [<8078b664>] (netlink_sendmsg)
> [<8071b47c>] (sock_sendmsg)
> [<8071bd18>] (___sys_sendmsg)
> [<8071ce3c>] (__sys_sendmsg)
> [<8071ce94>] (sys_sendmsg)
> 
> The reason is that nft_quota_do_init() calls atomic64_set() on an
> atomic64_t which is only aligned to 32-bit, not 64-bit, because it
> succeeds struct nft_expr in memory which only contains a 32-bit pointer.
> Fix by aligning the nft_expr private data to 64-bit.
> 
> Fixes: 96518518cc41 ("netfilter: add nftables")
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Cc: stable@vger.kernel.org # v3.13+
> ---
>  include/net/netfilter/nf_tables.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index 001d294..2d0275f 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -820,7 +820,8 @@ struct nft_expr_ops {
>   */
>  struct nft_expr {
>  	const struct nft_expr_ops	*ops;
> -	unsigned char			data[];
> +	unsigned char			data[]
> +		__attribute__((aligned(__alignof__(u64))));
>  };
>  
>  static inline void *nft_expr_priv(const struct nft_expr *expr)
> -- 
> 2.20.1
