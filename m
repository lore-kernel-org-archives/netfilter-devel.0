Return-Path: <SRS0=QEZg=T4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6D11C04AB6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 21:32:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C459F20657
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 21:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbfE1Vcq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 May 2019 17:32:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56150 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbfE1Vcq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 May 2019 17:32:46 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C79424CF7F;
        Tue, 28 May 2019 21:32:45 +0000 (UTC)
Received: from egarver.localdomain (ovpn-122-200.rdu2.redhat.com [10.10.122.200])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A8DA60BF1;
        Tue, 28 May 2019 21:32:45 +0000 (UTC)
Date:   Tue, 28 May 2019 17:32:44 -0400
From:   Eric Garver <eric@garver.life>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v4 1/7] src: Fix cache_flush() in cache_needs_more()
 logic
Message-ID: <20190528213244.teiqi7y7rxz5b5ri@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190528210323.14605-1-phil@nwl.cc>
 <20190528210323.14605-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528210323.14605-2-phil@nwl.cc>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 28 May 2019 21:32:45 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 28, 2019 at 11:03:17PM +0200, Phil Sutter wrote:
> Commit 34a20645d54fa enabled cache updates depending on command causing

Actual hash is eeda228c2d17. 

> it. As a side-effect, this disabled measures in cache_flush() preventing
> a later cache update. Re-establish this by setting cache->cmd in
> addition to cache->genid after dropping cache entries.
> 
> While being at it, set cache->cmd in cache_release() as well. This
> shouldn't be necessary since zeroing cache->genid should suffice for
> cache_update(), but better be consistent (and future-proof) here.
> 
> Fixes: 34a20645d54fa ("src: update cache if cmd is more specific")

Actual hash is eeda228c2d17. 

> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Changes since v1:
> - Adjust cache_release() as well, just to make sure.
> ---
>  src/rule.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/src/rule.c b/src/rule.c
> index 326edb5dd459a..966948cd7ae90 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -299,12 +299,15 @@ void cache_flush(struct nft_ctx *nft, enum cmd_ops cmd, struct list_head *msgs)
>  
>  	__cache_flush(&cache->list);
>  	cache->genid = mnl_genid_get(&ctx);
> +	cache->cmd = CMD_LIST;
>  }
>  
>  void cache_release(struct nft_cache *cache)
>  {
>  	__cache_flush(&cache->list);
>  	cache->genid = 0;
> +	cache->cmd = CMD_INVALID;
> +
>  }
>  
>  /* internal ID to uniquely identify a set in the batch */
> -- 
> 2.21.0

Otherwise looks good.
