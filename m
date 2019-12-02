Return-Path: <SRS0=20nZ=ZY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91767C432C0
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 19:27:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D06520833
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 19:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbfLBT1W (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 14:27:22 -0500
Received: from correo.us.es ([193.147.175.20]:40002 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727686AbfLBT1V (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 14:27:21 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7170FB6B8D
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Dec 2019 20:27:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6147DDA737
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Dec 2019 20:27:18 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 633C2DA80C; Mon,  2 Dec 2019 20:27:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3FAA9DA808;
        Mon,  2 Dec 2019 20:27:10 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 02 Dec 2019 20:27:10 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1B7134265A5A;
        Mon,  2 Dec 2019 20:27:10 +0100 (CET)
Date:   Mon, 2 Dec 2019 20:27:11 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org,
        Brett Mastbergen <bmastbergen@untangle.com>
Subject: Re: [nft PATCH v3] src: Support maps as left side expressions
Message-ID: <20191202192711.uv6ercspf6ibsvue@salvia>
References: <20191130135321.5188-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191130135321.5188-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Nov 30, 2019 at 02:53:21PM +0100, Phil Sutter wrote:
> From: Brett Mastbergen <bmastbergen@untangle.com>
> 
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
> 
> Signed-off-by: Brett Mastbergen <bmastbergen@untangle.com>
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> v2: Add testcases
> v3: Support maps on vmap LHS
> 
> Pablo, Brett,
> 
> Reading the discussion about pending v2 of this patch I gave it a try
> and extending functionality to verdict maps was easy and
> straightforward, so I just went ahead and extended the code accordingly.

Nice, thanks a lot for following up on this.

There is still one more case we have to cover and we go:

$ sudo nft add rule x z ip saddr map { 1.1.1.1 : 22 } vmap { 22 : accept }
Error: No symbol type information
add rule x z ip saddr map { 1.1.1.1 : 22 } vmap { 22 : accept }
                                      ^^

The existing syntax does not give us a chance to specify the right
hand side datatype. For named sets, this is fine because the set
reference implicit gives us the datatype. This information is not
available on implicit sets.

I think we have to update the syntax to include this information. For
the named set case, this will allow us to validate that actually the
specified selector and the set datatype are matching. For the implicit
sets, this will give us the datatype for the right hand side.

Otherwise, I'm afraid we will have to deal with variable length
integer, which will make things more complicated. At this stage, I
would start with strict typing, later on we can probably relax this in
the future as we find a way to reasonable infer information. This
means that a more verbose syntax, but I think that is fine.
