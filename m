From: Piyush Pangtey <gokuvsvegita@gmail.com>
Subject: Re: [RFC] nft: Remove memory-leak
Date: Mon, 14 Mar 2016 14:18:57 +0530
Message-ID: <56E67AF9.1030105@gmail.com>
References: <20160313120843.GA6919@fate> <20160313202256.GD1548@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:34896 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315AbcCNIsn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Mar 2016 04:48:43 -0400
Received: by mail-pf0-f175.google.com with SMTP id n5so93462775pfn.2
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Mar 2016 01:48:42 -0700 (PDT)
In-Reply-To: <20160313202256.GD1548@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 14 March 2016 01:52 AM, Florian Westphal wrote:
> Piyush Pangtey <gokuvsvegita@gmail.com> wrote:
>> Memory leak due to the absence of matching free :
>> ==4797== 189 bytes in 27 blocks are definitely lost in loss record 22 of 51
>> ==4797==    at 0x4C2AB80: malloc (in
>> /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
>> ==4797==    by 0x57A3839: strdup (strdup.c:42)
>> ==4797==    by 0x41C00D: xstrdup (utils.c:64)
>> ==4797==    by 0x411E4B: netlink_delinearize_chain.isra.3 (netlink.c:717)
>> ==4797==    by 0x411F20: list_chain_cb (netlink.c:748)
>> ==4797==    by 0x504A943: nft_chain_list_foreach (chain.c:1015)
>> ==4797==    by 0x41455E: netlink_list_chains (netlink.c:771)
>> ==4797==    by 0x4078EF: cache_init_objects (rule.c:90)
>> ==4797==    by 0x4078EF: cache_init (rule.c:130)
>> ==4797==    by 0x4078EF: cache_update (rule.c:147)
>> ==4797==    by 0x40FB09: cmd_evaluate (evaluate.c:2475)
>> ==4797==    by 0x4296BC: nft_parse (parser_bison.y:655)
>> ==4797==    by 0x4064CC: nft_run (main.c:231)
>> ==4797==    by 0x42CE57: cli_complete (cli.c:124)
> ..
>> --- a/src/netlink.c
>> +++ b/src/netlink.c
>> @@ -714,12 +714,12 @@ static struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
>>  		chain->priority      =
>>  			nftnl_chain_get_s32(nlc, NFTNL_CHAIN_PRIO);
>>  		chain->type          =
>> -			xstrdup(nftnl_chain_get_str(nlc, NFTNL_CHAIN_TYPE));
>> +			nftnl_chain_get_str(nlc, NFTNL_CHAIN_TYPE);
> 
> This looks wrong, nlc lifetime is not tied to chain object.
> Seems chain_free() needs xfree calls for type and ->dev ?
> 

Yes.Thanks for commenting.
I tried this as a workaround, because I was not sure about nlc :).
I sent a patch for adding matching free calls to chain_free().
