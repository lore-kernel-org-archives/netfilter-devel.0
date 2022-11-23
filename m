Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 661ABC46467
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Nov 2022 13:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235918AbiKWNcf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Nov 2022 08:32:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236356AbiKWNbc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Nov 2022 08:31:32 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCFF8E0B0
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Nov 2022 05:13:52 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1oxpZW-0001rQ-09; Wed, 23 Nov 2022 14:13:50 +0100
Date:   Wed, 23 Nov 2022 14:13:49 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables-nft RFC 1/5] nft-shared: dump errors on stdout to
 garble output
Message-ID: <Y34cjdOo11JO8J7/@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20221121111932.18222-1-fw@strlen.de>
 <20221121111932.18222-2-fw@strlen.de>
 <Y30NJTaQx8Wn7RLE@orbyte.nwl.cc>
 <20221123125032.GA2753@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123125032.GA2753@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 23, 2022 at 01:50:32PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > What I don't like about this is that users won't notice the problem
> > until they try to restore the ruleset. For us it is clearly beneficial
> > to see where things break, but I doubt regular users care and we should
> > just tell them to stop mixing iptables and nft calls.
> 
> So what would you propose...?

I like the "table XXX is incompatible" because of how consequent it is.
But this is exactly orthogonal to your emphasis on "print as much as
possible", so not sure if we'll find a compromise. :)

> > Can we maybe add "--force" to iptables-nft-save to make it print as much
> > as possible despite the table being considered incompatible? Not sure
> > how ugly this is to implement, though.
> 
> I don't see this as useful thing because we already have "nft --debug=netlink".

What's your motivation to print parts of the rule which have been parsed
correctly? I assumed it is for debugging purposes.

> > We still exit(0) in case parsing fails, BTW. Guess this is the most
> > important thing to fix despite all the above.
> 
> Huh?
> iptables-restore < bla
> iptables-restore v1.8.8 (nf_tables): unknown option "--bla"
> Error occurred at line: 7 Try `iptables-restore -h' or 'iptables-restore --help' for more information.
> 
> ... exits with 2.
> 
> Can you give an example?

# nft add table ip filter '{ chain FORWARD { \
	type filter hook forward priority filter; \
	ip saddr 10.1.2.3 meta cpu 3 counter accept; }; }'

# nft list ruleset 
table ip filter {
	chain FORWARD {
		type filter hook forward priority filter; policy accept;
		ip saddr 10.1.2.3 meta cpu 3 counter packets 0 bytes 0 accept
	}
}

# iptables-nft -S FORWARD
-P FORWARD ACCEPT
-A FORWARD -s 10.1.2.3/32 -j ACCEPT
# echo $?
0

Note: this is without any of your pending patches applied, I might even
miss pushed commits. I just did this using the current iptables-nft I
have around, but I don't recall any patches changing iptables' return
code if any of the nft_parse_* functions fail.

Cheers, Phil
