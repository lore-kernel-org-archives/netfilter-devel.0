From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 2/4] netlink_delinearize: Avoid potential null
 pointer deref
Date: Wed, 17 Aug 2016 16:46:18 +0200
Message-ID: <20160817144618.GB10362@salvia>
References: <1471017610-3473-1-git-send-email-phil@nwl.cc>
 <1471017610-3473-3-git-send-email-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58466 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbcHQOqY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 10:46:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id CDB9DD162D
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 16:46:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BDF6C9663D
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 16:46:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BD36ADA7F6
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 16:46:19 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1471017610-3473-3-git-send-email-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 12, 2016 at 06:00:08PM +0200, Phil Sutter wrote:
> As netlink_get_register() may return NULL, we must not pass the returned
> data unchecked to expr_set_type() as that will dereference it. Since the
> parser has failed at that point anyway, by returning early we can skip
> the useless statement allocation that follows in
> netlink_parse_ct_stmt().
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  src/netlink_delinearize.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> index 12d0b4a277795..6ac2e9690fd39 100644
> --- a/src/netlink_delinearize.c
> +++ b/src/netlink_delinearize.c
> @@ -518,6 +518,8 @@ static void netlink_parse_ct_stmt(struct netlink_parse_ctx *ctx,
>  
>  	sreg = netlink_parse_register(nle, NFTNL_EXPR_CT_SREG);
>  	expr = netlink_get_register(ctx, loc, sreg);
> +	if (!expr)
> +		return;

I would add a netlink_error() by here too.

I can see more spots with this problem, would you send us a patch to
resolve the multiple reincarnations of this problem in one go?

Thanks!
