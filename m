From: Nicolas George <nicolas.george@ens.fr>
Subject: Re: TCPMSS target for IPv6
Date: Fri, 19 Dec 2003 02:32:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031219013251.GA9129@clipper.ens.fr>
References: <20031215210705.GA2326@clipper.ens.fr> <Pine.LNX.4.44.0312172005030.18802-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Cc: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>,
        netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0312172005030.18802-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Le septidi 27 frimaire, an CCXII, Henrik Nordstrom a =E9crit=A0:
> But is does not solve the underlying MTU problem, and you may still risk
> running into MTU issues especially if there is non-TCP traffic involved a=
s=20
> MSS only applies to TCP, not UDP/AH/ESP/Whatever.

You are right, but I did not find a way to control the MTU. I did try
something like:

ip -6 route add $network/48 dev ppp0 mtu 1452

but all I get is:

$network/48 dev ppp0  metric 1024  mtu 1492 advmss 1432

(same reslt with "mtu lock" instead of "mtu", and with just one target
IP instead of a network)

I know that altering the MSS would not solve the problem for non-TCP
traffic, but solving it for TCP would be at least something (andindeed,
I do not expect to do anything but TCP on that link).

> PMTU issues (not PMTU discovery as such) is relatively rare unless there
> is tunnels involved. Any tunneling equipment not properly (automatically
> or manually) handling PMTU at the endpoints is broken and needs to be
> fixed now.

I agree, but I can not fix the tunnel that is bothering me, I do not
control the offending end-point. My situation is the following:

   my computer
        |
        |	IPv6/PPPoE, MTU=3D1492
        |
       ISP
        |
        |	IPv6/???, MTU>=3D1500
        |
   6to4 gateway
        |
        |	IPv6/IPv4/???, MTU=3D1480
        |
    other ISP
        |
        |	IPv6/IPv4/PPPoE, MTU=3D1472
        |
friend's computer
        |
	|	IPv6/Ethernet, MTU=3D1500
	|
 other friend's
    computer

I suspect "other ISP" (which is ProXaD, aka Free Telecom, one of the big
french ISP) to do something nasty with fragmentation needed ICMPs.

Packets of size 1493-1500 get an ICMP from my own computer or are
fragmented, packets of size 1481-1492 get an ICMP from the 6to4 gateway,
packets of size <=3D1472 arrive, but packets of size 1473-1480 never
arrive nor get an ICMP. As you can see, fixing the tunnel is not an
option for me.

I have others problems linked to MSS and failed PMTU discovery,
involving a computer on a private network behind my internet-connected
computer and some random web server whose replies freeze. I'm wondering
if my ISP is blocking fragmentation needed ICMP, but I doubt it because
I trust their technical skills. One think I discovered while testing all
these network problems is that someone between my outgoing interface and
the peer where I can check is lowering the MSS in my packets from 1460
to 1420; I do not know who (there is rp-pppoe, but it should only lower
it to 1452). Unfortunately, I will not be able to experiment further for
two weeks.

To conclude that mail, I would say two things:

- Maybe I am missing the right and powerful way to address PMTU
  discovery problems, but I am not alone: a lot of people use MSS
  alteration for that, either in newsgroups or mailing-lists, or in
  software (see the -m option to rp-pppoe).

- All this discussion gave me the idea of another option to the REJECT
  target: icmp-too-big/icmp-fragmentation-needed.

Regards,

--=20
  Nicolas George

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.0 (SunOS)

iD8DBQE/4lVDsGPZlzblTJMRAmsVAJ91V0Uto5WTSRVltpGHjQ+ZsDOxoACfdrRK
3jcV1ntSpF6j4nZMK6flm4A=
=MUfj
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
