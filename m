From: =?ISO-8859-1?Q?S=E9rgio_Bernardino?= <sergio.bernardino@gmail.com>
Subject: Re: LibIPQ issue
Date: Wed, 9 Mar 2005 00:36:23 +0000
Message-ID: <e54bc18805030816365ac642bb@mail.gmail.com>
References: <e54bc1880503070451419fc57@mail.gmail.com>
	<422C52AB.4030801@trash.net>
	<e54bc1880503071117322999d@mail.gmail.com>
	<Pine.LNX.4.62.0503072027540.5934@kaber.coreworks.de>
	<e54bc188050308150854d6b128@mail.gmail.com>
	<20050308233028.GA10431@zion.homelinux.com>
Reply-To: =?ISO-8859-1?Q?S=E9rgio_Bernardino?= <sergio.bernardino@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050308233028.GA10431@zion.homelinux.com>
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

It was hardly a stupid question. That was precisely the problem!
Such a simple thing and i completely failed to consider that possibility.
Thank you all for your help, it was priceless.

> On Tue, Mar 08, 2005 at 11:08:17PM +0000, S=E9rgio Bernardino told us:
> > After a bit more time working with this i realized something "interesti=
ng":
> > When i send a packet from a machine A to a machine B and capture it in
> > PRE_ROUTING, if i change the destination address so that it points to
> > machine C, the packet disappears and i can't track it anywhere. On the
> > other hand, if i instead change the source address of the packet so
> > that it points to machine C everything works fine. I can "see" the
> > packet traversing into machine B, which receives the packet and
> > promptly replies sending a packet to machine C. Machine A never
> > receives a reply to the packet it sent and machine C receives a reply
> > from a packet it never sent. Exactly the behaviour expected when
> > changing the source address field. Now, if this works in this case,
> > merely changing it to alter the destination address (my original
> > intention) should work also, but it doesn't.
> > My code can't be incorrect in a situation like this, so what exactly
> > is wrong? And is there a away to solve such situation?
> > Ideas anyone?
On Wed, 09 Mar 2005 00:29:28 +0100, Patrick McHardy <kaber@trash.net> wrote=
:
>=20
> Have you got IP forwarding enabled ?
>=20
> echo 1 >/proc/sys/net/ipv4/ip_forward
>=20
> Regards
> Patrick
>=20
>=20
On Wed, 9 Mar 2005 00:30:28 +0100, Sven Schuster <schuster.sven@gmx.de> wro=
te:
>=20
> Hi S=E9rgio,
>=20
> Stupid question, but do you have ip_forward set to 1 on machine B??
>=20
> Sven
>=20
> --
> Linux zion 2.6.11-mm1 #1 Sat Mar 5 13:54:40 CET 2005 i686 athlon i386 GNU=
/Linux
>  00:28:53 up 3 days,  3:34,  2 users,  load average: 0.12, 0.07, 0.06
>=20
>=20
>=20
--=20
S=E9rgio Bernardino

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
"The Dragon awakens in the darkness
with a frozen heart he roars.
If you are close, the dragon sleeps
And when the wings appear before him
people's dreams will fill the sky..."
