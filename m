From: Patrick McHardy <kaber@trash.net>
Subject: Re: [libnftnl PATCH v2] expr: dynset: fix json/xml parsing
Date: Mon, 13 Apr 2015 20:24:15 +0100
Message-ID: <20150413192415.GC20275@acer.localdomain>
References: <20150413190800.26738.53260.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39060 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbbDMTY0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Apr 2015 15:24:26 -0400
Content-Disposition: inline
In-Reply-To: <20150413190800.26738.53260.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 13.04, Arturo Borrero Gonzalez wrote:
> expr/dynset.c: In function 'nft_rule_expr_dynset_json_parse':
> expr/dynset.c:194:3: warning: implicit declaration of function 'nft_rule_expr_dynset_str' [-Wimplicit-function-declaration]
>    nft_rule_expr_dynset_str(e, NFT_EXPR_DYNSET_SET, set_name);
>    ^
> expr/dynset.c:194:31: error: 'NFT_EXPR_DYNSET_SET' undeclared (first use in this function)
>    nft_rule_expr_dynset_str(e, NFT_EXPR_DYNSET_SET, set_name);
>                                ^
> expr/dynset.c:194:31: note: each undeclared identifier is reported only once for each function it appears in
> expr/dynset.c:197:3: warning: implicit declaration of function 'nft_rule_expr_dynset_u32' [-Wimplicit-function-declaration]
>    nft_rule_expr_dynset_u32(e, NFT_EXPR_DYNSET_SREG, sreg);
>    ^
> expr/dynset.c:197:31: error: 'NFT_EXPR_DYNSET_SREG' undeclared (first use in this function)
>    nft_rule_expr_dynset_u32(e, NFT_EXPR_DYNSET_SREG, sreg);
>                                ^
> expr/dynset.c:200:31: error: 'NFT_EXPR_DYNSET_DREG' undeclared (first use in this function)
>    nft_rule_expr_dynset_u32(e, NFT_EXPR_DYNSET_DREG, dreg);
>                                ^
> expr/dynset.c: In function 'nft_rule_expr_dynset_xml_parse':
> expr/dynset.c:220:31: error: 'NFT_EXPR_DYNSET_SET' undeclared (first use in this function)
>    nft_rule_expr_dynset_str(e, NFT_EXPR_DYNSET_SET, set_name);
>                                ^
> expr/dynset.c:224:31: error: 'NFT_EXPR_DYNSET_SREG' undeclared (first use in this function)
>    nft_rule_expr_dynset_u32(e, NFT_EXPR_DYNSET_SREG, sreg);
>                                ^
> expr/dynset.c:228:31: error: 'NFT_EXPR_DYNSET_DREG' undeclared (first use in this function)
>    nft_rule_expr_dynset_u32(e, NFT_EXPR_DYNSET_DREG, dreg);
>                                ^
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

Applied and pushed out, thanks Arturo.
