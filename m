From: Eric Leblond <eric@inl.fr>
Subject: libnetfilter_queue hang when flooding
Date: Sat, 29 Jul 2006 14:10:07 +0200
Message-ID: <1154175007.8178.28.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-zQGLqTlb2BzPwy0JMnfL"
Cc: victor@inl.fr, Vincent Deffontaines <vincent@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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


--=-zQGLqTlb2BzPwy0JMnfL
Content-Type: multipart/mixed; boundary="=-JWXLE2n+FsCYu+Oiksm+"


--=-JWXLE2n+FsCYu+Oiksm+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I've proceed to some stress test of libnetfilter_queue using hping3.

./hping3 -p 5000  --flood localhost


The main issue is that the recv buffer of the netlink socket gets full.
We've got error 105 during recv.
unbinding from queue 0

I provide a patch to print error and avoid printf to be able to test
performance of libnetfilter_queue.

The problem is that when socket is full we disconnect and try to close
the queue :
	got error 105 during recv.
	unbinding from queue 0
It hangs here. gdb shows that we hang in recvmsg.

Here's the backtrace :

#0  0x00002aaaaad98762 in recvmsg () from /lib/libc.so.6
#1  0x00002aaaaaf0aa36 in nfnl_talk (nfnlh=3D0x502010, n=3D<value optimized
out>,=20
    peer=3D<value optimized out>, groups=3D<value optimized out>,
answer=3D0x0, junk=3D0, jarg=3D0x0)
    at libnfnetlink.c:552
#2  0x00002aaaaabc2dff in __build_send_cfg_msg (h=3D0x5021e0, command=3D2
'\002',=20
    queuenum=3D<value optimized out>, pf=3D0) at libnetfilter_queue.c:112
#3  0x00002aaaaabc312d in nfq_destroy_queue (qh=3D0x502250) at
libnetfilter_queue.c:258
#4  0x0000000000401028 in main ()

In fact, the control message can not be received as the receive buffer
of the socket is full.

I did not find any workaround except brutal cancellation? Any idea are
welcome.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-JWXLE2n+FsCYu+Oiksm+
Content-Disposition: attachment; filename=nfqnl_test.diff
Content-Type: text/x-patch; name=nfqnl_test.diff; charset=ISO-8859-15
Content-Transfer-Encoding: base64

SW5kZXg6IHV0aWxzL25mcW5sX3Rlc3QuYw0KPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KLS0tIHV0aWxzL25mcW5sX3Rl
c3QuYwkocmV2aXNpb24gNjY1MikNCisrKyB1dGlscy9uZnFubF90ZXN0LmMJKHdvcmtpbmcgY29w
eSkNCkBAIC0yLDExICsyLDE0IEBADQogI2luY2x1ZGUgPHN0ZGlvLmg+DQogI2luY2x1ZGUgPHN0
ZGxpYi5oPg0KICNpbmNsdWRlIDx1bmlzdGQuaD4NCisjaW5jbHVkZSA8ZXJybm8uaD4NCiAjaW5j
bHVkZSA8bmV0aW5ldC9pbi5oPg0KICNpbmNsdWRlIDxsaW51eC9uZXRmaWx0ZXIuaD4JCS8qIGZv
ciBORl9BQ0NFUFQgKi8NCiANCiAjaW5jbHVkZSA8bGlibmV0ZmlsdGVyX3F1ZXVlL2xpYm5ldGZp
bHRlcl9xdWV1ZS5oPg0KIA0KKyNkZWZpbmUgUFJJTlRfSU5GT1MgDQorDQogLyogcmV0dXJucyBw
YWNrZXQgaWQgKi8NCiBzdGF0aWMgdV9pbnQzMl90IHByaW50X3BrdCAoc3RydWN0IG5mcV9kYXRh
ICp0YikNCiB7DQpAQCAtMTYsMTMgKzE5LDE3IEBADQogCWludCByZXQ7DQogCWNoYXIgKmRhdGE7
DQogCQ0KKyAgICBpZCA9IG50b2hsKHBoLT5wYWNrZXRfaWQpOw0KIAlwaCA9IG5mcV9nZXRfbXNn
X3BhY2tldF9oZHIodGIpOw0KIAlpZiAocGgpew0KIAkJaWQgPSBudG9obChwaC0+cGFja2V0X2lk
KTsNCisjaWZkZWYgUFJJTlRfSU5GT1MNCiAJCXByaW50ZigiaHdfcHJvdG9jb2w9MHglMDR4IGhv
b2s9JXUgaWQ9JXUgIiwNCiAJCQludG9ocyhwaC0+aHdfcHJvdG9jb2wpLCBwaC0+aG9vaywgaWQp
Ow0KKyNlbmRpZg0KIAl9DQogCQ0KKyNpZmRlZiBQUklOVF9JTkZPUw0KIAltYXJrID0gbmZxX2dl
dF9uZm1hcmsodGIpOw0KIAlpZiAobWFyaykNCiAJCXByaW50ZigibWFyaz0ldSAiLCBtYXJrKTsN
CkBAIC00MCw3ICs0Nyw3IEBADQogCQlwcmludGYoInBheWxvYWRfbGVuPSVkICIsIHJldCk7DQog
DQogCWZwdXRjKCdcbicsIHN0ZG91dCk7DQotDQorI2VuZGlmDQogCXJldHVybiBpZDsNCiB9DQog
CQ0KQEAgLTQ5LDcgKzU2LDkgQEANCiAJICAgICAgc3RydWN0IG5mcV9kYXRhICpuZmEsIHZvaWQg
KmRhdGEpDQogew0KIAl1X2ludDMyX3QgaWQgPSBwcmludF9wa3QobmZhKTsNCisjaWZkZWYgUFJJ
TlRfSU5GT1MNCiAJcHJpbnRmKCJlbnRlcmluZyBjYWxsYmFja1xuIik7DQorI2VuZGlmDQogCXJl
dHVybiBuZnFfc2V0X3ZlcmRpY3QocWgsIGlkLCBORl9BQ0NFUFQsIDAsIE5VTEwpOw0KIH0NCiAN
CkBAIC05NiwxMiArMTA1LDE3IEBADQogDQogCW5oID0gbmZxX25mbmxoKGgpOw0KIAlmZCA9IG5m
bmxfZmQobmgpOw0KLQ0KIAl3aGlsZSAoKHJ2ID0gcmVjdihmZCwgYnVmLCBzaXplb2YoYnVmKSwg
MCkpICYmIHJ2ID49IDApIHsNCisjaWZkZWYgUFJJTlRfSU5GT1MNCiAJCXByaW50ZigicGt0IHJl
Y2VpdmVkXG4iKTsNCisjZW5kaWYNCiAJCW5mcV9oYW5kbGVfcGFja2V0KGgsIGJ1ZiwgcnYpOw0K
IAl9DQogDQorICAgIGlmIChydjwwKXsNCisgICAgICAgIHByaW50ZigiZ290IGVycm9yICVkIGR1
cmluZyByZWN2XG4iLGVycm5vKTsNCisgICAgfQ0KKw0KIAlwcmludGYoInVuYmluZGluZyBmcm9t
IHF1ZXVlIDBcbiIpOw0KIAluZnFfZGVzdHJveV9xdWV1ZShxaCk7DQogDQo=


--=-JWXLE2n+FsCYu+Oiksm+--

--=-zQGLqTlb2BzPwy0JMnfL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQBEy1AfnxA7CdMWjzIRAoLnAKCONcF9sOH7S4JENmFN9Ito2AuZ+ACfZSYK
VMx/sEPCJFgucNGcm2rHh3Y=
=jLn5
-----END PGP SIGNATURE-----

--=-zQGLqTlb2BzPwy0JMnfL--
