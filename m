From: Chris Wilson <chris@netservers.co.uk>
Subject: Re: IPtables performance (fwd)
Date: Fri, 2 May 2003 19:32:29 +0100 (BST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0305021921030.14737-100000@localhost>
References: <20030429143442.GD684@naboo.intranet.astaro.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, Robert Olsson <robban@robtex.com>,
   John McEleney <john@netservers.co.uk>, Ben McKeegan <ben@netservers.co.uk>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030429143442.GD684@naboo.intranet.astaro.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Harald,

> I have to admit that I don't exactly remember all the details about
> mark_source_chains without re-investigating it as well.  I did that now,
> so I think I'm fit for further discussion  ;)

I know it's late on Friday evening and I'm in a rush to get home, but I'd
like to give everyone the weekend to think about this, so I'm going to
venture into unknown territory and risk making a fool of myself in public =)

> > It appears to me that loop check made by mark_source_chains is
> > deterministic, so once we've visited a particular rule, and determined
> > that there are no loops in the paths leading from it, then the rule is
> > _safe_, and we don't need to check it again.
> 
> You are missing the other half of the functionality of
> mark_source_chains:  It needs to write down (into the 'comefrom' field),
> from which hooks the particular rule can be called.
> 
> There are matches (like the 'owner' match), that can only be used at
> certain hooks (in our example: There is no socket owner at
> NF_IP_FORWARD).

I agree completely that it's important for the kernel to verify that the 
ruleset does not break this condition by calling rules which are not 
valid from a given hook.

However, it seems to me that it's only necessary to visit each rule once 
_and_ set the appropriate bit in the 'comefrom' bitmask. Once the bit is 
set, there's no use setting it again.

So it's only necessary to visit each rule once per hook, in order both to 
detect loops and mark the valid source chains (hooks).

Therefore, if the patched code does actually succeed in visiting each rule 
once, and detecting loops, and setting the appropriate bit in comefrom, 
then it's functionally equivalent to the original code, right?

Thanks for including the patch in pom/extra, we look forward to having it 
well tested. =)

Cheers, Chris.
-- 
   ___ __     _
 / __// / ,__(_)_  | Chris Wilson -- UNIX Firewall Lead Developer |
/ (_ / ,\/ _/ /_ \ | NetServers.co.uk http://www.netservers.co.uk |
\ _//_/_/_//_/___/ | 21 Signet Court, Cambridge, UK. 01223 576516 |
