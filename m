Return-Path: <SRS0=fPey=XB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F835C43331
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Sep 2019 08:36:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 037A020842
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Sep 2019 08:36:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="Go6qhkBY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389217AbfIFIgn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Sep 2019 04:36:43 -0400
Received: from mx1.riseup.net ([198.252.153.129]:57618 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731558AbfIFIgm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Sep 2019 04:36:42 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id BAF271B907E;
        Fri,  6 Sep 2019 01:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1567759002; bh=t2FNPIm7ART7GYpOXq8+Fiq6Qxz4MxImK4pOdQlNSk0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Go6qhkBYDYS5NS6YQH/3ezUzrU7ics+MBhu8UJ+yRmGzJHV3EeZlp3bZUMIXK+xS/
         2lAMpWK9TckHrreBksac/lMKZzroSQEgxAc2tE8y14hT8jLFfNSRzmPPb2f/2wfqxF
         PYwzX7QAGRGT5oFtWMfxBAvXvV49CxANrnRd/XDk=
X-Riseup-User-ID: 472C8FB7E389D6F309DD4195B318043043BED3C6AD0CB0F48E7975FBE1A38AE7
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id B670A222CF0;
        Fri,  6 Sep 2019 01:36:39 -0700 (PDT)
Subject: Re: [PATCH] netfilter: nf_tables: Fix an Oops in nf_tables_updobj()
 error handling
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel-janitors@vger.kernel.org
References: <20190906081808.GA8281@mwanda>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <efae8f44-224e-9337-64cf-47fd67ba2950@riseup.net>
Date:   Fri, 6 Sep 2019 10:36:49 +0200
MIME-Version: 1.0
In-Reply-To: <20190906081808.GA8281@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Oh sorry, I missed that. Thanks!

Acked-by: Fernando Fernandez Mancera <ffmancera@riseup.net>

On 9/6/19 10:18 AM, Dan Carpenter wrote:
> The "newobj" is an error pointer so we can't pass it to kfree().  It
> doesn't need to be freed so we can remove that and I also renamed the
> error label.
> 
> Fixes: d62d0ba97b58 ("netfilter: nf_tables: Introduce stateful object update operation")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  net/netfilter/nf_tables_api.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index cf767bc58e18..6f66898d63b4 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -5148,7 +5148,7 @@ static int nf_tables_updobj(const struct nft_ctx *ctx,
>  	newobj = nft_obj_init(ctx, type, attr);
>  	if (IS_ERR(newobj)) {
>  		err = PTR_ERR(newobj);
> -		goto err1;
> +		goto err_free_trans;
>  	}
>  
>  	nft_trans_obj(trans) = obj;
> @@ -5157,9 +5157,9 @@ static int nf_tables_updobj(const struct nft_ctx *ctx,
>  	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
>  
>  	return 0;
> -err1:
> +
> +err_free_trans:
>  	kfree(trans);
> -	kfree(newobj);
>  	return err;
>  }
>  
> 
