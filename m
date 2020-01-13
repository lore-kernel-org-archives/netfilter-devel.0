Return-Path: <SRS0=xASF=3C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC6F2C33CAD
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jan 2020 14:04:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DEBD20678
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jan 2020 14:04:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbgAMOEr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Jan 2020 09:04:47 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:44304 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728621AbgAMOEr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Jan 2020 09:04:47 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ir0Kj-0005mT-77; Mon, 13 Jan 2020 15:04:45 +0100
Date:   Mon, 13 Jan 2020 15:04:45 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [RFC nf-next 0/4] netfilter: conntrack: allow insertion of
 clashing entries
Message-ID: <20200113140445.GI795@breakpoint.cc>
References: <20200108134500.31727-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200108134500.31727-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> This series allows conntrack to insert a duplicate conntrack entry
> if the reply direction doesn't result in a clash with a different
> original connection.
> 
> Background:
> 
> kubernetes creates load-balancing rules for DNS using
> -m statistics, e.g.:
> -p udp --dport 53 -m statistics --mode random ... -j DNAT --to-destination x
> -p udp --dport 53 -m statistics --mode random ... -j DNAT --to-destination y
> 
> When the resolver sends an A and AAAA request back-to-back from
> different threads on the same socket, this has a high chance of a connection
> tracking clash at insertion time.
> 
> This in turn results in a drop of the clashing udp packet which then
> results in a 5 second DNS timeout.

I'd really like to get feedback for this patch set.

If its deemed unacceptable thats OK, at least I can then tell users they
must change their rulesets to make this work.

If someone has alternative ideas on how to resolve this I'd be
interested as well.
