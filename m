Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAE57C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jan 2022 13:03:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353334AbiALND3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Jan 2022 08:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240808AbiALND3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jan 2022 08:03:29 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20BEC06173F
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jan 2022 05:03:28 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1n7dHh-0002Qi-R6; Wed, 12 Jan 2022 14:03:25 +0100
Date:   Wed, 12 Jan 2022 14:03:25 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v2 00/11] Share do_parse() between nft and legacy
Message-ID: <Yd7RnX0CaKqOTLdD@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220111150429.29110-1-phil@nwl.cc>
 <Yd6+m/k2PPpB8DwF@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yd6+m/k2PPpB8DwF@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jan 12, 2022 at 12:42:19PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Jan 11, 2022 at 04:04:18PM +0100, Phil Sutter wrote:
> > Patch 1 removes remains of an unused (and otherwise dropped) feature,
> > yet the change is necessary for the following ones. Patches 2-6 prepare
> > for patch 7 which moves do_parse() to xshared.c. Patches 8 and 9 prepare
> > for use of do_parse() from legacy code, Patches 10 and 11 finally drop
> > legacy ip(6)tables' rule parsing code.
> 
> Just two nitpicks in case you would like to apply them before pushing
> out.
> 
> - Patch #6
> 
> diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
> index b211a30937db3..ba696c6a6a123 100644
> --- a/iptables/nft-arp.c
> +++ b/iptables/nft-arp.c
> @@ -802,7 +802,7 @@ struct nft_family_ops nft_family_ops_arp = {
>         .print_rule             = nft_arp_print_rule,
>         .save_rule              = nft_arp_save_rule,
>         .save_chain             = nft_arp_save_chain,
> -       .post_parse             = nft_arp_post_parse,
> +       .cmd_parse.post_parse   = nft_arp_post_parse,
>         .rule_to_cs             = nft_rule_to_iptables_command_state,
>         .init_cs                = nft_arp_init_cs,
>         .clear_cs               = nft_clear_iptables_command_state,
> 
> I would use C99:
> 
>         .cmd_parse              = {
>                 .post_parse     = nft_arp_post_parse,
>         },
> 
> for future extensibility, but maybe it is too far fetched.

Fine with me!

> - Patch #10, instead of:
> 
> +       case CMD_NONE:
> +       /* do_parse ignored the line (eg: -4 with ip6tables-restore) */
> +               break;
> 
> this:
> 
> +       case CMD_NONE:
> +               /* do_parse ignored the line (eg: -4 with ip6tables-restore) */
> +               break;

Oh yes, of course.

Thanks, Phil
