Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A97CBC43334
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jun 2022 07:05:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbiFVHF0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Jun 2022 03:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiFVHFZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Jun 2022 03:05:25 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E18FA369EB
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2022 00:05:23 -0700 (PDT)
Date:   Wed, 22 Jun 2022 09:05:18 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Cc:     netfilter-devel@vger.kernel.org, mikhail.sennikovsky@gmail.com
Subject: Re: [PATCH 1/3] conntrack: introduce new -A command
Message-ID: <YrK/LuvlSQVtED0a@salvia>
References: <20220621225547.69349-1-mikhail.sennikovskii@ionos.com>
 <20220621225547.69349-2-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220621225547.69349-2-mikhail.sennikovskii@ionos.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 22, 2022 at 12:55:45AM +0200, Mikhail Sennikovsky wrote:
> The -A command works exactly the same way as -I except that it
> does not fail if the ct entry already exists.
> This command is useful for the batched ct loads to not abort if
> some entries being applied exist.
> 
> The ct entry dump in the "save" format is now switched to use the
> -A command as well for the generated output.

For those reading this patch: Mikhail would like to have a way to
restore a batch of conntrack entries skipping failures in insertions
(currently, -I sets on NLM_F_CREATE), hence this new -A command.
The conntrack tool does not have create and add like nftables, it used
to have -I only. The mapping here is: -I means NLM_F_CREATE and -A
means no NLM_F_CREATE (report no error on EEXIST).

> Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
> ---
>  src/conntrack.c | 34 +++++++++++++++++++++++++++-------
>  1 file changed, 27 insertions(+), 7 deletions(-)
> 
> diff --git a/src/conntrack.c b/src/conntrack.c
> index 500e736..465a4f9 100644
> --- a/src/conntrack.c
> +++ b/src/conntrack.c
> @@ -115,6 +115,7 @@ struct ct_cmd {
>  	unsigned int	cmd;
>  	unsigned int	type;
>  	unsigned int	event_mask;
> +	unsigned int 	cmd_options;
>  	int		options;
>  	int		family;
>  	int		protonum;
> @@ -215,6 +216,11 @@ enum ct_command {
>  };
>  /* If you add a new command, you have to update NUMBER_OF_CMD in conntrack.h */
>  
> +enum ct_command_options {
> +	CT_CMD_OPT_IGNORE_ALREADY_DONE_BIT = 0,
> +	CT_CMD_OPT_IGNORE_ALREADY_DONE     = (1 << CT_CMD_OPT_IGNORE_ALREADY_DONE_BIT),

Could you add CT_ADD command type so we can save this flag?

You will have to update a few more spots in the code but this should
be fine.

Thanks.
