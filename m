Return-Path: <SRS0=J2Vc=4L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B31BC35671
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 22:38:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42ED6206E2
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 22:38:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgBWWiy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Feb 2020 17:38:54 -0500
Received: from correo.us.es ([193.147.175.20]:35888 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbgBWWix (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Feb 2020 17:38:53 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1E809ED5C0
        for <netfilter-devel@vger.kernel.org>; Sun, 23 Feb 2020 23:38:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 100F5DA7B6
        for <netfilter-devel@vger.kernel.org>; Sun, 23 Feb 2020 23:38:47 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 050C8DA736; Sun, 23 Feb 2020 23:38:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 330CCDA788;
        Sun, 23 Feb 2020 23:38:45 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 23 Feb 2020 23:38:45 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 15B1642EF4E0;
        Sun, 23 Feb 2020 23:38:45 +0100 (CET)
Date:   Sun, 23 Feb 2020 23:38:49 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] evaluate: don't eval unary arguments.
Message-ID: <20200223223849.ainqgs32iyd4wtbw@salvia>
References: <20200128184918.d663llqkrmaxyusl@salvia>
 <20200223221411.GA121279@azazel.net>
 <20200223222321.kjfsxjl6ftbcrink@salvia>
 <20200223223424.GZ19559@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200223223424.GZ19559@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Feb 23, 2020 at 11:34:24PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Sun, Feb 23, 2020 at 10:14:11PM +0000, Jeremy Sowden wrote:
> > > After giving this some thought, it occurred to me that this could be
> > > fixed by extending bitwise boolean operations to support a variable
> > > righthand operand (IIRC, before Christmas Florian suggested something
> > > along these lines to me in another, related context), so I've gone down
> > > that route.  Patches to follow shortly.
> > 
> > Would this require a new kernel extensions? What's the idea behind
> > this?
> 
> Something like this:
> nft ... ct mark set ct mark & 0xffff0000 | meta mark & 0xffff

I see, so this requires two source registers as input for nft_bitwise?
