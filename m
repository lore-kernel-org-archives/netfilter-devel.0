From: Tom Eastep <teastep@shorewall.net>
Subject: Re: RFC: Disable defered bridge hooks by default
Date: Fri, 07 Jul 2006 17:36:48 -0700
Message-ID: <44AEFE20.3020307@shorewall.net>
References: <44AA3446.6050609@trash.net> <44AA3496.5050909@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig6C8C4C96E6D96290AB38A0A3"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44AA3496.5050909@trash.net>
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

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6C8C4C96E6D96290AB38A0A3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Patrick McHardy wrote:

> +Why:	The defered output hooks are a bad layering violation causing
> +	lots of unusual and broken behaviour on bridge devices.
> +	Examples include broken QoS classifation using the MARK or
> +	CLASSIFY targets, broken behaviour with the IPsec policy match,
> +	broken connection tracking with VLAN on a bridge, ...
> +
> +	Their only use is to enable bridge output port filtering within
> +	iptables with the physdev match, which can just as well be done by
> +	combining iptables and ebtables using netfilter marks.

Patrick,

Once again, netfilter marks are the solution of last resort. This is
becoming very painful for those of us who produce general Netfilter
configuration tools. The situation is exacerbated by the fact that
ebtables doesn't support modifying the mark value via logical AND/OR and
the other fwmark consumers (tc, ip) don't allow a mask when testing the
fwmark value.

Be that as it may, I'm having difficulty trying to apply your proposed
approach to Shorewall.

Here's an example of a forwarding rule in Shorewall:

	ACCEPT	foo	bar	tcp	25

'foo' and 'bar' are "zone" names and in a bridged configuration each may
be associated with a different port on a bridge. Today, there is a
single rule that sends all 'foo' -> 'bar' packets to a separate chain
(this isn't the exact rule is but it illustrates the point):

	iptables -A FORWARD -i bridge -o bridge -m physdev \
	--physdev-in <foo port> --physdev-out <bar port> -j foo2bar

Given that the ebtables filter table FORWARD chain is traversed before
the iptables filter table FORWARD chain, that single iptables command
can be replaced by:

	ebtables -A FORWARD -o <bar port> -j mark \
	--set-mark <bar mark> # --or-mark would be real handy here

	iptables -A FORWARD -i <bridge> -o <bridge> -m physdev \
	--physdev-in <foo port> -m mark --mark <bar mark> -j foo2bar

The Shorewall rule listed above then creates:

	iptables -A foo2bar -p tcp --dport 25 -j ACCEPT

At the end of the foo2bar chain is an unconditional rule that is
determined by the effective foo->bar policy specified by the user;
policy values include DROP, REJECT, ACCEPT and CONTINUE (CONTINUE is
used for nested zones).

A similar approach is taken for locally-generated packets. There is a
single rule to direct all 'fw' to 'bar' traffic to the 'fw2bar' chain
("fw" is the default name for the zone comprised of the local system):

	iptables -A OUTPUT -o <bridge> -m physdev \
	--physdev-out <bar port> -j fw2bar

As with forwarding, the fw2bar chain ends with a rule that enforces the
fw->bar policy.

Predictably, the Shorewall rule:

	ACCEPT	fw	bar	tcp	25

generates:

	iptables -A fw2bar -p tcp --dport 25 -j ACCEPT

I see no sensible way to eliminate the --physdev-out usage in the OUTPUT
chain using ebtables/iptables and marking. What am I missing?

-Tom
--=20
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net
PGP Public Key   \ https://lists.shorewall.net/teastep.pgp.key



--------------enig6C8C4C96E6D96290AB38A0A3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFErv4nO/MAbZfjDLIRAogmAJ9BQPdx/cD7GPSqq4yNWvRpKk9b8wCfVwIV
CRMTS8Gg0Ax9ieXUpnx7CN0=
=VPJo
-----END PGP SIGNATURE-----

--------------enig6C8C4C96E6D96290AB38A0A3--
