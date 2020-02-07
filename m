Return-Path: <SRS0=l6lg=33=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88641C2BA83
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Feb 2020 17:59:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6529C214AF
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Feb 2020 17:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgBGR7F (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Feb 2020 12:59:05 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:52030 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbgBGR7E (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Feb 2020 12:59:04 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1j07uA-0005rW-MX; Fri, 07 Feb 2020 18:59:02 +0100
Date:   Fri, 7 Feb 2020 18:59:02 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 2/2] scanner: Extend asteriskstring definition
Message-ID: <20200207175902.GB19873@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200206113828.7306-1-phil@nwl.cc>
 <20200206113828.7306-2-phil@nwl.cc>
 <20200207173140.hhqav2g6ckxnibmy@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200207173140.hhqav2g6ckxnibmy@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Fri, Feb 07, 2020 at 06:31:40PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Feb 06, 2020 at 12:38:28PM +0100, Phil Sutter wrote:
> > Accept sole escaped asterisks as well as unescaped asterisks if
> > surrounded by strings. The latter is merely cosmetic, but literal
> > asterisk will help when translating from iptables where asterisk has no
> > special meaning.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  src/scanner.l | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/src/scanner.l b/src/scanner.l
> > index 99ee83559d2eb..da9bacee23eb5 100644
> > --- a/src/scanner.l
> > +++ b/src/scanner.l
> > @@ -120,7 +120,7 @@ numberstring	({decstring}|{hexstring})
> >  letter		[a-zA-Z]
> >  string		({letter}|[_.])({letter}|{digit}|[/\-_\.])*
> >  quotedstring	\"[^"]*\"
> > -asteriskstring	({string}\*|{string}\\\*)
> > +asteriskstring	({string}\*|{string}\\\*|\\\*|{string}\*{string})
> 
> Probably this:
> 
>         {string}\\\*{string})
> 
> instead of:
> 
>         {string}\*{string})
> 
> ?
> 
> The escaping makes it probably clear that there is no support for
> infix wildcard matching?

Ah, you're right. I assumed it wasn't necessary to escape the asterisk
mid-string, but if we ever added support for infix wildcards (no matter
how unlikely) we were in real trouble.

BTW: Given how confusing bison-generated error messages are, maybe I
should introduce "infixasteriskstring" in scanner.l to catch unescaped
infix asterisks and generate a readable error message from there?

> This asteriskstring rule is falling under the string rule in bison.
> This is allowing to use \\\* for log messages too, and elsewhere.

Ah, that's right. Good, bad, ugly? Just a "neutral remark" from you? :)

Thanks, Phil
