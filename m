From: Harald Welte <laforge@netfilter.org>
Subject: Re: Transparent broadband network connectivity (IP PnP)
Date: Thu, 13 Mar 2003 10:08:22 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030313090821.GA7053@naboo.de.gnumonks.org>
References: <5.2.0.9.2.20030313100719.01f73bc0@216.136.173.10>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: dragon_nlt@yahoo.com
Content-Disposition: inline
In-Reply-To: <5.2.0.9.2.20030313100719.01f73bc0@216.136.173.10>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 13, 2003 at 10:10:28AM +0700, dragon_nlt@yahoo.com wrote:
> Sorry, it's me again. I don't think my question is simple
> usage/configuration question. It's really need a professional support. It=
's
> greatly appreciated if you can help me some.

'professional' was meant to translate to 'commercial', 'being paid' ;)

Anway.  This question would belong to the devel list, so I'm Cc'ing it
with a fullquote attached. Hope you don't mind.

The netfilter/iptables implementation does not support broken network
configurations like the one you describe.  From my perspective, people
should use some autoconfiguration mechanism like DHCP.  I think it's the
wrong way to not expect the end user to at least know how to activate DHCP
on a network interface.

A broken setup like you describe breaks about any of the fundamental
assumptions of a working IP network. (and of layering in a network)

Even though there are commercial products trying to provide service to a
broken network, this doesn't meen that netfilter/iptables should do the
same horrible kludge.

> >Date: Thu, 13 Mar 2003 09:43:50 +0700
> >To: laforge@gnumonks.org
> >From: dragon_nlt@yahoo.com
> >Subject: RE: Transparent broadband network connectivity (IP PnP)
> >
> >Hi,
> >
> >Maybe you will misunderstand my question. So i will describe the problem
> >in detail.
> >
> >This is the implementation for such a public internet access network like
> >airport, hotel, ... So the client IP address can be any thing. The main
> >point is that a client just only need to plug into the net then he can
> >surf internet without changing his ip configuration.
> >I found some commercial products for this such as IP PnP
> >(http://www.infino.co.kr/infino/eng/softpackage_e.php), Reliaware
> >(http://www.demarctech.com/products/reliawave-rwh/reliawave-ipnpsg.html)
> >(Please see Address Translate Function section). I wonder that iptables
> >itself can do it or not.
> >
> >With iptables, we can nat outgoing traffic, but the problem is that
> >clients inside internal network can be any IP address (different subnet,
> >netmask, gateway, dns ... and even thought clients have the same IP). I
> >think there is needed a layer-2 NAT, e.g. handling clients which may have
> >any IP address (even the same IP address), etc. correctly. I found a
> >useful thread here
> >http://lists.personaltelco.net/pipermail/ptp/2002q4/010591.html.
> >
> >For example
> >
> >Client 1 -----------|
> >192.168.10.5        |
> >                     |  172.16.1.1  PublicIP
> >Client 2 -----------|        eth0    eth1
> >DHCP(172.16.1.90)   |-------- [ GW ] ----- [ router ] --- Internet
> >                     |  DefaultGW=3DRouterIP
> >Client 3 -----------|
> >200.192.16.10       |
> >                     |
> >Client 4 -----------|
> >64.12.5.12
> >
> >I can set the eth0 into proxy arp mode (net.ipv4.conf.eth0.proxy_arp =3D=
 1)
> >to set it as the gateway for all clients, and use iptables SNAT target
> >inside nat POSTROUTING chain of eth1.
> >
> >iptables -t nat -A POSTROUTING -o eth1 -j SNAT --to-source <eth1 ip>
> >
> >When client send a packet out, the packet goes into eth0, goes through
> >forward chain after routing decision, get nat'd on eth1 then send to the
> >router. The problem is that when the reply packet from router goes back
> >eth1, after de-nat'd, the packet will be sent to the eth1 following the
> >default route on gateway box instead of eth0 (since client can have any
> >ip, so we can't set the routing table; default gateway is router's ip via
> >eth1). I think there is needed such a MAC based NAT module on PREROUTING
> >chain of eth0. So the gateway will don't care about client IP, just clie=
nt
> >MAC address (assume that MAC address is unique). Do you have any idea?
> >
> >Best Regards,
> >
> >John Duke
> >
> >>Date: Wed, 12 Mar 2003 18:55:21 +0700
> >>To: laforge@gnumonks.org
> >>From: dragon_nlt@yahoo.com
> >>Subject: Transparent broadband network connectivity (IP PnP)
> >>
> >>Hello,
> >>
> >>Can you let me know if netfilter can allow clients inside Internal
> >>network (can be any ip) access Internet by using NAT?
> >>
> >>Internal-network --- [ gateway ] --- Internet
> >>  (any ip)
> >>
> >>
> >>There is a product called IP PnP
> >>(http://www.infino.co.kr/infino/eng/softpackage_e.php) provide that
> >>feature but I'm looking for an opensource solution. Do current netfilter
> >>can do it or I need to hack some netfilter code?
> >>
> >>Looking forward to your reply,
> >>
> >>Best Regards,
> >>
> >>John Duke
>=20
>=20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+cEqFXaXGVTD0i/8RAuleAKCQf1BPn5PNMhzr2A26m7bWZJCCYgCgpcbd
iRIkAfWTGQpzqlaDpXR8zqE=
=9nTA
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
