From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC] nft: Remove memory-leak
Date: Sun, 13 Mar 2016 21:22:56 +0100
Message-ID: <20160313202256.GD1548@breakpoint.cc>
References: <20160313120843.GA6919@fate>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Piyush Pangtey <gokuvsvegita@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:48932 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754300AbcCMUW7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Mar 2016 16:22:59 -0400
Content-Disposition: inline
In-Reply-To: <20160313120843.GA6919@fate>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Piyush Pangtey <gokuvsvegita@gmail.com> wrote:
> Memory leak due to the absence of matching free :
> ==4797== 189 bytes in 27 blocks are definitely lost in loss record 22 of 51
> ==4797==    at 0x4C2AB80: malloc (in
> /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
> ==4797==    by 0x57A3839: strdup (strdup.c:42)
> ==4797==    by 0x41C00D: xstrdup (utils.c:64)
> ==4797==    by 0x411E4B: netlink_delinearize_chain.isra.3 (netlink.c:717)
> ==4797==    by 0x411F20: list_chain_cb (netlink.c:748)
> ==4797==    by 0x504A943: nft_chain_list_foreach (chain.c:1015)
> ==4797==    by 0x41455E: netlink_list_chains (netlink.c:771)
> ==4797==    by 0x4078EF: cache_init_objects (rule.c:90)
> ==4797==    by 0x4078EF: cache_init (rule.c:130)
> ==4797==    by 0x4078EF: cache_update (rule.c:147)
> ==4797==    by 0x40FB09: cmd_evaluate (evaluate.c:2475)
> ==4797==    by 0x4296BC: nft_parse (parser_bison.y:655)
> ==4797==    by 0x4064CC: nft_run (main.c:231)
> ==4797==    by 0x42CE57: cli_complete (cli.c:124)
..
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -714,12 +714,12 @@ static struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
>  		chain->priority      =
>  			nftnl_chain_get_s32(nlc, NFTNL_CHAIN_PRIO);
>  		chain->type          =
> -			xstrdup(nftnl_chain_get_str(nlc, NFTNL_CHAIN_TYPE));
> +			nftnl_chain_get_str(nlc, NFTNL_CHAIN_TYPE);

This looks wrong, nlc lifetime is not tied to chain object.
Seems chain_free() needs xfree calls for type and ->dev ?
