From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 0/3] ipset: change 'iface' part in hash:net,iface set
Date: Fri, 6 Jul 2012 22:39:55 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207062225290.16055@blackhole.kfki.hu>
References: <cover.1341525006.git.mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207060947530.14535@blackhole.kfki.hu> <4FF736FE.8030109@googlemail.com> <alpine.DEB.2.00.1207062138140.16055@blackhole.kfki.hu> <4FF74868.3070303@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:53656 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab2GFUj5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jul 2012 16:39:57 -0400
In-Reply-To: <4FF74868.3070303@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 6 Jul 2012, Mr Dash Four wrote:

> > This creates more confusion for the users than the current state: one 
> > had to keep in mind what kind of sets are stored in a list of sets and 
> > depending on them, use "src/dst" or "in/out" in the second direction 
> > parameter.
>
> Please explain the 'confusion' bit?

Look at your patches and the manpage modifications: do you explain in them 
what happens when a hash:net,iface type of set is a member of a list of 
sets and one uses "in/out" or "src/dst"? No. And even if you add the 
appropriate lines, the user still faces:
 
> >  And additionally,
> > 
> > iptables -A INPUT -m set --match-set list1 src,src -j ACCEPT
> > 
> > and
> > 
> > iptables -A INPUT -m set --match-set list1 src,in -j ACCEPT
> > 
> > produced different results for the same member sets with the same elements
> > against the same packets. This is unacceptable for me.
> >   
> You can't expect to issue two different iptables statements (as in your
> example above) and get the same number of matches! Not going to happen, is it?
> By the same token, if I execute the following two statements:
> 
> iptables -A INPUT -m set --match-set list1 src,src -j ACCEPT
> 
> and
> 
> iptables -A INPUT -m set --match-set list1 src,dst -j ACCEPT

Your example is wrong, because the effect of two command are of course 
different.

But what I gave above, the results depends from the type of the members of 
the set list, which is invisible in the command line. Even if it's 
stressed in the manpage that "in" is equivalent with "src" but just for 
the hash:net,iface type, that is an equivalency and users will expect the 
same result for the cited commands. And they're right.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
