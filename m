Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2018FE810AC
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 08:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbjI0IqS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 04:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjI0IqS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 04:46:18 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224AB95
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 01:46:17 -0700 (PDT)
Received: from [78.30.34.192] (port=50020 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qlQBR-00BEkF-H2; Wed, 27 Sep 2023 10:46:15 +0200
Date:   Wed, 27 Sep 2023 10:46:13 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] mergesort: avoid cloning value in expr_msort_cmp()
Message-ID: <ZRPr1QVa268brGbA@calendula>
References: <20230927065941.1386475-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230927065941.1386475-1-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Thomas,

Thanks for your patch.

On Wed, Sep 27, 2023 at 08:59:34AM +0200, Thomas Haller wrote:
> If we have a plain EXPR_VALUE value, there is no need to copy
> it via mpz_set().
> 
> Signed-off-by: Thomas Haller <thaller@redhat.com>
> ---
>  src/mergesort.c | 34 ++++++++++++++++++----------------
>  1 file changed, 18 insertions(+), 16 deletions(-)
> 
> diff --git a/src/mergesort.c b/src/mergesort.c
> index 5965236af6b7..af7f163b2779 100644
> --- a/src/mergesort.c
> +++ b/src/mergesort.c
> @@ -12,8 +12,6 @@
>  #include <gmputil.h>
>  #include <list.h>
>  
> -static void expr_msort_value(const struct expr *expr, mpz_t value);
> -
>  static void concat_expr_msort_value(const struct expr *expr, mpz_t value)
>  {
>  	unsigned int len = 0, ilen;
> @@ -29,20 +27,20 @@ static void concat_expr_msort_value(const struct expr *expr, mpz_t value)
>  	mpz_import_data(value, data, BYTEORDER_HOST_ENDIAN, len);
>  }
>  
> -static void expr_msort_value(const struct expr *expr, mpz_t value)
> +static mpz_srcptr expr_msort_value(const struct expr *expr, mpz_t value)
>  {
> +recursive_again:

We are in userspace, recursion is possible. Any chance to avoid the
copy without this goto approach?
