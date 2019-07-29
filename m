Return-Path: <SRS0=chdK=V2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39FAEC433FF
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Jul 2019 14:57:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 145162171F
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Jul 2019 14:57:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbfG2O5b (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 Jul 2019 10:57:31 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:35262 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726281AbfG2O5a (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Jul 2019 10:57:30 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hs75c-00044g-Pz; Mon, 29 Jul 2019 16:57:28 +0200
Date:   Mon, 29 Jul 2019 16:57:28 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Brett Mastbergen <bmastbergen@untangle.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: Support maps as left side expressions
Message-ID: <20190729145728.a52k3gwmvkc7s6lz@breakpoint.cc>
References: <20190729143450.5733-1-bmastbergen@untangle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729143450.5733-1-bmastbergen@untangle.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Brett Mastbergen <bmastbergen@untangle.com> wrote:
> This change allows map expressions on the left side of comparisons:
> 
> nft add rule foo bar ip saddr map @map_a == 22 counter
> 
> It also allows map expressions as the left side expression of other
> map expressions:
> 
> nft add rule foo bar ip saddr map @map_a map @map_b == 22 counter
> 
> To accomplish this, some additional context needs to be set during
> evaluation and delinearization.  A tweak is also make to the parser
> logic to allow map expressions as the left hand expression to other
> map expressions.
> 
> By allowing maps as left side comparison expressions one can map
> information in the packet to some arbitrary piece of data and use
> the equality (or inequality) to make some decision about the traffic,
> unlike today where the result of a map lookup is only usable as the
> right side of a statement (like dnat or snat) that actually uses the
> value as input.

Can you add a test case for this?

FWIW, this appears to work fine:

table inet filter {
        map map_a {
                type ipv4_addr : mark
                elements = { 127.0.0.1 : 0x0000002a }
        }

        map map_b {
                type mark : inet_service
                elements = { 0x0000002a : 22 }
        }

        chain input {
                type filter hook input priority filter; policy accept;
                ip saddr map @map_a map @map_b 22 counter
        }
}

inet filter input
  [ meta load nfproto => reg 1 ]
  [ cmp eq reg 1 0x00000002 ]
  [ payload load 4b @ network header + 12 => reg 1 ]
  [ lookup reg 1 set map_a dreg 1 ] # looks up ipv4 addr in map_a
  [ lookup reg 1 set map_b dreg 1 ] # looks up mark in map_b 
  [ cmp eq reg 1 0x00001600 ]	    # cmp port number from map_b with 22
  [ counter pkts 0 bytes 0 ]

... so this looks good to me.

Guess its time for me to work on typeof() keyword again
so we can have strings in named sets.
