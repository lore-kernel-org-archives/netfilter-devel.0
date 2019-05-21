Return-Path: <SRS0=lkya=TV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89F24C04AAF
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 May 2019 19:42:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 691D821019
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 May 2019 19:42:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727424AbfEUTmP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 May 2019 15:42:15 -0400
Received: from mail.us.es ([193.147.175.20]:48166 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726771AbfEUTmO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 May 2019 15:42:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 75C9CF2583
        for <netfilter-devel@vger.kernel.org>; Tue, 21 May 2019 21:42:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 653F6DA70A
        for <netfilter-devel@vger.kernel.org>; Tue, 21 May 2019 21:42:11 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 64B43DA708; Tue, 21 May 2019 21:42:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6037CDA705;
        Tue, 21 May 2019 21:42:09 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 21 May 2019 21:42:09 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3D1644265A31;
        Tue, 21 May 2019 21:42:09 +0200 (CEST)
Date:   Tue, 21 May 2019 21:42:08 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v3 1/2] jump: Introduce chain_expr in jump and goto
 statements
Message-ID: <20190521194208.weiqqu6xfhvsceqd@salvia>
References: <20190516204559.28910-1-ffmancera@riseup.net>
 <20190521092837.vd3egt54lvdhynqi@salvia>
 <1ff8b9ea-ce19-301f-e683-790417a179a7@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1ff8b9ea-ce19-301f-e683-790417a179a7@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 21, 2019 at 09:38:16PM +0200, Fernando Fernandez Mancera wrote:
> Hi Pablo,
> 
> On 5/21/19 11:28 AM, Pablo Neira Ayuso wrote:
> > On Thu, May 16, 2019 at 10:45:58PM +0200, Fernando Fernandez Mancera wrote:
> >> Now we can introduce expressions as a chain in jump and goto statements. This
> >> is going to be used to support variables as a chain in the following patches.
> > 
> > Something is wrong with json:
> > 
> > json.c: In function ‘verdict_expr_json’:
> > json.c:683:11: warning: assignment from incompatible pointer type
> > [-Wincompatible-pointer-types]
> >      chain = expr->chain;
> >            ^
> > parser_json.c: In function ‘json_parse_verdict_expr’:
> > parser_json.c:1086:8: warning: passing argument 3 of
> > ‘verdict_expr_alloc’ from incompatible pointer type
> > [-Wincompatible-pointer-types]
> >         chain ? xstrdup(chain) : NULL);
> >         ^~~~~
> > 
> > Most likely --enable-json missing there.
> > 
> 
> Sorry, I am going to fix that.

Thanks!

> >  diff --git a/src/datatype.c b/src/datatype.c
> >> index ac9f2af..10f185b 100644
> >> --- a/src/datatype.c
> >> +++ b/src/datatype.c
> >> @@ -254,6 +254,8 @@ const struct datatype invalid_type = {
> >>  
> >>  static void verdict_type_print(const struct expr *expr, struct output_ctx *octx)
> >>  {
> >> +	char chain[NFT_CHAIN_MAXNAMELEN];
> >> +
> >>  	switch (expr->verdict) {
> >>  	case NFT_CONTINUE:
> >>  		nft_print(octx, "continue");
> >> @@ -262,10 +264,26 @@ static void verdict_type_print(const struct expr *expr, struct output_ctx *octx)
> >>  		nft_print(octx, "break");
> >>  		break;
> >>  	case NFT_JUMP:
> >> -		nft_print(octx, "jump %s", expr->chain);
> >> +		if (expr->chain->etype == EXPR_VALUE) {
> >> +			mpz_export_data(chain, expr->chain->value,
> >> +					BYTEORDER_HOST_ENDIAN,
> >> +					NFT_CHAIN_MAXNAMELEN);
> >> +			nft_print(octx, "jump %s", chain);
> >> +		} else {
> >> +			nft_print(octx, "jump ");
> >> +			expr_print(expr->chain, octx);
> >> +		}
> > 
> > I think this should be fine:
> > 
> >         case NFT_JUMP:
> > 		nft_print(octx, "jump ");
> > 		expr_print(expr->chain, octx);
> >                 break;
> > 
> > Any reason to have the 'if (expr->chain->etype == EXPR_VALUE) {'
> > check?
> > 
> 
> Yes, without this check the list ruleset is slightly different when
> using variables.
> 
> table ip foo {
> 	chain bar {
> 		type filter hook input priority filter; policy accept;
> 		jump "ber"
> 	}
> 
> 	chain ber {
> 		counter packets 45 bytes 3132
> 	}
> }
> 
> Please, note the quote marks in the jump statement. If we don't want to
> check that, we need to change all the tests that involve jumps (about 12).

Thanks for explaining.
