Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B0DBC433E6
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Jan 2021 19:09:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 024F922CE3
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Jan 2021 19:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbhAZF6q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:58:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728790AbhAYQAS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Jan 2021 11:00:18 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A49DC06174A
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Jan 2021 07:02:59 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1l43OE-0003KE-8C; Mon, 25 Jan 2021 16:02:50 +0100
Date:   Mon, 25 Jan 2021 16:02:50 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, Lukas Wunner <lukas@wunner.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Laura Garcia Liebana <nevola@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, Thomas Graf <tgraf@suug.ch>
Subject: Re: [netfilter-core] [PATCH nft v4] src: Support netdev egress hook
Message-ID: <20210125150250.GK3158@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, Lukas Wunner <lukas@wunner.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Laura Garcia Liebana <nevola@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, Thomas Graf <tgraf@suug.ch>
References: <4b3c95a0449591c97f68be15d8d17bda298a7b5e.1611498014.git.lukas@wunner.de>
 <20210125132238.GG3158@orbyte.nwl.cc>
 <20210125133405.GR19605@breakpoint.cc>
 <20210125134432.GH3158@orbyte.nwl.cc>
 <20210125143157.GA11062@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125143157.GA11062@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Mon, Jan 25, 2021 at 03:31:57PM +0100, Pablo Neira Ayuso wrote:
> On Mon, Jan 25, 2021 at 02:44:32PM +0100, Phil Sutter wrote:
> > On Mon, Jan 25, 2021 at 02:34:05PM +0100, Florian Westphal wrote:
> > > Phil Sutter <phil@nwl.cc> wrote:
> > > > > diff --git a/tests/py/inet/ip.t.payload.netdev b/tests/py/inet/ip.t.payload.netdev
> > > > > index 95be919..38ed0ad 100644
> > > > > --- a/tests/py/inet/ip.t.payload.netdev
> > > > > +++ b/tests/py/inet/ip.t.payload.netdev
> > > > > @@ -12,3 +12,17 @@ netdev test-netdev ingress
> > > > >    [ payload load 6b @ link header + 6 => reg 10 ]
> > > > >    [ lookup reg 1 set __set%d ]
> > > > >  
> > > > > +# meta protocol ip ip saddr . ip daddr . ether saddr { 1.1.1.1 . 2.2.2.2 . ca:fe:ca:fe:ca:fe }
> > > > > +__set%d test-netdev 3
> > > > > +__set%d test-netdev 0
> > > > > +	element 01010101 02020202 fecafeca 0000feca  : 0 [end]
> > > > > +netdev test-netdev egress 
> > > > > +  [ meta load protocol => reg 1 ]
> > > > > +  [ cmp eq reg 1 0x00000008 ]
> > > > > +  [ meta load iiftype => reg 1 ]
> > >                    ~~~~~~~
> > > 
> > > shouldn't nft add oiftype for egress?
> > 
> > Oh, you're right. So I "take everything back and claim the opposite". ;)
> > To cover for the different dependency expressions, we need to introduce
> > hook-specific payload files. :/
> 
> I'm planning to generalize iftype to check for iiftype from the
> ingress path and oiftype from the egress path. This check is there to
> make sure this is an ethernet device. This can be done once this hook
> hits net-next.

Maybe a dumb question, but doesn't the meta protocol match suffice? If
not, can it pass while the following iftype check then fails?

Cheers, Phil
