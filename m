Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 999BBC4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Nov 2022 13:46:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236933AbiKWNqX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Nov 2022 08:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235953AbiKWNqH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Nov 2022 08:46:07 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626DED112
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Nov 2022 05:34:28 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1oxptS-00022x-ON; Wed, 23 Nov 2022 14:34:26 +0100
Date:   Wed, 23 Nov 2022 14:34:26 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables-nft RFC 1/5] nft-shared: dump errors on stdout to
 garble output
Message-ID: <Y34hYgdBOdpAFWJP@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20221121111932.18222-1-fw@strlen.de>
 <20221121111932.18222-2-fw@strlen.de>
 <Y30NJTaQx8Wn7RLE@orbyte.nwl.cc>
 <20221123125032.GA2753@breakpoint.cc>
 <Y34cjdOo11JO8J7/@orbyte.nwl.cc>
 <20221123132749.GB2753@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123132749.GB2753@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 23, 2022 at 02:27:49PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > > Huh?
> > > iptables-restore < bla
> > > iptables-restore v1.8.8 (nf_tables): unknown option "--bla"
> > > Error occurred at line: 7 Try `iptables-restore -h' or 'iptables-restore --help' for more information.
> > > 
> > > ... exits with 2.
> > > 
> > > Can you give an example?
> > 
> > # nft add table ip filter '{ chain FORWARD { \
> > 	type filter hook forward priority filter; \
> > 	ip saddr 10.1.2.3 meta cpu 3 counter accept; }; }'
> > 
> > # nft list ruleset 
> > table ip filter {
> > 	chain FORWARD {
> > 		type filter hook forward priority filter; policy accept;
> > 		ip saddr 10.1.2.3 meta cpu 3 counter packets 0 bytes 0 accept
> > 	}
> > }
> > 
> > # iptables-nft -S FORWARD
> > -P FORWARD ACCEPT
> > -A FORWARD -s 10.1.2.3/32 -j ACCEPT
> > # echo $?
> > 0
> 
> Ah.  I thought you were talking about iptables-restore/rule parsing.

No, my point is that in 'iptables-save | iptables-restore' the first
command should fail already if kernel ruleset is unparseable. :)

Cheers, Phil
