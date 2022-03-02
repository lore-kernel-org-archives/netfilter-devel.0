Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC45C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Mar 2022 13:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242228AbiCBNbU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Mar 2022 08:31:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242246AbiCBNbT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Mar 2022 08:31:19 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D6AC4E3B
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2022 05:30:33 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nPP3m-0002tm-6b; Wed, 02 Mar 2022 14:30:30 +0100
Date:   Wed, 2 Mar 2022 14:30:30 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        kadlec@netfilter.org, hmmsjan@kpnplanet.nl
Subject: Re: TCP connection fails in a asymmetric routing situation
Message-ID: <20220302133030.GA8249@breakpoint.cc>
References: <20220225123030.GK28705@breakpoint.cc>
 <Yh9VyPluvrmNQWUz@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh9VyPluvrmNQWUz@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Conntrack needs to see traffic in both directions, otherwise it is
> pickup the state from the middle from time to time (part of the
> history is lost for us).
> 
> What am I missing here?

Connectivity breaks.

First packet that conntrack picks up is the syn-ack, this results in
following sequence:

1. SYN    x:12345 -> y -> 443 // sent by initiator, receiverd by responder
2. SYNACK y:443 -> x:12345 // First packet seen by conntrack, as sent by responder
3. tuple_force_port_remap() gets called, sees:
  'tcp from 443 to port 12345 NAT' -> pick a new source port, inititor receives
4. SYNACK y:$RANDOM -> x:12345   // connection is never established

This needs:
1. conntrack + nat enabled
2. connection is forwarded between two different machines
3. SYN packet is sent by a different route so conntrack only
sees return traffic.

This broke before as well if you would e.g. add 'masquerade random'
rule, but now the nat core does that automatically due to the 'port
shadow avoidance' change.
