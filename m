From: Andre Uratsuka Manoel <andre@insite.com.br>
Subject: Re: IPtables performance (fwd)
Date: Fri, 2 May 2003 17:15:50 -0300 (BRT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0305021628100.8241-100000@fantomas.insite.com.br>
References: <Pine.LNX.4.44.0305021921030.14737-100000@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
	"netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>,
	Robert Olsson <robban@robtex.com>,
	John McEleney <john@netservers.co.uk>,
	Ben McKeegan <ben@netservers.co.uk>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Wilson <chris@netservers.co.uk>
In-Reply-To: <Pine.LNX.4.44.0305021921030.14737-100000@localhost>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



	I also may be making a fool of myself (not a first), but my take
is this:

	The traditional algorithm for finding loops in graphs is:

	paint every vertex white
	for every vertex (in this case, for every hook)
		visit(vertex)
	visit(vertex) is:
		if vertex is gray, return LOOP
		if vertex is black, return NO_LOOPS
		if vertex is white
			paint vertex gray
			for every arc leaving from vertex
				if (visit(arc->destination) == LOOP)
					return LOOP
			paint vertex black.
		return NO_LOOPS


	This takes 1 visit to every vertex and 1 verification for every 
arc, but that's it.

	If you have to also colour chains according to what hooks they
came from, the easiest way would be to use about the same algorithm to
traverse the chains, marking the comefrom bitfield. For that you have to
paint the chains white (unvisited) every time (or you use a bitfield and
set it only once).

	for every vertice:
		paint vertex white
	vertex := vertex pointed to by hook
	visit_and_mark(vertex)

	visit_and_mark(vertex) is:
		if (vertex is white)
			mark(vertex)
			paint vertex gray
			for every arc leaving from vertex
				visit_and_mark(vertex)

			
	One visit per vertex downstream from a hook, one check per arc.
Vertices that are used by more than one hook would be visited n times, but
no vertice would be visited more times than twice. It takes O(n+m).

	So, in pathological cases, you would have 2 visits to every chain
and every rule, to find loops, plus 6 visits to every chain and every rule
(supposing every rule is used by every hook), but it is still linear time, 
no matter how complex the ruleset is.


> > > It appears to me that loop check made by mark_source_chains is
> > > deterministic, so once we've visited a particular rule, and determined
> > > that there are no loops in the paths leading from it, then the rule is
> > > _safe_, and we don't need to check it again.
> > 
> > You are missing the other half of the functionality of
> > mark_source_chains:  It needs to write down (into the 'comefrom' field),
> > from which hooks the particular rule can be called.
> > 
> > There are matches (like the 'owner' match), that can only be used at
> > certain hooks (in our example: There is no socket owner at
> > NF_IP_FORWARD).
> 
> I agree completely that it's important for the kernel to verify that the 
> ruleset does not break this condition by calling rules which are not 
> valid from a given hook.
> 
> However, it seems to me that it's only necessary to visit each rule once 
> _and_ set the appropriate bit in the 'comefrom' bitmask. Once the bit is 
> set, there's no use setting it again.
> 
> So it's only necessary to visit each rule once per hook, in order both to 
> detect loops and mark the valid source chains (hooks).
> 
> Therefore, if the patched code does actually succeed in visiting each rule 
> once, and detecting loops, and setting the appropriate bit in comefrom, 
> then it's functionally equivalent to the original code, right?
> 
> Thanks for including the patch in pom/extra, we look forward to having it 
> well tested. =)
> 
> Cheers, Chris.
> 
