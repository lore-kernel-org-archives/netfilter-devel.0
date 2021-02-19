Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,FORGED_MUA_MOZILLA,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F841C433DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Feb 2021 00:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C559364ECD
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Feb 2021 00:19:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhBSATP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Feb 2021 19:19:15 -0500
Received: from correo.us.es ([193.147.175.20]:54008 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229468AbhBSATO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Feb 2021 19:19:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EF4B42A2BA3
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Feb 2021 01:18:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DF93DDA722
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Feb 2021 01:18:31 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D488BDA789; Fri, 19 Feb 2021 01:18:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9A3D2DA73F;
        Fri, 19 Feb 2021 01:18:29 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 19 Feb 2021 01:18:29 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 786A742DC702;
        Fri, 19 Feb 2021 01:18:29 +0100 (CET)
Date:   Fri, 19 Feb 2021 01:18:29 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Maya Rashish <mrashish@redhat.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH 2/2 v2] Avoid out of bounds read from data
Message-ID: <20210219001829.GA4379@salvia>
References: <152a0191-c777-2b57-0775-ba94a59c74a0@redhat.com>
 <20210217230100.GB32290@salvia>
 <1ec62c2c-869d-9acf-138d-99baeaca07b0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1ec62c2c-869d-9acf-138d-99baeaca07b0@redhat.com>
User-Agent: Mozilla/5.0
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Maya,

On Thu, Feb 18, 2021 at 01:06:38PM +0200, Maya Rashish wrote:
> When data is smaller than the destination, &ctr->pkts.
> 
> This might introduce some issues since we're now not
> filling the rest of the memory, but filling out with
> uninitialized garbage is probably as bad as leaving it
> as garbage.

Probably you could update src/expr/ to use nftnl_assert_validate() to
sanity check the input data length?

Please, have a look at nftnl_assert_attr_exists() and
nftnl_assert_validate().

> Signed-off-by: Maya Rashish <mrashish@redhat.com>
> ---
>  include/utils.h    | 2 ++
>  src/expr/counter.c | 4 ++--
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/utils.h b/include/utils.h
> index 8af5a8e..6b22e46 100644
> --- a/include/utils.h
> +++ b/include/utils.h
> @@ -67,6 +67,8 @@ void __nftnl_assert_attr_exists(uint16_t attr, uint16_t attr_max,
> 
>  #define array_size(arr)		(sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
> 
> +#define	MIN(a,b)		((a) > (b) ? (b) : (a))
> +
>  const char *nftnl_family2str(uint32_t family);
>  int nftnl_str2family(const char *family);
> 
> diff --git a/src/expr/counter.c b/src/expr/counter.c
> index 89a602e..fb036dd 100644
> --- a/src/expr/counter.c
> +++ b/src/expr/counter.c
> @@ -35,10 +35,10 @@ nftnl_expr_counter_set(struct nftnl_expr *e, uint16_t type,
> 
>  	switch(type) {
>  	case NFTNL_EXPR_CTR_BYTES:
> -		memcpy(&ctr->bytes, data, sizeof(ctr->bytes));
> +		memcpy(&ctr->bytes, data, MIN(data_len, sizeof(ctr->bytes)));
>  		break;
>  	case NFTNL_EXPR_CTR_PACKETS:
> -		memcpy(&ctr->pkts, data, sizeof(ctr->pkts));
> +		memcpy(&ctr->pkts, data, MIN(data_len, sizeof(ctr->pkts)));
>  		break;
>  	default:
>  		return -1;
> -- 
> 2.29.2
> 
