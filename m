From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: New draft document on nat / traversal / hole punching (with
	Dan Kegel)
Date: Wed, 10 Nov 2004 13:26:16 +0100
Message-ID: <1100089575.2660.6.camel@nienna.balabit>
References: <20041109154946.GD22257@sunbeam.de.gnumonks.org>
	<1100024526.6496.10.camel@tux.rsn.bth.se>
	<1100043724.25963.19.camel@localhost.localdomain>
	<20041109221025.6617b513.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: coreteam@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20041109221025.6617b513.davem@davemloft.net>
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


  Hi,

2004-11-10, sze keltez=E9ssel 07:10-kor David S. Miller ezt =EDrta:
> On Wed, 10 Nov 2004 10:42:04 +1100
> Rusty Russell <rusty@rustcorp.com.au> wrote:
>=20
> > On Tue, 2004-11-09 at 19:22 +0100, Martin Josefsson wrote:
> > > Rusty, iirc we have a problem in the NAT core when we SNAT and have=
 to
> > > remap ports, later SNAT'd connections from the same host:port pair
> > > doesn't get the same mapping as the first one. You were working on =
a fix
> > > for this? Was this ever made public?
> >=20
> > Dave, please apply.  (Thanks for the reminder Martin).
>=20
> Applied, thanks Rusty.

  BTW, are there any plans to apply this fix to 2.4 as well? (With the
in_range() fix included, of course.)

--=20
 Regards,
   Krisztian KOVACS
