From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: [ANNOUNCE] Release of libnfnetlink,
	libnfnetlink_conntrack and conntrack
Date: Tue, 27 Sep 2005 15:23:11 +0300
Message-ID: <20050927122310.GK10146@edu.joroinen.fi>
References: <20050924215413.GD731@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: coreteam@netfilter.org,
	Netfilter Announcement List <netfilter-announce@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	lwn@lwn.net
Content-Disposition: inline
In-Reply-To: <20050924215413.GD731@sunbeam.de.gnumonks.org>
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

On Sat, Sep 24, 2005 at 11:54:13PM +0200, Netfilter Core Team wrote:
> Hi!
>=20
> The netfilter project proudly presents:
>=20
> 	libnfnetlink-0.0.10
> 	libnfnetlink_conntrack-0.0.10
> 	conntrack-0.81
>=20
> Each of those three releases is the first official release of the
> respective project.  They're the counterparts to the first pieces of th=
e
> "next generation" netfilter subsystem that will be present in the 2.6.1=
4
> linux kernel release.
>=20
> libnfnetlink
> 	is the low-level userspace library for nfnetlink based
> 	communication between the kernel-side netfilter and the
> 	userspace world.
>=20
> libnfnetlink_conntrack
> 	is the librarry for userspace access to the in-kernel connection
> 	tracking table.
>=20
> conntrack
> 	is a commandline program for listing, querying, deleting,
> 	updating entries in the connection tracking table.  It also
> 	supports real-time tracing of connection tracking state changes
> 	(conntrack events).
>=20
> You can download the three releases from=20
> 	ftp://ftp.netfilter.org/pub/libnfnetlink/libnfnetlink-0.0.10.tar.bz2
> 	ftp://ftp.netfilter.org/pub/libnfnetlink_conntrack/libnfnetlink_conntr=
ack-0.0.10.tar.bz2
> 	ftp://ftp.netfilter.org/pub/conntrack/conntrack-0.81.tar.bz2
>=20
> Happy firewalling,
>=20
> 	Harald Welte (for the Netfilter Core Team)
>

Cool.=20

These will be used for the future netfilter-ha / conntrack sync stuff?

- Pasi K=E4rkk=E4inen
=20
> p.s.: expect some more news on libnfnetlink_log and libnfnetlink_queue
> in the next couple of days(!)
>=20
> --=20
> - Harald Welte <laforge@netfilter.org>             http://www.netfilter=
.org/
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>   "Fragmentation is like classful addressing -- an interesting early
>    architectural error that shows how much experimentation was going
>    on while IP was being designed."                    -- Paul Vixie
