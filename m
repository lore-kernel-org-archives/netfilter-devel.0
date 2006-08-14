From: Joakim Axelsson <gozem@gozem.se>
Subject: Re: priv_data patch
Date: Mon, 14 Aug 2006 17:20:26 +0200
Message-ID: <20060814152026.GU7194@kriss.csbnet.se>
References: <44E07BCD.8030206@trash.net>
	<20060814142559.GS7194@kriss.csbnet.se>
	<44E08946.1040105@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Massimiliano Hofer <max@nucleus.it>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <44E08946.1040105@trash.net>
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

2006-08-14 16:31:34+0200, Patrick McHardy <kaber@trash.net> ->
> Joakim Axelsson wrote:
> > 2006-08-14 15:34:05+0200, Patrick McHardy <kaber@trash.net> ->
> > 
> >>I'm afraid I have some bad news ..
> >>
> >>[...]
> >
> > I do not completly understand you. Today a modification of ONE rule will or
> > will not trigger the checkentry()/init() of ALL rules? 
> 
> Yes it will. Modification happens like this:
> 
> - dump entire table to userspace
> - modify table
> - send new table to kernel
> 
> _All_ matches and target and reinstantiated, since the kernel doesn't
> know which rule in the currently active table corresponds to which
> in the new table. When moving state out of the data shared with
> userspace it will get lost during this.
> 

Lost? Like the memory will be reallocated and we have a memory leak from the
old priv_data?

Can't we just figure out if thie pointer is null and don't allocate new
memory?

Or am i lost here?

> > I know they did before (in 2.4) since modules i have written has code to
> > workaround this. Having a low limiter like say a few packets each 5min can't
> > just be reset each time we modify another unrelated rule.
> 
> Exactly.
> 
> > Latly howver it seams as it doesn't? What do you mean we are breaking with
> > this patch? A match/target doesn't have to use this new data area. Just let
> > don't alter them and they will continue to act aas they always done? We will
> > however provide better tools for new modules (not yet in pom-ng).
> 
> Well, if nobody can use it reasonable there is no reason to introduce
> it.

Alot of my patches can use it. Not having todo an ugly solution trying to
sneak away from being reseted when another rule is altered. I sure would
like to have it added. Simpyl do not change for example -m limit into using
it if it breaks the "feature" of reseting its state then altering another
unrelated rule.

Please have a look here for 4 modules "needing" this patch:
http://www.gozem.se/~gozem/netfilter/

I'm copying here the code they are using today to workaround this
reset-"feature":

struct info {
	... data here ...
	atomic_t refcount;
};

init() {
	/* Already initiated? Since this is runned each time ANY rule is changed */
	if (lim->state != NULL) {
		/* Increase the reference counter so we wont delete this match */
		atomic_inc( &lim->state->refcount );

		DEBUGPRINT("already initiated, abort ref=%u", 
		   atomic_read( &lim->state->refcount) );

		return 1;
	}
		
	/* init state data, set refcount to 1 */
	lim->state = kmalloc( sizeof(struct ipt_lim_state), GFP_ATOMIC );
	if (lim->state == NULL)
		return -ENOMEM;
	atomic_set(&lim->state->refcount, 1);
}

destroy() {
	/* Decrease our reference counter and test if its zero*/
	if ( atomic_dec_and_test(&lim->state->refcount) ) {
		/* Really delete this match */
		DEBUGPRINTP("really delete");

		/* free state */
		kfree(lim->state);
	}
}


--
Joakim Axelsson
