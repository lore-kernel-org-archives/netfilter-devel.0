Return-Path: <SRS0=fe67=44=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D82DDC10F27
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Mar 2020 13:26:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4C5521655
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Mar 2020 13:26:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729660AbgCKN0T convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Mar 2020 09:26:19 -0400
Received: from correo.us.es ([193.147.175.20]:34428 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729611AbgCKN0T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Mar 2020 09:26:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id ADA0B1E2C67
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2020 14:25:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9CB3E11C4DB
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2020 14:25:54 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9250011C4C1; Wed, 11 Mar 2020 14:25:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 87E1311C4D9;
        Wed, 11 Mar 2020 14:25:52 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 11 Mar 2020 14:25:52 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6B3CC42EF42A;
        Wed, 11 Mar 2020 14:25:52 +0100 (CET)
Date:   Wed, 11 Mar 2020 14:26:13 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Florian Westphal <fw@strlen.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v3 18/18] tests: py: add variable binop RHS tests.
Message-ID: <20200311132613.c2onkaxo7uizzofs@salvia>
References: <20200303094844.26694-1-jeremy@azazel.net>
 <20200303094844.26694-19-jeremy@azazel.net>
 <20200310023913.uebkl7uywu4gkldn@salvia>
 <20200310093008.GA166204@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200310093008.GA166204@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jeremy,

On Tue, Mar 10, 2020 at 09:30:08AM +0000, Jeremy Sowden wrote:
> On 2020-03-10, at 03:39:13 +0100, Pablo Neira Ayuso wrote:
> > On Tue, Mar 03, 2020 at 09:48:44AM +0000, Jeremy Sowden wrote:
> > [...]
> > > diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
> > > index 661591257804..17a1c382ea65 100644
> > > --- a/tests/py/any/ct.t.payload
> > > +++ b/tests/py/any/ct.t.payload
> > > @@ -359,6 +359,39 @@ ip test-ip4 output
> > >    [ lookup reg 1 set __map%d dreg 1 ]
> > >    [ ct set mark with reg 1 ]
> > >
> > > +# ct mark set ct mark and 0xffff0000 or meta mark and 0xffff
> > > +ip
> > > +  [ ct load mark => reg 1 ]
> > > +  [ bitwise reg 1 = (reg=1 & 0xffff0000 ) ^ 0x00000000 ]
> >
> > These two are: ct mark and 0xffff0000
> >
> > > +  [ meta load mark => reg 2 ]
> > > +  [ bitwise reg 2 = (reg=2 & 0x0000ffff ) ^ 0xffffffff ]
> >
> > Refetch.
> >
> > > +  [ meta load mark => reg 3 ]
> > > +  [ bitwise reg 3 = (reg=3 & 0x0000ffff ) ^ 0x00000000 ]
> >
> > These two are: meta mark and 0xffff
> >
> > > +  [ bitwise reg 1 = (reg=1 & reg 2 ) ^ reg 3 ]
> >
> > This one is triggering the refetch from meta load in reg 2, right?
> >
> > If so, probably extend nft_bitwise to support for 'or' from two
> > registers would make things more simple?
> >
> >      [ bitwise reg 1 = (reg 1 | reg 3) ]
> >
> > This one requires two registers as input for this new OR operation.
> >
> > > +  [ ct set mark with reg 1 ]
> > > +
> > [...]
> > > diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
> > > index d627b22f2614..d6c5d14d52ac 100644
> > > --- a/tests/py/ip/ip.t.payload
> > > +++ b/tests/py/ip/ip.t.payload
> > [...]
> > > +# iif "lo" ip dscp set ip dscp or 0x3
> > > +ip
> > > +  [ meta load iif => reg 1 ]
> > > +  [ cmp eq reg 1 0x00000001 ]
> > > +  [ payload load 2b @ network header + 0 => reg 1 ]
> > > +  [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00000000 ]
> > > +  [ payload load 1b @ network header + 1 => reg 2 ]
> > > +  [ bitwise reg 2 = (reg=2 & 0x000000fc ) ^ 0x00000000 ]
> > > +  [ bitwise reg 2 = ( reg 2 >> 0x00000002 ) ]
> > > +  [ bitwise reg 2 = (reg=2 & 0x000000fc ) ^ 0x00000003 ]
> > > +  [ bitwise reg 2 = ( reg 2 << 0x00000002 ) ]
> > > +  [ bitwise reg 1 = (reg=1 & 0x0000ffff ) ^ reg 2 ]
> > > +  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
> >
> > Probably extending nft_bitwise again is the way to go to simplify
> > this?
> >
> > 1) fetch two bytes from payload => reg 1.
> > 2) reg 2 = ( reg 1 | 0x000c )
> >
> >    userspace 0x3 << 2 => 0x0c, then extend this to two bytes => 0x000c
> >
> > This is an OR with immediate value.
> >
> > 3) payload write reg 1
> >
> > This one requires two immediates.
> >
> > Then, how does 'ip dscp set ip dscp and 0x01' bytecode looks like?
> >
> > 1) fetch two bytes => reg 1.
> > 2) reg 1 = (reg 1 & 0xff07) ^ 0x0
> >
> > userspace 0x01 => 0x04 (after << 2). Then, 0x04 & 0xff03 = 0xff07.
> >
> > This case should be possible to support it with the existing bitwise.
> >
> > The delinearization path will need to calculate the closest field
> > matching, but there is already code for this in the userspace tree (it
> > was required when matching ip dscp using bitwise operation).
> >
> > Would it be possible to simplify all this through new kernel
> > extension? If so, I'm sorry for wasting resources, this might go to a
> > different direction than _MREG and _XREG.
> 
> No problem. :)
> 
> > Moreover, for field updates like in these examples, I wonder if it is
> > worth to introduce a new syntax, ie.
> >
> >         ip dscp |= 0x01
> >         ip dscp or_eq 0x01
> >
> >         ip dscp &= 0x01
> >         ip dscp and_eq 0x01
> >
> > | and & might be a problem for the shell, for the native nft cli this
> > should be fine. But this is a different issue.
> 
> Thanks for the feedback, Pablo.

Do you think it would be to keep back this one from the nf-next tree
until you evaluate an alternative way to extend nft_bitwise?

commit 8d1f378a51fcf2f5e44e06ff726a91c885d248cc
Author: Jeremy Sowden <jeremy@azazel.net>
Date:   Mon Feb 24 12:49:31 2020 +0000

    netfilter: bitwise: add support for passing mask and xor values in registers.

Thanks.
