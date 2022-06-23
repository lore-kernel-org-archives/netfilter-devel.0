Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69385CCA47C
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jun 2022 19:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiFWTjd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jun 2022 15:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiFWTjK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jun 2022 15:39:10 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 09CFB2DFC
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 12:27:37 -0700 (PDT)
Date:   Thu, 23 Jun 2022 21:27:33 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Cc:     netfilter-devel@vger.kernel.org, mikhail.sennikovsky@gmail.com
Subject: Re: [PATCH 6/6] conntrack: fix -o save dump for unknown protocols
Message-ID: <YrS+pfx7yxkuzXAH@salvia>
References: <20220623175000.49259-1-mikhail.sennikovskii@ionos.com>
 <20220623175000.49259-7-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220623175000.49259-7-mikhail.sennikovskii@ionos.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 23, 2022 at 07:50:00PM +0200, Mikhail Sennikovsky wrote:
> Make sure the protocol (-p) option is included in the -o save
> ct entry dumps for L4 protocols unknown to the conntrack tool
> 
> Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
> ---
>  src/conntrack.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/src/conntrack.c b/src/conntrack.c
> index dca7da6..f8a228f 100644
> --- a/src/conntrack.c
> +++ b/src/conntrack.c
> @@ -870,9 +870,18 @@ static int ct_save_snprintf(char *buf, size_t len,
>  
>  		ret = ct_snprintf_opts(buf + offset, len, ct, cur->print_opts);
>  		BUFFER_SIZE(ret, size, len, offset);
> -		break;
> +		goto done_proto4;

I'd suggest:

                l4proto_set = true;

so you can remove this goto.

>  	}
>  
> +	/**
> +	 * Do not use getprotobynumber here to ensure
> +	 * "-o save" data incompatibility between hosts having
> +	 * different /etc/protocols contents
> +	 */

No need for this comment, explain this in the commit message, git
annotate will help to find the reason for this.

> +	ret = snprintf(buf + offset, len, "-p %d ", l4proto);
> +	BUFFER_SIZE(ret, size, len, offset);

        if (!l4proto_set) {
                ret = snprintf(buf + offset, len, "-p %d ", l4proto);
                BUFFER_SIZE(ret, size, len, offset);
        }

> +
> +done_proto4:
>  	/* skip trailing space, if any */
>  	for (; size && buf[size-1] == ' '; --size)
>  		buf[size-1] = '\0';
> -- 
> 2.25.1
> 
