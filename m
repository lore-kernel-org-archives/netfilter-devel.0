From: Andre Uratsuka Manoel <andre@insite.com.br>
Subject: Re: libiptc optimization
Date: Tue, 24 Jun 2003 17:34:42 -0300 (BRT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0306241717080.7888-100000@fantomas.insite.com.br>
References: <20030624174530.GZ2645@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030624174530.GZ2645@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



On Tue, 24 Jun 2003, Harald Welte wrote:

> I've recently done some profiling on iptables, and found out that
> libiptc is very inefficient when it comes to large rulesets. 
> 
> As an example, loading a ruleset with 10000 rules in 1000 chains 
> using iptables-restore takes:
> 
> original 1.2.8 code: 
> 	ruleset-1000:	3m55.575s (3m27.310s user / 0m28.270s system)
> 
> After looking at the gprof output, it was clear that
> 
> >  %   cumulative   self              self     total           
> > time   seconds   seconds    calls   s/call   s/call  name    
> > 42.57     66.68    66.68    11999     0.01     0.01  insert_rules
> > 22.79    102.38    35.70 83528513     0.00     0.00  add_chain
> > 19.74    133.31    30.93 83541508     0.00     0.00  correct_verdict
> 
> there are two functions with almost O^2 complexity in libiptc, eating up
> 42.5% of the total runtime.   
> 
> the first case (add_chain) has now been eliminated from libiptc.  This
> was done in two steps: 
> 	1. make the chain cache work with relative offsets rather
> 	   than memory adresses (libiptc.c 1.39)
> 	2. add support to incrementally update the chain cache with
> 	   every operation, rather than rebuilding it from scratch
> 	   10000 times. (libiptc.c 1.40)
> 
> Now the results look like:
> 
> modified libiptc with relative offset + correct_cache()
> 	ruleset-1000:	2m19.566s (1m52.510s user / 0m26.980s system)
> 
> Which is a 46% execution speedup for the userspace part, quite
> promising.
> 
> The problem is with the second function (correct_verdict).  It corrects
> the jump destination after a rule has been inserted the ruleset.  There
> is no way to eliminate this O^2 complexity while keeping the current
> libiptc architecture.  To get rid of this complexity, one would need to
> reimplement iptables to use some intermediate data structure (like
> linked lists of chains, linked lists of rules) and then compiling the
> ruleset only at iptc_commit() time.  This would speed up rule insertion,
> since all you need is a simple list_add() for every iptc_append_entry().
> 

	I'm doing exactly that. The idea is to have a linked list of
chains, which point to a linked list of rules. When the table is read from
kernel it is transformed in that structure. At commit time we rebuild the
table. Every function on libiptc gets much easier, then: insert, replace,
delete, flush. The only that I see that gets a little harder is the 
counter_map handling, but that is offset, IMO, by the gains in the rest.

	Also, find_label would use a hash table to make it O(1). When 
building the structure I would also use a hashtable mapping from target 
offsets to chains.

> However, this is quite a task, and I'm not willing to put too much
> effort into this now.

	Well, I have to do that, since I have a project that requires
roughly 50,000 rules on 5,000 different chains. When I have something that
compiles I will send it to you.

	Regards,
	Andre
