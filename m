Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC96C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Mar 2021 17:18:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6461164EFC
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Mar 2021 17:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhCORRy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Mar 2021 13:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233676AbhCORRg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Mar 2021 13:17:36 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5DF25C06174A
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Mar 2021 10:17:36 -0700 (PDT)
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0FAB163534;
        Mon, 15 Mar 2021 18:17:33 +0100 (CET)
Date:   Mon, 15 Mar 2021 18:17:31 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v3 4/8] conntrack: introduce ct_cmd_list
Message-ID: <20210315171731.GA24971@salvia>
References: <20210129212452.45352-1-mikhail.sennikovskii@cloud.ionos.com>
 <20210129212452.45352-5-mikhail.sennikovskii@cloud.ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210129212452.45352-5-mikhail.sennikovskii@cloud.ionos.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jan 29, 2021 at 10:24:48PM +0100, Mikhail Sennikovsky wrote:
> As a multicommand support preparation, add support for the
> ct_cmd_list, which represents a list of ct_cmd elements.
> Currently only a single entry generated from the command line
> arguments is created.
> 
> Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
> ---
>  src/conntrack.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 66 insertions(+), 3 deletions(-)
> 
> diff --git a/src/conntrack.c b/src/conntrack.c
> index 4783825..1719ca9 100644
> --- a/src/conntrack.c
> +++ b/src/conntrack.c
> @@ -598,6 +598,19 @@ static unsigned int addr_valid_flags[ADDR_VALID_FLAGS_MAX] = {
>  	CT_OPT_REPL_SRC | CT_OPT_REPL_DST,
>  };
>  
> +#define CT_COMMANDS_LOAD_FILE_ALLOWED ( 0 \
> +						| CT_CREATE       \
> +						| CT_UPDATE_BIT   \

This should CT_UPDATE.

> +						| CT_DELETE       \
> +						| CT_FLUSH        \
> +						| EXP_CREATE      \
> +						| EXP_DELETE      \
> +						| EXP_FLUSH       \

Do you need expectations too? The expectation support for the
conntrack command line tool is limited IIRC.

I would probably collapse patch 4/8 and 5/8, it should be easy to
review, it all basically new code to support for the batching mode.
