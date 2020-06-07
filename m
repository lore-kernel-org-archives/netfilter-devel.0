Return-Path: <SRS0=+9KY=7U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9F90C433E0
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Jun 2020 22:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0CFB2075A
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Jun 2020 22:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgFGWIP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 7 Jun 2020 18:08:15 -0400
Received: from correo.us.es ([193.147.175.20]:56992 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbgFGWIP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Jun 2020 18:08:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 309A280B05
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jun 2020 00:08:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 210ACDA73F
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jun 2020 00:08:13 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 16355DA72F; Mon,  8 Jun 2020 00:08:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D9B97DA722;
        Mon,  8 Jun 2020 00:08:10 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 08 Jun 2020 00:08:10 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id BC48F426CCB9;
        Mon,  8 Jun 2020 00:08:10 +0200 (CEST)
Date:   Mon, 8 Jun 2020 00:08:10 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Rick van Rein <rick@openfortress.nl>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: Expressive limitation: (daddr,dport) <--> (daddr',dport')
Message-ID: <20200607220810.GA6604@salvia>
References: <5EDC7662.1070002@openfortress.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5EDC7662.1070002@openfortress.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Rick,

On Sun, Jun 07, 2020 at 07:08:50AM +0200, Rick van Rein wrote:
> Hello,
> 
> I seem to be running into an expressive limitation of nft while trying
> to do stateless translation.  I prefer statelessness because it it is
> clearer for bidirectionality / peering, and saves lookup times.
> 
> After nat64, I have a small set of IPv6 addresses and I would like to
> map their (daddr,dport) or better even (daddr,proto,dport) tuples to
> outgoing (daddr',dport').  Effectively, port forwarding for IPv6.
> 
> Individual rules work, like this one side of a bidir portmap:
> 
> nft add rule ip6 raw prerouting \
>    ip6 daddr $PREFIX::64:75 \
>    tcp dport 8080 \
>    ip6 daddr set $PREFIX::100:20 \
>    tcp dport set 80 \
>    notrack
> 
> I have problems doing this with the map construct, presumably because it
> does not atomically replace (daddr,dport) by (daddr',dport') but instead
> does two assignments with intermediate alterede state.

Right.

> This is bound to work in many cases, but it can give undesired
> crossover behaviours [namely between incoming IPs if they map to the
> same daddr' while coming from the same dport]:
> 
> nft add rule ip6 raw prerouting \
>    ip6 daddr set \
>       ip6 daddr . tcp dport \
>          map { $PREFIX::64:75 . 8080 : $PREFIX::100:20 } \
>    tcp dport set \
>       ip6 daddr . tcp dport \
>          map { $PREFIX::100:20 . 8080 : 80 } \

So, you would consolidate this in one single rule? So there is one
single lookup to obtain the IP address and the destination port for
the stateless packet mangling.

>    notrack
> 
> So now I am wondering,
> 
>  0. Is there a way to use maps as atomic setter for (daddr,dport)?

Not yet.

>  1. Can I reach back to the original value of a just-modified value?

You mean, the original header field that was just mangled? Like
matching on the former IP address before the mangling?

>  2. Is there a variable, or stack, to prepare with the old value?

But this is to achieve the atomic mangling that you describe above or
you have something else in mind? You would like to store the former IP
daddr in some scratchpad area that can be accessed later on, right?

Thanks.
