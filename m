From: Peter Surda <shurdeek@panorama.sth.ac.at>
Subject: Re: using string match - was: my new option calls httpr
Date: Mon, 3 Mar 2003 13:43:35 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030303124335.GF20786@smith.cb.ac.at>
References: <618861251.20030301124005@yahoo.es> <200303031637.30785.fabrice@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wTWi5aaYRw9ix9vO"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: lista de correo netfilter <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <200303031637.30785.fabrice@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--wTWi5aaYRw9ix9vO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 03, 2003 at 04:37:30PM +0800, Fabrice MARIE wrote:
> Hola,
hi

> On Saturday 01 March 2003 19:40, macadanet@yahoo.es wrote:
> > When I didn't modify -string option. I created a new option -httpr
> > (http request).
> > I had done a test suite above my network with this patch aplied. In
> > Input string on NETFILTER hook, I had a 4 rules:
> > iptables -A INPUT -m httpr --httpr '"GET"?"cmd.exe"?"dir"?"HTTP"' -j LOG
> > iptables -A INPUT -m httpr --httpr '"GET"?"tftp"?"HTTP"' -j LOG
> > iptables -A INPUT -m httpr --httpr '"GET"?"root.exe"?"HTTP"' -j LOG
> > iptables -A INPUT -m httpr --httpr '"GET"?"default.ida"?[XNO]*?"HTTP"' =
-j LOG
> > [...]
> Don't get me wrong, I'm just trying to explain why you shouldn't be doing=
 this,
> please don't take it personally. This is a reminder for a lot of people, =
not
> just you.
I had a slightly similar problem to solve. I solved it by writing a daemon =
in
perl that processes logs in realtime and if it finds out someone is hitting=
 it
with nimda, it calls iptables to DROP the IP and sends me an email with
description and excerpts from the logs. The advantage is, this method can be
used both for squid and httpd.

> All the HTTP rules above will be exploited trivially with Unicode encodin=
g,
> or ASCII encoding (for example you can write the URL as GET /cmd.%65x%65
> %65 being the hexadecimal ASCII number for 'e'). Look at the tool whisker
> for more informations on IDS evasion techniques, a lot of them are applic=
able
> to the string match.
Basically you are right, but in this case it doesn't happen. Nimda hits only
with non-escaped URLs. Anyway, user space daemon can take care of that as
well.

> Have a nice day,
>=20
> Fabrice.
Bye,

Peter Surda (Shurdeek) <shurdeek@panorama.sth.ac.at>, ICQ 10236103, +436505=
122023

--
                   Disc space - The final frontier.

--wTWi5aaYRw9ix9vO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: Weitere Infos: siehe http://www.gnupg.org

iD8DBQE+Y033zogxsPZwLzcRAgr6AJwJRbm4m9A47Ta/8jGPG5RYf/tv5ACgia92
KPmbMre+rrD97e+5Q2M4NlA=
=BSQt
-----END PGP SIGNATURE-----

--wTWi5aaYRw9ix9vO--
