Return-Path: <SRS0=+wqM=Q7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E59C1C43381
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Feb 2019 14:37:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B703420663
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Feb 2019 14:37:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728128AbfBXOhy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 Feb 2019 09:37:54 -0500
Received: from ja.ssi.bg ([178.16.129.10]:39404 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725956AbfBXOhy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 Feb 2019 09:37:54 -0500
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x1OEbjEt012645;
        Sun, 24 Feb 2019 16:37:46 +0200
Date:   Sun, 24 Feb 2019 16:37:45 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     Phil Sutter <phil@nwl.cc>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 1/3] extensions: Fix ipvs vproto parsing
In-Reply-To: <20190221190932.16281-1-phil@nwl.cc>
Message-ID: <alpine.LFD.2.21.1902241634020.5707@ja.home.ssi.bg>
References: <20190221190932.16281-1-phil@nwl.cc>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Thu, 21 Feb 2019, Phil Sutter wrote:

> This was broken by integration into guided option parser:
> 
> * Make 'vproto' option XTTYPE_PROTOCOL, otherwise its arguments are
>   parsed as garbage only.
> 
> * Drop O_VPROTO case from ipvs_mt_parse(), due to XTOPT_POINTER() and
>   above change there is nothing to do for it in there.
> 
> Fixes: 372203af4c70f ("libxt_ipvs: use guided option parser")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

	The 3 patches look good to me, thanks!

Reviewed-by: Julian Anastasov <ja@ssi.bg>

> ---
>  extensions/libxt_ipvs.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/extensions/libxt_ipvs.c b/extensions/libxt_ipvs.c
> index a6c57a030d2c6..fe98fef951686 100644
> --- a/extensions/libxt_ipvs.c
> +++ b/extensions/libxt_ipvs.c
> @@ -27,7 +27,7 @@ enum {
>  static const struct xt_option_entry ipvs_mt_opts[] = {
>  	{.name = "ipvs", .id = O_IPVS, .type = XTTYPE_NONE,
>  	 .flags = XTOPT_INVERT},
> -	{.name = "vproto", .id = O_VPROTO, .type = XTTYPE_STRING,
> +	{.name = "vproto", .id = O_VPROTO, .type = XTTYPE_PROTOCOL,
>  	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, l4proto)},
>  	{.name = "vaddr", .id = O_VADDR, .type = XTTYPE_HOSTMASK,
>  	 .flags = XTOPT_INVERT},
> @@ -69,9 +69,6 @@ static void ipvs_mt_parse(struct xt_option_call *cb)
>  
>  	xtables_option_parse(cb);
>  	switch (cb->entry->id) {
> -	case O_VPROTO:
> -		data->l4proto = cb->val.protocol;
> -		break;
>  	case O_VADDR:
>  		memcpy(&data->vaddr, &cb->val.haddr, sizeof(cb->val.haddr));
>  		memcpy(&data->vmask, &cb->val.hmask, sizeof(cb->val.hmask));
> -- 
> 2.20.1

Regards

--
Julian Anastasov <ja@ssi.bg>
