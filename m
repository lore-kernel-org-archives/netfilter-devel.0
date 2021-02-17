Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,FORGED_MUA_MOZILLA,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 960B1C433DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Feb 2021 23:01:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AB0764E58
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Feb 2021 23:01:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhBQXAv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Feb 2021 18:00:51 -0500
Received: from correo.us.es ([193.147.175.20]:54468 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhBQXAv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Feb 2021 18:00:51 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 36199D28C5
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Feb 2021 00:00:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 08F78DA73D
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Feb 2021 00:00:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id ED86EDA730; Thu, 18 Feb 2021 00:00:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BA48ADA704;
        Thu, 18 Feb 2021 00:00:06 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 18 Feb 2021 00:00:06 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8F3D842DC6E2;
        Thu, 18 Feb 2021 00:00:06 +0100 (CET)
Date:   Thu, 18 Feb 2021 00:00:06 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Maya Rashish <mrashish@redhat.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH 1/2] Avoid out of bound reads in tests.
Message-ID: <20210217230006.GA32290@salvia>
References: <6b4add9f-7947-9f81-48c9-83b77286d2e6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6b4add9f-7947-9f81-48c9-83b77286d2e6@redhat.com>
User-Agent: Mozilla/5.0
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Maya,

On Wed, Feb 17, 2021 at 10:45:45PM +0200, Maya Rashish wrote:
> Our string isn't NUL-terminated. To avoid reading past
> the last character, use strndup.

Is this a theoretical problem or some static analisys tool is
reporting out-of-bound memread?

> Signed-off-by: Maya Rashish <mrashish@redhat.com>
> ---
>  tests/nft-expr_match-test.c  | 2 +-
>  tests/nft-expr_target-test.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/nft-expr_match-test.c b/tests/nft-expr_match-test.c
> index 39a49d8..f6b7bc0 100644
> --- a/tests/nft-expr_match-test.c
> +++ b/tests/nft-expr_match-test.c
> @@ -71,7 +71,7 @@ int main(int argc, char *argv[])
> 
>  	nftnl_expr_set_str(ex, NFTNL_EXPR_MT_NAME, "Tests");
>  	nftnl_expr_set_u32(ex, NFTNL_EXPR_MT_REV, 0x12345678);
> -	nftnl_expr_set(ex, NFTNL_EXPR_MT_INFO, strdup(data), sizeof(data));
> +	nftnl_expr_set(ex, NFTNL_EXPR_MT_INFO, strndup(data, sizeof(data)), sizeof(data));
>  	nftnl_rule_add_expr(a, ex);
> 
>  	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
> diff --git a/tests/nft-expr_target-test.c b/tests/nft-expr_target-test.c
> index ba56b27..a135b9c 100644
> --- a/tests/nft-expr_target-test.c
> +++ b/tests/nft-expr_target-test.c
> @@ -71,7 +71,7 @@ int main(int argc, char *argv[])
> 
>  	nftnl_expr_set(ex, NFTNL_EXPR_TG_NAME, "test", strlen("test"));
>  	nftnl_expr_set_u32(ex, NFTNL_EXPR_TG_REV, 0x56781234);
> -	nftnl_expr_set(ex, NFTNL_EXPR_TG_INFO, strdup(data), sizeof(data));
> +	nftnl_expr_set(ex, NFTNL_EXPR_TG_INFO, strndup(data, sizeof(data)), sizeof(data));
>  	nftnl_rule_add_expr(a, ex);
> 
>  	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
> -- 
> 2.29.2
> 
