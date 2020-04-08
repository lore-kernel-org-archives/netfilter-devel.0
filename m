Return-Path: <SRS0=8NPN=5Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41937C2D0F4
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Apr 2020 19:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFACB20678
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Apr 2020 19:59:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="bet6+DzE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbgDHT7R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Apr 2020 15:59:17 -0400
Received: from smtp-out.kfki.hu ([148.6.0.46]:33115 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726550AbgDHT7R (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Apr 2020 15:59:17 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp1.kfki.hu (Postfix) with ESMTP id 106FA3C80130;
        Wed,  8 Apr 2020 21:59:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1586375951; x=1588190352; bh=DaA4X+sloP
        LHNDjJTAin+RwUkOvFF7FtAiz98eGL7UQ=; b=bet6+DzE6L5AtzHOo054ZFK+vs
        qthapGvYlbFGlxK5QBMpPSsjZjqkA5fplW4YYN15H/kZUAP3p2haMxG6rnFWOnB+
        dhaWD7hAql5xEfsnVs6AYyoFptQjaoFAAAGN4CYDAiRE0TH5XeqzrRckkb8l4cYW
        uVJSW5z3nCFg7dE6k=
X-Virus-Scanned: Debian amavisd-new at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
        by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Wed,  8 Apr 2020 21:59:11 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp1.kfki.hu (Postfix) with ESMTP id 88CA33C80128;
        Wed,  8 Apr 2020 21:59:11 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 3B68A2097A; Wed,  8 Apr 2020 21:59:11 +0200 (CEST)
Date:   Wed, 8 Apr 2020 21:59:11 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     Phil Sutter <phil@nwl.cc>
cc:     Stefano Brivio <sbrivio@redhat.com>,
        netfilter-devel@vger.kernel.org, Mithil Mhatre <mmhatre@redhat.com>
Subject: Re: [PATCH] ipset: Update byte and packet counters regardless of
 whether they match
In-Reply-To: <20200408160937.GI14051@orbyte.nwl.cc>
Message-ID: <alpine.DEB.2.21.2004082147410.23414@blackhole.kfki.hu>
References: <20200225094043.5a78337e@redhat.com> <alpine.DEB.2.20.2002250954060.26348@blackhole.kfki.hu> <20200225132235.5204639d@redhat.com> <alpine.DEB.2.20.2002252113111.29920@blackhole.kfki.hu> <20200225215322.6fb5ecb0@redhat.com>
 <alpine.DEB.2.20.2002272112360.11901@blackhole.kfki.hu> <20200228124039.00e5a343@redhat.com> <alpine.DEB.2.20.2003031020330.3731@blackhole.kfki.hu> <20200303231646.472e982e@elisabeth> <alpine.DEB.2.20.2003091059110.6217@blackhole.kfki.hu>
 <20200408160937.GI14051@orbyte.nwl.cc>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Wed, 8 Apr 2020, Phil Sutter wrote:

> On Mon, Mar 09, 2020 at 11:07:46AM +0100, Jozsef Kadlecsik wrote:
> > On Tue, 3 Mar 2020, Stefano Brivio wrote:
> > > On Tue, 3 Mar 2020 10:36:53 +0100 (CET)
> > > Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > > > On Fri, 28 Feb 2020, Stefano Brivio wrote:
> > > > > On Thu, 27 Feb 2020 21:37:10 +0100 (CET)
> > > > > Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > > > > > On Tue, 25 Feb 2020, Stefano Brivio wrote:
> > > > > > > On Tue, 25 Feb 2020 21:37:45 +0100 (CET)
> > > > > > > Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > > > > > > > On Tue, 25 Feb 2020, Stefano Brivio wrote:
> > > > > > > > > > The logic could be changed in the user rules from
> > > > > > > > > > 
> > > > > > > > > > iptables -I INPUT -m set --match-set c src --bytes-gt 800 -j DROP
> > > > > > > > > > 
> > > > > > > > > > to
> > > > > > > > > > 
> > > > > > > > > > iptables -I INPUT -m set --match-set c src --bytes-lt 800 -j ACCEPT
> > > > > > > > > > [ otherwise DROP ]
> > > > > > > > > > 
> > > > > > > > > > but of course it might be not so simple, depending on how the rules are 
> > > > > > > > > > built up.      
> > > > > > > > > 
> > > > > > > > > Yes, it would work, unless the user actually wants to check with the
> > > > > > > > > same counter how many bytes are sent "in excess".      
> > > > > > > > 
> > > > > > > > You mean the counters are still updated whenever the element is matched in 
> > > > > > > > the set and then one could check how many bytes were sent over the 
> > > > > > > > threshold just by listing the set elements.    
> > > > > > > 
> > > > > > > Yes, exactly -- note that it was possible (and, I think, used) before.    
> > > > > > 
> > > > > > I'm still not really convinced about such a feature. Why is it useful to 
> > > > > > know how many bytes would be sent over the "limit"?  
> > > > > 
> > > > > This is useful in case one wants different treatments for packets
> > > > > according to a number of thresholds in different rules. For example,
> > > > > 
> > > > >     iptables -I INPUT -m set --match-set c src --bytes-lt 100 -j noise
> > > > >     iptables -I noise -m set --match-set c src --bytes-lt 20000 -j download
> > > > > 
> > > > > and you want to log packets from chains 'noise' and 'download' with
> > > > > different prefixes.  
> > > > 
> > > > What do you think about this patch?
> > > 
> > > Thanks, I think it gives a way to avoid the issue.
> > > 
> > > I'm still not convinced that keeping this disabled by default is the 
> > > best way to go (mostly because we had a kernel change affecting 
> > > semantics that were exported to userspace for a long time), but if 
> > > there's a need for the opposite of this option, introducing it as a 
> > > negation becomes linguistically awkward. :)
> > 
> > The situation is far from ideal: the original mode (update counters 
> > regardless of the outcome of the counter matches) worked for almost five 
> > years. Then the 'Fix "don't update counters" mode...' patch changed it so 
> > that the result of the counter matches was taken into account, for about 
> > two years. I don't know how many user is expecting either the original or 
> > the changed behaviour, but better not change it again. Also, the grammar 
> > seems to be simpler this way :-).
> 
> I didn't look at the mentioned fix, but if it really changed counters 
> that fundamentally, that's a clear sign that nobody uses it, or at least 
> nobody with a current kernel. :)
> 
> Either way, the risk of reverting to the old behaviour is not bigger 
> than the original divert two years ago and that seems to not have upset 
> anyone.
> 
> Regarding the actual discussed functionality, I second Stefano in that 
> ipset match and rule match should be regarded as two different things: 
> ipset counters should count how many packets matched an element in that 
> ipset, not how many packets matched an iptables rule referring to it. 
> For the latter question, there are iptables rule counters already.

The ipset match cannot check the other parts of the iptables rule.

The question is that in the case of the ipset match, say

	-m set --match-set foo src --packets-lt N

should the ipset elemet counters be updated if the packet matched the set
or if the packet matched the set and the element counter values according 
to the condition as well? What constitutes a "match" in the ipset context 
and how does it refer to the counter updating?

Stefano believes that the former is the natural choice. In my mind the 
second one.

The patch in the ipset git tree makes possible to choose :-)

What is the case with nftables? Is the counter value updated if the 
counter match parts in a rule returns false?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
