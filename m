From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: OpenBSD Firewall Failover with pfsync and CARP, Netfilter solutions?
Date: Sun, 4 Apr 2004 13:40:52 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040404104052.GB19532@edu.joroinen.fi>
References: <20040330153008.GH1237@eychenne.org> <20040404101851.GA19532@edu.joroinen.fi> <1081074350.1649.68.camel@anduril.intranet.cartel-securite.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Cedric Blancher <blancher@cartel-securite.fr>
Content-Disposition: inline
In-Reply-To: <1081074350.1649.68.camel@anduril.intranet.cartel-securite.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, Apr 04, 2004 at 12:25:50PM +0200, Cedric Blancher wrote:
> Le dim 04/04/2004 =E0 12:18, Pasi K=E4rkk=E4inen a =E9crit :
> > I noticed this one too.. I'm wondering, if there is same functionalit=
y
> > available for Linux ?
>=20
> Not yet.
>=20
> > ucarp runs on Linux too, as does vrrp, but the pfsync-part seems to b=
e
> > missing.. ?
>=20
> It's pf specific. pf runs on BSD, not on Linux, the same way Netfilter
> is specific to Linux.
>=20

Yep, I know this. Maybe I should have said "pfsync like thing for netfilt=
er"
instead of "pfsync-part" :)

> > Is there any way to synchronize the state tables of two Linux/Netfilt=
er
> > boxes?
>=20
> Harald seems to be working hard on this (libnfnetlink/libctnetlink). Se=
e
> CVS.
>=20

OK. Nice. I'll check the CVS. Any ideas about the current status of this
work?

-- Pasi K=E4rkk=E4inen
      =20
                                   ^
                                .     .
                                 Linux
                              /    -    \
                             Choice.of.the
                           .Next.Generation.
