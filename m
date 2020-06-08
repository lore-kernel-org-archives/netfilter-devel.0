Return-Path: <SRS0=kOBD=7V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6967C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jun 2020 10:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A100E2076A
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jun 2020 10:31:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729300AbgFHKbq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jun 2020 06:31:46 -0400
Received: from correo.us.es ([193.147.175.20]:51808 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726202AbgFHKbp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jun 2020 06:31:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5AA27FFAC7
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jun 2020 12:31:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4946BDA78C
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jun 2020 12:31:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3EF74DA78B; Mon,  8 Jun 2020 12:31:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1CB4ADA78F;
        Mon,  8 Jun 2020 12:31:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 08 Jun 2020 12:31:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 00B1E42EE38E;
        Mon,  8 Jun 2020 12:31:40 +0200 (CEST)
Date:   Mon, 8 Jun 2020 12:31:40 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Rick van Rein <rick@openfortress.nl>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: Expressive limitation: (daddr,dport) <--> (daddr',dport')
Message-ID: <20200608103140.GA15655@salvia>
References: <5EDC7662.1070002@openfortress.nl>
 <20200607220810.GA6604@salvia>
 <5EDE0C9B.2020701@openfortress.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5EDE0C9B.2020701@openfortress.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Rick,

On Mon, Jun 08, 2020 at 12:02:03PM +0200, Rick van Rein wrote:
> Hi Pablo / NFT-dev,
> 
> >> This is bound to work in many cases, but it can give undesired
> >> crossover behaviours [namely between incoming IPs if they map to the
> >> same daddr' while coming from the same dport]:
> >>
> >> nft add rule ip6 raw prerouting \
> >>    ip6 daddr set \
> >>       ip6 daddr . tcp dport \
> >>          map { $PREFIX::64:75 . 8080 : $PREFIX::100:20 } \
> >>    tcp dport set \
> >>       ip6 daddr . tcp dport \
> >>          map { $PREFIX::100:20 . 8080 : 80 } \
> > 
> > So, you would consolidate this in one single rule? So there is one
> > single lookup to obtain the IP address and the destination port for
> > the stateless packet mangling.
> 
> It already is a single rule, but a single mapping, or one that appears
> like one.  In reality, I use dynamic map @refs, of course.

Right, one single mapping.

> A single lookup would avoid the problem that the key has changed in the
> second lookup.
> 
> I played around, trying if I could "ip6 daddr . tcp dport set" and
> perhaps have a map with elements like "{ $PREFIX::64:75 . 8080 :
> $PREFIX::100:20 . 80 }" but did not find a syntax.  [I've been missing a
> formal syntax, it's all examples so I wasn't sure if this was possible
> at all.]  It'd look like
> 
> new_nft add rule ip6 raw prerouting \
>    ip6 daddr . tcp dport set \
>       ip6 daddr . tcp dport \
>          map { $PREFIX::64:75 . 8080 : $PREFIX::100:20 . 80 }

I see.

> >>  0. Is there a way to use maps as atomic setter for (daddr,dport)?
> > 
> > Not yet.
> 
> Ah, you spotted the problem too.  No surprise ;-)
> 
> >>  1. Can I reach back to the original value of a just-modified value?
> > 
> > You mean, the original header field that was just mangled? Like
> > matching on the former IP address before the mangling?
> 
> Yes, exactly.  That way, I can use two maps but find the right
> combination of addr/port without intermediate key changes.
> 
> >>  2. Is there a variable, or stack, to prepare with the old value?
> > 
> > But this is to achieve the atomic mangling that you describe above or
> > you have something else in mind? You would like to store the former IP
> > daddr in some scratchpad area that can be accessed later on, right?
> 
> It is another possible way to get to the old value so I can make the
> same mapping.
> 
> I could imagine storing the old daddr in daddr2 then mapping daddr and
> using daddr2 in the second map looking to find the matching port.  That
> might look like
> 
> new_nft add rule ip6 raw prerouting \
>    rulevar set ip6 daddr \
>    ip6 daddr set \
>       ip6 daddr . tcp dport \
>          map { $PREFIX::64:75 . 8080 : $PREFIX::100:20 } \
>    tcp dport set \
>       rulevar . tcp dport \
>          map { $PREFIX::100:20 . 8080 : 80 } \
> 
> If the language internally uses a stack, I could imagine pushing the old
> value(s) to prepare for the second map, then perform the first map and
> continue with the second.  That might look like
> 
> new_nft add rule ip6 raw prerouting \
>    ip6 daddr push \
>    ip6 daddr set \
>       ip6 daddr . tcp dport \
>          map { $PREFIX::64:75 . 8080 : $PREFIX::100:20 } \
>    tcp dport set \
>       pop . tcp dport \
>          map { $PREFIX::100:20 . 8080 : 80 } \
> 
> 
> The examples are just three syntaxes I can think of.

OK, but you only need this "stack" idea is alternative proposal to get
the "one single mapping" idea working, correct?

Thanks.
