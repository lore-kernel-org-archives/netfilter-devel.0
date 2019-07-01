Return-Path: <SRS0=danl=U6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AC49C0650E
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 18:13:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32C1A20B7C
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 18:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfGASNq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Jul 2019 14:13:46 -0400
Received: from mail.us.es ([193.147.175.20]:49238 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726846AbfGASNq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Jul 2019 14:13:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2DEF11324C5
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Jul 2019 20:13:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1CA3BFB37C
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Jul 2019 20:13:44 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 11F6CDA704; Mon,  1 Jul 2019 20:13:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E20D8DA732;
        Mon,  1 Jul 2019 20:13:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 01 Jul 2019 20:13:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id BF01D4265A31;
        Mon,  1 Jul 2019 20:13:41 +0200 (CEST)
Date:   Mon, 1 Jul 2019 20:13:41 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2] parser_bison: Accept arbitrary user-defined names
 by quoting
Message-ID: <20190701181341.na3v3jmk2hejlmyq@salvia>
References: <20190624163608.17348-1-phil@nwl.cc>
 <20190628180051.47o27vbgqrsjpwab@salvia>
 <20190701161139.GQ31548@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701161139.GQ31548@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 01, 2019 at 06:11:39PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Fri, Jun 28, 2019 at 08:00:51PM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Jun 24, 2019 at 06:36:08PM +0200, Phil Sutter wrote:
> > > Parser already allows to quote user-defined strings in some places to
> > > avoid clashing with defined keywords, but not everywhere. Extend this
> > > support further and add a test case for it.
> > > 
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > ---
> > > Changes since v1:
> > > - Fix testcase, I forgot to commit adjustments done to it.
> > > 
> > > Note: This is a reduced variant of "src: Quote user-defined names" sent
> > >       back in January. Discussion was not conclusive regarding whether
> > >       to quote these names on output or not, but I assume allowing for
> > >       users to specify them by adding quotes is a step forward without
> > >       drawbacks.
> > 
> > So this will fail later on, right?
> > 
> >         nft list ruleset > file.nft
> >         nft -f file.nft
> 
> Yes, that's right. I sent a complete version which does the necessary
> quoting on output in January[1], but discussion wasn't conclusive. You
> had a different approach which accepts the quotes as part of the name
> but you weren't happy with it, either. I *think* you wanted to search
> for ways to solve this from within bison but we never got back to it
> anymore.
> 
> This simplified patch is merely trying to make things consistent
> regarding user-defined names. IIRC, I can already have an interface
> named "month", use that in a netdev family chain declaration (quoted)
> and 'nft list ruleset' will print it unquoted, so it can't be applied
> anymore. Without my patch, it is simply impossible to use certain
> recognized keywords as names for tables, chains, etc., even if one
> accepted the implications it has.

I'm not arguing there's something to fix.

I'm telling this is still incomplete.

Would you allocate a bit of time to discuss this during the NFWS?
