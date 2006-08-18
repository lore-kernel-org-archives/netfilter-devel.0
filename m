From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: new ABI
Date: Fri, 18 Aug 2006 23:40:18 +0200
Message-ID: <200608182340.19213.max@nucleus.it>
References: <200608142312.41851.max@nucleus.it>
	<200608160057.05431.max@nucleus.it>
	<1108.83.88.199.217.1155910475.squirrel@mail.parknet.dk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Simon Lodal" <simonl@parknet.dk>
In-Reply-To: <1108.83.88.199.217.1155910475.squirrel@mail.parknet.dk>
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

On Friday 18 August 2006 4:14 pm, Simon Lodal wrote:

> > Everyone agrees that we have reached the maximum expressiveness with
> > the  current system.
>
> You mean we have created the ideal system?!
>
> Or that we have created a mess that is no longer extendable?

Something in between. :)
You can do incremental improvements, but some people is asking for structural 
changes in order to achieve other goals.

I'm not dissatisfied with the current code. The whole purpose of this thread 
is to understand if there is something worth an extensive change of the API 
(between core netfilter and its modules), possibly maintaining the ABI.

I was just seeking new ideas for the sake of it. Then we'll see what's worth, 
what can be done with what we have today, what is just too troublesome and 
what is just too idealistic to achieve in the near future (but potentially 
interesting).

The hard part will be when someone will have to do the real work. ;)

> > The real question thus becomes: is it worh to restart from (almost)
> > scratch?
>
> Sometimes you can have something entirely different in mind and still make
> incremental changes.
> The iptables syntax/interface as seen by user is far from stellar but
> perhaps good enough for it's purposes. I do not see any urgent need to
> change it's syntax.

Neither do I, but it's mostly a matter of taste.

> But the API's suck. Good ideas get nowhere because the API's can not
> support it. Is that really controversial? My point is they need to change,
> and it will be incomatible, too bad, but is has to done some day.

The question is: how much can we change the API without affecting the ABI?
Most things can be added incrementally, but I mostly started this thread 
because Patrick complained about the lack of a way to change individual rules 
or matches.
I think this will be the hardest feature yet proposed.

> The idea is just to make it less error prone to write match/target
> modules; the less free()'s you need to call the less memory leaks we get.
> Since you can only have one .instance_data pointer, the old one should be
> deallocated if you allocate another. Why not let netfilter do that. You
> would just tell netfilter how much memory you need, and it will just
> deliver that. And guarantee against accidental memory leaks in individual
> modules.

We'd need a 2 stage intialization. Something like:
- a simple init for matches that don't need .(priv|instance)_data or that 
declare a fixed size in the match registration;
- a size determinig call and the real init for dynamic ones.

This could be tricky for complex data and this could be rare enough to justify 
a fixed base structure and more complex data completely managed by the match 
module. People might end up like that anyway if what we do isn't enough 
(after all we could supply arbirtrarily sized structures, but only at init 
time). Maybe the simple solution would be enough.

> Here, the only rule is: No pointers. Use local offsets instead if you
> really need to "point".

No "local" pointers. Pointers to external data will work.

With these requirements we could keep the current copy and discard mechanism.
We could have a match array (mostly like the current one) and supplement it 
with a (priv|instance)_data array with size and offsets computed with a quick 
pass through the first one. With proper locking we could copy the necessary 
data with no memory fragmantation, and no lists.
Of course we have a major disadvantage: the current code can afford to build 
the new array without locking. The list approach can lock single nodes or the 
whole list for the time needed to change a single node. This last proposal 
would need to lock everything while it copies what could be thousands of 
rules.

The main questio remains this one: are we really scared by fragmentation?
I'll do some investigation, but I don't know if I'll have an answer.

> The most important goal is to pass a number of pointers (descriptors) to
> the modules, each being shared in different ways (and having dynamic size,
> preferably). It might work if any module could (re)allocate those shared
> memory areas independently, but would be much simpler if netfilter
> allocation wrappers handles synchronization between them.

You're describing priv_data. :)

> > Either way we'll need some form of rule and match id.
> > I don't know what level of transactionality is desired. Currently
> > iptables-restore is atomic and so are single changes with iptables. How
> > much  is needed with the new system? At least rule level atomicity is
> > certainly  desired, so we'll need to create duplicate data (just the
> > core structure with  pointers to the real descriptors) during
> > modifications.
>
> I agree with that desire. But it totally rules out a filesystem
> representation, I guess. Not that I really want an iptablesfs.
> I guess some hierarchical locking would be necessary.

I mentioned the file system approach just for the sake of it. I like the 
everything-is-a-file approach, but it certainly has its limits.

-- 
Saluti,
   Massimiliano Hofer
        Nucleus
