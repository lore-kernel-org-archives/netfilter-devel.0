From: netfilter@interlinx.bc.ca
Subject: Re: disturbing MTU experiment
Date: Tue, 8 Apr 2003 13:47:54 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030408174753.GA8158@pc.ilinx>
References: <20030408154101.13919.89741.Mailman@kashyyyk> <16018.64600.149601.372694@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <16018.64600.149601.372694@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 08, 2003 at 09:44:08AM -0700, Don Cohen wrote:
>=20
> (Let me know if there's a more appropriate place to send this.)

A general [[I|i]inter]networking mailing list perhaps, but I am sure
everybody here is familiar with the phenomenon you describe.

> My understanding of IPv4 is that
> - the forwarding path between two machines might have links of
>   different MTUs,
> - when an IP datagram marked DF is too big for one of those links, the
>   machine that would otherwise forward it is supposed to return an
>   ICMP unreachable reply

And include a suggestion as to how big the datagram should be to pass
through the link.

> - the sending machine is supposed to react to that ICMP reply, either
>   by sending a smaller datagram or by allowing fragmentation or of
>   course, giving up.
>=20
> The following experiment ought to exhibit this behavior:
>=20
>  internet --- eth0:linux_firewall:eth1 --- client
>=20
> - on linux firewall do
>   ifconfig eth1 mtu 1400
> - on client machine try to use the internet, e.g., run a web browser

We all know what is coming...  :-)

> When I do this I find, to my dismay, that MANY sites don't work!

Get in line buddy.  :-)

> A tcpdump on the firewall shows the web server in the internet sending
> a DF packet of size 1500, the firewall sending the ICMP reply, and the
> server ignoring it, i.e., resending the large packet over and over.

Yup.  Happens all to disturbingly often.

> 1. Is there something wrong with my experiment or is a large part of
> the internet really broken in this way?  Do others out there see the
> same thing?

No, yes and yes.

> 2. What's the cause of this breakage?

It's called a "PMTU blackhole".

> Are servers filtering ICMP due
> to attacks?

Naive packet filter administrators are filtering out the ICMPs yes.
Instead of understanding for themselves what they should filter out
they follow "recipies" and listent to all the FUD about how
"dangerous" ICMP is and just filter it all, lock, stock and barrel.

> Are they behind firewalls that don't know how to forward
> the ICMP packets?

Oh, the firewalls know how to forward them, their administrators have
just disallowed it.

> Are ISPs filtering the ICMP packets?

This could be to a certain extent a problem, but in most cases it's in
the last mile (i.e. between the ISP and the end node).

> 3. Are links with MTU < 1500 are extremely rare in the internet?

Good question.

> The fact that the internet mostly seems to work would suggest that.

Not really.  It could suggest that OR it could suggest that the portion
of the Internet that works is run by competent admins.  But of course,
it's a combination of the two in reality.

> Surely this has not always been the case.  When did it happen?

When the Internet stopped being a friendly community and firewalls
were being erected to keep the evils out.

> 4. What can be done about it?

There was/is a project on the Internet to identify and notify owners
of PMTU blackholes.  I don't recall the URL however.  Maybe some
Googlin' will turn it up.

In any case, Googlin' for "PMTU blackhole" will turn up lots more
information for you.

b.

--=20
Brian J. Murrell

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+kwtJl3EQlGLyuXARAjloAJ9ts+Yo6QYnCcjxSvgm/zD2m2qdewCffg/r
4qyqsWma0Ne9sI8mfnvpvfQ=
=SaI6
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
