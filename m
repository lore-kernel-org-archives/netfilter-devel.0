From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: ip_conntrack performance issues
Date: 18 Jan 2003 03:30:18 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1042857018.16805.19.camel@tux.rsn.bth.se>
References: <200301180113.04460.alchemyx@uznam.net.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?iso-8859-2?Q?Micha=B3?= Margula <alchemyx@uznam.net.pl>
In-Reply-To: <200301180113.04460.alchemyx@uznam.net.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 2003-01-18 at 01:13, Micha=B3 Margula wrote:
> Hello!
>=20
> First of all I would like to apologize if issue I am writing about, was=20
> discussed here before. I wasn't looking trough archive, because it is abo=
ut=20
> 63 MB of pure mbox, I was only googling.
>=20
> The problem is that I have Linux box, that is making NAT for few hundreds=
 of=20
> workstations. I am using 2.4.18 but it also happens on 2.4.19 or 2.4.20. =
I=20
> need to run identd daemon for those workstations behind NAT. I am using=20
> oidentd for that purpose. Oidentd reads /proc/net/ip_conntrack to identif=
y=20
> connections.
>=20
> My /proc/net/ip_conntrack has about 100 000 entries. Sometimes less, some=
times=20
> more but near that value. Oidentd parsing that file "eats" almost whole C=
PU=20
> time. Running more than one instance of oidentd is simply a suicide. But =
that=20
> is not main problem - when parsing /proc/net/ip_conntrack my network goes=
=20
> weird. Packet lossess on every interface increase, round trip time behave=
s=20
> funny (jumping from 10 ms to 300). Network flow is also affected in a sam=
e=20
> way (file transfers "hangs" for a while).
>=20
> I investigated deeper into the problem and it is for sure not caused by=20
> oidentd. The problem lies in /proc/net/ip_conntrack interface. I tried=20
> running few instances of cat  /proc/net/ip_conntrack > /dev/null and effe=
ct=20
> was same as with ident daemon.

This is well known.

Are you sure you really googled? You should have found at least one of
my mail to this list about the very same issue.=20

You can read this:

http://lists.netfilter.org/pipermail/netfilter-devel/2002-April/007530.html

there are other messages about this matter aswell.

You can find my latest patch here:

http://gandalf.hjorten.nu/oidentd-2.0.3+cvs20020603-ctnetlink-diff

You need libctnetlink from the iptables2 module in cvs. And you need the
nfnetlink-ctnetlink-0.11.patch patch from patch-o-matic and

http://www.netfilter.org/~gandalf/patches/nfnetlink_conntrack-fix.diff

and possibly
http://www.netfilter.org/~gandalf/patches/libctnetlink-020809-2.diff

It's been a while since I touched this stuff, I don't remember if the
two last patches have been integrated or not.

> Friend of mine created "dirty hack" which consist of kernel module=20
> (ip_conntrack_identd) and patched version of oidentd, but he says that he=
=20
> won't make it public, because that solution is very bad and shouldn't be =
done=20
> this way.

ctnetlink + my patch will be enough. Then oidentd will use netlink to
perform a lookup in the conntrack hashtable. It's very fast and works
well here.

ctnetlink will be the standard way to communicate with ip_conntrack from
userspace.

I'd guess that your friends module (ip_conntrack_identd) does about the
same as the ctnetlink stuff. Just recive the tuple from userspace,
perform the lookup in the hashtable and return the answer.

> Also it is not problem of performance of box making NAT because I am usin=
g 2 x=20
> Xeon 2.0 GHz with HyperThreading (on 2.4.19 or 2.4.20) so it has power of=
=20
> almost four CPUs and nothing has changed.
>=20
> So question is - what now? Are there any ideas to improve performance of=20
> /proc/net/ip_conntrack or maybe replacing that with some calls to interna=
ls=20
> of the kernel? It is quite important issue, because using ident daemon on=
=20
> boxes with huge amounts of traffic is impossible.

/proc/net/ip_conntrack has an O(n^2) complexity and you have to search
it in a linear fashion. It will never become a fast interface to the
ip_conntrack hashtable. Use ctnetlink.

Oh I must mention that ctnetlink isn't finished :) YMMV

--=20
/Martin

Never argue with an idiot. They drag you down to their level, then beat you=
 with experience.
