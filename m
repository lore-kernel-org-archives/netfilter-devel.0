From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: iptables nfacct match question
Date: Thu, 4 Apr 2013 23:46:30 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1304042341530.24744@blackhole.kfki.hu>
References: <51292D41.8000703@googlemail.com> <20130225154848.GA20609@localhost> <512BC79F.1070708@googlemail.com> <20130226135529.GA9526@localhost> <512D0BA4.7060809@googlemail.com> <20130226214707.GA3555@localhost> <512E7331.10304@googlemail.com>
 <515DE487.9020209@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Michael Zintakis <michael.zintakis@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:55145 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764920Ab3DDVxw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Apr 2013 17:53:52 -0400
In-Reply-To: <515DE487.9020209@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 4 Apr 2013, Michael Zintakis wrote:

> Michael Zintakis wrote:
> > Pablo Neira Ayuso wrote:
> >> I see. Then my new proposal is to add a new automagic function to
> >> round the output to the most expressive measure, would be somehow
> >> similar to xtables_print_num:
> >>
> >> http://git.netfilter.org/cgi-bin/gitweb.cgi?p=iptables.git;a=blob;f=libxtables/xtables.c;h=009ab9115f6fd687a762a2552f89ac0b81ee1a42;hb=HEAD#l1915
> Something we've discovered with regards to the nfacct match recently. If 
> I have the following iptables statement:
> 
> iptables -A INPUT -m nfacct --nfacct <nfacct_obj> -m <match2> -m <match3>
>
> The above aklways updates the "nfacct_obj" byte and packet counters, 
> regardless of whether "match2" and "match3" actually matches. However, 
> if we have:
> 
> iptables -A INPUT -m <match2> -m nfacct --nfacct <nfacct_obj> -m <match3>
>
> then "nfacct_obj" counters are updated only when "match1" is satisfied, 
> but if we have:
> 
> iptables -A INPUT -m <match2> -m <match3> -m nfacct --nfacct <nfacct_obj>
>
> then "nfacct_obj" counters are updated when both match2 and match3 are 
> matched (which was the initial intention).
> 
> This inconsistency stems from the fact that the nfacct match in the 
> kernel (xt_nfacct.c::nfacct_mt) always returns true, but also because of 
> how iptables evaluates matches: it does so from left to right.
> 
> Since there isn't a callback in the xt_match struct which is called 
> after ALL matches have been satisfied (xt_match.match is called for each 
> registered match in that statement), this causes the nfacct counters to 
> be updated (or not) depending on the position of the nfacct match.
> 
> What I have done locally is to add a separate callback (I called it 
> "matched") which is called for all matches after all such matches in a 
> particular statement have been satisfied, but that obviously will break 
> lots of code depending on the old xt_match struct if such approach is 
> adopted. My question is: is there more elegant solution to do this? 

In my opinion this is not inconsistency at all, but the intended 
behaviour. So I don't see any reason to add such a hack to override it.

What prevents you from entering the matches in the order you want them to 
be evaluated?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
