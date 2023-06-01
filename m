Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3163C77B7A
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Jun 2023 18:58:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjFAS6i (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Jun 2023 14:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjFAS6i (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Jun 2023 14:58:38 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B3712186
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Jun 2023 11:58:36 -0700 (PDT)
Date:   Thu, 1 Jun 2023 20:58:31 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     tongxiaoge1001@126.com
Cc:     netfilter-devel@vger.kernel.org, shixuantong1@huawei.com
Subject: Re: [PATCH] fix typo
Message-ID: <ZHjqV4Nj5/ALy9fN@calendula>
References: <20230601154945.65460-1-tongxiaoge1001@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230601154945.65460-1-tongxiaoge1001@126.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

May I add your Signed-off-by: tag to your patch?

Thanks

On Thu, Jun 01, 2023 at 11:49:45PM +0800, tongxiaoge1001@126.com wrote:
> From: shixuantong <tongxiaoge1001@126.com>
> 
> ---
>  tests/nft-table-test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/nft-table-test.c b/tests/nft-table-test.c
> index 1b2f280..53cf3d1 100644
> --- a/tests/nft-table-test.c
> +++ b/tests/nft-table-test.c
> @@ -34,7 +34,7 @@ static void cmp_nftnl_table(struct nftnl_table *a, struct nftnl_table *b)
>  		print_err("table flags mismatches");
>  	if (nftnl_table_get_u32(a, NFTNL_TABLE_FAMILY) !=
>  	    nftnl_table_get_u32(b, NFTNL_TABLE_FAMILY))
> -		print_err("tabke family mismatches");
> +		print_err("table family mismatches");
>  }
>  
>  int main(int argc, char *argv[])
> -- 
> 2.33.0
> 
