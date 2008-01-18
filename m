From: "=?ISO-8859-1?Q?Damien_Th=E9bault?=" <damien.thebault@gmail.com>
Subject: RTSP conntrack patch and different RTSP/UDP servers
Date: Fri, 18 Jan 2008 10:30:02 +0100
Message-ID: <9a4a382a0801180130r5b790398m189642ed941f2a3d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_4920_29979205.1200648602949"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:65431 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbYARJaE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Jan 2008 04:30:04 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1623043wah.23
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Jan 2008 01:30:03 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

------=_Part_4920_29979205.1200648602949
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

I was trying to use the RTSP conntrack patch from the netfilter's
patch-o-matic extra repository, and incoming stream packets were not
transferred from the "wan".
The previous kernel I tried was 2.6.17, and this was working. After
looking further, in my setup I have two servers with two different IP
addresses, one doing RTSP, and the other sending the stream.

I don't know why it was working on 2.6.17 (the source ip was defined
in exp->tuple like here in 2.6.23) , maybe conntrack is stricter now.

The IP address of the stream server is present in the "source"
parameter of the "Transport" header in the reply to the "SETUP"
request (this seems to be standard, see rfc2326 =A712.39).
Currently, we parse the SETUP request so we can't do "the right thing"
in this case because we don't have the information.

I hacked a small patch to allow any source IP address, it may be
useful to people with the same use case (this lowers security since
anyone is then able to send the stream) :

--- 2.6.23-ori/net/netfilter/nf_conntrack_rtsp.c=092007-11-27
16:49:30.000000000 +0100
+++ 2.6.23/net/netfilter/nf_conntrack_rtsp.c=092008-01-18 09:23:28.00000000=
0 +0100
@@ -61,6 +61,7 @@
 static int num_ports =3D 0;
 static int max_outstanding =3D 8;
 static unsigned int setup_timeout =3D 300;
+static int strict =3D 0;

 MODULE_AUTHOR("Tom Marshall <tmarshall at real.com>");
 MODULE_DESCRIPTION("RTSP connection tracking module");
@@ -71,6 +72,8 @@
 MODULE_PARM_DESC(max_outstanding, "max number of outstanding SETUP
requests per RTSP session");
 module_param(setup_timeout, int, 0400);
 MODULE_PARM_DESC(setup_timeout, "timeout on for unestablished data channel=
s");
+module_param(strict, int, 0400);
+MODULE_PARM_DESC(strict, "redirect the UDP stream only if the sender
is the RTSP server");

 static char *rtsp_buffer;
 static DEFINE_SPINLOCK(rtsp_buffer_lock);
@@ -330,7 +333,8 @@
 =09=09be_loport =3D htons(expinfo.loport);

 =09=09nf_ct_expect_init(exp, ct->tuplehash[!dir].tuple.src.l3num,
-=09=09=09&ct->tuplehash[!dir].tuple.src.u3, &ct->tuplehash[!dir].tuple.dst=
.u3,
+=09=09=09strict ? &ct->tuplehash[!dir].tuple.src.u3 : NULL,
+=09=09=09&ct->tuplehash[!dir].tuple.dst.u3,
 =09=09=09IPPROTO_UDP, NULL, &be_loport);

 =09=09exp->master =3D ct;

Reguards,
--=20
Damien Thebault

------=_Part_4920_29979205.1200648602949
Content-Type: text/x-patch; name=rtsp_strict.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fbkizk210
Content-Disposition: attachment; filename=rtsp_strict.patch

LS0tIDIuNi4yMy1vcmkvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfcnRzcC5jCTIwMDctMTEt
MjcgMTY6NDk6MzAuMDAwMDAwMDAwICswMTAwCisrKyAyLjYuMjMvbmV0L25ldGZpbHRlci9uZl9j
b25udHJhY2tfcnRzcC5jCTIwMDgtMDEtMTggMDk6MjM6MjguMDAwMDAwMDAwICswMTAwCkBAIC02
MSw2ICs2MSw3IEBACiBzdGF0aWMgaW50IG51bV9wb3J0cyA9IDA7CiBzdGF0aWMgaW50IG1heF9v
dXRzdGFuZGluZyA9IDg7CiBzdGF0aWMgdW5zaWduZWQgaW50IHNldHVwX3RpbWVvdXQgPSAzMDA7
CitzdGF0aWMgaW50IHN0cmljdCA9IDA7CiAKIE1PRFVMRV9BVVRIT1IoIlRvbSBNYXJzaGFsbCA8
dG1hcnNoYWxsIGF0IHJlYWwuY29tPiIpOwogTU9EVUxFX0RFU0NSSVBUSU9OKCJSVFNQIGNvbm5l
Y3Rpb24gdHJhY2tpbmcgbW9kdWxlIik7CkBAIC03MSw2ICs3Miw4IEBACiBNT0RVTEVfUEFSTV9E
RVNDKG1heF9vdXRzdGFuZGluZywgIm1heCBudW1iZXIgb2Ygb3V0c3RhbmRpbmcgU0VUVVAgcmVx
dWVzdHMgcGVyIFJUU1Agc2Vzc2lvbiIpOwogbW9kdWxlX3BhcmFtKHNldHVwX3RpbWVvdXQsIGlu
dCwgMDQwMCk7CiBNT0RVTEVfUEFSTV9ERVNDKHNldHVwX3RpbWVvdXQsICJ0aW1lb3V0IG9uIGZv
ciB1bmVzdGFibGlzaGVkIGRhdGEgY2hhbm5lbHMiKTsKK21vZHVsZV9wYXJhbShzdHJpY3QsIGlu
dCwgMDQwMCk7CitNT0RVTEVfUEFSTV9ERVNDKHN0cmljdCwgInJlZGlyZWN0IHRoZSBVRFAgc3Ry
ZWFtIG9ubHkgaWYgdGhlIHNlbmRlciBpcyB0aGUgUlRTUCBzZXJ2ZXIiKTsKIAogc3RhdGljIGNo
YXIgKnJ0c3BfYnVmZmVyOwogc3RhdGljIERFRklORV9TUElOTE9DSyhydHNwX2J1ZmZlcl9sb2Nr
KTsKQEAgLTMzMCw3ICszMzMsOCBAQAogCQliZV9sb3BvcnQgPSBodG9ucyhleHBpbmZvLmxvcG9y
dCk7CiAKIAkJbmZfY3RfZXhwZWN0X2luaXQoZXhwLCBjdC0+dHVwbGVoYXNoWyFkaXJdLnR1cGxl
LnNyYy5sM251bSwKLQkJCSZjdC0+dHVwbGVoYXNoWyFkaXJdLnR1cGxlLnNyYy51MywgJmN0LT50
dXBsZWhhc2hbIWRpcl0udHVwbGUuZHN0LnUzLAorCQkJc3RyaWN0ID8gJmN0LT50dXBsZWhhc2hb
IWRpcl0udHVwbGUuc3JjLnUzIDogTlVMTCwKKwkJCSZjdC0+dHVwbGVoYXNoWyFkaXJdLnR1cGxl
LmRzdC51MywKIAkJCUlQUFJPVE9fVURQLCBOVUxMLCAmYmVfbG9wb3J0KTsgCiAKIAkJZXhwLT5t
YXN0ZXIgPSBjdDsK
------=_Part_4920_29979205.1200648602949--
