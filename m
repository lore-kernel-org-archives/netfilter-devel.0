From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [2/2] osf: fixed /proc reading bug
Date: Mon, 23 Aug 2004 14:39:14 +0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1093257554.21197.121.camel@uganda>
References: <20040822010358.79048eda@zanzibar.2ka.mipt.ru>
	 <4127CCF9.2030505@trash.net>
	 <Pine.LNX.4.61.0408220142220.21373@filer.marasystems.com>
	 <4127E586.5000707@trash.net> <1093251429.21197.8.camel@uganda>
	 <4129BF18.3010204@trash.net>  <1093257059.21197.106.camel@uganda>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MdL2LVNqFds7yxllB8Qf"
Cc: Henrik Nordstrom <hno@marasystems.com>,
        Harald Welte <laforge@netfilter.org>,
        netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <1093257059.21197.106.camel@uganda>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-MdL2LVNqFds7yxllB8Qf
Content-Type: multipart/mixed; boundary="=-zcW8ArV6n7RN+5BM6wmq"


--=-zcW8ArV6n7RN+5BM6wmq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2004-08-23 at 14:30, Evgeniy Polyakov wrote:
> On Mon, 2004-08-23 at 13:55, Patrick McHardy wrote:
> > Evgeniy Polyakov wrote:
> >=20
> > >It simply checks if return value from snprintf is 0 and breaks,
> > >otherwise it proceeds.
> > >
> > Still broken. snprintf returns a value > n if it truncated to n bytes.
> > See my last mail again. BTW, did the overflow actually cause problems ?
> > proc has an extra k of space just for overflows ..
>=20
> If it truncates than we have [avoided] overflow and definetely will not
> write anything after it(except zero-lengh snprintf) since
>  __count-count =3D=3D 0 there.

Actually <=3D 0 which is not good but avoids overflows.
I can trigger overflow without patch(actually it was hard lockup without
any messages).

> Do you mean following:
> 	list_for_each()
> 	{
> 		snprintf();
> 		if (count > __count)
> 			break;
> 	}

Attached with check=20
	__count >=3D count + err;

>=20
> >=20
> > Regards
> > Patrick

--=20
	Evgeniy Polyakov ( s0mbre )

Crash is better than data corruption. -- Art Grabowski

--=-zcW8ArV6n7RN+5BM6wmq
Content-Disposition: attachment; filename=ipt_osf.diff.1
Content-Transfer-Encoding: base64
Content-Type: text/plain; name=ipt_osf.diff.1; charset=koi8-r

LS0tIG5ldGZpbHRlcl9jdnMvcGF0Y2gtby1tYXRpYy1uZy9vc2YvbGludXgtMi42L25ldC9pcHY0
L25ldGZpbHRlci9pcHRfb3NmLmMJMjAwNC0wOC0yMiAwMDo1NDo0NC4wMDAwMDAwMDAgKzA0MDAN
CisrKyBuZXRmaWx0ZXJfY3ZzL3BhdGNoLW8tbWF0aWMtbmcvb3NmL2xpbnV4LTIuNi9uZXQvaXB2
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
ZXRhaWxzKTsNCi0JCQ0KKwkJaWYgKGVyciA9PSAwIHx8IF9fY291bnQgPj0gY291bnQgKyBlcnIp
DQorCQkJYnJlYWs7DQorCQllbHNlDQorCQkJY291bnQgKz0gZXJyOw0KIAkJaWYgKGYtPm9wdF9u
dW0pDQogCQl7DQogCQkJbG9nYSgiIE9QVDogIik7DQpAQCAtNjMwLDcgKzYzNiwxMSBAQA0KIAkJ
CX0NCiAJCX0NCiAJCWxvZ2EoIlxuIik7DQotCQljb3VudCArPSBzcHJpbnRmKGJ1Zitjb3VudCwg
IlxuIik7DQorCQllcnIgPSBzbnByaW50ZihidWYrY291bnQsIF9fY291bnQtY291bnQsICJcbiIp
Ow0KKwkJaWYgKGVyciA9PSAwIHx8IF9fY291bnQgPj0gY291bnQgKyBlcnIpDQorCQkJYnJlYWs7
DQorCQllbHNlDQorCQkJY291bnQgKz0gZXJyOw0KIAl9DQogCXJlYWRfdW5sb2NrX2JoKCZvc2Zf
bG9jayk7DQogDQo=

--=-zcW8ArV6n7RN+5BM6wmq
Content-Disposition: attachment; filename=ipt_osf.diff.1.24
Content-Transfer-Encoding: base64
Content-Type: text/plain; name=ipt_osf.diff.1.24; charset=koi8-r

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
ZXRhaWxzKTsNCi0JCQ0KKwkJaWYgKGVyciA9PSAwIHx8IF9fY291bnQgPj0gY291bnQgKyBlcnIp
DQorCQkJYnJlYWs7DQorCQllbHNlDQorCQkJY291bnQgKz0gZXJyOw0KIAkJaWYgKGYtPm9wdF9u
dW0pDQogCQl7DQogCQkJbG9nYSgiIE9QVDogIik7DQpAQCAtNjMwLDcgKzYzNiwxMSBAQA0KIAkJ
CX0NCiAJCX0NCiAJCWxvZ2EoIlxuIik7DQotCQljb3VudCArPSBzcHJpbnRmKGJ1Zitjb3VudCwg
IlxuIik7DQorCQllcnIgPSBzbnByaW50ZihidWYrY291bnQsIF9fY291bnQtY291bnQsICJcbiIp
Ow0KKwkJaWYgKGVyciA9PSAwIHx8IF9fY291bnQgPj0gY291bnQgKyBlcnIpDQorCQkJYnJlYWs7
DQorCQllbHNlDQorCQkJY291bnQgKz0gZXJyOw0KIAl9DQogCXJlYWRfdW5sb2NrX2JoKCZvc2Zf
bG9jayk7DQogDQo=

--=-zcW8ArV6n7RN+5BM6wmq--

--=-MdL2LVNqFds7yxllB8Qf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBKclSIKTPhE+8wY0RAgw/AJsHv5bgQEK+i1kV3mkTkt5KcDtrTgCeJO2E
JqiQlzJMllQWXXxMi+U5nYM=
=yW4p
-----END PGP SIGNATURE-----

--=-MdL2LVNqFds7yxllB8Qf--
