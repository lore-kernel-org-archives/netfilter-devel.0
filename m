Return-Path: <SRS0=FCuH=V3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45640C0650F
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 14:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2141F20659
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 14:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730034AbfG3OSv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Jul 2019 10:18:51 -0400
Received: from correo.us.es ([193.147.175.20]:53624 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbfG3OSv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Jul 2019 10:18:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B919A11ED88
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jul 2019 16:18:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A9806D1929
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jul 2019 16:18:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9F261461; Tue, 30 Jul 2019 16:18:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9331CFF6CC;
        Tue, 30 Jul 2019 16:18:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 30 Jul 2019 16:18:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [47.60.32.83])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 321F84265A32;
        Tue, 30 Jul 2019 16:18:47 +0200 (CEST)
Date:   Tue, 30 Jul 2019 16:18:45 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 0/2] parser_bison: Get rid of (most) bison
 compiler warnings
Message-ID: <20190730141845.exhy3tshlbdjnknj@salvia>
References: <20190723132313.13238-1-phil@nwl.cc>
 <20190730124106.5edmsjwzzgknpnjs@salvia>
 <20190730140354.GO14469@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730140354.GO14469@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 30, 2019 at 04:03:54PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Tue, Jul 30, 2019 at 02:41:06PM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Jul 23, 2019 at 03:23:11PM +0200, Phil Sutter wrote:
> > > Eliminate as many bison warnings emitted since bison-3.3 as possible.
> > > Sadly getting bison, flex and automake right is full of pitfalls so on
> > > one hand this series does not fix for deprecated %name-prefix statement
> > > and on the other passes -Wno-yacc to bison to not complain about POSIX
> > > incompatibilities although automake causes to run bison in POSIX compat
> > > mode in the first place. Fixing either of those turned out to be
> > > non-trivial.
> > 
> > Indeed, lots of warnings and things to be updated.
> > 
> > Do you think it's worth fixing those in the midterm?
> > 
> > We can just place these two small ones in the tree, I'm just concerned
> > about tech debt in the midterm, these deprecated stuff might just go
> > away.
> 
> We should avoid calling bison with -y since the parser simply isn't
> POSIX yacc compatible. I found a trick somewhere in WWW to do that (one
> has to substitute AC_PROG_YACC) but lost the reference again. But after
> doing so, there was a problem with file names I failed to resolve.
> Hence why I resorted to just passing -Wno-yacc.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

If parser does not break with this and tests pass fine, I'm ok with
this temporary solution. I also need all most warnings go away here by
now.

Please, if you find that reference again share it with me.

Thanks.
