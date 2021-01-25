Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F093C433E6
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Jan 2021 02:43:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFF7D22D58
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Jan 2021 02:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbhAYP4l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Jan 2021 10:56:41 -0500
Received: from correo.us.es ([193.147.175.20]:47384 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730617AbhAYPxt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Jan 2021 10:53:49 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 603A981413
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Jan 2021 16:52:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 500FEDA78C
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Jan 2021 16:52:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4F190DA78B; Mon, 25 Jan 2021 16:52:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1FE2EDA793;
        Mon, 25 Jan 2021 16:52:07 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 25 Jan 2021 16:52:07 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id DD52D426CC84;
        Mon, 25 Jan 2021 16:52:06 +0100 (CET)
Date:   Mon, 25 Jan 2021 16:53:04 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        Lukas Wunner <lukas@wunner.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Laura Garcia Liebana <nevola@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, Thomas Graf <tgraf@suug.ch>
Subject: Re: [netfilter-core] [PATCH nft v4] src: Support netdev egress hook
Message-ID: <20210125155303.GA27304@salvia>
References: <4b3c95a0449591c97f68be15d8d17bda298a7b5e.1611498014.git.lukas@wunner.de>
 <20210125132238.GG3158@orbyte.nwl.cc>
 <20210125133405.GR19605@breakpoint.cc>
 <20210125134432.GH3158@orbyte.nwl.cc>
 <20210125143157.GA11062@salvia>
 <20210125150250.GK3158@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210125150250.GK3158@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jan 25, 2021 at 04:02:50PM +0100, Phil Sutter wrote:
> Hi,
> 
> On Mon, Jan 25, 2021 at 03:31:57PM +0100, Pablo Neira Ayuso wrote:
> > On Mon, Jan 25, 2021 at 02:44:32PM +0100, Phil Sutter wrote:
> > > On Mon, Jan 25, 2021 at 02:34:05PM +0100, Florian Westphal wrote:
> > > > Phil Sutter <phil@nwl.cc> wrote:
> > > > > > diff --git a/tests/py/inet/ip.t.payload.netdev b/tests/py/inet/ip.t.payload.netdev
> > > > > > index 95be919..38ed0ad 100644
> > > > > > --- a/tests/py/inet/ip.t.payload.netdev
> > > > > > +++ b/tests/py/inet/ip.t.payload.netdev
> > > > > > @@ -12,3 +12,17 @@ netdev test-netdev ingress
> > > > > >    [ payload load 6b @ link header + 6 => reg 10 ]
> > > > > >    [ lookup reg 1 set __set%d ]
> > > > > >  
> > > > > > +# meta protocol ip ip saddr . ip daddr . ether saddr { 1.1.1.1 . 2.2.2.2 . ca:fe:ca:fe:ca:fe }
> > > > > > +__set%d test-netdev 3
> > > > > > +__set%d test-netdev 0
> > > > > > +	element 01010101 02020202 fecafeca 0000feca  : 0 [end]
> > > > > > +netdev test-netdev egress 
> > > > > > +  [ meta load protocol => reg 1 ]
> > > > > > +  [ cmp eq reg 1 0x00000008 ]
> > > > > > +  [ meta load iiftype => reg 1 ]
> > > >                    ~~~~~~~
> > > > 
> > > > shouldn't nft add oiftype for egress?
> > > 
> > > Oh, you're right. So I "take everything back and claim the opposite". ;)
> > > To cover for the different dependency expressions, we need to introduce
> > > hook-specific payload files. :/
> > 
> > I'm planning to generalize iftype to check for iiftype from the
> > ingress path and oiftype from the egress path. This check is there to
> > make sure this is an ethernet device. This can be done once this hook
> > hits net-next.
> 
> Maybe a dumb question, but doesn't the meta protocol match suffice? If
> not, can it pass while the following iftype check then fails?

I think so, yes, it should be possible to generate more efficient
bytecode if the rule pulls in the meta protocol. This dependency
should cancel the iftype match dependency.
