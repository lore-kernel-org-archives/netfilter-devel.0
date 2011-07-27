From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset "contains" question
Date: Wed, 27 Jul 2011 09:17:14 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1107270851570.24850@blackhole.kfki.hu>
References: <4E2DED59.1030902@wildgooses.com> <alpine.DEB.2.00.1107261151210.20945@blackhole.kfki.hu> <4E2E95D5.1040408@wildgooses.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:39778 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156Ab1G0HRP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Jul 2011 03:17:15 -0400
In-Reply-To: <4E2E95D5.1040408@wildgooses.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 26 Jul 2011, Ed W wrote:

> >> Many thanks for ipset.  Quick question please: I'm implementing a
> >> captive portal and I have an ipset (CP) containing bitmap:ip,mac.  How
> >> should I best implement rules to:
> >>
> >> - Drop packets from same IP, different MAC
> >>
> >> I might be missing the obvious, but how do I query to match on IP, then
> >> drop IP with a mismatching MAC (in the bitmap ipset)? Can this be done
> >> without a second ipset tracking only IP?
> > 
> > At a first glance I'd allow packets from (IP, MAC) and drop everything 
> > else, i.e. (same IP, different MAC) and (different IP, same MAC), etc.
> 
> Thanks - I think it's important to separate the traffic, not block it
> for my situation. You need to login to the captive portal, so some
> traffic needs to flow without being authenticated. I think you can very,
> very nearly have a clean split between auth/non auth users, but for
> flexibility my idea was to add some specific blocks/drops to classes of
> users who were clearly trying to cheat

You can add rules which allow the unauthenticated traffic, because 
the destination is well defined: the DHCP server, web server, etc.
 
> (And yes I do get that "auth" based on IP/Mac has some significant
> limitations...)
>  
> > If you want to match the IP address only, too, then a single set is not 
> > sufficient, unfortunately.
> 
> That's fine.  Do you think it's a sensible feature request that has a
> use elsewhere? ie given a bitmap:ip,mac, does it make sense to want to
> search it for just IP or Mac?

There's a strict input checking in ipset core, which does not allow to 
call the set types with insufficient data. That disables "looking up" just 
the IP address in a bitmap:ip,mac type. Accidentally, it *could* be 
relaxed for the bitmap types, but that'd require adding an exception to 
the core, and adding a new handler code to the type functions.
 
> Additionally it would have been very useful to use an ipset to assign a
> packet mark, ie the "result" of an ipset is also stored in the ipset.
> Do you think this is a reasonable feature request..? (what other
> "parameters" do people want to lookup, flow rates, marks, last seen,
> time constraints..?)

ipset is not a general solution, which replaces everything else :-).
The mark values are already stored in the skbuff, so there's no point in 
storing them again; for flow rates, time you have other matches.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
