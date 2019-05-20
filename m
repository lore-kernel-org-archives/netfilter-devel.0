Return-Path: <SRS0=v9tr=TU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3937C04AAC
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 12:42:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B83EF216FD
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 12:42:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390682AbfETMmQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 May 2019 08:42:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63495 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390124AbfETMmP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 May 2019 08:42:15 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 265E588306;
        Mon, 20 May 2019 12:42:14 +0000 (UTC)
Received: from egarver.localdomain (ovpn-122-94.rdu2.redhat.com [10.10.122.94])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D9E7F60CD1;
        Mon, 20 May 2019 12:42:09 +0000 (UTC)
Date:   Mon, 20 May 2019 08:42:07 -0400
From:   Eric Garver <eric@garver.life>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH 1/3] src: Improve cache_needs_more() algorithm
Message-ID: <20190520124207.sgdrzok6uqoupzzp@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20190517230033.25417-1-phil@nwl.cc>
 <20190517230033.25417-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517230033.25417-2-phil@nwl.cc>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Mon, 20 May 2019 12:42:14 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, May 18, 2019 at 01:00:31AM +0200, Phil Sutter wrote:
> The old logic wasn't optimal: If e.g. current command was CMD_RESET and
> old command was CMD_LIST, cache was already fully populated but still
> refreshed.
> 
> Introduce a simple scoring system which reflects how
> cache_init_objects() looks at the current command to decide if it is
> finished already or not. Then use that in cache_needs_more(): If current
> commands score is higher than old command's, cache needs an update.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  src/rule.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/src/rule.c b/src/rule.c
> index afe37cd90b1da..17bf5bbbe680c 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -220,13 +220,21 @@ static int cache_init(struct netlink_ctx *ctx, enum cmd_ops cmd)
>  	return 0;
>  }
>  
> -static int cache_needs_more(enum cmd_ops old_cmd, enum cmd_ops cmd)
> +/* Return a "score" of how complete local cache will be if
> + * cache_init_objects() ran for given cmd. Higher value
> + * means more complete. */
> +static int cache_completeness(enum cmd_ops cmd)
>  {
> -	if (cmd == CMD_LIST && old_cmd != CMD_LIST)
> -		return 1;
> -	if (cmd == CMD_RESET && old_cmd != CMD_RESET)
> -		return 1;
> -	return 0;
> +	if (cmd == CMD_LIST)
> +		return 3;
> +	if (cmd != CMD_RESET)
> +		return 2;
> +	return 1;
> +}
> +
> +static bool cache_needs_more(enum cmd_ops old_cmd, enum cmd_ops cmd)
> +{
> +	return cache_completeness(old_cmd) < cache_completeness(cmd);
>  }
>  
>  int cache_update(struct nft_ctx *nft, enum cmd_ops cmd, struct list_head *msgs)
> -- 
> 2.21.0

LGTM. Feel free to take my patch and fold it into this series.
