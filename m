Return-Path: <SRS0=BYf1=4P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F98C11D3D
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Feb 2020 20:37:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B5FC2469C
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Feb 2020 20:37:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="tS0fXdGx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729391AbgB0UhQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Feb 2020 15:37:16 -0500
Received: from smtp-out.kfki.hu ([148.6.0.45]:33057 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbgB0UhP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Feb 2020 15:37:15 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id C6A7167400F4;
        Thu, 27 Feb 2020 21:37:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1582835830; x=1584650231; bh=Dd47ozFQ1T
        u+lgAHNuFv58fL4wibR3dx6vpReJ10jPo=; b=tS0fXdGxHHTc6lbdTgoD9vHymN
        JhuBwiV4cMnZbaEW0mqP4JX9/HAMIN6EzukC6UJIMJeoZUMlODMT8Slee3izKMmU
        6hgJNy/omXMVjlWV0jWecopX2iT6snayMe+leXZg8REMs3C2C4QrwqrntyTUAwD4
        e+riUoZ1O/pX5eqcI=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Thu, 27 Feb 2020 21:37:10 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp0.kfki.hu (Postfix) with ESMTP id 71E6867400F2;
        Thu, 27 Feb 2020 21:37:10 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 42DFD21645; Thu, 27 Feb 2020 21:37:10 +0100 (CET)
Date:   Thu, 27 Feb 2020 21:37:10 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     Stefano Brivio <sbrivio@redhat.com>
cc:     netfilter-devel@vger.kernel.org, Mithil Mhatre <mmhatre@redhat.com>
Subject: Re: [PATCH] ipset: Update byte and packet counters regardless of
 whether they match
In-Reply-To: <20200225215322.6fb5ecb0@redhat.com>
Message-ID: <alpine.DEB.2.20.2002272112360.11901@blackhole.kfki.hu>
References: <f4b0ae68661c865c3083d2fa896e9a112057a82f.1582566351.git.sbrivio@redhat.com>        <alpine.DEB.2.20.2002250857120.26348@blackhole.kfki.hu>        <20200225094043.5a78337e@redhat.com>        <alpine.DEB.2.20.2002250954060.26348@blackhole.kfki.hu>
        <20200225132235.5204639d@redhat.com>        <alpine.DEB.2.20.2002252113111.29920@blackhole.kfki.hu> <20200225215322.6fb5ecb0@redhat.com>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Stefano,

On Tue, 25 Feb 2020, Stefano Brivio wrote:

> On Tue, 25 Feb 2020 21:37:45 +0100 (CET)
> Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> 
> > On Tue, 25 Feb 2020, Stefano Brivio wrote:
> > 
> > > > The logic could be changed in the user rules from
> > > > 
> > > > iptables -I INPUT -m set --match-set c src --bytes-gt 800 -j DROP
> > > > 
> > > > to
> > > > 
> > > > iptables -I INPUT -m set --match-set c src --bytes-lt 800 -j ACCEPT
> > > > [ otherwise DROP ]
> > > > 
> > > > but of course it might be not so simple, depending on how the rules are 
> > > > built up.  
> > > 
> > > Yes, it would work, unless the user actually wants to check with the
> > > same counter how many bytes are sent "in excess".  
> > 
> > You mean the counters are still updated whenever the element is matched in 
> > the set and then one could check how many bytes were sent over the 
> > threshold just by listing the set elements.
> 
> Yes, exactly -- note that it was possible (and, I think, used) before.

I'm still not really convinced about such a feature. Why is it useful to 
know how many bytes would be sent over the "limit"? Also, there's no 
protection against overflow in the counters. I know firewalls with ipset, 
10gb interfaces and long uptimes, so it's not completely a theoretical 
issue.
 
> > > > I almost added to my previous mail that the 'ge' and 'gt' matches 
> > > > are not really useful at the moment...
> > > 
> > > ...yes, I can't think of any other use for those either.  
> > 
> > Those could really be useful if the counters could be decremented. 
> > Otherwise I think the counter matching in the sets is not as useful as 
> > it seems to be.
> 
> Still, if counters are updated with just matching element, but not 
> necessarily matching rule, they should be as useful as in the hypothesis 
> of introducing a "decrementing" feature -- one just needs to adjust the 
> rule logic to that.

That's true.

> > > > The other possibility is to force counter update. I.e. instead of
> > > > 
> > > > iptables -I INPUT -m set --match-set c src --bytes-gt 800 -j DROP
> > > > 
> > > > something like
> > > > 
> > > > iptables -I INPUT -m set --match-set c src --update-counters \
> > > > 	--bytes-gt 800 -j DROP
> > > > 
> > > > but that also requires some internal changes to store a new flag, because 
> > > > at the moment only "! --update-counters" is supported. So there'd be then 
> > > > a fine-grained control over how the counters are updated:
> > > > 
> > > > - no --update-counters flag: update counters only if the whole rule 
> > > >   matches, including the counter matches
> > > > - --update-counters flag: update counters if counter matching is false  
> > > 
> > > ...this should probably be "in any case", also if it's true.  
> > 
> > Yes, but now I don't really like the name itself: --force-update-counters
> > or something like that would be more clear.
> > 
> > > > - ! --update-counters flag: don't update counters  
> > > 
> > > I think that would fix the issue as well, I'm just struggling to find a
> > > sensible use case for the "no --update-counters" case -- especially one
> > > where there would be a substantial issue with the change I proposed.  
> > 
> > The no update counter flag was introduced to handle when one needs to 
> > match in the same set multiple times, i.e. there are multiple rules with 
> > the same set. Like you need to match in the raw/mangle/filter tables as 
> > well. Unfortunately I can't recall the usercase.
> 
> Okay, but what you're describing is the "! --update-counters" option. 
> That works, didn't work before 4750005a85f7, but would still work with 
> this change.
> 
> What I meant is really the case where "--update-counters" (or 
> "--force-update-counters") and "! --update-counters" are both absent: I 
> don't see any particular advantage in the current behaviour for that 
> case.

The counters are used just for statistical purposes: reflect the 
packets/bytes which were let through, i.e. matched the whole "rule".
In that case updating the counters before the counter value matching is 
evaluated gives false results.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
