Return-Path: <SRS0=p03Y=VS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D603DC76191
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 18:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B723A2084C
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 18:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbfGUStH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Jul 2019 14:49:07 -0400
Received: from mail.us.es ([193.147.175.20]:43782 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726905AbfGUStH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Jul 2019 14:49:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7B584DA702
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Jul 2019 20:49:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6AFD81150B9
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Jul 2019 20:49:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6066EDA704; Sun, 21 Jul 2019 20:49:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 25A31DA732;
        Sun, 21 Jul 2019 20:49:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 21 Jul 2019 20:49:03 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.214.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E68ED4265A31;
        Sun, 21 Jul 2019 20:49:02 +0200 (CEST)
Date:   Sun, 21 Jul 2019 20:49:01 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 3/3] src: evaluate: return immediately if no op was
 requested
Message-ID: <20190721184901.n5ea7kpn246bddnb@salvia>
References: <20190721001406.23785-1-fw@strlen.de>
 <20190721001406.23785-4-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190721001406.23785-4-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jul 21, 2019 at 02:14:07AM +0200, Florian Westphal wrote:
> This makes nft behave like 0.9.0 -- the ruleset
> 
> flush ruleset
> table inet filter {
> }
> table inet filter {
>       chain test {
>         counter
>     }
> }
> 
> loads again without generating an error message.
> I've added a test case for this, without this it will create an error,
> and with a checkout of the 'fixes' tag we get crash.
> 
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1351
> Fixes: e5382c0d08e3c ("src: Support intra-transaction rule references")

This one is causing the cache corruption, right?

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/evaluate.c                                  |  3 +++
>  tests/shell/testcases/cache/0003_cache_update_0 | 12 ++++++++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index b56932ccabcc..8c1c82abed4e 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -3258,6 +3258,9 @@ static int rule_cache_update(struct eval_ctx *ctx, enum cmd_ops op)
>  	struct table *table;
>  	struct chain *chain;
>  
> +	if (op == CMD_INVALID)
> +		return 0;
> +
>  	table = table_lookup(&rule->handle, &ctx->nft->cache);
>  	if (!table)
>  		return table_not_found(ctx);
> diff --git a/tests/shell/testcases/cache/0003_cache_update_0 b/tests/shell/testcases/cache/0003_cache_update_0
> index 05edc9c7c33e..fb4b0e24c790 100755
> --- a/tests/shell/testcases/cache/0003_cache_update_0
> +++ b/tests/shell/testcases/cache/0003_cache_update_0
> @@ -48,3 +48,15 @@ $NFT -f - >/dev/null <<EOF
>  add rule ip t4 c meta l4proto igmp accept
>  add rule ip t4 c index 2 drop
>  EOF
> +
> +# Trigger a crash or rule restore error with nft 0.9.1
> +$NFT -f - >/dev/null <<EOF
> +flush ruleset
> +table inet testfilter {
> +}
> +table inet testfilter {
> +      chain test {
> +        counter
> +    }
> +}
> +EOF
> -- 
> 2.21.0
> 
