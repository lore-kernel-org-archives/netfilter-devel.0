From: Joakim Axelsson <gozem@gozem.se>
Subject: Re: priv_data patch
Date: Mon, 14 Aug 2006 16:25:59 +0200
Message-ID: <20060814142559.GS7194@kriss.csbnet.se>
References: <44E07BCD.8030206@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Massimiliano Hofer <max@nucleus.it>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <44E07BCD.8030206@trash.net>
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

2006-08-14 15:34:05+0200, Patrick McHardy <kaber@trash.net> ->
> I'm afraid I have some bad news ..
> 
> While merging the priv_data patch I noticed an oversight. Currently,
> when modifying the ruleset, all modules dump their entire state
> (user configuration + internal state kept in the same structure)
> to userspace, which will return it to the kernel. That means for
> example that the limit match will not loose its current state when
> modifying other rules. When we move the state out of the data shared
> with userspace this can't be done anymore, so each modification to
> the table will cause all modules to loose their current state, even
> if they we're not directly affected by the change. We can't break
> this behaviour, so this limits potential users of the priv_data stuff
> to things like hashlimit or recent, which do a lookup of state stored
> completely external from the ruleset (and could use it to cache the
> lookup result). I don't think that this is worth it, we probably need
> to wait until we have a better userspace interface before we can do
> something like this ..
> 

I do not completly understand you. Today a modification of ONE rule will or
will not trigger the checkentry()/init() of ALL rules? 

I know they did before (in 2.4) since modules i have written has code to
workaround this. Having a low limiter like say a few packets each 5min can't
just be reset each time we modify another unrelated rule.

Latly howver it seams as it doesn't? What do you mean we are breaking with
this patch? A match/target doesn't have to use this new data area. Just let
don't alter them and they will continue to act aas they always done? We will
however provide better tools for new modules (not yet in pom-ng).

However, a problem that i just mailed about in another thread still exists.

The problem with limit acting up can be solved with my new module "lim". Its
so complety different that a new name is needed rather than a revision.
Solving the problem. Im currently porting it now.

Or did i missunderstand you completly?

--
Joakim Axelsson
