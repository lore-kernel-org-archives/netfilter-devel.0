From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: new ABI
Date: Fri, 18 Aug 2006 23:40:25 +0200
Message-ID: <200608182340.26555.max@nucleus.it>
References: <200608142312.41851.max@nucleus.it>
	<20060816121653.GA31235@kriss.csbnet.se>
	<1086.83.88.199.217.1155906363.squirrel@mail.parknet.dk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <1086.83.88.199.217.1155906363.squirrel@mail.parknet.dk>
Content-Disposition: inline
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

On Friday 18 August 2006 3:06 pm, Simon Lodal wrote:

> > Also keep in mind that we can allow several targets. I previously in
> > another mail talked about actions. Its not needed i think, but might
> > make it easier to distringuisch between jumps, ending targets and just
> > changing and logging targets. It should be perfect legal already today
> > to say:
> >
> > iptables -m match -j other_chain -j LOG -j other_chain2 -j DROP -j TTL
>
> LOG + DROP in one rule would be a huge improvement. Even though it would
> just reintroduce an ipchains feature.

I like the idea of actions. I could perform separate type of mangling and 
other non "terminal" things with separate rules without worrying about 
precedence and specific combinations. The current use of "--continue" with 
some, but not all, targets really should be handles in a more general way and 
actions looks like a good solution to me.

> I would like to do it in a generic way: Introduce a "match index" variable
> that can be set by matches and used by targets. A "--dports 1000:1023"
> match has 24 possible matches, so it would set the index to between 0 and
> 23. Same can be done for IP, sets; all other matches that have a finite
> set of possible matches and can enumerate them.

What if we just assign a numeric index to every rule (plus an additional index 
for individual matches). This would let us identify rules for future changes, 
but we could go a step farther and let people choose a specific label if they 
want to.
This way we could jump to a separate chain or just to label two rules away.
If we combine this with my proposal for "functional chains" we could represent 
a whole lot of complex rulesets with far less rules than today.

> I agree with all your points, perhaps except the XML part ... I am one of
> those non-converts. But you may be right anyway. It would be nice to have
> an standard way to define a ruleset, as descriptive data rather than
> commands.

I'm a non-convert too, but perhaps it doesn't matter. The final userspace 
representation is irrelevant to the kernel and might be a matter of a few 
additional scripts.

-- 
Saluti,
   Massimiliano Hofer
        Nucleus
