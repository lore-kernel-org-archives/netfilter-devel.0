From: Erich Schubert <erich@debian.org>
Subject: iptables should prevent --rttl together with --set in recent module
Date: Mon, 13 Feb 2006 03:13:18 +0100
Message-ID: <1139796798.21844.7.camel@wintermute.xmldesign.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-B7eJAlLqBF1tPfRpoShq"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--=-B7eJAlLqBF1tPfRpoShq
Content-Type: multipart/mixed; boundary="=-eb+MPpejUcLz0KY5aERx"


--=-eb+MPpejUcLz0KY5aERx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,
iptables should prevent the use of --rttl together with --set in the
recent module.
By mistake I had the --rttl flag also on my --set rule, which resulted
in iptables blocking almost any connections in my case (instead of only
those ssh connections coming in at more than 5/sec from one host)
A simple check should be able to prevent that from happening to others.

Attached is a patch to add such a check; this is just how I'd add this
by looking at your code... I don't know if there is maybe a nicer way to
do this kind of sanity check. Feel free to do it entirely different. Or
maybe it's actually nicer to fix this issue within the kernel...

Note that this also is a deficiency in
nfsim-testsuite/01iptables/40ipt_recent.sh:
test #3 uses --rttl outside of the spec (i.e. together with --set), and
doesn't verify that a sixth packet by a different source would still
pass.
This might also explain the issues with Test #4?

The second thing I'd like to bring forward to you is a clarification
request WRT to the string match (maybe document it in the man page):
the "from" and "to" range - what is it on? is it within the packet? does
it include Packet headers? Is it on stream data?
I'd like to use the string match for blocking BitTorrent traffic, but in
order to minimize performance impact, I'd like to keep the search range
as low as possible, or maybe only scan the first few packets of a
connection (bypass via fragmentation isn't a big problem, this is just
about filtering people having bittorrent running on their laptop in
background by accident...)

best regards,
Erich Schubert
--=20
     erich@(vitavonni.de|debian.org)    --    GPG Key ID: 4B3A135C    (o_
  There is no branch of mathematics, however abstract, which may not  //\
 some day be applied to phenomena of the real world. --- Lobatchevsky V_/_
   Es ist nicht wenig Zeit, die wir haben, sondern es ist viel Zeit,
                   die wir nicht nutzen. --- Seneca

--=-eb+MPpejUcLz0KY5aERx
Content-Disposition: attachment; filename=iptables-recent-ensure-sane-rttl.diff
Content-Type: text/x-patch; name=iptables-recent-ensure-sane-rttl.diff;
	charset=ISO-8859-15
Content-Transfer-Encoding: base64

SW5kZXg6IGxpYmlwdF9yZWNlbnQuYw0KPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KLS0tIGxpYmlwdF9yZWNlbnQuYwko
UmV2aXNpb24gNjQ0NSkNCisrKyBsaWJpcHRfcmVjZW50LmMJKEFyYmVpdHNrb3BpZSkNCkBAIC0y
MSw2ICsyMSwxMiBAQA0KICNkZWZpbmUgSVBUX1JFQ0VOVF9OQU1FX0xFTgkyMDANCiAjZW5kaWYg
LyogSVBUX1JFQ0VOVF9OQU1FX0xFTiAqLw0KIA0KKyNpZm5kZWYgSVBUX1JFQ0VOVF9GTEFHU19B
Q1RJT04NCisjZGVmaW5lIElQVF9SRUNFTlRfRkxBR1NfQUNUSU9OIDENCisjZGVmaW5lIElQVF9S
RUNFTlRfRkxBR1NfSEFTX1JUVEwgMg0KKyNkZWZpbmUgSVBUX1JFQ0VOVF9GTEFHU19NQVlfUlRU
TCA0DQorI2VuZGlmIC8qIElQVF9SRUNFTlRfRkxBR1NfQUNUSU9ODQorDQogLyogT3B0aW9ucyBm
b3IgdGhpcyBtb2R1bGUgKi8NCiBzdGF0aWMgc3RydWN0IG9wdGlvbiBvcHRzW10gPSB7DQogCXsg
Lm5hbWUgPSAic2V0IiwgICAgICAuaGFzX2FyZyA9IDAsIC5mbGFnID0gMCwgLnZhbCA9IDIwMSB9
LCANCkBAIC05MSw0MyArOTcsNDcgQEANCiAJc3RydWN0IGlwdF9yZWNlbnRfaW5mbyAqaW5mbyA9
IChzdHJ1Y3QgaXB0X3JlY2VudF9pbmZvICopKCptYXRjaCktPmRhdGE7DQogCXN3aXRjaCAoYykg
ew0KIAkJY2FzZSAyMDE6DQotCQkJaWYgKCpmbGFncykgZXhpdF9lcnJvcihQQVJBTUVURVJfUFJP
QkxFTSwNCisJCQlpZiAoKmZsYWdzICYgSVBUX1JFQ0VOVF9GTEFHU19BQ1RJT04pDQorCQkJCWV4
aXRfZXJyb3IoUEFSQU1FVEVSX1BST0JMRU0sDQogCQkJCQkicmVjZW50OiBvbmx5IG9uZSBvZiBg
LS1zZXQnLCBgLS1yY2hlY2snICINCiAJCQkJCSJgLS11cGRhdGUnIG9yIGAtLXJlbW92ZScgbWF5
IGJlIHNldCIpOw0KIAkJCWNoZWNrX2ludmVyc2Uob3B0YXJnLCAmaW52ZXJ0LCAmb3B0aW5kLCAw
KTsNCiAJCQlpbmZvLT5jaGVja19zZXQgfD0gSVBUX1JFQ0VOVF9TRVQ7DQogCQkJaWYgKGludmVy
dCkgaW5mby0+aW52ZXJ0ID0gMTsNCi0JCQkqZmxhZ3MgPSAxOw0KKwkJCSpmbGFncyB8PSBJUFRf
UkVDRU5UX0ZMQUdTX0FDVElPTjsNCiAJCQlicmVhazsNCiAJCQkNCiAJCWNhc2UgMjAyOg0KLQkJ
CWlmICgqZmxhZ3MpIGV4aXRfZXJyb3IoUEFSQU1FVEVSX1BST0JMRU0sDQorCQkJaWYgKCpmbGFn
cyAmIElQVF9SRUNFTlRfRkxBR1NfQUNUSU9OKQ0KKwkJCQlleGl0X2Vycm9yKFBBUkFNRVRFUl9Q
Uk9CTEVNLA0KIAkJCQkJInJlY2VudDogb25seSBvbmUgb2YgYC0tc2V0JywgYC0tcmNoZWNrJyAi
DQogCQkJCQkiYC0tdXBkYXRlJyBvciBgLS1yZW1vdmUnIG1heSBiZSBzZXQiKTsNCiAJCQljaGVj
a19pbnZlcnNlKG9wdGFyZywgJmludmVydCwgJm9wdGluZCwgMCk7DQogCQkJaW5mby0+Y2hlY2tf
c2V0IHw9IElQVF9SRUNFTlRfQ0hFQ0s7DQogCQkJaWYoaW52ZXJ0KSBpbmZvLT5pbnZlcnQgPSAx
Ow0KLQkJCSpmbGFncyA9IDE7DQorCQkJKmZsYWdzIHw9IElQVF9SRUNFTlRfRkxBR1NfQUNUSU9O
IHwgSVBUX1JFQ0VOVF9GTEFHU19NQVlfUlRUTDsNCiAJCQlicmVhazsNCiANCiAJCWNhc2UgMjAz
Og0KLQkJCWlmICgqZmxhZ3MpIGV4aXRfZXJyb3IoUEFSQU1FVEVSX1BST0JMRU0sDQorCQkJaWYg
KCpmbGFncyAmIElQVF9SRUNFTlRfRkxBR1NfQUNUSU9OKQ0KKwkJCQlleGl0X2Vycm9yKFBBUkFN
RVRFUl9QUk9CTEVNLA0KIAkJCQkJInJlY2VudDogb25seSBvbmUgb2YgYC0tc2V0JywgYC0tcmNo
ZWNrJyAiDQogCQkJCQkiYC0tdXBkYXRlJyBvciBgLS1yZW1vdmUnIG1heSBiZSBzZXQiKTsNCiAJ
CQljaGVja19pbnZlcnNlKG9wdGFyZywgJmludmVydCwgJm9wdGluZCwgMCk7DQogCQkJaW5mby0+
Y2hlY2tfc2V0IHw9IElQVF9SRUNFTlRfVVBEQVRFOw0KIAkJCWlmIChpbnZlcnQpIGluZm8tPmlu
dmVydCA9IDE7DQotCQkJKmZsYWdzID0gMTsNCisJCQkqZmxhZ3MgfD0gSVBUX1JFQ0VOVF9GTEFH
U19BQ1RJT04gfCBJUFRfUkVDRU5UX0ZMQUdTX01BWV9SVFRMOw0KIAkJCWJyZWFrOw0KIA0KIAkJ
Y2FzZSAyMDY6DQotCQkJaWYgKCpmbGFncykgZXhpdF9lcnJvcihQQVJBTUVURVJfUFJPQkxFTSwN
CisJCQlpZiAoKmZsYWdzICYgSVBUX1JFQ0VOVF9GTEFHU19BQ1RJT04pDQorCQkJCWV4aXRfZXJy
b3IoUEFSQU1FVEVSX1BST0JMRU0sDQogCQkJCQkicmVjZW50OiBvbmx5IG9uZSBvZiBgLS1zZXQn
LCBgLS1yY2hlY2snICINCiAJCQkJCSJgLS11cGRhdGUnIG9yIGAtLXJlbW92ZScgbWF5IGJlIHNl
dCIpOw0KIAkJCWNoZWNrX2ludmVyc2Uob3B0YXJnLCAmaW52ZXJ0LCAmb3B0aW5kLCAwKTsNCiAJ
CQlpbmZvLT5jaGVja19zZXQgfD0gSVBUX1JFQ0VOVF9SRU1PVkU7DQogCQkJaWYgKGludmVydCkg
aW5mby0+aW52ZXJ0ID0gMTsNCi0JCQkqZmxhZ3MgPSAxOw0KKwkJCSpmbGFncyB8PSBJUFRfUkVD
RU5UX0ZMQUdTX0FDVElPTjsNCiAJCQlicmVhazsNCiANCiAJCWNhc2UgMjA0Og0KQEAgLTE0MCw2
ICsxNTAsNyBAQA0KIA0KIAkJY2FzZSAyMDc6DQogCQkJaW5mby0+Y2hlY2tfc2V0IHw9IElQVF9S
RUNFTlRfVFRMOw0KKwkJCSpmbGFncyB8PSBJUFRfUkVDRU5UX0ZMQUdTX0hBU19SVFRMOw0KIAkJ
CWJyZWFrOw0KIA0KIAkJY2FzZSAyMDg6DQpAQCAtMTY3LDEwICsxNzgsMTQgQEANCiBmaW5hbF9j
aGVjayh1bnNpZ25lZCBpbnQgZmxhZ3MpDQogew0KIA0KLQlpZiAoIWZsYWdzKQ0KKwlpZiAoIWZs
YWdzICYgSVBUX1JFQ0VOVF9GTEFHU19BQ1RJT04pDQogCQlleGl0X2Vycm9yKFBBUkFNRVRFUl9Q
Uk9CTEVNLA0KIAkJCSJyZWNlbnQ6IHlvdSBtdXN0IHNwZWNpZnkgb25lIG9mIGAtLXNldCcsIGAt
LXJjaGVjaycgIg0KIAkJCSJgLS11cGRhdGUnIG9yIGAtLXJlbW92ZSciKTsNCisJaWYgKChmbGFn
cyAmIElQVF9SRUNFTlRfRkxBR1NfSEFTX1JUVEwpICYmIChmbGFncyAmIElQVF9SRUNFTlRfRkxB
R1NfTUFZX1JUVEwgPT0gMCkpDQorCQlleGl0X2Vycm9yKFBBUkFNRVRFUl9QUk9CTEVNLA0KKwkJ
CSJyZWNlbnQ6IHlvdSBtYXkgb25seSB1c2UgYC0tcnR0bCcgd2l0aCBlaXRoZXIgYC0tcmNoZWNr
JyAiDQorCQkJIm9yIGAtLXVwZGF0ZSciKTsNCiB9DQogDQogLyogUHJpbnRzIG91dCB0aGUgbWF0
Y2hpbmZvLiAqLw0K


--=-eb+MPpejUcLz0KY5aERx--

--=-B7eJAlLqBF1tPfRpoShq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBD7+s+ntB470s6E1wRAk6hAJ43ruZu54RfPry9WfhSGJom9wv0pgCghWQR
Prqak6bFWG0t62ptxfMUMZ4=
=JRE6
-----END PGP SIGNATURE-----

--=-B7eJAlLqBF1tPfRpoShq--
