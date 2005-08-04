From: Eric Leblond <eric@inl.fr>
Subject: [PATCH] iptables NFQUEUE target
Date: Thu, 04 Aug 2005 22:11:06 +0200
Message-ID: <1123186266.8822.3.camel@porky>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-HjN6k4QDcYBuMCh68yVQ"
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


--=-HjN6k4QDcYBuMCh68yVQ
Content-Type: multipart/mixed; boundary="=-QjtzoujgctQDFFEgUaN8"


--=-QjtzoujgctQDFFEgUaN8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

This patch contains a trivial bugfix : --queue-num can now really be
used with NFQUEUE target.
I've also updated the man page.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-QjtzoujgctQDFFEgUaN8
Content-Disposition: attachment; filename=iptables-NFQUEUE.diff
Content-Type: text/x-patch; name=iptables-NFQUEUE.diff; charset=ISO-8859-15
Content-Transfer-Encoding: base64

SW5kZXg6IGV4dGVuc2lvbnMvbGliaXB0X05GUVVFVUUuYw0KPT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KLS0tIGV4dGVu
c2lvbnMvbGliaXB0X05GUVVFVUUuYwkocmV2aXNpb24gNDIxMCkNCisrKyBleHRlbnNpb25zL2xp
YmlwdF9ORlFVRVVFLmMJKHdvcmtpbmcgY29weSkNCkBAIC01OSw2ICs1OSw3IEBADQogCQkJZXhp
dF9lcnJvcihQQVJBTUVURVJfUFJPQkxFTSwgIk5GUVVFVUUgdGFyZ2V0OiAiDQogCQkJCSAgICJP
bmx5IHVzZSAtLXF1ZXVlLW51bSBPTkNFISIpOw0KIAkJcGFyc2VfbnVtKG9wdGFyZywgdGluZm8p
Ow0KKwkJYnJlYWs7DQogCWRlZmF1bHQ6DQogCQlyZXR1cm4gMDsNCiAJfQ0KSW5kZXg6IGV4dGVu
c2lvbnMvbGliaXB0X05GUVVFVUUubWFuDQo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQotLS0gZXh0ZW5zaW9ucy9saWJp
cHRfTkZRVUVVRS5tYW4JKHJldmlzaW9uIDQyMTApDQorKysgZXh0ZW5zaW9ucy9saWJpcHRfTkZR
VUVVRS5tYW4JKHdvcmtpbmcgY29weSkNCkBAIC0xLDcgKzEsMTAgQEANCiBUaGlzIHRhcmdldCBp
cyBhbiBleHRlbnNpb24gb2YgdGhlIFFVRVVFIHRhcmdldC4gQXMgb3Bwb3NlZCB0byBRVUVVRSwg
aXQgYWxsb3dzDQogeW91IHRvIHB1dCBhIHBhY2tldCBpbnRvIGFueSBzcGVjaWZpYyBxdWV1ZSwg
aWRlbnRpZmllZCBieSBpdHMgMTYtYml0IHF1ZXVlDQotbnVtYmVyLiAgDQorbnVtYmVyLiAgSXQg
dGFrZXMgb25lIG9wdGlvbjoNCiAuVFANCisuQlIgIi0tcXVldWUtbnVtICIgIlxmSXZhbHVlIg0K
K1RoaXMgc3BlY2lmaWVzIHRoZSBRVUVVRSBudW1iZXIgdG8gdXNlLiBWYWxpZCBxdWV1ZSBudW1i
ZXJzIGFyZSAwLTY1NTM1LiANCisuVFANCiBJdCBjYW4gb25seSBiZSB1c2VkIHdpdGggS2VybmVs
IHZlcnNpb25zIDIuNi4xNCBvciBsYXRlciwgc2luY2UgaXQgcmVxdWlyZXMNCiB0aGUNCiAuQg0K



--=-QjtzoujgctQDFFEgUaN8--

--=-HjN6k4QDcYBuMCh68yVQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBC8nZanxA7CdMWjzIRAhK2AJ94KV1rruR7tZyF/C9LvDDkyNkBSQCbBXlm
6zvVuUg6paU4AfK6HRSQr/Y=
=f4k7
-----END PGP SIGNATURE-----

--=-HjN6k4QDcYBuMCh68yVQ--
