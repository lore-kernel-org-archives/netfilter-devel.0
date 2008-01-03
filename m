From: Eric Leblond <eric@inl.fr>
Subject: Ulogd2: ulogd2 warn when exiting on error
Date: Thu, 03 Jan 2008 14:25:29 +0100
Message-ID: <1199366729.11916.6.camel@khasse.inl.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2W4yzEwQ7KpfMjxI7ylf"
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:51472 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533AbYACNZb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:25:31 -0500
Received: from khasse.inl.fr ([192.168.33.139])
	by fydelkass.inl.fr with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <eric@inl.fr>)
	id 1JAQ4f-000509-QY
	for netfilter-devel@vger.kernel.org; Thu, 03 Jan 2008 14:25:29 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-2W4yzEwQ7KpfMjxI7ylf
Content-Type: multipart/mixed; boundary="=-kohAzbAjk3deAP8XfcKk"


--=-kohAzbAjk3deAP8XfcKk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

This patch adds a warning message to ulogd2 when it exits on error. It
simply tell to look at the configuration file.

BR,
--=20
=C3=89ric Leblond, eleblond@inl.fr
T=C3=A9l=C3=A9phone : 01 44 89 46 40, Fax : 01 44 89 45 01
INL, http://www.inl.fr

--=-kohAzbAjk3deAP8XfcKk
Content-Disposition: attachment; filename=ulogd2-warn-when-exit.diff
Content-Type: text/x-patch; name=ulogd2-warn-when-exit.diff; charset=UTF-8
Content-Transfer-Encoding: base64

PT09IHNyYy91bG9nZC5jDQo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT0NCi0tLSBzcmMvdWxvZ2QuYwkocmV2aXNpb24gNDg4
MCkNCisrKyBzcmMvdWxvZ2QuYwkocmV2aXNpb24gNDg4MSkNCkBAIC0zMTUsNiArMzE1LDEzIEBA
DQogCX0NCiB9DQogDQorc3RhdGljIHZvaWQgd2Fybl9hbmRfZXhpdChpbnQgZGFlbW9uaXplKQ0K
K3sNCisJaWYgKCFkYWVtb25pemUpDQorCQlmcHJpbnRmKHN0ZGVyciwgIkZhdGFsIGVycm9yLCBj
aGVjayBsb2dmaWxlLlxuIik7DQorCWV4aXQoMSk7DQorfQ0KKw0KIC8qIGNsZWFuIHJlc3VsdHMg
KHNldCBhbGwgdmFsdWVzIHRvIDAgYW5kIGZyZWUgcG9pbnRlcnMpICovDQogc3RhdGljIHZvaWQg
dWxvZ2RfY2xlYW5fcmVzdWx0cyhzdHJ1Y3QgdWxvZ2RfcGx1Z2luc3RhbmNlICpwaSkNCiB7DQpA
QCAtOTE0LDQ0ICs5MjEsNDQgQEANCiAJaWYgKGNvbmZpZ19yZWdpc3Rlcl9maWxlKHVsb2dkX2Nv
bmZpZ2ZpbGUpKSB7DQogCQl1bG9nZF9sb2coVUxPR0RfRkFUQUwsICJlcnJvciByZWdpc3Rlcmlu
ZyBjb25maWdmaWxlIFwiJXNcIlxuIiwNCiAJCQkgIHVsb2dkX2NvbmZpZ2ZpbGUpOw0KLQkJZXhp
dCgxKTsNCisJCXdhcm5fYW5kX2V4aXQoZGFlbW9uaXplKTsNCiAJfQ0KIAkNCiAJLyogcGFyc2Ug
Y29uZmlnIGZpbGUgKi8NCiAJaWYgKHBhcnNlX2NvbmZmaWxlKCJnbG9iYWwiLCAmdWxvZ2Rfa3Nl
dCkpIHsNCiAJCXVsb2dkX2xvZyhVTE9HRF9GQVRBTCwgInBhcnNlX2NvbmZmaWxlXG4iKTsNCi0J
CWV4aXQoMSk7DQorCQl3YXJuX2FuZF9leGl0KGRhZW1vbml6ZSk7DQogCX0NCiANCiAJaWYgKGxs
aXN0X2VtcHR5KCZ1bG9nZF9waV9zdGFja3MpKSB7DQogCQl1bG9nZF9sb2coVUxPR0RfRkFUQUws
IA0KIAkJCSAgIm5vdCBldmVuIGEgc2luZ2xlIHdvcmtpbmcgcGx1Z2luIHN0YWNrXG4iKTsNCi0J
CWV4aXQoMSk7DQorCQl3YXJuX2FuZF9leGl0KGRhZW1vbml6ZSk7DQogCX0NCiANCiAJaWYgKGNo
YW5nZV91aWQpIHsNCiAJCXVsb2dkX2xvZyhVTE9HRF9OT1RJQ0UsICJDaGFuZ2luZyBVSUQgLyBH
SURcbiIpOw0KIAkJaWYgKHNldGdpZChnaWQpKSB7DQogCQkJdWxvZ2RfbG9nKFVMT0dEX0ZBVEFM
LCAiY2FuJ3Qgc2V0IEdJRCAldVxuIiwgZ2lkKTsNCi0JCQlleGl0KDEpOw0KKwkJCXdhcm5fYW5k
X2V4aXQoZGFlbW9uaXplKTsNCiAJCX0NCiAJCWlmIChzZXRlZ2lkKGdpZCkpIHsNCiAJCQl1bG9n
ZF9sb2coVUxPR0RfRkFUQUwsICJjYW4ndCBzZXQgZWZmZWN0aXZlIEdJRCAldVxuIiwNCiAJCQkJ
ICBnaWQpOw0KLQkJCWV4aXQoMSk7DQorCQkJd2Fybl9hbmRfZXhpdChkYWVtb25pemUpOw0KIAkJ
fQ0KIAkJaWYgKGluaXRncm91cHModXNlciwgZ2lkKSkgew0KIAkJCXVsb2dkX2xvZyhVTE9HRF9G
QVRBTCwgImNhbid0IHNldCB1c2VyIHNlY29uZGFyeSBHSURcbiIpOw0KLQkJCWV4aXQoMSk7DQor
CQkJd2Fybl9hbmRfZXhpdChkYWVtb25pemUpOw0KIAkJfQ0KIAkJaWYgKHNldHVpZCh1aWQpKSB7
DQogCQkJdWxvZ2RfbG9nKFVMT0dEX0ZBVEFMLCAiY2FuJ3Qgc2V0IFVJRCAldVxuIiwgdWlkKTsN
Ci0JCQlleGl0KDEpOw0KKwkJCXdhcm5fYW5kX2V4aXQoZGFlbW9uaXplKTsNCiAJCX0NCiAJCWlm
IChzZXRldWlkKHVpZCkpIHsNCiAJCQl1bG9nZF9sb2coVUxPR0RfRkFUQUwsICJjYW4ndCBzZXQg
ZWZmZWN0aXZlIFVJRCAldVxuIiwNCiAJCQkJICB1aWQpOw0KLQkJCWV4aXQoMSk7DQorCQkJd2Fy
bl9hbmRfZXhpdChkYWVtb25pemUpOw0KIAkJfQ0KIAl9DQogDQo=


--=-kohAzbAjk3deAP8XfcKk--

--=-2W4yzEwQ7KpfMjxI7ylf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHfOJJnxA7CdMWjzIRArt+AJ9pqN0e+XIShd2RbStQdp0y15ckOwCdFktz
TW47f2UUlOKUmBj+9nnXINk=
=ZIIo
-----END PGP SIGNATURE-----

--=-2W4yzEwQ7KpfMjxI7ylf--

