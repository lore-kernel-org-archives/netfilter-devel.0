From: Patrick Schaaf <bof@bof.de>
Subject: Re: Multiple Targets
Date: Sat, 19 Feb 2005 18:41:59 +0100
Message-ID: <20050219174159.GB18228@oknodo.bof.de>
References: <7174b1e405021900052b4545c4@mail.gmail.com>
	<20050219082851.GA18228@oknodo.bof.de>
	<1589344960.20050219102331@dns.toxicfilms.tv>
	<421775A0.3040902@niksula.hut.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Maciej Soltysiak <solt@dns.toxicfilms.tv>,
	netfilter-devel@lists.netfilter.org
To: Jonas Berlin <jberlin@niksula.hut.fi>
Content-Disposition: inline
In-Reply-To: <421775A0.3040902@niksula.hut.fi>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

> >>Problem: target options. How would the commandline parser see that
> >>--set-mark belongs to MARK, and --log-prefix belongs to LOG? What
> >>about the hypothetical case of several targets having target options
> >>with identical names?
> >>   
> >>
> Isn't it possible to have multiple matchers also? How are the arguments 
> to them separated?

Very strangely, or so they said. As far as I remember, doing things
cleanly in this regard, was one of the main motivations for pkttables.
(Sorry, I never tried to understand this in more detail)

> If the latter, how about having a match target instead that matches if 
> the previous one matched?
> 
> This would be quite easy to implement, not break any binary interface 
> and my guess is it wouldn't be too slow either.

Heh. I've got the same idea, but you beat me. However, I'd simply name this
'and', instead of 'previous':

iptables -A INPUT -p tcp --dport 53 -j LOG --log-prefix "foo: "
iptables -A INPUT -m and -j MARK --set-mark 1
iptables -A INPUT -m and -j ACCEPT

I agree that implementing this would be rather easy: the main table
scanning can certainly know the result of the last match it did,
and it could specialcase recognition of 'and' (i.e. NOT call the
match function, which would then wonder how to get at its caller's
knowledge of the previous match result...)

best regards
  Patrick
