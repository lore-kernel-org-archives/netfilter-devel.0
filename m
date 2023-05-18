Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD5DFC7EE23
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 May 2023 14:32:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjEROc3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 May 2023 10:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbjEROc1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 May 2023 10:32:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F0510E2
        for <netfilter-devel@vger.kernel.org>; Thu, 18 May 2023 07:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684420301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XhIL21LzUoVfHh+njWH6kdOQxRzFQazjn9MPQzOldvg=;
        b=OUda/NWDNUju+bwTwa+1ul18TSWDlv2Op622kv6gPjksDVRGP9kHwCXFkP/ithF8FqbS1M
        UCJJFlAwg1bn+Z5OkaClwz9sdqC0kT8OZp2RjwbEtU14+ZL/1G+ymRdzllb95zeg/qMDG1
        +6TUDFg+ZB4vuYsPFPUnTy2iTam5nW4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-52-eVLMWoRQP5uj7yWq7wpbHQ-1; Thu, 18 May 2023 10:31:38 -0400
X-MC-Unique: eVLMWoRQP5uj7yWq7wpbHQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50E5E281294F;
        Thu, 18 May 2023 14:31:38 +0000 (UTC)
Received: from localhost (unknown [10.22.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C1C4492C13;
        Thu, 18 May 2023 14:31:37 +0000 (UTC)
Date:   Thu, 18 May 2023 10:31:36 -0400
From:   Eric Garver <eric@garver.life>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, phil@nwl.cc
Subject: Re: [PATCH nft] evaluate: set NFT_SET_EVAL flag if dynamic set
 already exists
Message-ID: <ZGY2yOm-GVyMwnRL@egarver-thinkpadt14sgen1.remote.csb>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, phil@nwl.cc
References: <20230518125806.11100-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518125806.11100-1-pablo@netfilter.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 18, 2023 at 02:58:06PM +0200, Pablo Neira Ayuso wrote:
>  # cat test.nft
>  table ip test {
>         set dlist {
>                 type ipv4_addr
>                 size 65535
>         }
> 
>         chain output {
>                 type filter hook output priority filter; policy accept;
>                 udp dport 1234 update @dlist { ip daddr } counter packets 0 bytes 0
>         }
>  }
>  # nft -f test.nft
>  # nft -f test.nft
>  test.nft:2:6-10: Error: Could not process rule: File exists
>          set dlist {
>              ^^^^^
> 
> Phil Sutter says:
> 
> In the first call, the set lacking 'dynamic' flag does not exist
> and is therefore added to the cache. Consequently, both the 'add set'
> command and the set statement point at the same set object. In the
> second call, a set with same name exists already, so the object created
> for 'add set' command is not added to cache and consequently not updated
> with the missing flag. The kernel thus rejects the NEWSET request as the
> existing set differs from the new one.
> 
> Set on the NFT_SET_EVAL flag if the existing set sets it on.
> 
> Fixes: 8d443adfcc8c1 ("evaluate: attempt to set_eval flag if dynamic updates requested")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> Hi Phil,
> 
> Maybe this fix so there is no need for revert?
> 
>  src/evaluate.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 63e3e4147a40..09ad4ea19409 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -4516,6 +4516,14 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
>  		existing_set = set_cache_find(table, set->handle.set.name);
>  		if (!existing_set)
>  			set_cache_add(set_get(set), table);
> +
> +		if (existing_set && existing_set->flags & NFT_SET_EVAL) {
> +			uint32_t existing_flags = existing_set->flags & ~NFT_SET_EVAL;
> +			uint32_t new_flags = set->flags & ~NFT_SET_EVAL;
> +
> +			if (existing_flags == new_flags)
> +				set->flags |= NFT_SET_EVAL;
> +		}
>  	}
>  
>  	if (!(set->flags & NFT_SET_INTERVAL) && set->automerge)
> -- 
> 2.30.2

Tested-by: Eric Garver <eric@garver.life>

Thanks Pablo! This fixes the issue for me. Verified with my reproducer
[1].

[1]: https://bugzilla.redhat.com/show_bug.cgi?id=2177667#c2

