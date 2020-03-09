Return-Path: <SRS0=jBJt=42=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A32C10F27
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Mar 2020 10:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 958852072A
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Mar 2020 10:07:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="TtgMvynj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgCIKHw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Mar 2020 06:07:52 -0400
Received: from smtp-out.kfki.hu ([148.6.0.48]:50999 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725942AbgCIKHw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Mar 2020 06:07:52 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id EF497CC011C;
        Mon,  9 Mar 2020 11:07:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1583748466; x=1585562867; bh=I163FxNVnW
        Fue4AwkHHkxiaC6ft7b5aVIginGdHCAQI=; b=TtgMvynj1c7fAdxdpsAB83TSqY
        z5xXeJiA3y1h2jKOv5TwjgCBpIdSUFs6iv0Cf/b2FtbF77LDVtFwaK22CaOFgPF9
        t/t1xByXSXxDDBgn2mdl9ttuFB/DorzA1c03aUj2Wx8lC+fVlO0bIgBizrFVC5Bt
        ipsUY+FgwJ8MlDG4I=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Mon,  9 Mar 2020 11:07:46 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 8243ACC00E8;
        Mon,  9 Mar 2020 11:07:46 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 23C822142E; Mon,  9 Mar 2020 11:07:46 +0100 (CET)
Date:   Mon, 9 Mar 2020 11:07:46 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     Stefano Brivio <sbrivio@redhat.com>
cc:     netfilter-devel@vger.kernel.org, Mithil Mhatre <mmhatre@redhat.com>
Subject: Re: [PATCH] ipset: Update byte and packet counters regardless of
 whether they match
In-Reply-To: <20200303231646.472e982e@elisabeth>
Message-ID: <alpine.DEB.2.20.2003091059110.6217@blackhole.kfki.hu>
References: <f4b0ae68661c865c3083d2fa896e9a112057a82f.1582566351.git.sbrivio@redhat.com>        <alpine.DEB.2.20.2002250857120.26348@blackhole.kfki.hu>        <20200225094043.5a78337e@redhat.com>        <alpine.DEB.2.20.2002250954060.26348@blackhole.kfki.hu>
        <20200225132235.5204639d@redhat.com>        <alpine.DEB.2.20.2002252113111.29920@blackhole.kfki.hu>        <20200225215322.6fb5ecb0@redhat.com>        <alpine.DEB.2.20.2002272112360.11901@blackhole.kfki.hu>        <20200228124039.00e5a343@redhat.com>
        <alpine.DEB.2.20.2003031020330.3731@blackhole.kfki.hu> <20200303231646.472e982e@elisabeth>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Stefano,

On Tue, 3 Mar 2020, Stefano Brivio wrote:

> On Tue, 3 Mar 2020 10:36:53 +0100 (CET)
> Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> 
> > On Fri, 28 Feb 2020, Stefano Brivio wrote:
> > 
> > > On Thu, 27 Feb 2020 21:37:10 +0100 (CET)
> > > Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > >   
> > > > On Tue, 25 Feb 2020, Stefano Brivio wrote:
> > > >   
> > > > > On Tue, 25 Feb 2020 21:37:45 +0100 (CET)
> > > > > Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > > > >     
> > > > > > On Tue, 25 Feb 2020, Stefano Brivio wrote:
> > > > > >     
> > > > > > > > The logic could be changed in the user rules from
> > > > > > > > 
> > > > > > > > iptables -I INPUT -m set --match-set c src --bytes-gt 800 -j DROP
> > > > > > > > 
> > > > > > > > to
> > > > > > > > 
> > > > > > > > iptables -I INPUT -m set --match-set c src --bytes-lt 800 -j ACCEPT
> > > > > > > > [ otherwise DROP ]
> > > > > > > > 
> > > > > > > > but of course it might be not so simple, depending on how the rules are 
> > > > > > > > built up.      
> > > > > > > 
> > > > > > > Yes, it would work, unless the user actually wants to check with the
> > > > > > > same counter how many bytes are sent "in excess".      
> > > > > > 
> > > > > > You mean the counters are still updated whenever the element is matched in 
> > > > > > the set and then one could check how many bytes were sent over the 
> > > > > > threshold just by listing the set elements.    
> > > > > 
> > > > > Yes, exactly -- note that it was possible (and, I think, used) before.    
> > > > 
> > > > I'm still not really convinced about such a feature. Why is it useful to 
> > > > know how many bytes would be sent over the "limit"?  
> > > 
> > > This is useful in case one wants different treatments for packets
> > > according to a number of thresholds in different rules. For example,
> > > 
> > >     iptables -I INPUT -m set --match-set c src --bytes-lt 100 -j noise
> > >     iptables -I noise -m set --match-set c src --bytes-lt 20000 -j download
> > > 
> > > and you want to log packets from chains 'noise' and 'download' with
> > > different prefixes.  
> > 
> > What do you think about this patch?
> 
> Thanks, I think it gives a way to avoid the issue.
> 
> I'm still not convinced that keeping this disabled by default is the 
> best way to go (mostly because we had a kernel change affecting 
> semantics that were exported to userspace for a long time), but if 
> there's a need for the opposite of this option, introducing it as a 
> negation becomes linguistically awkward. :)

The situation is far from ideal: the original mode (update counters 
regardless of the outcome of the counter matches) worked for almost five 
years. Then the 'Fix "don't update counters" mode...' patch changed it so 
that the result of the counter matches was taken into account, for about 
two years. I don't know how many user is expecting either the original or 
the changed behaviour, but better not change it again. Also, the grammar 
seems to be simpler this way :-).
 
> And anyway, it's surely better than not having this possibility at all.
> 
> Let me know if you want me to review (or try to draft) man page
> changes. Just a few comments inline:

Could you write a manpage update to describe properly the features?
 
> > diff --git a/kernel/net/netfilter/ipset/ip_set_core.c b/kernel/net/netfilter/ipset/ip_set_core.c
> > index 1df6536..423d0de 100644
> > --- a/kernel/net/netfilter/ipset/ip_set_core.c
> > +++ b/kernel/net/netfilter/ipset/ip_set_core.c
> > @@ -622,10 +622,9 @@ ip_set_add_packets(u64 packets, struct ip_set_counter *counter)
> >  
> >  static void
> >  ip_set_update_counter(struct ip_set_counter *counter,
> > -		      const struct ip_set_ext *ext, u32 flags)
> > +		      const struct ip_set_ext *ext)
> >  {
> > -	if (ext->packets != ULLONG_MAX &&
> > -	    !(flags & IPSET_FLAG_SKIP_COUNTER_UPDATE)) {
> > +	if (ext->packets != ULLONG_MAX) {
> 
> This means that UPDATE_COUNTERS_FIRST wins over SKIP_COUNTER_UPDATE. Is 
> that intended? Intuitively, I would say that "skip" is more imperative 
> than "do it *first*". Anyway, I guess they will be mutually exclusive.

In my opinion the two flags are mutually exclusive, therefore I dropped
the checking in ip_set_update_counter(). IPSET_FLAG_SKIP_COUNTER_UPDATE is 
taken into account in ip_set_match_extensions() now.

> > -		ip_set_update_counter(counter, ext, flags);
> > +
> > +		if (!(flags & (IPSET_FLAG_UPDATE_COUNTERS_FIRST|
> 
> Nit: whitespace before |.

I'll fix it, thanks!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
