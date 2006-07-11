From: Tom Eastep <teastep@shorewall.net>
Subject: Re: RFC: Disable defered bridge hooks by default
Date: Tue, 11 Jul 2006 13:34:22 -0700
Message-ID: <44B40B4E.6080206@shorewall.net>
References: <44AA3446.6050609@trash.net>
	<44AA3496.5050909@trash.net>	<44AEFE20.3020307@shorewall.net>
	<44AF200F.9000204@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigEFF6D1230E68E0465F2402A1"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44AF200F.9000204@trash.net>
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
--------------enigEFF6D1230E68E0465F2402A1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Patrick McHardy wrote:
> Tom Eastep wrote:

>>
>> A similar approach is taken for locally-generated packets. There is a
>> single rule to direct all 'fw' to 'bar' traffic to the 'fw2bar' chain
>> ("fw" is the default name for the zone comprised of the local system):=

>>
>> 	iptables -A OUTPUT -o <bridge> -m physdev \
>> 	--physdev-out <bar port> -j fw2bar
>>
>> As with forwarding, the fw2bar chain ends with a rule that enforces th=
e
>> fw->bar policy.
>>
>> Predictably, the Shorewall rule:
>>
>> 	ACCEPT	fw	bar	tcp	25
>>
>> generates:
>>
>> 	iptables -A fw2bar -p tcp --dport 25 -j ACCEPT
>>
>> I see no sensible way to eliminate the --physdev-out usage in the OUTP=
UT
>> chain using ebtables/iptables and marking. What am I missing?
>=20
> I'm a lazy reader, so I didn't follow this entirely. But:
>=20
> "-i <bridge> -o <bridge> "
>=20
> implies you're using this for purely bridged traffic. The feature
> we're going to remove only affects locally generated traffic exiting
> on a bridge device, in that case iptables _can't_ know the output
> port.

And that is the case that I'm concerned about.

> But you can do your iptables matching, mark matching packets
> and filter on the mark within ebtables.

I was afraid that's what you were going to suggest. If Shorewall was an
appliance that only supported a limited set of configurations, I could en=
tertain
that approach; as it is, I'm not sure.

I'm going to issue a warning to my users that Shorewall support for
bridge/firewalls may be discontinued in the future. If in the next six mo=
nths, I
can come up with code that is clean enough to go forward with, I'll resci=
nd the
announcement.

So that I understand the playing field, --physdev-out will no longer be
supported out of the FORWARD and OUTPUT chains (all tables); is that corr=
ect?

Thanks,
-Tom
--=20
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net
PGP Public Key   \ https://lists.shorewall.net/teastep.pgp.key


--------------enigEFF6D1230E68E0465F2402A1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFEtAtOO/MAbZfjDLIRAg2aAJ959kqcDpgtDcXM0L1Lbggn/YbV4wCgnALI
hzw0X8iZcYaklxxLvm3Q0SQ=
=RYEI
-----END PGP SIGNATURE-----

--------------enigEFF6D1230E68E0465F2402A1--
