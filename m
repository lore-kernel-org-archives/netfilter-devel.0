From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: nf_conntrack
Date: Mon, 1 Mar 2004 12:47:29 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0403011222510.31180-100000@blackhole.kfki.hu>
References: <20040224092137.GU13386@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>,
	<netfilter-devel@lists.netfilter.org>,
	Rusty Russell <rusty@rustcorp.com.au>, <jozef@sunbeam.gnumonks.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040224092137.GU13386@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Tue, 24 Feb 2004, Harald Welte wrote:

> > In previous version, the l3 part in tuple is represented by "union" of IPv4
> > and IPv6 address.
> >
> > And in this version, size of the l3 part in tuple varies with layer 3
> > protocol.  Then it's more complex than the previous version, but can
> > save memory spaces where many IPv4 connections are created.
>
> Yes, this is definitely something we need.  Although I still don't like
> the idea of having to explicitly allocate three pieces of memory
> (2*tuple, 1*nf_conntrack) per new connection.  This will hurt connection
> setup rate very badly, I expect :(

I don't like allocating in chunks either.

> What I initially had in mind (but don't know if it can be implemented in
> any reasonable way) was:
>
> - have a static part of struct np_conntrack without tuples
> - this static part contains a bitmask
> - this bitmask determines which 'extension structures' are present at
>   the end
> - possible 'extension structures' might be:
> 	- ipv4 orig/reply tuple
> 	- ipv6 orig/reply tuple
> 	- ipv4 l3 protocol (and helper) data
> 	- ipv6 l3 protocol (and helper) data
>
> I know it sounds very tricky.  We always guarantee the ordering of such
> extension structures.  The nf_conntrack core would maintain a list of
> slab caches for every reasonable combination of extensions structures.
> The extension structures are always allocated in one chunk gogether with
> the static nf_conntrack 'header'.
>
> Extension structures would always be accessed via pre-defined macros
> (which just add an offset depending on the bitmask)
>
> Even thinking further, this would enable us to put more parts than just
> the tuple into those extensions (let's say the nat or helper union).
> This in turn means that we can make conntrack structures for the normal
> case (ipv4 only, no helper, no nat) even smaller.
>
> I'm not sure if it's worth performance-wise.  The benefits of such a
> solution would be:
>
> 1) still one chunk of memory for any conntrack
> 	- one allocation at connection setup time
> 	- conntrack+tuple still physically close in memory instead of
> 	  having to dereference every tuple
> 2) potentially smaller conntracks even in the current 'normal' case
>    (one of our long-term wishes)
>
> As disadvantage I can see
> 1) difficult implementation with lots of macros/offset calculation
> 2) we'd have to determine which slab we came from at destroy() time
>    [maybe save cachep in nf_contrack?]
> 3) slightly higher computational cost when we want to access extension
>    structures (like tuples), since relative offset has to be calculated
>    at runtime.
>
> What do you think?

Definitely this is the way we should go.

Even NAT-PT could be fitted into it, with the overhead of allocating
new conntrack entries at NAT-PT. Maybe Henrik's suggestion to use a
special tun device would be more optimal from performance point of view,
with the cost of two conntrack entries for each protocol-translated
session.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
