From: Martin Josefsson <gandalf@netfilter.org>
Subject: [PATCH 2.4 RESEND] netfilter: add size check for udp packet
	mangling
Date: Mon, 13 Oct 2003 20:17:38 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1066069057.29182.155.camel@tux.rsn.bth.se>
References: <20031002142646.GC5758@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CKZHcURE4C6S3ALSBj8c"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
In-Reply-To: <20031002142646.GC5758@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-CKZHcURE4C6S3ALSBj8c
Content-Type: multipart/mixed; boundary="=-liNxTJwLYgnfm3k3N1HT"


--=-liNxTJwLYgnfm3k3N1HT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2003-10-02 at 16:26, Harald Welte wrote:
> Hi Davem!
>=20
> Please apply the following patchto your 2.4 tree and push it to Marcelo.
> Thanks.
>=20
>=20
> Author: Patrick McHardy <kaber@trash.net>
>=20
> Add size check to ip_nat_mangle_udp_packet

Hi Dave

Harald sent this with the wrong subject and it got dropped.
Here it is with the correct subject.
Found when syncing patch-o-matic with 2.4-bk
Please apply. More resends are coming.


Author: Patrick McHardy <kaber@trash.net>

Add size check to ip_nat_mangle_udp_packet

--=20
/Martin

--=-liNxTJwLYgnfm3k3N1HT
Content-Disposition: attachment; filename=79_mangle_udp-sizecheck.patch
Content-Type: text/plain; name=79_mangle_udp-sizecheck.patch; charset=ISO-8859-15
Content-Transfer-Encoding: base64

IyBUaGlzIGlzIGEgQml0S2VlcGVyIGdlbmVyYXRlZCBwYXRjaCBmb3IgdGhlIGZvbGxvd2luZyBw
cm9qZWN0Og0KIyBQcm9qZWN0IE5hbWU6IExpbnV4IGtlcm5lbCB0cmVlDQojIFRoaXMgcGF0Y2gg
Zm9ybWF0IGlzIGludGVuZGVkIGZvciBHTlUgcGF0Y2ggY29tbWFuZCB2ZXJzaW9uIDIuNSBvciBo
aWdoZXIuDQojIFRoaXMgcGF0Y2ggaW5jbHVkZXMgdGhlIGZvbGxvd2luZyBkZWx0YXM6DQojCSAg
ICAgICAgICAgQ2hhbmdlU2V0CTEuMTEzNCAgLT4gMS4xMTM1IA0KIwluZXQvaXB2NC9uZXRmaWx0
ZXIvaXBfbmF0X2hlbHBlci5jCTEuMTAgICAgLT4gMS4xMSAgIA0KIw0KIyBUaGUgZm9sbG93aW5n
IGlzIHRoZSBCaXRLZWVwZXIgQ2hhbmdlU2V0IExvZw0KIyAtLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KIyAwMy8wOS8yOAlrYWJlckB0cmFzaC5uZXQJMS4xMTM1
DQojIFtORVRGSUxURVJdOiBBZGQgc2l6ZSBjaGVjayB0byBpcF9uYXRfbWFuZ2xlX3VkcF9wYWNr
ZXQNCiMgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCiMNCmRp
ZmYgLU5ydSBhL25ldC9pcHY0L25ldGZpbHRlci9pcF9uYXRfaGVscGVyLmMgYi9uZXQvaXB2NC9u
ZXRmaWx0ZXIvaXBfbmF0X2hlbHBlci5jDQotLS0gYS9uZXQvaXB2NC9uZXRmaWx0ZXIvaXBfbmF0
X2hlbHBlci5jCVN1biBTZXAgMjggMDQ6NDA6MjkgMjAwMw0KKysrIGIvbmV0L2lwdjQvbmV0Zmls
dGVyL2lwX25hdF9oZWxwZXIuYwlTdW4gU2VwIDI4IDA0OjQwOjI5IDIwMDMNCkBAIC0yMzMsNiAr
MjMzLDEzIEBADQogCW5ld3VkcGxlbiA9IHVkcGxlbiAtIG1hdGNoX2xlbiArIHJlcF9sZW47DQog
CW5ld2xlbiA9IGlwaC0+aWhsKjQgKyBuZXd1ZHBsZW47DQogDQorCS8qIFVEUCBoZWxwZXJzIG1p
Z2h0IGFjY2lkZW50YWxseSBtYW5nbGUgdGhlIHdyb25nIHBhY2tldCAqLw0KKwlpZiAodWRwbGVu
IDwgc2l6ZW9mKCp1ZHBoKSArIG1hdGNoX29mZnNldCArIG1hdGNoX2xlbikgew0KKwkJaWYgKG5l
dF9yYXRlbGltaXQoKSkNCisJCQlwcmludGsoImlwX25hdF9tYW5nbGVfdWRwX3BhY2tldDogdW5k
ZXJzaXplZCBwYWNrZXRcbiIpOw0KKwkJcmV0dXJuIDA7DQorCX0NCisNCiAJaWYgKG5ld2xlbiA+
IDY1NTM1KSB7DQogCQlpZiAobmV0X3JhdGVsaW1pdCgpKQ0KIAkJCXByaW50aygiaXBfbmF0X21h
bmdsZV91ZHBfcGFja2V0OiBuYXQnZWQgcGFja2V0ICINCg==

--=-liNxTJwLYgnfm3k3N1HT--

--=-CKZHcURE4C6S3ALSBj8c
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQA/iuxBWm2vlfa207ERApqsAJwKCLntENhPqBYc//LN752MYejboQCeLq2R
03ozWBndsD/SVcVaDIxvGJI=
=EKoO
-----END PGP SIGNATURE-----

--=-CKZHcURE4C6S3ALSBj8c--
