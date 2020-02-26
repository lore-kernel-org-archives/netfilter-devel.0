Return-Path: <SRS0=IqR4=4O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B386AC4BA0E
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 11:36:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86205206E6
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 11:36:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dy6Em83W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgBZLgh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Feb 2020 06:36:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21878 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728238AbgBZLgh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Feb 2020 06:36:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582716995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vHSZqTOzfOEMS3v/EWR5N+AUIFRFumi5QSh6gKo+yxo=;
        b=dy6Em83WKY+Is6mtdPKjrG4+KnrVlMIa88e3b4sUCt15yWnpJ+ar23n3NgBbYu2l0cfQAN
        cusGTlmUuGAwuN/w0i6sKIZAKIi0lJBVpiQ/wazT/kVEmOAvBZFUvFTGpLk10gn0bjiLMx
        nkH1ePBNnW5+Y+PODFKA1vpFUs8iTl4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-kiW7Us3hNi6KWX36x7p-dQ-1; Wed, 26 Feb 2020 06:36:34 -0500
X-MC-Unique: kiW7Us3hNi6KWX36x7p-dQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F0E2190B2A7;
        Wed, 26 Feb 2020 11:36:33 +0000 (UTC)
Received: from localhost (ovpn-200-34.brq.redhat.com [10.40.200.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D9D08B779;
        Wed, 26 Feb 2020 11:36:31 +0000 (UTC)
Date:   Wed, 26 Feb 2020 12:36:26 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf 0/2] nft_set_pipapo: Fix crash due to dangling
 entries in mapping table
Message-ID: <20200226123626.561451e7@redhat.com>
In-Reply-To: <20200226112935.bdsz733f2gltkbpu@salvia>
References: <20200223222258.2bb7516a@redhat.com>
        <20200225123934.p3vru3tmbsjj2o7y@salvia>
        <20200225141346.7406e06b@redhat.com>
        <20200225134236.sdz5ujufvxm2in3h@salvia>
        <20200225153435.17319874@redhat.com>
        <20200225202143.tqsfhggvklvhnsvs@salvia>
        <20200225213815.3c0a1caa@redhat.com>
        <20200225205847.s5pjjp652unj6u7v@salvia>
        <20200226105804.xramr6duqkvrtop3@salvia>
        <20200226120253.71e9f0e0@redhat.com>
        <20200226112935.bdsz733f2gltkbpu@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 26 Feb 2020 12:29:35 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> From a17f22eac1dfd599ff97bb262fc97d64333b06fe Mon Sep 17 00:00:00 2001
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> Date: Wed, 26 Feb 2020 12:11:53 +0100
> Subject: [PATCH] netfilter: nf_tables: report ENOTEMPTY on element
>  intersection
> 
> The set backend uses ENOTEMPTY to report an intersection between two
> range elements.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_tables_api.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index d1318bdf49ca..48ad273a273e 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -5059,7 +5059,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
>  	ext->genmask = nft_genmask_cur(ctx->net) | NFT_SET_ELEM_BUSY_MASK;
>  	err = set->ops->insert(ctx->net, set, &elem, &ext2);
>  	if (err) {
> -		if (err == -EEXIST) {
> +		if (err == -EEXIST || err == -ENOTEMPTY) {
>  			if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA) ^
>  			    nft_set_ext_exists(ext2, NFT_SET_EXT_DATA) ||
>  			    nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF) ^
> @@ -5073,10 +5073,17 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
>  				    nft_set_ext_data(ext2), set->dlen) != 0) ||
>  			    (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF) &&
>  			     nft_set_ext_exists(ext2, NFT_SET_EXT_OBJREF) &&
> -			     *nft_set_ext_obj(ext) != *nft_set_ext_obj(ext2)))
> +			     *nft_set_ext_obj(ext) != *nft_set_ext_obj(ext2))) {
>  				err = -EBUSY;
> -			else if (!(nlmsg_flags & NLM_F_EXCL))
> -				err = 0;
> +			} else {
> +				/* ENOTEMPTY reports an intersection between
> +				 * this element and an existing one.
> +				 */
> +				if (err == -ENOTEMPTY)
> +					err = -EEXIST;
> +				else if (!(nlmsg_flags & NLM_F_EXCL))
> +					err = 0;
> +			}
>  		}
>  		goto err_element_clash;
>  	}

I haven't tested it, but isn't:

@@ -5077,6 +5077,11 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
                                err = -EBUSY;
                        else if (!(nlmsg_flags & NLM_F_EXCL))
                                err = 0;
+               } else if (err == -ENOTEMPTY) {
+                       /* ENOTEMPTY reports overlapping between this element
+                        * and an existing one.
+                        */
+                       err = -EEXIST;
                }
                goto err_element_clash;
        }

simpler and equivalent?

-- 
Stefano

