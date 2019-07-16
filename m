Return-Path: <SRS0=/Fuh=VN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9465EC7618F
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 18:26:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 534692145D
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 18:26:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388369AbfGPS0N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jul 2019 14:26:13 -0400
Received: from mail.us.es ([193.147.175.20]:57418 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728121AbfGPS0M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jul 2019 14:26:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AEC59BEBA7
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 20:26:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E93A96165
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 20:26:10 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9421121FE4; Tue, 16 Jul 2019 20:26:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C6458DA708;
        Tue, 16 Jul 2019 20:26:07 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 16 Jul 2019 20:26:07 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A1F714265A31;
        Tue, 16 Jul 2019 20:26:07 +0200 (CEST)
Date:   Tue, 16 Jul 2019 20:26:07 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>,
        Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        charles@ccxtechnologies.com
Subject: Re: [PATCH nft] evaluate: bogus error when refering to existing
 non-base chain
Message-ID: <20190716182607.wdqq2de7nz2s5gce@salvia>
References: <20190716115120.21710-1-pablo@netfilter.org>
 <20190716164711.GF1628@orbyte.nwl.cc>
 <63707D89-2251-4B96-BE53-880E12FF0F6A@riseup.net>
 <20190716180004.dwueos7c4yn75udi@breakpoint.cc>
 <20190716181253.dtmvpgqiykgx563m@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190716181253.dtmvpgqiykgx563m@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 16, 2019 at 08:12:53PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Jul 16, 2019 at 08:00:04PM +0200, Florian Westphal wrote:
> > Fernando Fernandez Mancera <ffmancera@riseup.net> wrote:
> > > El 16 de julio de 2019 18:47:11 CEST, Phil Sutter <phil@nwl.cc> escribió:
> > > >Hi Pablo,
> > > >
> > > >On Tue, Jul 16, 2019 at 01:51:20PM +0200, Pablo Neira Ayuso wrote:
> > > >[...]
> > > >> diff --git a/src/evaluate.c b/src/evaluate.c
> > > >> index f95f42e1067a..cd566e856a11 100644
> > > >> --- a/src/evaluate.c
> > > >> +++ b/src/evaluate.c
> > > >> @@ -1984,17 +1984,9 @@ static int stmt_evaluate_verdict(struct
> > > >eval_ctx *ctx, struct stmt *stmt)
> > > >>  	case EXPR_VERDICT:
> > > >>  		if (stmt->expr->verdict != NFT_CONTINUE)
> > > >>  			stmt->flags |= STMT_F_TERMINAL;
> > > >> -		if (stmt->expr->chain != NULL) {
> > > >> -			if (expr_evaluate(ctx, &stmt->expr->chain) < 0)
> > > >> -				return -1;
> > > >> -			if ((stmt->expr->chain->etype != EXPR_SYMBOL &&
> > > >> -			    stmt->expr->chain->etype != EXPR_VALUE) ||
> > > >> -			    stmt->expr->chain->symtype != SYMBOL_VALUE) {
> > > >> -				return stmt_error(ctx, stmt,
> > > >> -						  "invalid verdict chain expression %s\n",
> > > >> -						  expr_name(stmt->expr->chain));
> > > >> -			}
> > > >> -		}
> > > >
> > > >According to my logs, this bit was added by Fernando to cover for
> > > >invalid variable values[1]. So I fear we can't just drop this check.
> > > >
> > > >Cheers, Phil
> > > >
> > > >[1] I didn't check with current sources, but back then the following
> > > >    variable contents were problematic:
> > > >
> > > >    * define foo = @set1 (a set named 'set1' must exist)
> > > >    * define foo = { 1024 }
> > > >    * define foo = *
> > > 
> > > Yes I am looking to the report and why current version fails when the jump is to a non-base chain because I tested that some months ago.
> > > 
> > > I will catch up with more details in a few hours. Sorry for the inconveniences.
> > 
> > Fernando, in case Pablos patch v2 fixes the reported bug, could you
> > followup with a test case?  It would help when someone tries to remove
> > "unneeded code" in the future ;-)
> 
> I'm not sure it's worth a test for this unlikely corner case.
> 
> There are thousands of paths where we're not performing strict
> expression validation as in this case... and if you really want to get
> this right.

Having said this, if you want a test for this specific case, I really
don't mind :-)
