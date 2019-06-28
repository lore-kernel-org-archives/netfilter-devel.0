Return-Path: <SRS0=rhnh=U3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA95AC4321A
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jun 2019 18:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEBD22083B
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jun 2019 18:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbfF1SA7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Jun 2019 14:00:59 -0400
Received: from mail.us.es ([193.147.175.20]:56424 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbfF1SA7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jun 2019 14:00:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 799C61B6943
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2019 20:00:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 692CA4CA35
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2019 20:00:57 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 68687FB37C; Fri, 28 Jun 2019 20:00:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 64D1EDA4D0;
        Fri, 28 Jun 2019 20:00:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 28 Jun 2019 20:00:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.195.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3C2E04265A2F;
        Fri, 28 Jun 2019 20:00:53 +0200 (CEST)
Date:   Fri, 28 Jun 2019 20:00:51 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2] parser_bison: Accept arbitrary user-defined names
 by quoting
Message-ID: <20190628180051.47o27vbgqrsjpwab@salvia>
References: <20190624163608.17348-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624163608.17348-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 24, 2019 at 06:36:08PM +0200, Phil Sutter wrote:
> Parser already allows to quote user-defined strings in some places to
> avoid clashing with defined keywords, but not everywhere. Extend this
> support further and add a test case for it.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Changes since v1:
> - Fix testcase, I forgot to commit adjustments done to it.
> 
> Note: This is a reduced variant of "src: Quote user-defined names" sent
>       back in January. Discussion was not conclusive regarding whether
>       to quote these names on output or not, but I assume allowing for
>       users to specify them by adding quotes is a step forward without
>       drawbacks.

So this will fail later on, right?

        nft list ruleset > file.nft
        nft -f file.nft

> ---
>  src/parser_bison.y                            |  3 ++-
>  .../shell/testcases/nft-f/0018quoted-names_0  | 20 +++++++++++++++++++
>  2 files changed, 22 insertions(+), 1 deletion(-)
>  create mode 100755 tests/shell/testcases/nft-f/0018quoted-names_0
> 
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index 670e91f544c75..de8b097a4c222 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -1761,7 +1761,7 @@ flowtable_list_expr	:	flowtable_expr_member
>  			|	flowtable_list_expr	COMMA	opt_newline
>  			;
>  
> -flowtable_expr_member	:	STRING
> +flowtable_expr_member	:	string
>  			{
>  				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
>  						       current_scope(state),
> @@ -1968,6 +1968,7 @@ chain_policy		:	ACCEPT		{ $$ = NF_ACCEPT; }
>  			;
>  
>  identifier		:	STRING
> +			|	QUOTED_STRING
>  			;
>  
>  string			:	STRING
> diff --git a/tests/shell/testcases/nft-f/0018quoted-names_0 b/tests/shell/testcases/nft-f/0018quoted-names_0
> new file mode 100755
> index 0000000000000..6526d66b8e8a1
> --- /dev/null
> +++ b/tests/shell/testcases/nft-f/0018quoted-names_0
> @@ -0,0 +1,20 @@
> +#!/bin/bash
> +
> +# Test if keywords are allowed as names if quoted
> +
> +set -e
> +
> +RULESET='
> +table inet "day" {
> +	chain "minute" {}
> +	set "hour" { type inet_service; }
> +	flowtable "second" { hook ingress priority 0; devices = { "lo" }; }
> +	counter "table" { packets 0 bytes 0 }
> +	quota "chain" { 10 bytes }
> +}'
> +
> +$NFT -f - <<< "$RULESET"
> +
> +# XXX: not possible (yet)
> +#OUTPUT=$($NFT list ruleset)
> +#$NFT -f - <<< "$OUTPUT"
> -- 
> 2.21.0
> 
