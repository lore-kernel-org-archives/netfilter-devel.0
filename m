From: Eric Leblond <eric@inl.fr>
Subject: Re: Resend [Patch 1/2] Avoid direct connections between NATed hosts
Date: Wed, 17 Jan 2007 16:18:20 +0100
Message-ID: <1169047100.26570.1.camel@localhost.localdomain>
References: <1168621167.28615.14.camel@localhost.localdomain>
	<Pine.LNX.4.61.0701122350230.19224@yvahk01.tjqt.qr>
	<1168722049.5737.4.camel@localhost>  <45AE153F.6010105@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-mHYAqw7wgY2sTlTdizzS"
Cc: netfilter-devel@lists.netfilter.org,
	Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <45AE153F.6010105@trash.net>
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


--=-mHYAqw7wgY2sTlTdizzS
Content-Type: multipart/mixed; boundary="=-c5WD9cik6a/xezcpn+my"


--=-c5WD9cik6a/xezcpn+my
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

This patch is a try to apply all the modifications you have asked.

BR,

Le mercredi 17 janvier 2007 =E0 13:23 +0100, Patrick McHardy a =E9crit :
> Eric Leblond wrote:
> > diff --git a/include/linux/netfilter_ipv4/ip_nat.h b/include/linux/netf=
ilter_ipv4/ip_nat.h
> > index bdf5536..bbca89a 100644
> > --- a/include/linux/netfilter_ipv4/ip_nat.h
> > +++ b/include/linux/netfilter_ipv4/ip_nat.h
> > @@ -16,6 +16,7 @@ #define HOOK2MANIP(hooknum) ((hooknum) !
> > =20
> >  #define IP_NAT_RANGE_MAP_IPS 1
> >  #define IP_NAT_RANGE_PROTO_SPECIFIED 2
> > +#define IP_NAT_RANGE_PROTO_RANDOM 4 /* add randomness to "port" select=
ion */
> > =20
> >  /* NAT sequence number modifications */
> >  struct ip_nat_seq {
> > diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_=
nat.h
> > index 61c6206..bc57dd7 100644
> > --- a/include/net/netfilter/nf_nat.h
> > +++ b/include/net/netfilter/nf_nat.h
> > @@ -16,6 +16,7 @@ #define HOOK2MANIP(hooknum) ((hooknum) !
> > =20
> >  #define IP_NAT_RANGE_MAP_IPS 1
> >  #define IP_NAT_RANGE_PROTO_SPECIFIED 2
> > +#define IP_NAT_RANGE_PROTO_RANDOM 4
> > =20
> >  /* NAT sequence number modifications */
> >  struct nf_nat_seq {
> > diff --git a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_n=
at_core.c
> > index 9d1a517..5e08c2b 100644
> > --- a/net/ipv4/netfilter/ip_nat_core.c
> > +++ b/net/ipv4/netfilter/ip_nat_core.c
> > @@ -246,8 +246,9 @@ get_unique_tuple(struct ip_conntrack_tup
> >  	if (maniptype =3D=3D IP_NAT_MANIP_SRC) {
> >  		if (find_appropriate_src(orig_tuple, tuple, range)) {
> >  			DEBUGP("get_unique_tuple: Found current src map\n");
> > -			if (!ip_nat_used_tuple(tuple, conntrack))
> > -				return;
> > +			if (!(range->flags & IP_NAT_RANGE_PROTO_RANDOM))
> > +				if (!ip_nat_used_tuple(tuple, conntrack))
> > +					return;
> >  		}
> >  	}
> > =20
> > @@ -261,6 +262,13 @@ get_unique_tuple(struct ip_conntrack_tup
> > =20
> >  	proto =3D ip_nat_proto_find_get(orig_tuple->dst.protonum);
> > =20
> > +	/* Change protocol info to have some randomization */
> > +	if (range->flags & IP_NAT_RANGE_PROTO_RANDOM) {
>=20
> This doesn't seem to make much sense for DNAT. Either catch it in
> the checkentry functions or avoid some other way.
>=20
> > +		proto->unique_tuple(tuple, range, maniptype, conntrack);
> > +		ip_nat_proto_put(proto);
> > +		return;
> > +	}
> > +
> >  	/* Only bother mapping if it's not already in range and unique */
> >  	if ((!(range->flags & IP_NAT_RANGE_PROTO_SPECIFIED)
> >  	     || proto->in_range(tuple, maniptype, &range->min, &range->max))
> > diff --git a/net/ipv4/netfilter/ip_nat_proto_tcp.c b/net/ipv4/netfilter=
/ip_nat_proto_tcp.c
> > index b586d18..154a4f7 100644
> > --- a/net/ipv4/netfilter/ip_nat_proto_tcp.c
> > +++ b/net/ipv4/netfilter/ip_nat_proto_tcp.c
> > @@ -18,6 +18,8 @@ #include <linux/netfilter_ipv4/ip_nat_ru
> >  #include <linux/netfilter_ipv4/ip_nat_protocol.h>
> >  #include <linux/netfilter_ipv4/ip_nat_core.h>
> > =20
> > +#include <linux/random.h>
>=20
> Put this next to the other linux/ includes please.
>=20
> > +
> >  static int
> >  tcp_in_range(const struct ip_conntrack_tuple *tuple,
> >  	     enum ip_nat_manip_type maniptype,
> > @@ -75,6 +77,9 @@ tcp_unique_tuple(struct ip_conntrack_tup
> >  		range_size =3D ntohs(range->max.tcp.port) - min + 1;
> >  	}
> > =20
> > +	/* Start from random port to avoid prediction */
> > +	if (range->flags & IP_NAT_RANGE_PROTO_RANDOM)
> > +		port =3D (u_int16_t) net_random();
>=20
> No need to cast, also endianness error (port is __be16).
>=20
> >  	for (i =3D 0; i < range_size; i++, port++) {
> >  		*portptr =3D htons(min + port % range_size);
> >  		if (!ip_nat_used_tuple(tuple, conntrack)) {

--=-c5WD9cik6a/xezcpn+my
Content-Disposition: attachment;
	filename=0001-Avoid-direct-connections-between-NATed-hosts.txt
Content-Transfer-Encoding: base64
Content-Type: text/plain;
	name=0001-Avoid-direct-connections-between-NATed-hosts.txt;
	charset=iso-8859-15

RnJvbSAzYzg1MDc0Nzg1OTM1YzhkZmVhNDE5MTU5MDhjMTk2ZDk4ZTZjNDdkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogRXJpYyBMZWJsb25kIDxlcmljQGlubC5mcj4NCkRhdGU6IFdl
ZCwgMTcgSmFuIDIwMDcgMTY6MTQ6MjMgKzAxMDANClN1YmplY3Q6IFtQQVRDSF0gQXZvaWQgZGly
ZWN0IGNvbm5lY3Rpb25zIGJldHdlZW4gTkFUZWQgaG9zdHMNCg0KVGhpcyBwYXRjaCBhZGRzIHRo
ZSBjYXBhYmlsaXR5IHRvIHJhbmRvbWl6ZSBwb3J0cyBjaG9pY2UNCmR1cmluZyBOQVQuIFRoaXMg
YmxvY2tzIHNvbWUgc29mdHdhcmUgdXNpbmcgcG9ydCBwcmVkaWN0aW9uDQp0byBlc3RhYmxpc2hl
ZCBjb25uZWN0aW9ucyBiZXR3ZWVuIE5BVGVkIGhvc3RzLg0KU2lnbmVkLW9mZi1ieTogRXJpYyBM
ZWJsb25kIDxlcmljQGljZS1hZ2UuKG5vbmUpPg0KLS0tDQogaW5jbHVkZS9saW51eC9uZXRmaWx0
ZXJfaXB2NC9pcF9uYXQuaCB8ICAgIDEgKw0KIGluY2x1ZGUvbmV0L25ldGZpbHRlci9uZl9uYXQu
aCAgICAgICAgfCAgICAxICsNCiBuZXQvaXB2NC9uZXRmaWx0ZXIvaXBfbmF0X2NvcmUuYyAgICAg
IHwgICAxMiArKysrKysrKysrLS0NCiBuZXQvaXB2NC9uZXRmaWx0ZXIvaXBfbmF0X3Byb3RvX3Rj
cC5jIHwgICAgNCArKysrDQogbmV0L2lwdjQvbmV0ZmlsdGVyL2lwX25hdF9wcm90b191ZHAuYyB8
ICAgIDQgKysrKw0KIG5ldC9pcHY0L25ldGZpbHRlci9pcF9uYXRfcnVsZS5jICAgICAgfCAgICA0
ICsrKysNCiBuZXQvaXB2NC9uZXRmaWx0ZXIvbmZfbmF0X2NvcmUuYyAgICAgIHwgICAxMiArKysr
KysrKysrLS0NCiBuZXQvaXB2NC9uZXRmaWx0ZXIvbmZfbmF0X3Byb3RvX3RjcC5jIHwgICAgMyAr
KysNCiBuZXQvaXB2NC9uZXRmaWx0ZXIvbmZfbmF0X3Byb3RvX3VkcC5jIHwgICAgMyArKysNCiBu
ZXQvaXB2NC9uZXRmaWx0ZXIvbmZfbmF0X3J1bGUuYyAgICAgIHwgICAgNCArKysrDQogMTAgZmls
ZXMgY2hhbmdlZCwgNDQgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdp
dCBhL2luY2x1ZGUvbGludXgvbmV0ZmlsdGVyX2lwdjQvaXBfbmF0LmggYi9pbmNsdWRlL2xpbnV4
L25ldGZpbHRlcl9pcHY0L2lwX25hdC5oDQppbmRleCBiZGY1NTM2Li5iYmNhODlhIDEwMDY0NA0K
LS0tIGEvaW5jbHVkZS9saW51eC9uZXRmaWx0ZXJfaXB2NC9pcF9uYXQuaA0KKysrIGIvaW5jbHVk
ZS9saW51eC9uZXRmaWx0ZXJfaXB2NC9pcF9uYXQuaA0KQEAgLTE2LDYgKzE2LDcgQEAgI2RlZmlu
ZSBIT09LMk1BTklQKGhvb2tudW0pICgoaG9va251bSkgIQ0KIA0KICNkZWZpbmUgSVBfTkFUX1JB
TkdFX01BUF9JUFMgMQ0KICNkZWZpbmUgSVBfTkFUX1JBTkdFX1BST1RPX1NQRUNJRklFRCAyDQor
I2RlZmluZSBJUF9OQVRfUkFOR0VfUFJPVE9fUkFORE9NIDQgLyogYWRkIHJhbmRvbW5lc3MgdG8g
InBvcnQiIHNlbGVjdGlvbiAqLw0KIA0KIC8qIE5BVCBzZXF1ZW5jZSBudW1iZXIgbW9kaWZpY2F0
aW9ucyAqLw0KIHN0cnVjdCBpcF9uYXRfc2VxIHsNCmRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC9u
ZXRmaWx0ZXIvbmZfbmF0LmggYi9pbmNsdWRlL25ldC9uZXRmaWx0ZXIvbmZfbmF0LmgNCmluZGV4
IDYxYzYyMDYuLmJjNTdkZDcgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL25ldC9uZXRmaWx0ZXIvbmZf
bmF0LmgNCisrKyBiL2luY2x1ZGUvbmV0L25ldGZpbHRlci9uZl9uYXQuaA0KQEAgLTE2LDYgKzE2
LDcgQEAgI2RlZmluZSBIT09LMk1BTklQKGhvb2tudW0pICgoaG9va251bSkgIQ0KIA0KICNkZWZp
bmUgSVBfTkFUX1JBTkdFX01BUF9JUFMgMQ0KICNkZWZpbmUgSVBfTkFUX1JBTkdFX1BST1RPX1NQ
RUNJRklFRCAyDQorI2RlZmluZSBJUF9OQVRfUkFOR0VfUFJPVE9fUkFORE9NIDQNCiANCiAvKiBO
QVQgc2VxdWVuY2UgbnVtYmVyIG1vZGlmaWNhdGlvbnMgKi8NCiBzdHJ1Y3QgbmZfbmF0X3NlcSB7
DQpkaWZmIC0tZ2l0IGEvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwX25hdF9jb3JlLmMgYi9uZXQvaXB2
NC9uZXRmaWx0ZXIvaXBfbmF0X2NvcmUuYw0KaW5kZXggOWQxYTUxNy4uNWUwOGMyYiAxMDA2NDQN
Ci0tLSBhL25ldC9pcHY0L25ldGZpbHRlci9pcF9uYXRfY29yZS5jDQorKysgYi9uZXQvaXB2NC9u
ZXRmaWx0ZXIvaXBfbmF0X2NvcmUuYw0KQEAgLTI0Niw4ICsyNDYsOSBAQCBnZXRfdW5pcXVlX3R1
cGxlKHN0cnVjdCBpcF9jb25udHJhY2tfdHVwDQogCWlmIChtYW5pcHR5cGUgPT0gSVBfTkFUX01B
TklQX1NSQykgew0KIAkJaWYgKGZpbmRfYXBwcm9wcmlhdGVfc3JjKG9yaWdfdHVwbGUsIHR1cGxl
LCByYW5nZSkpIHsNCiAJCQlERUJVR1AoImdldF91bmlxdWVfdHVwbGU6IEZvdW5kIGN1cnJlbnQg
c3JjIG1hcFxuIik7DQotCQkJaWYgKCFpcF9uYXRfdXNlZF90dXBsZSh0dXBsZSwgY29ubnRyYWNr
KSkNCi0JCQkJcmV0dXJuOw0KKwkJCWlmICghKHJhbmdlLT5mbGFncyAmIElQX05BVF9SQU5HRV9Q
Uk9UT19SQU5ET00pKQ0KKwkJCQlpZiAoIWlwX25hdF91c2VkX3R1cGxlKHR1cGxlLCBjb25udHJh
Y2spKQ0KKwkJCQkJcmV0dXJuOw0KIAkJfQ0KIAl9DQogDQpAQCAtMjYxLDYgKzI2MiwxMyBAQCBn
ZXRfdW5pcXVlX3R1cGxlKHN0cnVjdCBpcF9jb25udHJhY2tfdHVwDQogDQogCXByb3RvID0gaXBf
bmF0X3Byb3RvX2ZpbmRfZ2V0KG9yaWdfdHVwbGUtPmRzdC5wcm90b251bSk7DQogDQorCS8qIENo
YW5nZSBwcm90b2NvbCBpbmZvIHRvIGhhdmUgc29tZSByYW5kb21pemF0aW9uICovDQorCWlmIChy
YW5nZS0+ZmxhZ3MgJiBJUF9OQVRfUkFOR0VfUFJPVE9fUkFORE9NKSB7DQorCQlwcm90by0+dW5p
cXVlX3R1cGxlKHR1cGxlLCByYW5nZSwgbWFuaXB0eXBlLCBjb25udHJhY2spOw0KKwkJaXBfbmF0
X3Byb3RvX3B1dChwcm90byk7DQorCQlyZXR1cm47DQorCX0NCisNCiAJLyogT25seSBib3RoZXIg
bWFwcGluZyBpZiBpdCdzIG5vdCBhbHJlYWR5IGluIHJhbmdlIGFuZCB1bmlxdWUgKi8NCiAJaWYg
KCghKHJhbmdlLT5mbGFncyAmIElQX05BVF9SQU5HRV9QUk9UT19TUEVDSUZJRUQpDQogCSAgICAg
fHwgcHJvdG8tPmluX3JhbmdlKHR1cGxlLCBtYW5pcHR5cGUsICZyYW5nZS0+bWluLCAmcmFuZ2Ut
Pm1heCkpDQpkaWZmIC0tZ2l0IGEvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwX25hdF9wcm90b190Y3Au
YyBiL25ldC9pcHY0L25ldGZpbHRlci9pcF9uYXRfcHJvdG9fdGNwLmMNCmluZGV4IGI1ODZkMTgu
Ljc4ZmYxYmIgMTAwNjQ0DQotLS0gYS9uZXQvaXB2NC9uZXRmaWx0ZXIvaXBfbmF0X3Byb3RvX3Rj
cC5jDQorKysgYi9uZXQvaXB2NC9uZXRmaWx0ZXIvaXBfbmF0X3Byb3RvX3RjcC5jDQpAQCAtOCw2
ICs4LDcgQEANCiANCiAjaW5jbHVkZSA8bGludXgvdHlwZXMuaD4NCiAjaW5jbHVkZSA8bGludXgv
aW5pdC5oPg0KKyNpbmNsdWRlIDxsaW51eC9yYW5kb20uaD4NCiAjaW5jbHVkZSA8bGludXgvbmV0
ZmlsdGVyLmg+DQogI2luY2x1ZGUgPGxpbnV4L2lwLmg+DQogI2luY2x1ZGUgPGxpbnV4L3RjcC5o
Pg0KQEAgLTc1LDYgKzc2LDkgQEAgdGNwX3VuaXF1ZV90dXBsZShzdHJ1Y3QgaXBfY29ubnRyYWNr
X3R1cA0KIAkJcmFuZ2Vfc2l6ZSA9IG50b2hzKHJhbmdlLT5tYXgudGNwLnBvcnQpIC0gbWluICsg
MTsNCiAJfQ0KIA0KKwkvKiBTdGFydCBmcm9tIHJhbmRvbSBwb3J0IHRvIGF2b2lkIHByZWRpY3Rp
b24gKi8NCisJaWYgKHJhbmdlLT5mbGFncyAmIElQX05BVF9SQU5HRV9QUk9UT19SQU5ET00pDQor
CQlwb3J0ID0gIF9fY3B1X3RvX2JlMTYobmV0X3JhbmRvbSgpKTsNCiAJZm9yIChpID0gMDsgaSA8
IHJhbmdlX3NpemU7IGkrKywgcG9ydCsrKSB7DQogCQkqcG9ydHB0ciA9IGh0b25zKG1pbiArIHBv
cnQgJSByYW5nZV9zaXplKTsNCiAJCWlmICghaXBfbmF0X3VzZWRfdHVwbGUodHVwbGUsIGNvbm50
cmFjaykpIHsNCmRpZmYgLS1naXQgYS9uZXQvaXB2NC9uZXRmaWx0ZXIvaXBfbmF0X3Byb3RvX3Vk
cC5jIGIvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwX25hdF9wcm90b191ZHAuYw0KaW5kZXggNWNlZDA4
Ny4uNzUyYTI5MiAxMDA2NDQNCi0tLSBhL25ldC9pcHY0L25ldGZpbHRlci9pcF9uYXRfcHJvdG9f
dWRwLmMNCisrKyBiL25ldC9pcHY0L25ldGZpbHRlci9pcF9uYXRfcHJvdG9fdWRwLmMNCkBAIC04
LDYgKzgsNyBAQA0KIA0KICNpbmNsdWRlIDxsaW51eC90eXBlcy5oPg0KICNpbmNsdWRlIDxsaW51
eC9pbml0Lmg+DQorI2luY2x1ZGUgPGxpbnV4L3JhbmRvbS5oPg0KICNpbmNsdWRlIDxsaW51eC9u
ZXRmaWx0ZXIuaD4NCiAjaW5jbHVkZSA8bGludXgvaXAuaD4NCiAjaW5jbHVkZSA8bGludXgvdWRw
Lmg+DQpAQCAtNzQsNiArNzUsOSBAQCB1ZHBfdW5pcXVlX3R1cGxlKHN0cnVjdCBpcF9jb25udHJh
Y2tfdHVwDQogCQlyYW5nZV9zaXplID0gbnRvaHMocmFuZ2UtPm1heC51ZHAucG9ydCkgLSBtaW4g
KyAxOw0KIAl9DQogDQorCS8qIFN0YXJ0IGZyb20gcmFuZG9tIHBvcnQgdG8gYXZvaWQgcHJlZGlj
dGlvbiAqLw0KKwlpZiAocmFuZ2UtPmZsYWdzICYgSVBfTkFUX1JBTkdFX1BST1RPX1JBTkRPTSkN
CisJCXBvcnQgPSBfX2NwdV90b19iZTE2KG5ldF9yYW5kb20oKSk7DQogCWZvciAoaSA9IDA7IGkg
PCByYW5nZV9zaXplOyBpKyssIHBvcnQrKykgew0KIAkJKnBvcnRwdHIgPSBodG9ucyhtaW4gKyBw
b3J0ICUgcmFuZ2Vfc2l6ZSk7DQogCQlpZiAoIWlwX25hdF91c2VkX3R1cGxlKHR1cGxlLCBjb25u
dHJhY2spKQ0KZGlmZiAtLWdpdCBhL25ldC9pcHY0L25ldGZpbHRlci9pcF9uYXRfcnVsZS5jIGIv
bmV0L2lwdjQvbmV0ZmlsdGVyL2lwX25hdF9ydWxlLmMNCmluZGV4IGExNzZhYTMuLjZlYmFhZDMg
MTAwNjQ0DQotLS0gYS9uZXQvaXB2NC9uZXRmaWx0ZXIvaXBfbmF0X3J1bGUuYw0KKysrIGIvbmV0
L2lwdjQvbmV0ZmlsdGVyL2lwX25hdF9ydWxlLmMNCkBAIC0xOTMsNiArMTkzLDEwIEBAIHN0YXRp
YyBpbnQgaXB0X2RuYXRfY2hlY2tlbnRyeShjb25zdCBjaGENCiAJCXByaW50aygiRE5BVDogbXVs
dGlwbGUgcmFuZ2VzIG5vIGxvbmdlciBzdXBwb3J0ZWRcbiIpOw0KIAkJcmV0dXJuIDA7DQogCX0N
CisJaWYgKG1yLT5yYW5nZVswXS5mbGFncyAmIElQX05BVF9SQU5HRV9QUk9UT19SQU5ET00pIHsN
CisJCXByaW50aygiRE5BVDogcG9ydCByYW5kb21pemF0aW9uIG5vdCBzdXBwb3J0ZWRcbiIpOw0K
KwkJcmV0dXJuIDA7DQorCX0NCiAJcmV0dXJuIDE7DQogfQ0KIA0KZGlmZiAtLWdpdCBhL25ldC9p
cHY0L25ldGZpbHRlci9uZl9uYXRfY29yZS5jIGIvbmV0L2lwdjQvbmV0ZmlsdGVyL25mX25hdF9j
b3JlLmMNCmluZGV4IDg2YTkyMjcuLjk5OGIyNTUgMTAwNjQ0DQotLS0gYS9uZXQvaXB2NC9uZXRm
aWx0ZXIvbmZfbmF0X2NvcmUuYw0KKysrIGIvbmV0L2lwdjQvbmV0ZmlsdGVyL25mX25hdF9jb3Jl
LmMNCkBAIC0yNTQsOCArMjU0LDkgQEAgZ2V0X3VuaXF1ZV90dXBsZShzdHJ1Y3QgbmZfY29ubnRy
YWNrX3R1cA0KIAlpZiAobWFuaXB0eXBlID09IElQX05BVF9NQU5JUF9TUkMpIHsNCiAJCWlmIChm
aW5kX2FwcHJvcHJpYXRlX3NyYyhvcmlnX3R1cGxlLCB0dXBsZSwgcmFuZ2UpKSB7DQogCQkJREVC
VUdQKCJnZXRfdW5pcXVlX3R1cGxlOiBGb3VuZCBjdXJyZW50IHNyYyBtYXBcbiIpOw0KLQkJCWlm
ICghbmZfbmF0X3VzZWRfdHVwbGUodHVwbGUsIGN0KSkNCi0JCQkJcmV0dXJuOw0KKwkJCWlmICgh
KHJhbmdlLT5mbGFncyAmIElQX05BVF9SQU5HRV9QUk9UT19SQU5ET00pKQ0KKwkJCQlpZiAoIW5m
X25hdF91c2VkX3R1cGxlKHR1cGxlLCBjdCkpDQorCQkJCQlyZXR1cm47DQogCQl9DQogCX0NCiAN
CkBAIC0yNjksNiArMjcwLDEzIEBAIGdldF91bmlxdWVfdHVwbGUoc3RydWN0IG5mX2Nvbm50cmFj
a190dXANCiANCiAJcHJvdG8gPSBuZl9uYXRfcHJvdG9fZmluZF9nZXQob3JpZ190dXBsZS0+ZHN0
LnByb3RvbnVtKTsNCiANCisJLyogQ2hhbmdlIHByb3RvY29sIGluZm8gdG8gaGF2ZSBzb21lIHJh
bmRvbWl6YXRpb24gKi8NCisJaWYgKHJhbmdlLT5mbGFncyAmIElQX05BVF9SQU5HRV9QUk9UT19S
QU5ET00pIHsNCisJCXByb3RvLT51bmlxdWVfdHVwbGUodHVwbGUsIHJhbmdlLCBtYW5pcHR5cGUs
IGN0KTsNCisJCW5mX25hdF9wcm90b19wdXQocHJvdG8pOw0KKwkJcmV0dXJuOw0KKwl9DQorDQog
CS8qIE9ubHkgYm90aGVyIG1hcHBpbmcgaWYgaXQncyBub3QgYWxyZWFkeSBpbiByYW5nZSBhbmQg
dW5pcXVlICovDQogCWlmICgoIShyYW5nZS0+ZmxhZ3MgJiBJUF9OQVRfUkFOR0VfUFJPVE9fU1BF
Q0lGSUVEKSB8fA0KIAkgICAgIHByb3RvLT5pbl9yYW5nZSh0dXBsZSwgbWFuaXB0eXBlLCAmcmFu
Z2UtPm1pbiwgJnJhbmdlLT5tYXgpKSAmJg0KZGlmZiAtLWdpdCBhL25ldC9pcHY0L25ldGZpbHRl
ci9uZl9uYXRfcHJvdG9fdGNwLmMgYi9uZXQvaXB2NC9uZXRmaWx0ZXIvbmZfbmF0X3Byb3RvX3Rj
cC5jDQppbmRleCA3ZTI2YTdlLi5mMGUzN2YwIDEwMDY0NA0KLS0tIGEvbmV0L2lwdjQvbmV0Zmls
dGVyL25mX25hdF9wcm90b190Y3AuYw0KKysrIGIvbmV0L2lwdjQvbmV0ZmlsdGVyL25mX25hdF9w
cm90b190Y3AuYw0KQEAgLTgsNiArOCw3IEBADQogDQogI2luY2x1ZGUgPGxpbnV4L3R5cGVzLmg+
DQogI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4NCisjaW5jbHVkZSA8bGludXgvcmFuZG9tLmg+DQog
I2luY2x1ZGUgPGxpbnV4L2lwLmg+DQogI2luY2x1ZGUgPGxpbnV4L3RjcC5oPg0KIA0KQEAgLTc1
LDYgKzc2LDggQEAgdGNwX3VuaXF1ZV90dXBsZShzdHJ1Y3QgbmZfY29ubnRyYWNrX3R1cA0KIAkJ
cmFuZ2Vfc2l6ZSA9IG50b2hzKHJhbmdlLT5tYXgudGNwLnBvcnQpIC0gbWluICsgMTsNCiAJfQ0K
IA0KKwlpZiAocmFuZ2UtPmZsYWdzICYgSVBfTkFUX1JBTkdFX1BST1RPX1JBTkRPTSkNCisJCXBv
cnQgPSAgX19jcHVfdG9fYmUxNihuZXRfcmFuZG9tKCkpOw0KIAlmb3IgKGkgPSAwOyBpIDwgcmFu
Z2Vfc2l6ZTsgaSsrLCBwb3J0KyspIHsNCiAJCSpwb3J0cHRyID0gaHRvbnMobWluICsgcG9ydCAl
IHJhbmdlX3NpemUpOw0KIAkJaWYgKCFuZl9uYXRfdXNlZF90dXBsZSh0dXBsZSwgY3QpKQ0KZGlm
ZiAtLWdpdCBhL25ldC9pcHY0L25ldGZpbHRlci9uZl9uYXRfcHJvdG9fdWRwLmMgYi9uZXQvaXB2
NC9uZXRmaWx0ZXIvbmZfbmF0X3Byb3RvX3VkcC5jDQppbmRleCBhYjBjZTRjLi44YTQ2NTIxIDEw
MDY0NA0KLS0tIGEvbmV0L2lwdjQvbmV0ZmlsdGVyL25mX25hdF9wcm90b191ZHAuYw0KKysrIGIv
bmV0L2lwdjQvbmV0ZmlsdGVyL25mX25hdF9wcm90b191ZHAuYw0KQEAgLTgsNiArOCw3IEBADQog
DQogI2luY2x1ZGUgPGxpbnV4L3R5cGVzLmg+DQogI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4NCisj
aW5jbHVkZSA8bGludXgvcmFuZG9tLmg+DQogI2luY2x1ZGUgPGxpbnV4L2lwLmg+DQogI2luY2x1
ZGUgPGxpbnV4L3VkcC5oPg0KIA0KQEAgLTczLDYgKzc0LDggQEAgdWRwX3VuaXF1ZV90dXBsZShz
dHJ1Y3QgbmZfY29ubnRyYWNrX3R1cA0KIAkJcmFuZ2Vfc2l6ZSA9IG50b2hzKHJhbmdlLT5tYXgu
dWRwLnBvcnQpIC0gbWluICsgMTsNCiAJfQ0KIA0KKwlpZiAocmFuZ2UtPmZsYWdzICYgSVBfTkFU
X1JBTkdFX1BST1RPX1JBTkRPTSkNCisJCXBvcnQgPSAgX19jcHVfdG9fYmUxNihuZXRfcmFuZG9t
KCkpOw0KIAlmb3IgKGkgPSAwOyBpIDwgcmFuZ2Vfc2l6ZTsgaSsrLCBwb3J0KyspIHsNCiAJCSpw
b3J0cHRyID0gaHRvbnMobWluICsgcG9ydCAlIHJhbmdlX3NpemUpOw0KIAkJaWYgKCFuZl9uYXRf
dXNlZF90dXBsZSh0dXBsZSwgY3QpKQ0KZGlmZiAtLWdpdCBhL25ldC9pcHY0L25ldGZpbHRlci9u
Zl9uYXRfcnVsZS5jIGIvbmV0L2lwdjQvbmV0ZmlsdGVyL25mX25hdF9ydWxlLmMNCmluZGV4IGI4
NjhlZTAuLjM3NDVlZmUgMTAwNjQ0DQotLS0gYS9uZXQvaXB2NC9uZXRmaWx0ZXIvbmZfbmF0X3J1
bGUuYw0KKysrIGIvbmV0L2lwdjQvbmV0ZmlsdGVyL25mX25hdF9ydWxlLmMNCkBAIC0yMjYsNiAr
MjI2LDEwIEBAIHN0YXRpYyBpbnQgaXB0X2RuYXRfY2hlY2tlbnRyeShjb25zdCBjaGENCiAJCXBy
aW50aygiRE5BVDogbXVsdGlwbGUgcmFuZ2VzIG5vIGxvbmdlciBzdXBwb3J0ZWRcbiIpOw0KIAkJ
cmV0dXJuIDA7DQogCX0NCisJaWYgKG1yLT5yYW5nZVswXS5mbGFncyAmIElQX05BVF9SQU5HRV9Q
Uk9UT19SQU5ET00pIHsNCisJCXByaW50aygiRE5BVDogcG9ydCByYW5kb21pemF0aW9uIG5vdCBz
dXBwb3J0ZWRcbiIpOw0KKwkJcmV0dXJuIDA7DQorCX0NCiAJcmV0dXJuIDE7DQogfQ0KIA0KLS0g
DQoxLjQuMQ0KDQo=


--=-c5WD9cik6a/xezcpn+my--

--=-mHYAqw7wgY2sTlTdizzS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBFrj48nxA7CdMWjzIRAv3wAJ4mH4k/jgjeGJp5ADkjQm3PZBPB7ACfbFut
tvM3CgvTdUx20xEOZsHYmnQ=
=q4g8
-----END PGP SIGNATURE-----

--=-mHYAqw7wgY2sTlTdizzS--
