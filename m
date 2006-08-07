From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] ipset matches either,both
Date: Mon, 7 Aug 2006 12:49:31 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0608071108130.8741@blackhole.kfki.hu>
References: <eat75p$9o4$1@sea.gmane.org>
	<Pine.LNX.4.58.0608070907400.8741@blackhole.kfki.hu>
	<44D6FF0A.8050009@ufomechanic.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <44D6FF0A.8050009@ufomechanic.net>
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

On Mon, 7 Aug 2006, Amin Azez wrote:

> * Jozsef Kadlecsik wrote, On 07/08/06 08:41:
> > Hi,
> >
> > On Thu, 3 Aug 2006, Amin Azez wrote:
> >
> >
> >> These patches to ipset allow "either" and "both" to be specified as well
> >> as "src" and "dst".
> >
> > I'm a bit surprised because "either" can naturally be expressed by two
> > iptables rules and "both" is equivalent with two set matches:
> >
> > iptables ... -m set --set foo src -m set --set foo dst
> >
> > Why do you need "both" and "either" encoded internally in ipset?
> >
> Since when did iptables allow the same module to be used twice in a rule
> like that?

>From the svn changelog:

iptables.c, rev 6474, modified Fri Mar 3 09:36:50 2006 UTC (5 months ago):

Multiple matches of the same type can be specified on the commandline.

If two or more matches of the same type are detected then the options
are assumed to be grouped in order to tell which option belongs
to which match:

... -m foo ... <options0> ... -m foo ... <options1> ...

Otherwise the commandline parsing is unmodified.

> Although "either" can be expressed as two iptables rules, it gets hard
> if you want to use ! for neither, and your action is drop or return or
> something drastic. You have to start fiddling with subchains and it all
> gets very awkward.

You can express "neither A or B" as "not A and not B".

> >> I considered doing this as a hack in ip_set.c, by calling the match
> >> twice, faking flags of SRC and DST, but it was a hack and wouldn't
> >> easily cover the porthash which consumes two flags.
> >>
> >> Instead I've altered the test of all of the set types, to accept BOTH
> >> and EITHER as well.
> >
> > But thus all the extensions (set types) have to know what "both" and
> > "either" means, which'd belong to the ipset core as I believe, if
> > introduced.
> >
> You are probably right, but the current design where ipporthash consumes
> two flags doesn't permit this.

Sorry, I don't see why.

> >> I've tested the behaviour of src dst either and both for iphash.
> >> I'm not sure about ipportmap because the man pages aren't clear how to
> >> write rules for this.
> >
> > In order to match both dst IP and dst port (for example all publicly
> > available servers behind a firewall) one can use an ipportmap type of set
> > and a single rule like this:
> >
> > iptables ... -m set --set foo dst,dst
> >
> with bindings, yeah; we we going to do this, it would allow "both" if a
> set was bound to itself, but wouldn't allow "either."

No, without bindings. It *is* confusing :-(. In an ipporthash type of set
(sorry for the typo above, ipportmap does not exist) you store an IP
address and a port together. And therefore you can match any of the four
possibilities (src,src,...., dst,dst) in one go, but the most useful is
the example I cited:

# our public servers:
ipset -N foo ipporthash --network 192.168.0.0/16
ipset -A foo 192.168.0.1%22
ipset -A foo 192.168.0.2%80
ipset -A foo 192.168.0.3%25
....

# Allow access to our public servers
iptables -A FORWARD -p tcp -m set --set foo dst,dst -j ACCEPT

> > Pablo and I started to rewrite ipset using netlink as kernel/userspace
> > communication interface in the spring and thrown out bindings as
> > unnecessary baggage. Unfortunately I have been overburdened since then and
> > will only be able to pick up and continue the work in October :-(. But
> > that gives a wide window for new ideas in ipset(/nfset) :-).
> >
> Are you happy to "bless" this patch as embodying an ipset feature that
> will be retained in future revisions?

I'm open to feature requests and suggestions for the next revisions but
still not convinced about "both" and "either", sorry:

"both" is equal to    -m set --set foo src -m set --set foo dst
"neither" is equal to -m set ! --set foo src -m ! set --set foo dst
"either" can be expressed by two iptables rules.

So what can we gain?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
