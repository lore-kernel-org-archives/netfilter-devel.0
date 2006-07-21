From: Joakim Axelsson <gozem@gozem.se>
Subject: Re: [PATCH] priv_data 0/2
Date: Fri, 21 Jul 2006 11:29:10 +0200
Message-ID: <20060721092909.GW7194@kriss.csbnet.se>
References: <200606261641.47294.max@nucleus.it> <44A962DF.3080406@trash.net>
	<200607032305.06581.max@nucleus.it>
	<44A9A103.8090705@anduras.de> <44A9B458.1030106@trash.net>
	<20060720223846.GV7194@kriss.csbnet.se>
	<44C010DF.1060604@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <44C010DF.1060604@trash.net>
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

2006-07-21 01:25:19+0200, Patrick McHardy <kaber@trash.net> ->
> Joakim Axelsson wrote:
> > 2006-07-04 02:20:40+0200, Patrick McHardy <kaber@trash.net> ->
> > 
> >>Sven Anders wrote:
> >>
> >>>If this is merged, I would like to see a negated limit...
> >>>I need some advice to preserve compatibility here.
> >>
> >>Once this is merged we can convert matches and targets to keep their
> >>private state outside of the structure shared with userspace and can
> >>start reusing the fields, since they are ignored by userspace anyway.
> >>I'm not sure, but I think currently userspace initializes them to 0,
> >>which should make this easy.
> >>
> > 
> > 
> > I wonder where all this priv_data changes ended?
> 
> We missed the 2.6.18 merge window and I'm currently busy with a few
> other things, so I delayed it a bit. It will go in 2.6.19, I'll post
> the patches once I've merged them in my 2.6.19 tree.
> 

Okie. Guess i'll wait with updating it.

> > I have a few modules (that
> > I havn't submited, because i've been way to lazy :-/) that will benefit from
> > this. Among those a new limiter matcher simply called "lim". This match will
> > solve Sven Anders problem with negating match. It's also much more aqurate
> > and using a better limiter algoritm. Including being able to limit on packet
> > size etc etc. It has been working stable in large scale routers (several
> > 100Mbit/s) for a year now I think.
> 
> Please just post what you've got, I'd be interested in seeing why you
> chose to introduce a new match instead of enhancing the existing limit
> match.

Because i wrote it before revisions existed and its takes totally different
userspace parameters. You can find it here:
http://www.gozem.se/~gozem/netfilter/kernel/lim/

Userspace here:
http://www.gozem.se/~gozem/netfilter/userspace/

I'll try to submit them in pom-ng -format as soon as possible. That is if
netfilter-dev wants them. I know there are supposed to be external
svn-repositories nowdays, but i havn't really figured out how that is
supposed to work yet. So please point me in the right direction.

Ihave a patch for kernel but it includes 3 more modules described
below:
http://www.gozem.se/~gozem/netfilter/kernel/lim-norm-COUNT-SPEED.patch

Please read the comments on the algoritm in the code. Its more accurate as
it never useds any division which will have rounding errors. However, its
uses a few 64 bits integers. But i trade memory for a more accurate
alogritm. Specially when dealing with a few 1000/s. The existing limit
doesn't do this correctly at all. It starts limiting at a lower level. Also
it has fetuares as:
- Negation
- bytes-limit instead of packets
- Blackout. Limit down to zero if limited.
- Much more flexible way ot taking the limit amount. The following is valid
for example: --lim-packets 10k/2sec. Meaning 10 000 for each two seconds.
- Also, the --lim-start makes more sense than --limit-burst. --limit-burst
is a multiplier of --limit. I belivie many thinks of it as an absolut figure
then to start the limiting rather than being related as a multiplier for the
base figure of --limit.
- lim is shorter to write :-) It a very commonly used match in my firewall
setup.

The 3 other modules:
COUNT - As i've said before. A counting target that represents its figures
in /proc

SPEED - A speed-caclulating target, other the same as COUNT.

norm - A normalizer of traffic/packet flow. Uses the algoritm of my 'lim'
and my 'speed' combined. It has not been tested that well had the code needs
cleaning up.

A few more coming is:
-j LOG new revision. It will take a longer --log-prefix. 29 chars are way to
short for me. I have a large scale firewall setup and need to log the chain
name and a reason. This simply doesn't fit in 29 chars for most of the time.
Also a --log-limit and --drop. Its very common that you want to log the
packets you DROP but do not want to flood yourself with messages in case of
attacks. This solution will otherwise need a new chain and 2 or 3 rules in
that new chain. Unnessasary waste of memory, CPU and cachelines.

-m log, Same as -J LOG but (wrongly) using a match so not an extra rule or
chain is needed to actually do something with the packets later.

-m unclean new revision. With _alot_ of options so you can specifty exactly
which tests you want. Also with a --log that logs the packet with a reason
and an option prefix, rather than using the printk it does now. I know the
general option is that unclean is dangerous and possibly wrong. However i
use it very succesfully for several years now. A bit patched though to
correct a few things.

If anything above sounds intressting (or wrong). Please let me know.
