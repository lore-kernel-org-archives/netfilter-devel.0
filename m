From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] Netfilter: Don't cachline align slab allocs
Date: Wed, 02 Feb 2005 11:55:19 +1100
Message-ID: <1107305721.10400.16.camel@localhost.localdomain>
References: <1105947649.3954.39.camel@localhost.localdomain>
	<20050201125731.GD6878@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>,
	Anton Blanchard <anton@samba.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050201125731.GD6878@sunbeam.de.gnumonks.org>
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

On Tue, 2005-02-01 at 13:57 +0100, Harald Welte wrote:
> On Mon, Jan 17, 2005 at 06:40:49PM +1100, Rusty Russell wrote:
> > Anton points out that cacheline aligning conntrack entries is a wank.
> > He's right: there's lots of them, and they're currently ~200 bytes.
>=20
> I'm totally fine believing both of you... but ... So why is/was it a ba=
d
> idea? =20

It has the effect of enlarging the structure to a cacheline boundary,
hence reducing density and worsening cache behaviour (as well as wasting
memory).  The only gain would be if there were a significant probability
of "false sharing" where two connection tracking entries accessed by
different CPUs were in the same cacheline.  This is unlikely because of
the number of conntrack entries, and the fact that they are bigger than
a cacheline already (ie. at worst, only two could share a cacheline, and
then not completely).

In general, cacheline aligned is hard to justify for any slab allocation
for performance reasons, as slab indicates that many are being
allocated.

> > Same with the cargo-cult programming in ipt_hashlimit.
>=20
> Mh, please elaborate about that 'cargo-cult programming' phrase - seems
> to be an expression I'm not familiar with, as non-native english
> speaker.

That's disingenuous: don't blame your language skills for my lack of
clarity.  From the jargon file:

http://www.catb.org/~esr/jargon/html/C/cargo-cult-programming.html

cargo cult programming: n.
       =20
        A style of (incompetent) programming dominated by ritual
        inclusion of code or program structures that serve no real
        purpose. A cargo cult programmer will usually explain the extra
        code as a way of working around some bug encountered in the
        past, but usually neither the bug nor the reason the code
        apparently avoided the bug was ever fully understood (compare
        shotgun debugging, voodoo programming).
       =20
        The term =91cargo cult=92 is a reference to aboriginal religions
        that grew up in the South Pacific after World War II. The
        practices of these cults center on building elaborate mockups of
        airplanes and military style landing strips in the hope of
        bringing the return of the god-like airplanes that brought such
        marvelous cargo during the war. Hackish usage probably derives
        from Richard Feynman's characterization of certain practices as
        =93cargo cult science=94 in his book Surely You're Joking, Mr.
        Feynman! (W. W. Norton & Co, New York 1985, ISBN 0-393-01921-7).
       =20
My only difference here is that I place 50% of the blame on the
interface, not the poor programmer who copied the code.

Rusty.
--=20
A bad analogy is like a leaky screwdriver -- Richard Braakman
