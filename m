Return-Path: <SRS0=iWGL=XA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4588C43331
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Sep 2019 20:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D340C2067B
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Sep 2019 20:44:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388260AbfIEUof (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Sep 2019 16:44:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52790 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387491AbfIEUof (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Sep 2019 16:44:35 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7DEF98372F2;
        Thu,  5 Sep 2019 20:44:34 +0000 (UTC)
Received: from egarver.localdomain (ovpn-122-8.rdu2.redhat.com [10.10.122.8])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CE3E5D9CA;
        Thu,  5 Sep 2019 20:44:33 +0000 (UTC)
Date:   Thu, 5 Sep 2019 16:44:32 -0400
From:   Eric Garver <eric@garver.life>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] cache: fix --echo with index/position
Message-ID: <20190905204432.h2nv4zs5ysxlxhnq@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190905170939.4132-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905170939.4132-1-pablo@netfilter.org>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Thu, 05 Sep 2019 20:44:34 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 05, 2019 at 07:09:39PM +0200, Pablo Neira Ayuso wrote:
> Check for the index/position in case the echo flag is set on. Set the
> NFT_CACHE_UPDATE flag in this case to enable incremental cache updates.
> 
> Reported-by: Eric Garver <eric@garver.life>
> Fixes: 01e5c6f0ed03 ("src: add cache level flags")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  src/cache.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/src/cache.c b/src/cache.c
> index cffcbb623ced..71d16a0fbeed 100644
> --- a/src/cache.c
> +++ b/src/cache.c
> @@ -106,6 +106,9 @@ unsigned int cache_evaluate(struct nft_ctx *nft, struct list_head *cmds)
>  		case CMD_CREATE:
>  			if (nft_output_echo(&nft->output)) {
>  				flags = NFT_CACHE_FULL;
> +				if (cmd->handle.index.id ||
> +				    cmd->handle.position.id)
> +					flags |= NFT_CACHE_UPDATE;
>  				break;
>  			}
>  			flags = evaluate_cache_add(cmd, flags);

We can keep the special cases isolated to evaluate_cache_add() by always
calling it.

diff --git a/src/cache.c b/src/cache.c
index cffcbb623ced..f7ca8fe9068f 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -104,11 +104,10 @@ unsigned int cache_evaluate(struct nft_ctx *nft, struct list_head *cmds)
                case CMD_ADD:
                case CMD_INSERT:
                case CMD_CREATE:
+                       flags = evaluate_cache_add(cmd, flags);
                        if (nft_output_echo(&nft->output)) {
-                               flags = NFT_CACHE_FULL;
-                               break;
+                               flags |= NFT_CACHE_FULL;
                        }
-                       flags = evaluate_cache_add(cmd, flags);
                        break;
                case CMD_REPLACE:
                        flags = NFT_CACHE_FULL;
