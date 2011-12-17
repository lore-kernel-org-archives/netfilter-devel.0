From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/2] [RFC] Extended accounting infrastructure for
 iptables
Date: Sat, 17 Dec 2011 19:05:23 +0100
Message-ID: <20111217180523.GA31261@1984>
References: <1323860443-7129-1-git-send-email-pablo@netfilter.org>
 <CABa6K_Ffexe2SsaxyRPLBEjf1WOfSEgzJ4fa5L81QZs6JvXsVA@mail.gmail.com>
 <20111214133010.GA3155@1984>
 <CABa6K_HLc2w5K4taYmrNfhdXTPZsvE=OmdQtNnYBm32Erw8yBA@mail.gmail.com>
 <alpine.LNX.2.01.1112141655510.26476@frira.zrqbmnf.qr>
 <871us5bn3t.fsf@tac.ki.iif.hu>
 <alpine.LNX.2.01.1112152200410.2122@frira.zrqbmnf.qr>
 <87ty504jy5.fsf@tac.ki.iif.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Changli Gao <xiaosuo@gmail.com>,
	Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu,
	kaber@trash.net, thomas.jarosch@intra2net.com
To: Ferenc Wagner <wferi@niif.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50635 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab1LQSFc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 13:05:32 -0500
Content-Disposition: inline
In-Reply-To: <87ty504jy5.fsf@tac.ki.iif.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 16, 2011 at 04:25:54PM +0100, Ferenc Wagner wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> writes:
> 
> > What you propose is hackish.
> 
> Do you consider creating a new chain with a single empty rule hackish?

No. What I consider hackish is to parse the output of iptables -Lnv,
most likely looking for some pattern that -m comment displays to
collect the counters.

> I accept that nfacct is a more transparent solution.  But I don't think
> those single rule counter chains are that bad, either.  And they are
> potentially more flexible (which may be an advantage or a disadvantage
> as well).  And they don't require adding (and maintaining) new code.
>
> > You parse text-based outputs, which is not the nice way to make
> > things.
> 
> Agreed.  But I don't see the principal difference: just as you provide
> libnetfilter_acct, someone could provide a similar library for handling
> the rule counters (maybe such a library is already available, I don't
> know). Also, I bet 98% of the uses would involve shell scripts anyway,
> using nfacct_get http-traffic or iptables -vL http-traffic for much the
> same effect. :)

Bad betting, you owe me one beer ;-).

With nfacct you will not need to make shell scripts at all for your
applications. You've got one library that provides one netlink
interface that you can use in your C programs (or whatever language
that allows to make native calls to C functions).
