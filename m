Return-Path: <SRS0=6IYx=TT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60E72C04AB4
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 May 2019 17:10:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E247205ED
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 May 2019 17:10:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbfESRKU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 May 2019 13:10:20 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:33322 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbfESRKU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 May 2019 13:10:20 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hSOvs-0008Aq-B1; Sun, 19 May 2019 18:45:08 +0200
Date:   Sun, 19 May 2019 18:45:08 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH iptables 4/4] nft: keep old cache around until batch is
 refreshed in case of ERESTART
Message-ID: <20190519164508.GL4851@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20190519115121.32490-1-pablo@netfilter.org>
 <20190519115121.32490-4-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190519115121.32490-4-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Sun, May 19, 2019 at 01:51:21PM +0200, Pablo Neira Ayuso wrote:
> Phil Sutter says:
> 
> "The problem is that data in h->obj_list potentially sits in cache, too.
> At least rules have to be there so insert with index works correctly. If
> the cache is flushed before regenerating the batch, use-after-free
> occurs which crashes the program."
> 
> This patch keeps the old cache around until we have refreshed the batch.
> 
> Fixes: 862818ac3a0de ("xtables: add and use nft_build_cache")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> @Phil: I'd like to avoid the refcount infrastructure in libnftnl.

OK, then see below:

> Compile tested-only.

Please test it at least against
iptables/tests/shell/testcases/ipt-restore/0004-restore-race_0. You are
reworking a code-path which is hit only in rare cases, Florian did a
great job in creating something that triggers it.

My point is, I don't trust this code:

> diff --git a/iptables/nft.c b/iptables/nft.c
> index 14141bb7dbcf..51f05b6a6267 100644
> --- a/iptables/nft.c
> +++ b/iptables/nft.c
[...]
> @@ -2902,10 +2918,13 @@ retry:
>  	errno = 0;
>  	ret = mnl_batch_talk(h->nl, h->batch, &h->err_list);
>  	if (ret && errno == ERESTART) {
> -		nft_rebuild_cache(h);
> +		struct nft_cache *old_cache = nft_rebuild_cache(h);
>  
>  		nft_refresh_transaction(h);
>  
> +		if (old_cache)
> +			flush_cache(old_cache, h->tables, NULL);
> +

The call to flush_cache() should free objects referenced in batch jobs.
Note that nft_refresh_transaction() does not care about batch jobs'
payloads, it just toggles them on/off via 'skip' bit.

The only way to make the above work is by keeping the original cache
copy around until mnl_batch_talk has finally succeeded or failed with
something else than ERESTART.

Cheers, Phil
