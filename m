Return-Path: <SRS0=kgPV=3D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E8E4C33C9E
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 21:15:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E783D24658
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 21:15:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="ZqXyHlfP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgANVPE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Jan 2020 16:15:04 -0500
Received: from smtp-out.kfki.hu ([148.6.0.46]:49463 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727285AbgANVPE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Jan 2020 16:15:04 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp1.kfki.hu (Postfix) with ESMTP id 74BF53C80127;
        Tue, 14 Jan 2020 22:15:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1579036499; x=1580850900; bh=T3rnTV9WMb
        vW0zsYdqIpMfaaooTJQP0Ze2DVyLvu1fQ=; b=ZqXyHlfP5w/zIakAL2CrAqRr0H
        FlV5upiQBt+bkyuS62qxdZlqzmMQXuudsdPB7OOmJbLWQav8vciMTBYG5bBQj1sX
        2H2V53Ek5yVOZe7X3cIGXUkl7S16G5Td+xOZAOcOoOOSDzQB40ywRONcuU5GBabk
        +/oF2iHKH0RSwpk6A=
X-Virus-Scanned: Debian amavisd-new at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
        by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Tue, 14 Jan 2020 22:14:59 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp1.kfki.hu (Postfix) with ESMTP id A76F73C80123;
        Tue, 14 Jan 2020 22:14:58 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 91424222A3; Tue, 14 Jan 2020 22:14:58 +0100 (CET)
Date:   Tue, 14 Jan 2020 22:14:58 +0100 (CET)
From:   =?UTF-8?Q?Kadlecsik_J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>
To:     Florian Westphal <fw@strlen.de>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [RFC nf-next 0/4] netfilter: conntrack: allow insertion of
 clashing entries
In-Reply-To: <20200113235309.GM795@breakpoint.cc>
Message-ID: <alpine.DEB.2.20.2001142031060.17014@blackhole.kfki.hu>
References: <20200108134500.31727-1-fw@strlen.de> <20200113235309.GM795@breakpoint.cc>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

On Tue, 14 Jan 2020, Florian Westphal wrote:

> Florian Westphal <fw@strlen.de> wrote:
> > This entire series isn't nice but so far I did not find a better
> > solution.
> 
> I did consider getting rid of the unconfirmed list, but this is also
> problematic.
> 
> At allocation time we do not know what kind of NAT transformations
> will be applied by the ruleset, i.e. we'd need another locking step to
> move the entries to the right location in the hash table.
> 
> Same if the skb is dropped: we need to lock the conntrack table again to
> delete the newly added entry -- this isn't needed right now because the
> conntrack is only on the percpu unconfirmed list in this case.
> 
> This is also a problem because of conntrack events, we would have to
> seperate insertion and notification, else we'd flood userspace for every
> conntrack we create in case of a packet drop flood.
> 
> Other solutions are:
> 1. use a ruleset that assigns the same nat mapping for both A and AAAA
>    requests, or,
> 2. steer all packets that might have this problem (i.e. udp dport 53) to
>     the same cpu core.
> 
> Yet another solution would be a variation of this patch set:
> 
> 1. Only add the reply direction to the table (i.e. conntrack -L won't show
>    the duplicated entry).
> 2. Add a new conntrack flag for the duplicate that guarantees the
>    conntrack is removed immediately when first reply packet comes in.
>    This would also have the effect that the conntrack can never be
>    assured, i.e. the "hidden duplicates" are always early-dropable if
>    conntrack table gets full.
> 3. change event code to never report such duplicates to userspace.

Somehow my general feeling is that all proposed fixes in conntrack could 
in some cases break other non single-request - single-response UDP 
applications.

Reading about the kubernetes issue as far as I see

a. When the pods run glibc based systems, the issue could easily be
   fixed by configuring the real DNS server IP addresses in the pods
   resolv.conf files with "options single-request single-request-reopen" 
   enabled. 
b. When the pods run musl based systems, there's no such a solution
   because the main musl developer refused to implement the required
   RES_SNGLKUP and RES_SNGLKUPREOP options in musl.

However, I think there's a general already available solution in iptables: 
force the same DNAT mapping for the packets of the same socket by the 
HMARK target. Something like this:

-t raw -p udp --dport 53 -j HMARK --hmark-tuple src,sport \
	--hmark-mod 1 --hmark-offset 10 --hmark-rnd 0xdeafbeef
-t nat -p udp --dport 53 -m state --state NEW -m mark --mark 10 -j DNAT ..
-t nat -p udp --dport 53 -m state --state NEW -m mark --mark 11 -j DNAT ..

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
