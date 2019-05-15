Return-Path: <SRS0=H0Uh=TP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28019C04E53
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 May 2019 15:21:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 021122084E
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 May 2019 15:21:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbfEOPVh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 May 2019 11:21:37 -0400
Received: from mail.us.es ([193.147.175.20]:58046 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726969AbfEOPVh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 May 2019 11:21:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D28F8FB6C5
        for <netfilter-devel@vger.kernel.org>; Wed, 15 May 2019 17:21:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C45B1DA705
        for <netfilter-devel@vger.kernel.org>; Wed, 15 May 2019 17:21:34 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B9C02DA70D; Wed, 15 May 2019 17:21:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9A492DA707;
        Wed, 15 May 2019 17:21:32 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 15 May 2019 17:21:32 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7979B4265A31;
        Wed, 15 May 2019 17:21:32 +0200 (CEST)
Date:   Wed, 15 May 2019 17:21:32 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 2/2 nft] jump: Allow goto and jump to a variable using
 nft input files
Message-ID: <20190515152132.267ryecqod3xenyj@salvia>
References: <20190514211340.913-1-ffmancera@riseup.net>
 <20190514211340.913-2-ffmancera@riseup.net>
 <20190515105850.GA4851@orbyte.nwl.cc>
 <347917dc-086b-998c-dd2f-b5e4a87b38b1@riseup.net>
 <20190515111232.lu3ifr72mlhfriqc@salvia>
 <20190515114617.GB4851@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515114617.GB4851@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 15, 2019 at 01:46:17PM +0200, Phil Sutter wrote:
> On Wed, May 15, 2019 at 01:12:32PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, May 15, 2019 at 01:02:05PM +0200, Fernando Fernandez Mancera wrote:
> > > 
> > > 
> > > On 5/15/19 12:58 PM, Phil Sutter wrote:
> > > > Hey,
> > > > 
> > > > On Tue, May 14, 2019 at 11:13:40PM +0200, Fernando Fernandez Mancera wrote:
> > > > [...]
> > > >> diff --git a/src/datatype.c b/src/datatype.c
> > > >> index 6aaf9ea..7e9ec5e 100644
> > > >> --- a/src/datatype.c
> > > >> +++ b/src/datatype.c
> > > >> @@ -297,11 +297,22 @@ static void verdict_type_print(const struct expr *expr, struct output_ctx *octx)
> > > >>  	}
> > > >>  }
> > > >>  
> > > >> +static struct error_record *verdict_type_parse(const struct expr *sym,
> > > >> +					       struct expr **res)
> > > >> +{
> > > >> +	*res = constant_expr_alloc(&sym->location, &string_type,
> > > >> +				   BYTEORDER_HOST_ENDIAN,
> > > >> +				   (strlen(sym->identifier) + 1) * BITS_PER_BYTE,
> > > >> +				   sym->identifier);
> > > >> +	return NULL;
> > > >> +}
> > > > 
> > > > One more thing: The above lacks error checking of any kind. I *think*
> > > > this is the place where one should make sure the symbol expression is
> > > > actually a string (but I'm not quite sure how you do that).
> > > > 
> > > > In any case, please try to exploit that variable support in the testcase
> > > > (or maybe a separate one), just to make sure we don't allow weird
> > > > things.
> > > > 
> > > 
> > > I think I can get the symbol type and check if it is a string. I will
> > > check this on the testcase as you said. Thanks!
> > 
> > There's not much we can do in this case I think, have a look at
> > string_type_parse().
> 
> OK, maybe it's not as bad as I feared, symbol_parse() is called only if
> we do have a symbol expr. Still I guess we should make sure nft
> complains if the variable points to any other primary_expr or a set
> reference ('@<something>').

'@<something>' is currently allowed, as any arbitrary string can be
placed in between strings - although in some way this is taking us
back to the quote debate that needs to be addressed. If we want to
disallow something enclosed in quotes then we'll have to apply this
function everywhere we allow variables.
