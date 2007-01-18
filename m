From: Eric Leblond <eric@inl.fr>
Subject: [Patch 0/2] libnfnetlink and iface conversion to string
Date: Fri, 19 Jan 2007 00:24:36 +0100
Message-ID: <1169162676.8926.14.camel@localhost>
References: <1167257854.31765.21.camel@localhost>
	<45940145.3020003@netfilter.org> <1167349247.15420.13.camel@localhost>
	<20070107142607.GC13543@prithivi.gnumonks.org>
	<1168296086.12298.6.camel@localhost>
	<20070109115120.GX7655@prithivi.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-nuTRgHdEJ5mR/rDg9ut6"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	Vincent Deffontaines <vincent@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20070109115120.GX7655@prithivi.gnumonks.org>
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


--=-nuTRgHdEJ5mR/rDg9ut6
Content-Type: multipart/mixed; boundary="=-ILZuy64R/R1P+lUSSadh"


--=-ILZuy64R/R1P+lUSSadh
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

Le mardi 09 janvier 2007 =E0 12:51 +0100, Harald Welte a =E9crit :
> On Mon, Jan 08, 2007 at 11:41:26PM +0100, Eric Leblond wrote:
> > Hi,
> I have committed that code to svn:
> http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/libnfnetlink/src/
> rtnl.c and iftable.c
>=20
> However, I never found the time to integrate them intl libnfnetlink, so
> they remained dead code for the last 16 months :(

Here's an attempt to add iface name resolution to libnfnetlink. It works
and it is not too difficult to use.

> > In fact, if we omit the thread approach which is somehow intrusive, I
> > don't see a way to do this via a simple call to added functions.
>=20
> It isn't all that difficult to keep a in-memory list of name-ifindex
> mappings.  You once dump at startup, and then listen to events...

This can be translated like that :
     1. get netlink_fd with nlif_table_init()
     2. use nlif_treat_msg(netlink_fd) to parse initial message
     3. put netlink_fd in a select, and call nlif_treat_msg(netlink_fd)
        when data arrives
     4. cleanup with nlif_table_fini(void) when feature is not needed
        any more

I join the patch for NuFW as code example.

To follow :
      * Patch for libnfnetlink
      * Patch for libnetfilter_queue

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-ILZuy64R/R1P+lUSSadh
Content-Disposition: attachment; filename=nufw_iface_name.diff
Content-Type: text/x-patch; name=nufw_iface_name.diff; charset=ISO-8859-15
Content-Transfer-Encoding: base64

SW5kZXg6IHNyYy9udWZ3L3BhY2tldHNydi5jDQo9PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQotLS0gc3JjL251ZncvcGFj
a2V0c3J2LmMJKHLDqXZpc2lvbiAyNTk2KQ0KKysrIHNyYy9udWZ3L3BhY2tldHNydi5jCShjb3Bp
ZSBkZSB0cmF2YWlsKQ0KQEAgLTE4LDYgKzE4LDggQEANCiANCiAjaW5jbHVkZSAibnVmdy5oIg0K
IA0KKyNpbmNsdWRlICJpZmFjZS5oIg0KKw0KIC8qKiBcZmlsZSBwYWNrZXRzcnYuYw0KICAqICBc
YnJpZWYgUGFja2V0IHNlcnZlciB0aHJlYWQNCiAgKg0KQEAgLTE1OSw2ICsxNjEsNyBAQA0KICAg
ICByZXR1cm4gMTsNCiB9DQogDQorDQogLyoqDQogICogT3BlbiBhIG5ldGxpbmsgY29ubmVjdGlv
biBhbmQgcmV0dXJucyBmaWxlIGRlc2NyaXB0b3INCiAgKi8NCkBAIC0zMzUsNiArMzM4LDcgQEAN
CiAgICAgdW5zaWduZWQgY2hhciBidWZmZXJbQlVGU0laXTsNCiAgICAgc3RydWN0IHRpbWV2YWwg
dHY7DQogICAgIGludCBmZDsNCisgICAgaW50IGlmX2ZkOw0KICAgICBpbnQgcnY7DQogICAgIGlu
dCBzZWxlY3RfcmVzdWx0Ow0KICAgICBmZF9zZXQgd2tfc2V0Ow0KQEAgLTM0NSw2ICszNDksMTIg
QEANCiAgICAgICAgIGV4aXQoRVhJVF9GQUlMVVJFKTsNCiAgICAgfQ0KIA0KKyAgICBpZl9mZCA9
IGlmYWNlX3RhYmxlX29wZW4oKTsNCisNCisgICAgaWYgKGlmX2ZkIDwgMCkgew0KKyAgICAgICAg
ZXhpdChFWElUX0ZBSUxVUkUpOw0KKyAgICB9DQorDQogICAgIGxvZ19hcmVhX3ByaW50ZiAoREVC
VUdfQVJFQV9NQUlOLCBERUJVR19MRVZFTF9XQVJOSU5HLA0KICAgICAgICAgICAgICJbK10gUGFj
a2V0IHNlcnZlciBzdGFydGVkIik7DQogDQpAQCAtMzYwLDYgKzM3MCw3IEBADQogICAgICAgICAv
KiB3YWl0IG5ldyBldmVudCBvbiBzb2NrZXQgKi8NCiAgICAgICAgIEZEX1pFUk8oJndrX3NldCk7
DQogICAgICAgICBGRF9TRVQoZmQsJndrX3NldCk7DQorICAgICAgICBGRF9TRVQoaWZfZmQsJndr
X3NldCk7DQogICAgICAgICBzZWxlY3RfcmVzdWx0ID0gc2VsZWN0KGZkKzEsJndrX3NldCxOVUxM
LE5VTEwsJnR2KTsNCiAgICAgICAgIGlmIChzZWxlY3RfcmVzdWx0ID09IC0xKQ0KICAgICAgICAg
ew0KQEAgLTM4MCw2ICszOTEsMTAgQEANCiAgICAgICAgICAgICBjb250aW51ZTsNCiAgICAgICAg
IH0NCiANCisgICAgICAgIGlmIChGRF9JU1NFVChpZl9mZCwmd2tfc2V0KSl7DQorICAgICAgICAg
ICAgaWZhY2VfdHJlYXRfbWVzc2FnZShpZl9mZCk7DQorICAgICAgICAgICAgY29udGludWU7DQor
ICAgICAgICB9DQogICAgICAgICAvKiByZWFkIG9uZSBwYWNrZXQgKi8NCiAgICAgICAgIHJ2ID0g
cmVjdihmZCwgYnVmZmVyLCBzaXplb2YoYnVmZmVyKSwgMCk7DQogICAgICAgICBpZiAocnYgPCAw
KQ0KSW5kZXg6IHNyYy9udWZ3L2lmYWNlLmMNCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCi0tLSBzcmMvbnVmdy9pZmFj
ZS5jCShyw6l2aXNpb24gMjU5NikNCisrKyBzcmMvbnVmdy9pZmFjZS5jCShjb3BpZSBkZSB0cmF2
YWlsKQ0KQEAgLTQyLDQgKzQyLDI0IEBADQogCXJldHVybiAxOw0KIH0NCiANCitpbnQgaWZhY2Vf
dGFibGVfb3BlbigpDQorew0KKyAgICBpbnQgaWZ0YWJsZV9mZDsNCisgICAgLyogb3BlbmluZyBp
Zm5hbWUgcmVzb2x1dGlvbiBoYW5kbGUgKi8NCisgICAgaWZ0YWJsZV9mZCA9IG5saWZfdGFibGVf
aW5pdCgpOw0KKyAgICBpZiAoaWZ0YWJsZV9mZCA8PSAwKSB7DQorICAgICAgICBsb2dfYXJlYV9w
cmludGYgKERFQlVHX0FSRUFfTUFJTiwgREVCVUdfTEVWRUxfQ1JJVElDQUwsDQorICAgICAgICAg
ICAgICAgICJbIV0gRXJyb3IgZHVyaW5nIG5saWZfdGFibGVfaW5pdCgpIik7DQorICAgICAgICBy
ZXR1cm4gLTE7DQorICAgIH0NCisgICAgLyogdHJlYXQgaW5pdGlhbCBydG5ldGxpbmsgbWVzc2Fn
ZSAqLw0KKyAgICBubGlmX3RyZWF0X21zZyhpZnRhYmxlX2ZkKTsNCisNCisgICAgcmV0dXJuIGlm
dGFibGVfZmQ7DQorfQ0KKw0KK2ludCBpZmFjZV90cmVhdF9tZXNzYWdlKGludCBmZCkNCit7DQor
ICAgcmV0dXJuIG5saWZfdHJlYXRfbXNnKGZkKTsNCit9DQogI2VuZGlmDQpJbmRleDogc3JjL251
ZncvTWFrZWZpbGUuYW0NCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT0NCi0tLSBzcmMvbnVmdy9NYWtlZmlsZS5hbQkocsOp
dmlzaW9uIDI1OTYpDQorKysgc3JjL251ZncvTWFrZWZpbGUuYW0JKGNvcGllIGRlIHRyYXZhaWwp
DQpAQCAtNCw4ICs0LDggQEANCiBzYmluX1BST0dSQU1TID0gbnVmdw0KIA0KICMgbnVmdw0KLW51
ZndfU09VUkNFUyA9IGF1dGhzcnYuYyAgY29tbW9uLmMgIG1haW4uYyAgcGFja2V0c3J2LmMgIHBy
b3RvLmggIHN0cnVjdHVyZS5oXA0KLQkJdGxzLmMgYXVkaXQuYyBjb25udHJhY2suYyBsb2cuYyBp
ZmFjZS5jDQorbnVmd19TT1VSQ0VTID0gYXV0aHNydi5jICBjb21tb24uYyAgbWFpbi5jICBpZmFj
ZS5jIHBhY2tldHNydi5jICBwcm90by5oICBzdHJ1Y3R1cmUuaFwNCisJCXRscy5jIGF1ZGl0LmMg
Y29ubnRyYWNrLmMgbG9nLmMNCiBpZiBIQVZFX0lQUQ0KIG51ZndfTERBREQgPSAtbGlwcSAtbHB0
aHJlYWQgLWxnbnV0bHMNCiBlbmRpZg0KSW5kZXg6IENoYW5nZUxvZw0KPT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KLS0t
IENoYW5nZUxvZwkocsOpdmlzaW9uIDI1OTYpDQorKysgQ2hhbmdlTG9nCShjb3BpZSBkZSB0cmF2
YWlsKQ0KQEAgLTEsNiArMSw5IEBADQogMi4xLjINCiAJLSBsb2dfbXlzcWw6IGFkZCBvcHRpb24g
dG8gbG9nIGJ5IGRlZmF1bHQgaW4gU1FMDQogCWRhdGFiYXNlIHdpdGggSVBWNCBzY2hlbWENCisJ
LSBsaWJudWNsaWVudDogYWRkIG51X2dldF9ob21lX2RpciBmdW5jdGlvbiB3aGljaCBpcyBub3QN
CisJZGVwZW5kYW50IG9mIEhPTUUgZW52aXJvbm1lbnQgdmFyaWFibGUNCisJLSBudWZ3OiBmaXgg
Y29tcGlsYXRpb24gaW4gaXBxIG1vZGUgKHdvcmthcm91bmQgaXBxLmggcHJvYmxlbSkNCiAyLjEu
MSAoMjAwNy8wMS8wMykNCiAJLSBzdXBwcmVzcyBsZGFwIGF1dGhlbnRpY2F0aW9uIGNvZGUNCiAJ
LSBhZGQgc3VwcG9ydCBmb3IgbG9nIHByZWZpeA0K


--=-ILZuy64R/R1P+lUSSadh--

--=-nuTRgHdEJ5mR/rDg9ut6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBFsAG0nxA7CdMWjzIRAgsfAJ9bNroeeR5gcgnPmkaJ98+hirmaXwCgi0Oo
hYOHymhKixeUqnFC3xBRdYk=
=2hNK
-----END PGP SIGNATURE-----

--=-nuTRgHdEJ5mR/rDg9ut6--
