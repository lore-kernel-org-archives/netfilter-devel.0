From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [2/2] osf: fixed /proc reading bug
Date: Mon, 23 Aug 2004 12:57:09 +0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1093251429.21197.8.camel@uganda>
References: <20040822010358.79048eda@zanzibar.2ka.mipt.ru>
	 <4127CCF9.2030505@trash.net>
	 <Pine.LNX.4.61.0408220142220.21373@filer.marasystems.com>
	 <4127E586.5000707@trash.net>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TMiMNAetBLmd8Gcjz5GO"
Cc: Henrik Nordstrom <hno@marasystems.com>,
        Harald Welte <laforge@netfilter.org>,
        netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4127E586.5000707@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-TMiMNAetBLmd8Gcjz5GO
Content-Type: multipart/mixed; boundary="=-5E/RsYmYFyOzbDb/Nss8"


--=-5E/RsYmYFyOzbDb/Nss8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2004-08-22 at 04:15, Patrick McHardy wrote:
> Henrik Nordstrom wrote:
>=20
> > On Sun, 22 Aug 2004, Patrick McHardy wrote:
> >
> >>               log("%s [%s]", f->genre, f->details);
> >>
> >> -               count +=3D sprintf(buf+count, "%s - %s[%s] : %s",
> >> +               err =3D snprintf(buf+count, __count-count, "%s - %s[%s=
]=20
> >> : %s",
> >>                                       f->genre, f->version,
> >>                                       f->subtype, f->details);
> >> -
> >> +               if (err < 0)
> >
> >
> > This should read something like follows I think:
> >
> >           if (err < 0 || err > __count-count)
> >
> >> +                       break;
> >> +               else
> >> +                       count +=3D err;
> >>               if (f->opt_num)
> >>               {
> >>                       loga(" OPT: ");
> >
>=20
> Yes, but the check for < 0 is not needed and it should read >=3D __count =
-=20
> count
> to avoid useless zero-byte snprintfs. Evgeniy, can you please send a new=20
> patch ?

Sure.
It simply checks if return value from snprintf is 0 and breaks,
otherwise it proceeds.

ipt_osf.diff.1 - patch for 2.6
ipt_osf.diff.1.24 - patch for 2.4

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

> Regards
> Patrick
--=20
	Evgeniy Polyakov ( s0mbre )

Crash is better than data corruption. -- Art Grabowski

--=-5E/RsYmYFyOzbDb/Nss8
Content-Disposition: attachment; filename=ipt_osf.diff.1
Content-Type: text/plain; name=ipt_osf.diff.1; charset=koi8-r
Content-Transfer-Encoding: base64

LS0tIG5ldGZpbHRlcl9jdnMvcGF0Y2gtby1tYXRpYy1uZy9vc2YvbGludXgtMi40L25ldC9pcHY0
L25ldGZpbHRlci9pcHRfb3NmLmMJMjAwNC0wOC0yMiAwMDo1NDo0NC4wMDAwMDAwMDAgKzA0MDAN
CisrKyBuZXRmaWx0ZXJfY3ZzL3BhdGNoLW8tbWF0aWMtbmcvb3NmL2xpbnV4LTIuNC9uZXQvaXB2
NC9uZXRmaWx0ZXIvaXB0X29zZi5jCTIwMDQtMDgtMjAgMjI6MzY6MjQuMDAwMDAwMDAwICswNDAw
DQpAQCAtMTgyLDcgKzE4NSw2IEBADQogCQlvcHRzaXplID0gdGNwLT5kb2ZmKjQgLSBzaXplb2Yo
c3RydWN0IHRjcGhkcik7DQogCX0NCiANCi0JDQogCS8qIEFjdHVhbGx5IHdlIGNhbiBjcmVhdGUg
aGFzaC90YWJsZSBvZiBhbGwgZ2VucmVzIGFuZCBzZWFyY2gNCiAJICogb25seSBpbiBhcHByb3By
aWF0ZSBwYXJ0LCBidXQgaGVyZSBpcyBpbml0aWFsIHZhcmlhbnQsDQogCSAqIHNvIHdpbGwgdXNl
IHNsb3cgcGF0aC4NCkBAIC02MDEsOSArNjAzLDEwIEBADQogew0KIAlzdHJ1Y3QgbGlzdF9oZWFk
ICplbnQ7DQogCXN0cnVjdCBvc2ZfZmluZ2VyICpmID0gTlVMTDsNCi0JaW50IGk7DQorCWludCBp
LCBfX2NvdW50LCBlcnI7DQogCQ0KIAkqZW9mID0gMTsNCisJX19jb3VudCA9IGNvdW50Ow0KIAlj
b3VudCA9IDA7DQogDQogCXJlYWRfbG9ja19iaCgmb3NmX2xvY2spOw0KQEAgLTYxMywxMCArNjE2
LDEzIEBADQogDQogCQlsb2coIiVzIFslc10iLCBmLT5nZW5yZSwgZi0+ZGV0YWlscyk7DQogCQkN
Ci0JCWNvdW50ICs9IHNwcmludGYoYnVmK2NvdW50LCAiJXMgLSAlc1slc10gOiAlcyIsIA0KKwkJ
ZXJyID0gc25wcmludGYoYnVmK2NvdW50LCBfX2NvdW50LWNvdW50LCAiJXMgLSAlc1slc10gOiAl
cyIsIA0KIAkJCQkJZi0+Z2VucmUsIGYtPnZlcnNpb24sDQogCQkJCQlmLT5zdWJ0eXBlLCBmLT5k
ZXRhaWxzKTsNCi0JCQ0KKwkJaWYgKGVyciA9PSAwKQ0KKwkJCWJyZWFrOw0KKwkJZWxzZQ0KKwkJ
CWNvdW50ICs9IGVycjsNCiAJCWlmIChmLT5vcHRfbnVtKQ0KIAkJew0KIAkJCWxvZ2EoIiBPUFQ6
ICIpOw0KQEAgLTYzMCw3ICs2MzYsMTEgQEANCiAJCQl9DQogCQl9DQogCQlsb2dhKCJcbiIpOw0K
LQkJY291bnQgKz0gc3ByaW50ZihidWYrY291bnQsICJcbiIpOw0KKwkJZXJyID0gc25wcmludGYo
YnVmK2NvdW50LCBfX2NvdW50LWNvdW50LCAiXG4iKTsNCisJCWlmIChlcnIgPT0gMCkNCisJCQli
cmVhazsNCisJCWVsc2UNCisJCQljb3VudCArPSBlcnI7DQogCX0NCiAJcmVhZF91bmxvY2tfYmgo
Jm9zZl9sb2NrKTsNCiANCg==

--=-5E/RsYmYFyOzbDb/Nss8
Content-Disposition: attachment; filename=ipt_osf.diff.1.24
Content-Type: text/plain; name=ipt_osf.diff.1.24; charset=koi8-r
Content-Transfer-Encoding: base64

LS0tIG5ldGZpbHRlcl9jdnMvcGF0Y2gtby1tYXRpYy1uZy9vc2YvbGludXgtMi40L25ldC9pcHY0
L25ldGZpbHRlci9pcHRfb3NmLmMJMjAwNC0wOC0yMiAwMDo1NDo0NC4wMDAwMDAwMDAgKzA0MDAN
CisrKyBuZXRmaWx0ZXJfY3ZzL3BhdGNoLW8tbWF0aWMtbmcvb3NmL2xpbnV4LTIuNC9uZXQvaXB2
NC9uZXRmaWx0ZXIvaXB0X29zZi5jCTIwMDQtMDgtMjAgMjI6MzY6MjQuMDAwMDAwMDAwICswNDAw
DQpAQCAtMTgyLDcgKzE4NSw2IEBADQogCQlvcHRzaXplID0gdGNwLT5kb2ZmKjQgLSBzaXplb2Yo
c3RydWN0IHRjcGhkcik7DQogCX0NCiANCi0JDQogCS8qIEFjdHVhbGx5IHdlIGNhbiBjcmVhdGUg
aGFzaC90YWJsZSBvZiBhbGwgZ2VucmVzIGFuZCBzZWFyY2gNCiAJICogb25seSBpbiBhcHByb3By
aWF0ZSBwYXJ0LCBidXQgaGVyZSBpcyBpbml0aWFsIHZhcmlhbnQsDQogCSAqIHNvIHdpbGwgdXNl
IHNsb3cgcGF0aC4NCkBAIC02MDEsOSArNjAzLDEwIEBADQogew0KIAlzdHJ1Y3QgbGlzdF9oZWFk
ICplbnQ7DQogCXN0cnVjdCBvc2ZfZmluZ2VyICpmID0gTlVMTDsNCi0JaW50IGk7DQorCWludCBp
LCBfX2NvdW50LCBlcnI7DQogCQ0KIAkqZW9mID0gMTsNCisJX19jb3VudCA9IGNvdW50Ow0KIAlj
b3VudCA9IDA7DQogDQogCXJlYWRfbG9ja19iaCgmb3NmX2xvY2spOw0KQEAgLTYxMywxMCArNjE2
LDEzIEBADQogDQogCQlsb2coIiVzIFslc10iLCBmLT5nZW5yZSwgZi0+ZGV0YWlscyk7DQogCQkN
Ci0JCWNvdW50ICs9IHNwcmludGYoYnVmK2NvdW50LCAiJXMgLSAlc1slc10gOiAlcyIsIA0KKwkJ
ZXJyID0gc25wcmludGYoYnVmK2NvdW50LCBfX2NvdW50LWNvdW50LCAiJXMgLSAlc1slc10gOiAl
cyIsIA0KIAkJCQkJZi0+Z2VucmUsIGYtPnZlcnNpb24sDQogCQkJCQlmLT5zdWJ0eXBlLCBmLT5k
ZXRhaWxzKTsNCi0JCQ0KKwkJaWYgKGVyciA9PSAwKQ0KKwkJCWJyZWFrOw0KKwkJZWxzZQ0KKwkJ
CWNvdW50ICs9IGVycjsNCiAJCWlmIChmLT5vcHRfbnVtKQ0KIAkJew0KIAkJCWxvZ2EoIiBPUFQ6
ICIpOw0KQEAgLTYzMCw3ICs2MzYsMTEgQEANCiAJCQl9DQogCQl9DQogCQlsb2dhKCJcbiIpOw0K
LQkJY291bnQgKz0gc3ByaW50ZihidWYrY291bnQsICJcbiIpOw0KKwkJZXJyID0gc25wcmludGYo
YnVmK2NvdW50LCBfX2NvdW50LWNvdW50LCAiXG4iKTsNCisJCWlmIChlcnIgPT0gMCkNCisJCQli
cmVhazsNCisJCWVsc2UNCisJCQljb3VudCArPSBlcnI7DQogCX0NCiAJcmVhZF91bmxvY2tfYmgo
Jm9zZl9sb2NrKTsNCiANCg==

--=-5E/RsYmYFyOzbDb/Nss8--

--=-TMiMNAetBLmd8Gcjz5GO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBKbFlIKTPhE+8wY0RAmMuAJ4+jIjL/q5x12P3vfBa6C91imngqwCfXH6p
jZT1exfnzsj6vW6Mc5YKn7k=
=URbn
-----END PGP SIGNATURE-----

--=-TMiMNAetBLmd8Gcjz5GO--
