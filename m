From: Sven Schuster <schuster.sven@gmx.de>
Subject: Re: LibIPQ issue
Date: Wed, 9 Mar 2005 00:30:28 +0100
Message-ID: <20050308233028.GA10431@zion.homelinux.com>
References: <e54bc1880503070451419fc57@mail.gmail.com>
	<422C52AB.4030801@trash.net>
	<e54bc1880503071117322999d@mail.gmail.com>
	<Pine.LNX.4.62.0503072027540.5934@kaber.coreworks.de>
	<e54bc188050308150854d6b128@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Cc: netfilter-devel@lists.netfilter.org
To: =?iso-8859-1?Q?S=E9rgio?= Bernardino <sergio.bernardino@gmail.com>
Content-Disposition: inline
In-Reply-To: <e54bc188050308150854d6b128@mail.gmail.com>
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


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi S=E9rgio,

On Tue, Mar 08, 2005 at 11:08:17PM +0000, S=E9rgio Bernardino told us:
> After a bit more time working with this i realized something "interesting=
":
> When i send a packet from a machine A to a machine B and capture it in
> PRE_ROUTING, if i change the destination address so that it points to
> machine C, the packet disappears and i can't track it anywhere. On the
> other hand, if i instead change the source address of the packet so
> that it points to machine C everything works fine. I can "see" the
> packet traversing into machine B, which receives the packet and
> promptly replies sending a packet to machine C. Machine A never
> receives a reply to the packet it sent and machine C receives a reply
> from a packet it never sent. Exactly the behaviour expected when
> changing the source address field. Now, if this works in this case,
> merely changing it to alter the destination address (my original
> intention) should work also, but it doesn't.
> My code can't be incorrect in a situation like this, so what exactly
> is wrong? And is there a away to solve such situation?
> Ideas anyone?

Stupid question, but do you have ip_forward set to 1 on machine B??


Sven

--=20
Linux zion 2.6.11-mm1 #1 Sat Mar 5 13:54:40 CET 2005 i686 athlon i386 GNU/L=
inux
 00:28:53 up 3 days,  3:34,  2 users,  load average: 0.12, 0.07, 0.06

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFCLjWUo4FAdB2PneQRAn3BAJ4jde+CqmJuVCRWZv0cYm3xRLx0gwCfYdwU
sbIi4+LllUUpvziO27tykC0=
=mXrb
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
