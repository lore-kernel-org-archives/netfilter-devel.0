Return-Path: <SRS0=2ZCu=4N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45723C35DF9
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 09:16:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1700421744
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 09:16:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="Iag0Flhg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbgBYJQq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Feb 2020 04:16:46 -0500
Received: from smtp-out.kfki.hu ([148.6.0.48]:58541 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726867AbgBYJQq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Feb 2020 04:16:46 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 01F0CCC0135;
        Tue, 25 Feb 2020 10:16:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1582622201; x=1584436602; bh=lWCr37Ym/D
        ya+e9ZNeQOfRNoB+4PUXGUOHXenjVSDd0=; b=Iag0FlhgqdPcrBJDiUs04jpQFc
        YPczaN6dN0i3cRWH6aYoJg4IVaS5CnN4Al7tt/Ieuv6xSjI2/YpNHfMW29/aB/lH
        rQpt7CFReersp+310fN1T4OmCovL2eAAEC6Jnss26LA4rMTEeR34wzkDjFJKFXBC
        NbcnepnnLRqpqaXfI=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Tue, 25 Feb 2020 10:16:41 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 26811CC0133;
        Tue, 25 Feb 2020 10:16:41 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id EF8F320AB2; Tue, 25 Feb 2020 10:16:40 +0100 (CET)
Date:   Tue, 25 Feb 2020 10:16:40 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     Stefano Brivio <sbrivio@redhat.com>
cc:     netfilter-devel@vger.kernel.org, Mithil Mhatre <mmhatre@redhat.com>
Subject: Re: [PATCH] ipset: Update byte and packet counters regardless of
 whether they match
In-Reply-To: <20200225094043.5a78337e@redhat.com>
Message-ID: <alpine.DEB.2.20.2002250954060.26348@blackhole.kfki.hu>
References: <f4b0ae68661c865c3083d2fa896e9a112057a82f.1582566351.git.sbrivio@redhat.com>        <alpine.DEB.2.20.2002250857120.26348@blackhole.kfki.hu> <20200225094043.5a78337e@redhat.com>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Stefano,

On Tue, 25 Feb 2020, Stefano Brivio wrote:

> > > The issue observed is illustrated by this reproducer:
> > > 
> > >   ipset create c hash:ip counters
> > >   ipset add c 192.0.2.1
> > >   iptables -I INPUT -m set --match-set c src --bytes-gt 800 -j DROP
> > > 
> > > if we now send packets from 192.0.2.1, bytes and packets counters
> > > for the entry as shown by 'ipset list' are always zero, and, no
> > > matter how many bytes we send, the rule will never match, because
> > > counters themselves are not updated.  
> > 
> > Sorry, but I disagree. ipset behaves the same as iptables itself: the 
> > counters are increased when the whole rule matches and that includes the 
> > counter comparison as well. I think it's less counter-intuitive that one 
> > can create never matching rules than to explain that "counter matching is 
> > a non-match for the point of view of 'when the rule matches, update the 
> > counter'".
> 
> Note that this behaviour was modified two years ago: earlier, this was 
> not the case (and by the way this is how we found out, as it broke a 
> user setup).

That's  really bad. Still, I think it was a bug earlier which was 
then fixed. The logic could be changed in the user rules from

iptables -I INPUT -m set --match-set c src --bytes-gt 800 -j DROP

to

iptables -I INPUT -m set --match-set c src --bytes-lt 800 -j ACCEPT
[ otherwise DROP ]

but of course it might be not so simple, depending on how the rules are 
built up.

> Other than this, I'm a bit confused. How could --packets-gt and
> --bytes-gt be used, if counters don't increase as long as the rule
> doesn't match?

I almost added to my previous mail that the 'ge' and 'gt' matches are not 
really useful at the moment...
 
> > What's really missing is a decrement-counters flag: that way one could 
> > store different "quotas" for the elements in a set.
> 
> I see, that would work as well.

The other possibility is to force counter update. I.e. instead of

iptables -I INPUT -m set --match-set c src --bytes-gt 800 -j DROP

something like

iptables -I INPUT -m set --match-set c src --update-counters \
	--bytes-gt 800 -j DROP

but that also requires some internal changes to store a new flag, because 
at the moment only "! --update-counters" is supported. So there'd be then 
a fine-grained control over how the counters are updated:

- no --update-counters flag: update counters only if the whole rule 
  matches, including the counter matches
- --update-counters flag: update counters if counter matching is false
- ! --update-counters flag: don't update counters

Best regards,
Jozsef 
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
