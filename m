Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0291C05027
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Mar 2023 17:14:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbjCNROI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Mar 2023 13:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCNRN4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Mar 2023 13:13:56 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB48153290
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Mar 2023 10:13:53 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1pc8Df-0004YK-Ry; Tue, 14 Mar 2023 18:13:52 +0100
Date:   Tue, 14 Mar 2023 18:13:51 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v2] parser_bison: simplify reset syntax
Message-ID: <ZBCrT68HC5Emwq49@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230314165138.828102-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314165138.828102-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 14, 2023 at 05:51:38PM +0100, Pablo Neira Ayuso wrote:
> Simplify:
> 
> *reset rules* *chain* ['family'] 'table' ['chain]'
> to
> *reset rules* ['family'] 'table' 'chain'
> 
> *reset rules* *table* ['family'] 'table'
> to
> *reset rules* ['family'] 'table'
> 
> *reset counters* ['family'] *table* 'table'
> to
> *reset counters* ['family'] 'table'
> 
> *reset quotas* ['family'] *table* 'table'
> to
> *reset quotas* ['family'] 'table'
> 
> Previous syntax remains in place for backward compatibility.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: combine all three lines in manpage
>     remove leftover
> 
>  doc/nft.txt        |  8 +++-----
>  src/parser_bison.y | 20 ++++++++++++++++++++
>  2 files changed, 23 insertions(+), 5 deletions(-)
> 
> diff --git a/doc/nft.txt b/doc/nft.txt
> index 0d60c7520d31..82d3bc4211f1 100644
> --- a/doc/nft.txt
> +++ b/doc/nft.txt
> @@ -490,9 +490,7 @@ RULES
>  *replace rule* ['family'] 'table' 'chain' *handle* 'handle' 'statement' ... [*comment* 'comment']
>  {*delete* | *reset*} *rule* ['family'] 'table' 'chain' *handle* 'handle'
>  *destroy rule* ['family'] 'table' 'chain' *handle* 'handle'
> -*reset rules* ['family']
> -*reset rules* *table* ['family'] 'table'
> -*reset rules* *chain* ['family'] 'table' ['chain']
> +*reset rules* ['family'] ['table'] ['chain']

Sorry for being pedantic, but the above indicates something like 'reset
rules ip mychain' is allowed although it isn't.
