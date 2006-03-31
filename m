From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 4/4] first conntrack ID must be 1 not 2
Date: Fri, 31 Mar 2006 20:35:27 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0603312026030.9154@blackhole.kfki.hu>
References: <43EFF1F0.1090701@netfilter.org>
	<20060213112028.GU4601@sunbeam.de.gnumonks.org>
	<43F438F5.8070607@trash.net>
	<Pine.LNX.4.58.0602160943060.26770@blackhole.kfki.hu>
	<43F43FA9.4000906@trash.net>
	<Pine.LNX.4.58.0602161005450.26770@blackhole.kfki.hu>
	<43F4426D.9060807@trash.net>
	<Pine.LNX.4.58.0602161017590.26770@blackhole.kfki.hu>
	<43F4DBDF.9010008@trash.net> <442B9765.2020105@ufomechanic.net>
	<442C81A6.3040501@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Amin Azez <azez@ufomechanic.net>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <442C81A6.3040501@trash.net>
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

On Fri, 31 Mar 2006, Patrick McHardy wrote:

> >> Actually it would still not be unique if connections live
> >> shorter than a jiffy and are resurrected.
> >
> > In which case would there be any harm in it not being unqiue, if it were
> > the same connection resurrected, why try to avoid having the same id?
>
> Besides solving an implementation problem, so ID was meant as a
> long-term unique identifier. For the life-time of a connection
> the tuples are already a unique identifier.
>
> It's amazing, I've never had so many discussions about a single
> 32 bit field :)

It's amazingly hard to accept we need it :-).

Putting aside the implementation problem, there are so many information
already available in the conntrack entries: tuples, packet and byte
counters, state, timeout value. Those together can serve as a short-term
unique identifier, even after the entry is actually deleted. Not
bulletproof, but in practice those can be sufficient.

I could not resist... :-))

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
