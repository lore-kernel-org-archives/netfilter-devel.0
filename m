Return-Path: <SRS0=2ZCu=4N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC53C35E01
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 20:37:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C29E520675
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 20:37:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="cxBxHDIj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731835AbgBYUhu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Feb 2020 15:37:50 -0500
Received: from smtp-out.kfki.hu ([148.6.0.48]:50793 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731297AbgBYUhu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Feb 2020 15:37:50 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id CACF3CC0133;
        Tue, 25 Feb 2020 21:37:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1582663065; x=1584477466; bh=4DPMuG+3AI
        zXomvAvHVqQY4A1K7pXer9N5LB1BBbwvs=; b=cxBxHDIj7rK1gXF++btTrapH4H
        y9tNjxgqZ5Yx0p/WhKS8SfZcxvvvrhcKTMdxyOjfCMPgFTyoLTwyCq0TURjQB6ux
        wyoAy1HCwV+W62xipxuoOC8htBBtPs6/ADSOeIo31nATfNBjNRnwAb25w+Si7BU6
        4SSrxFhvLzP9bQuVc=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Tue, 25 Feb 2020 21:37:45 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 62299CC0131;
        Tue, 25 Feb 2020 21:37:45 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 357D120AB2; Tue, 25 Feb 2020 21:37:45 +0100 (CET)
Date:   Tue, 25 Feb 2020 21:37:45 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     Stefano Brivio <sbrivio@redhat.com>
cc:     netfilter-devel@vger.kernel.org, Mithil Mhatre <mmhatre@redhat.com>
Subject: Re: [PATCH] ipset: Update byte and packet counters regardless of
 whether they match
In-Reply-To: <20200225132235.5204639d@redhat.com>
Message-ID: <alpine.DEB.2.20.2002252113111.29920@blackhole.kfki.hu>
References: <f4b0ae68661c865c3083d2fa896e9a112057a82f.1582566351.git.sbrivio@redhat.com>        <alpine.DEB.2.20.2002250857120.26348@blackhole.kfki.hu>        <20200225094043.5a78337e@redhat.com>        <alpine.DEB.2.20.2002250954060.26348@blackhole.kfki.hu>
 <20200225132235.5204639d@redhat.com>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 25 Feb 2020, Stefano Brivio wrote:

> > The logic could be changed in the user rules from
> > 
> > iptables -I INPUT -m set --match-set c src --bytes-gt 800 -j DROP
> > 
> > to
> > 
> > iptables -I INPUT -m set --match-set c src --bytes-lt 800 -j ACCEPT
> > [ otherwise DROP ]
> > 
> > but of course it might be not so simple, depending on how the rules are 
> > built up.
> 
> Yes, it would work, unless the user actually wants to check with the
> same counter how many bytes are sent "in excess".

You mean the counters are still updated whenever the element is matched in 
the set and then one could check how many bytes were sent over the 
threshold just by listing the set elements.

> Now, I see the conceptual problem about matching: if the rule isn't 
> matching, and counters count matched packets, counters shouldn't 
> increase. But still, I think there are a number of facts to be 
> considered:
> 
> - the man page says (and has said for a number of years):
> 
> 	If the packet is matched an element in the set, match only if
> 	the byte counter of the element is greater than the given value
> 	as well.
> 
>   which actually makes the problem undecidable: matching depends on
>   matching itself. Trying some "common sense" interpretation, I would
>   read this as:
> 
> 	If the packet matches an *element* in the set, this *rule* will
> 	match only if the byte counter of the element is greater than
> 	the given value.
> 
>   that is, by separating the meaning of "element matching" from "rule
>   matching", this starts making sense.

Yes, you are right. Sometimes I think I'm far from the best at writing 
documentation... So I'm going to update the manpage with your sentence.
 
> - I spent the past two hours trying to think of an actual case that was
>   affected by 4750005a85f7, *other than the "main" bug it fixes*, that
>   is, "! --update-counters" was ignored altogether, and I couldn't.
> 
>   Even if we had a --bytes-lt option, it would be counter-intuitive,
>   because the counter would be updated until bytes are less than the
>   threshold, and then the rule would stop matching, meaning that the
>   user most probably thinks:
> 
> 	"Drop matching packets as long as less than 800 bytes are sent"
> 
>   and what happens is:
> 
> 	"Count and drop matching packets until 800 bytes are sent, then
> 	stop dropping and counting them"

Again, yes, that's what would happen.

>   The only "functional" case I can think of is something like
>   --bytes-lt 800 -j ACCEPT. User probably thinks:
> 
> 	"Don't let more than 800 bytes go through"
> 
>   and what happens is:
> 
> 	"Let up to 800 bytes, or 799 bytes plus one packet, go through,
> 	counting the bytes in packets that were let through"
> 
>   which isn't much different from the expectation.
> 
> - and then,
> 
> > > Other than this, I'm a bit confused. How could --packets-gt and
> > > --bytes-gt be used, if counters don't increase as long as the rule
> > > doesn't match?  
> > 
> > I almost added to my previous mail that the 'ge' and 'gt' matches are not 
> > really useful at the moment...
> 
> ...yes, I can't think of any other use for those either.

Those could really be useful if the counters could be decremented. 
Otherwise I think the counter matching in the sets is not as useful as it 
seems to be.
 
> > > > What's really missing is a decrement-counters flag: that way one could 
> > > > store different "quotas" for the elements in a set.  
> > > 
> > > I see, that would work as well.  
> > 
> > The other possibility is to force counter update. I.e. instead of
> > 
> > iptables -I INPUT -m set --match-set c src --bytes-gt 800 -j DROP
> > 
> > something like
> > 
> > iptables -I INPUT -m set --match-set c src --update-counters \
> > 	--bytes-gt 800 -j DROP
> > 
> > but that also requires some internal changes to store a new flag, because 
> > at the moment only "! --update-counters" is supported. So there'd be then 
> > a fine-grained control over how the counters are updated:
> > 
> > - no --update-counters flag: update counters only if the whole rule 
> >   matches, including the counter matches
> > - --update-counters flag: update counters if counter matching is false
> 
> ...this should probably be "in any case", also if it's true.

Yes, but now I don't really like the name itself: --force-update-counters
or something like that would be more clear.

> > - ! --update-counters flag: don't update counters
> 
> I think that would fix the issue as well, I'm just struggling to find a
> sensible use case for the "no --update-counters" case -- especially one
> where there would be a substantial issue with the change I proposed.

The no update counter flag was introduced to handle when one needs to 
match in the same set multiple times, i.e. there are multiple rules with 
the same set. Like you need to match in the raw/mangle/filter tables as 
well. Unfortunately I can't recall the usercase.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
