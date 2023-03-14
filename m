Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB7C9C6FD1C
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Mar 2023 16:13:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbjCNQNb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Mar 2023 12:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjCNQNa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Mar 2023 12:13:30 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32633A54E1
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Mar 2023 09:13:11 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1pc7Gt-0003sw-SP; Tue, 14 Mar 2023 17:13:07 +0100
Date:   Tue, 14 Mar 2023 17:13:07 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] parser_bison: simplify reset syntax
Message-ID: <ZBCdE7DdV2pWhSkv@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230314160537.827655-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314160537.827655-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 14, 2023 at 05:05:37PM +0100, Pablo Neira Ayuso wrote:
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
>  doc/nft.txt        |  8 ++++----
>  src/parser_bison.y | 20 ++++++++++++++++++++
>  2 files changed, 24 insertions(+), 4 deletions(-)
> 
> diff --git a/doc/nft.txt b/doc/nft.txt
> index 0d60c7520d31..8624d5dd8f60 100644
> --- a/doc/nft.txt
> +++ b/doc/nft.txt
> @@ -491,8 +491,8 @@ RULES
>  {*delete* | *reset*} *rule* ['family'] 'table' 'chain' *handle* 'handle'
>  *destroy rule* ['family'] 'table' 'chain' *handle* 'handle'
>  *reset rules* ['family']
> -*reset rules* *table* ['family'] 'table'
> -*reset rules* *chain* ['family'] 'table' ['chain']
> +*reset rules* ['family'] 'table'
> +*reset chain* ['family'] 'table' 'chain'
          ~~~~~

This is a leftover. You may combine all three lines into a single:

| *reset rules* ['family'] ['table' ['chain']]

Cheers, Phil
