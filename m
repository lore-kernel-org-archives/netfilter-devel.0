Return-Path: <SRS0=cAfZ=AO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11EF0C433E0
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jul 2020 10:24:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B89EB2073E
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jul 2020 10:24:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="FWxShKlW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgGCKYQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Jul 2020 06:24:16 -0400
Received: from smtp-out.kfki.hu ([148.6.0.45]:47027 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbgGCKYQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Jul 2020 06:24:16 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 6163E67400D9;
        Fri,  3 Jul 2020 12:24:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1593771844; x=1595586245; bh=6bmm/5ujzC
        oMrW4EkYV3dxh+HZTXcpLKOMMyAklzv+0=; b=FWxShKlWJhX9FKg5c/YIsjb8WJ
        NldcUjZQiUs8ufU4LfEgxAmW0/+ZY/DRCmMIcf1i5fmRkSg9ILK2vrCSIM//pbMU
        4tL8qyXcFKNtig2kjRgXQitLiqTV2JHSy6UZR7NY9nD3Fz5+B01fMZdPSlz3Szjd
        oTPDjOyWc9SBAOKQ8=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Fri,  3 Jul 2020 12:24:04 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp0.kfki.hu (Postfix) with ESMTP id A7CC767400BD;
        Fri,  3 Jul 2020 12:24:03 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 5AFF4340D60; Fri,  3 Jul 2020 12:24:03 +0200 (CEST)
Date:   Fri, 3 Jul 2020 12:24:03 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     Stefano Brivio <sbrivio@redhat.com>
cc:     Timo Sigurdsson <public_timo.s@silentcreek.de>,
        netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Subject: Re: Moving from ipset to nftables: Sets not ready for prime time
 yet?
In-Reply-To: <20200703112809.72eb94bf@elisabeth>
Message-ID: <alpine.DEB.2.22.394.2007031200050.9015@blackhole.kfki.hu>
References: <20200702223010.C282E6C848EC@dd34104.kasserver.com> <20200703112809.72eb94bf@elisabeth>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Stefano,

On Fri, 3 Jul 2020, Stefano Brivio wrote:

> On Fri,  3 Jul 2020 00:30:10 +0200 (CEST)
> "Timo Sigurdsson" <public_timo.s@silentcreek.de> wrote:
> 
> > Another issue I stumbled upon was that auto-merge may actually
> > generate wrong/incomplete intervals if you have multiple 'add
> > element' statements within an nftables script file. I consider this a
> > serious issue if you can't be sure whether the addresses or intervals
> > you add to a set actually end up in the set. I reported this here
> > [2]. The workaround for it is - again - to add all addresses in a
> > single statement.
> 
> Practically speaking I think it's a bug, but I can't find a formal,
> complete definition of automerge, so one can also say it "adds items up
> to and including the first conflicting one", and there you go, it's
> working as intended.
> 
> In general, when we discussed this "automerge" feature for
> multi-dimensional sets in nftables (not your case, but I aimed at
> consistency), I thought it was a mistake to introduce it altogether,
> because it's hard to define it and whatever definition one comes up
> with might not match what some users think. Consider this example:
> 
> # ipset create s hash:net,net
> # ipset add s 10.0.1.1/30,192.168.1.1/24
> # ipset add s 10.0.0.1/24,172.16.0.1
> # ipset list s
> [...]
> Members:
> 10.0.1.0/30,192.168.1.0/24
> 10.0.0.0/24,172.16.0.1
> 
> good, ipset has no notion of automerge, so it won't try to do anything
> bad here: the set of address pairs denoted by <10.0.1.1/30,
> 192.168.1.1/24> is disjoint from the set of address pairs denoted by
> <10.0.0.1/24, 172.16.0.1>. Then:
> 
> # ipset add s 10.0.0.1/16,192.168.0.0/16
> # ipset list s
> [...]
> Members:
> 10.0.1.0/30,192.168.1.0/24
> 10.0.0.0/16,192.168.0.0/16
> 10.0.0.0/24,172.16.0.1
> 
> and, as expected with ipset, we have entirely overlapping entries added
> to the set. Is that a problem? Not really, ipset doesn't support maps,
> so it doesn't matter which entry is actually matched.

Actually, the flags, extensions (nomatch, timeout, skbinfo, etc.) in ipset 
are some kind of mappings and do matter which entry is matched and which 
flags, extensions are applied to the matching packets.

Therefore the matching in the net kind of sets follow a strict ordering: 
most specific match wins and in the case of multiple dimensions (like 
net,net above) it goes from left to right to find the best most specific 
match.

> # nft add table t
> # nft add set t s '{ type ipv4_addr . ipv4_addr; flags interval ; }'
> # nft add element t s '{ 10.0.1.1/30 . 192.168.1.1/24 }'
> # nft add element t s '{ 10.0.0.1/24 . 172.16.0.1 }'
> # nft add element t s '{ 10.0.0.1/16 . 192.168.0.0/16 }'
> # nft list ruleset
> table ip t {
> 	set s {
> 		type ipv4_addr . ipv4_addr
> 		flags interval
> 		elements = { 10.0.1.0/30 . 192.168.1.0/24,
> 			     10.0.0.0/24 . 172.16.0.1,
> 			     10.0.0.0/16 . 192.168.0.0/16 }
> 	}
> }
> 
> also fine: the least generic entry is added first, so it matches first.
> Let's try to reorder the insertions:
> 
> # nft add element t s '{ 10.0.0.1/16 . 192.168.0.0/16 }'
> # nft add element t s '{ 10.0.0.1/24 . 172.16.0.1 }'
> # nft add element t s '{ 10.0.1.1/30 . 192.168.1.1/24 }'
> Error: Could not process rule: File exists
> add element t s { 10.0.1.1/30 . 192.168.1.1/24 }
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> ...because that entry would never match anything: it's inserted after a
> more generic one that already covers it completely, and we'd like to
> tell the user that it doesn't make sense.

I think sets should not store information about which order the entries 
were added. That should totally be indifferent. The input of the sets may 
come from countless sources and if the order of adding the entries matters 
then a preordering is required, which is sometimes non-trivial.
 
> Now, this is pretty much the only advantage of not allowing overlaps:
> telling the user that some insertion doesn't make sense, and thus it
> was probably not what the user wanted to do.

This makes also impossible to make exceptions in the sets in nftables - 
with the "nomatch" flag in ipset one can easily create exceptions in 
intentionally overlapping entries (in whatever deep nestings) in a single 
set. In practice it comes quite handy to say

ipset create access_to_servers hash:ip,port,net
ipset add access_to_servers your_ssh_server,22,x.y.z.0/24
ipset add access_to_servers your_ssh_server,22,x.y.z.32/27 nomatch
...

and exclude access to some parts of a given subnet.

However, the internals of the sets in nftables are totally different from 
ipset, so I'm pretty sure it's absolutely not trivial (and sometimes 
impossible) to provide exactly the same behaviour.

> So... I wouldn't know how deal with your use case, even in theory, in a
> consistent way. Should we rather introduce a flag that allows any type
> of overlapping (default with ipset), which is a way for the user to
> tell us they don't actually care about entries not having any effect?
> 
> And, in that case, would you expect the entry to be listed in the
> resulting set, in case of full overlap (where one set is a subset, not
> necessarily proper, of the other one)?
> 
> > [...]
> >
> > Summing up:
> > Well, that's quite a number of issues to run into as an nftables
> > newbie. I wouldn't have expected this at all. And frankly, I actually
> > converted my rules first and thought adjusting my scripts around
> > ipset to achieve the same with nftables sets would be straightforward
> > and simple... Maybe my approach or understanding of nftables is
> > wrong. But I don't think that the use case is that extraordinary that
> > it should be that difficult.
> 
> I don't think so either, still I kind of expect to see the issues you
> report as these features seem to start being heavily used just recently.
> 
> And I (maybe optimistically) think that all we need to iron out the
> most apparent issues on the subject is a few reports like yours, so
> thanks for sharing it.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
