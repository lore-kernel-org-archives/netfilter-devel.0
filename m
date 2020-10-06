Return-Path: <SRS0=CgNT=DN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73DE1C41604
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Oct 2020 10:33:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 126812080A
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Oct 2020 10:33:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="Fc6bJN4C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgJFKdn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Oct 2020 06:33:43 -0400
Received: from mx1.riseup.net ([198.252.153.129]:42034 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbgJFKdn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Oct 2020 06:33:43 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4C5DMq328szFfY3;
        Tue,  6 Oct 2020 03:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1601980423; bh=XjgBq0Pu6FuPCAcGdXsAD76QngbzUhOPkz/ufsjQTWQ=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=Fc6bJN4CJQPivLh7E5Uk2o065xqXA63Wz3xUHH8cppZ9Kke6s3oBz4gCSIvTVXV9s
         NslxlomcgPf4Wdn5QUR1gRxKu2HbyDGuBWyceJPycmnSuyknZIFFnoxh12iT5neP85
         bc3tLBKYHlOsjDtZiMjAfgi15Ta5yAOiJL1v7WEg=
X-Riseup-User-ID: EFCBFB5522F84339222215795FF6E74E0DBD48336F69F83CF0ED19BC9FFD89A4
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 4C5DMp5NlVz8sht;
        Tue,  6 Oct 2020 03:33:42 -0700 (PDT)
Subject: Re: [PATCH 1/1] Solves Bug 1462 - `nft -j list set` does not show
 counters
To:     Gopal Yadav <gopunop@gmail.com>, netfilter-devel@vger.kernel.org
References: <20201003125841.5138-1-gopunop@gmail.com>
From:   "Jose M. Guisado" <guigom@riseup.net>
Message-ID: <2c604efb-39a3-41de-f0a6-a44c703a20df@riseup.net>
Date:   Tue, 6 Oct 2020 12:33:41 +0200
MIME-Version: 1.0
In-Reply-To: <20201003125841.5138-1-gopunop@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Gopal,

On 3/10/20 14:58, Gopal Yadav wrote:
> Solves Bug 1462 - `nft -j list set` does not show counters
> 
> Signed-off-by: Gopal Yadav <gopunop@gmail.com>
> ---
>   src/json.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/src/json.c b/src/json.c
> index 5856f9fc..6ad48fdd 100644
> --- a/src/json.c
> +++ b/src/json.c
> @@ -589,7 +589,7 @@ json_t *set_elem_expr_json(const struct expr *expr, struct output_ctx *octx)
>   		return NULL;
>   
>   	/* these element attributes require formal set elem syntax */
> -	if (expr->timeout || expr->expiration || expr->comment) {
> +	if (expr->timeout || expr->expiration || expr->comment || expr->stmt) {
>   		root = json_pack("{s:o}", "val", root);
>   
>   		if (expr->timeout) {
> @@ -604,6 +604,10 @@ json_t *set_elem_expr_json(const struct expr *expr, struct output_ctx *octx)
>   			tmp = json_string(expr->comment);
>   			json_object_set_new(root, "comment", tmp);
>   		}
> +		if(expr->stmt) {
> +			tmp = expr->stmt->ops->json(expr->stmt, octx);

You can compact this using stmt_print_json

> +			json_object_update(root, tmp);

ASAN reports memleaks when using json_object_update. You should use 
json_object_update_new, or maybe json_object_update_missing_new to 
ensure only new keys are created.

> +		}
>   		return json_pack("{s:o}", "elem", root);
>   	}
>   
> 

