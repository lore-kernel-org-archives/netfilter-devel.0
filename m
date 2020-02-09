Return-Path: <SRS0=cwjY=35=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 080B5C2BA83
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 Feb 2020 22:21:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF8B020820
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 Feb 2020 22:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgBIWVs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 9 Feb 2020 17:21:48 -0500
Received: from correo.us.es ([193.147.175.20]:53788 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726843AbgBIWVs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 9 Feb 2020 17:21:48 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0CD8B6EAF0
        for <netfilter-devel@vger.kernel.org>; Sun,  9 Feb 2020 23:21:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F34B4DA702
        for <netfilter-devel@vger.kernel.org>; Sun,  9 Feb 2020 23:21:46 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E8E39DA711; Sun,  9 Feb 2020 23:21:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 17AA4DA702;
        Sun,  9 Feb 2020 23:21:45 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 09 Feb 2020 23:21:45 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id EEE2B41E4800;
        Sun,  9 Feb 2020 23:21:44 +0100 (CET)
Date:   Sun, 9 Feb 2020 23:21:43 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 2/2] scanner: Extend asteriskstring definition
Message-ID: <20200209222143.inqrt7dehomhe7no@salvia>
References: <20200206113828.7306-1-phil@nwl.cc>
 <20200206113828.7306-2-phil@nwl.cc>
 <20200207173140.hhqav2g6ckxnibmy@salvia>
 <20200207175902.GB19873@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200207175902.GB19873@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Feb 07, 2020 at 06:59:02PM +0100, Phil Sutter wrote:
> Hi Pablo,
> 
> On Fri, Feb 07, 2020 at 06:31:40PM +0100, Pablo Neira Ayuso wrote:
> > On Thu, Feb 06, 2020 at 12:38:28PM +0100, Phil Sutter wrote:
> > > Accept sole escaped asterisks as well as unescaped asterisks if
> > > surrounded by strings. The latter is merely cosmetic, but literal
> > > asterisk will help when translating from iptables where asterisk has no
> > > special meaning.
> > > 
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > ---
> > >  src/scanner.l | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/src/scanner.l b/src/scanner.l
> > > index 99ee83559d2eb..da9bacee23eb5 100644
> > > --- a/src/scanner.l
> > > +++ b/src/scanner.l
> > > @@ -120,7 +120,7 @@ numberstring	({decstring}|{hexstring})
> > >  letter		[a-zA-Z]
> > >  string		({letter}|[_.])({letter}|{digit}|[/\-_\.])*
> > >  quotedstring	\"[^"]*\"
> > > -asteriskstring	({string}\*|{string}\\\*)
> > > +asteriskstring	({string}\*|{string}\\\*|\\\*|{string}\*{string})
> > 
> > Probably this:
> > 
> >         {string}\\\*{string})
> > 
> > instead of:
> > 
> >         {string}\*{string})
> > 
> > ?
> > 
> > The escaping makes it probably clear that there is no support for
> > infix wildcard matching?
> 
> Ah, you're right. I assumed it wasn't necessary to escape the asterisk
> mid-string, but if we ever added support for infix wildcards (no matter
> how unlikely) we were in real trouble.

Yes, I don't expect mid-string matching in the future, but you never
know, so better reserve this just in case :-)

> BTW: Given how confusing bison-generated error messages are, maybe I
> should introduce "infixasteriskstring" in scanner.l to catch unescaped
> infix asterisks and generate a readable error message from there?

bison syntax error reporting is not great, yes. If you think that
makes it easier for error reporting as a short term way to address the
issue, that's fine with me.

> > This asteriskstring rule is falling under the string rule in bison.
> > This is allowing to use \\\* for log messages too, and elsewhere.
> 
> Ah, that's right. Good, bad, ugly? Just a "neutral remark" from you? :)

Just a remark, no issue.
