From: Ivan Homoliak <xhomol11@gmail.com>
Subject: Fwd: [PATCH]: libnetfilter_log: Uninitialized values in libnetfilter_log.c
Date: Mon, 3 Feb 2014 10:54:23 +0100
Message-ID: <CA+J3vcLKCH-4sYWNsDZXdd10cee7VjV74wfa44hnjXQ-TPtGWw@mail.gmail.com>
References: <CA+J3vc+YmPjtr2sJqR39cQSLOO+xmVK=RLChSRgv_+LN2tuRsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b2e09d121f35504f17d82c8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:48360 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaBCJyX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Feb 2014 04:54:23 -0500
Received: by mail-pd0-f177.google.com with SMTP id x10so6593873pdj.8
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Feb 2014 01:54:23 -0800 (PST)
In-Reply-To: <CA+J3vc+YmPjtr2sJqR39cQSLOO+xmVK=RLChSRgv_+LN2tuRsQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--047d7b2e09d121f35504f17d82c8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Uninitialized values in libnetfilter.log.c which were discovered by
valgrind and ulogd.

Signed-off-by: Ivan Homoliak <xhomol11@gmail.com>
---

Valgrinds output:

=3D=3D13821=3D=3D Syscall param socketcall.sendto(msg) points to uninitiali=
sed byte(s)
=3D=3D13821=3D=3D    at 0x3E93AF6E83: __sendto_nocancel (in /usr/lib64/libc=
-2.17.so)
=3D=3D13821=3D=3D    by 0x5433E81: nfnl_send (libnfnetlink.c:391)
=3D=3D13821=3D=3D    by 0x5435C0E: nfnl_query (libnfnetlink.c:1569)
=3D=3D13821=3D=3D    by 0x522E4E6: __build_send_cfg_msg (libnetfilter_log.c=
:143)
=3D=3D13821=3D=3D    by 0x522E87E: nflog_bind_group (libnetfilter_log.c:413=
)
=3D=3D13821=3D=3D    by 0x5029F3B: start (ulogd_inppkt_NFLOG.c:573)
=3D=3D13821=3D=3D    by 0x403E5D: create_stack_start_instances (ulogd.c:918=
)
=3D=3D13821=3D=3D    by 0x4041B4: create_stack (ulogd.c:1010)
=3D=3D13821=3D=3D    by 0x4078D6: config_parse_file (conffile.c:225)
=3D=3D13821=3D=3D    by 0x404411: parse_conffile (ulogd.c:1088)
=3D=3D13821=3D=3D    by 0x405478: main (ulogd.c:1573)
=3D=3D13821=3D=3D  Address 0x7feffff69 is on thread 1's stack
=3D=3D13821=3D=3D  Uninitialised value was created by a stack allocation
=3D=3D13821=3D=3D    at 0x522E45B: __build_send_cfg_msg (libnetfilter_log.c=
:129)
=3D=3D13821=3D=3D
=3D=3D13821=3D=3D Syscall param socketcall.sendto(msg) points to uninitiali=
sed byte(s)
=3D=3D13821=3D=3D    at 0x3E93AF6E83: __sendto_nocancel (in /usr/lib64/libc=
-2.17.so)
=3D=3D13821=3D=3D    by 0x5433E81: nfnl_send (libnfnetlink.c:391)
=3D=3D13821=3D=3D    by 0x5435C0E: nfnl_query (libnfnetlink.c:1569)
=3D=3D13821=3D=3D    by 0x522E9A0: nflog_set_mode (libnetfilter_log.c:481)
=3D=3D13821=3D=3D    by 0x5029FA2: start (ulogd_inppkt_NFLOG.c:581)
=3D=3D13821=3D=3D    by 0x403E5D: create_stack_start_instances (ulogd.c:918=
)
=3D=3D13821=3D=3D    by 0x4041B4: create_stack (ulogd.c:1010)
=3D=3D13821=3D=3D    by 0x4078D6: config_parse_file (conffile.c:225)
=3D=3D13821=3D=3D    by 0x404411: parse_conffile (ulogd.c:1088)
=3D=3D13821=3D=3D    by 0x405478: main (ulogd.c:1573)
=3D=3D13821=3D=3D  Address 0x7feffff9d is on thread 1's stack
=3D=3D13821=3D=3D  Uninitialised value was created by a stack allocation
=3D=3D13821=3D=3D    at 0x50293D0: ??? (in /usr/lib/ulogd/ulogd_inppkt_NFLO=
G.so)


Version: libnetfilter_log-1.0.1
File: libnetfilter_log.c
GCC: 4.8.2 20131212 (Red Hat 4.8.2-7)
OS: Fedora release 19 (Schr=F6dinger's Cat)
Kernel: 3.12.5-200.fc19.x86_64

--047d7b2e09d121f35504f17d82c8
Content-Type: text/x-patch; charset=US-ASCII; name="libnetfilter_log.patch"
Content-Disposition: attachment; filename="libnetfilter_log.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hr7jt5on0

LS0tIGEvc3JjL2xpYm5ldGZpbHRlcl9sb2cuYwkyMDEwLTExLTA0IDAwOjE5OjQ1LjAwMDAwMDAw
MCArMDEwMA0KKysrIGIvc3JjL2xpYm5ldGZpbHRlcl9sb2cuYwkyMDE0LTAxLTAzIDEwOjQ4OjM0
LjU5Mjc4MzM4OCArMDEwMA0KQEAgLTEzMyw2ICsxMzMsOCBAQCBfX2J1aWxkX3NlbmRfY2ZnX21z
ZyhzdHJ1Y3QgbmZsb2dfaGFuZGxlDQogCQlzdHJ1Y3Qgbmxtc2doZHIgbm1oOw0KIAl9IHU7DQog
CXN0cnVjdCBuZnVsbmxfbXNnX2NvbmZpZ19jbWQgY21kOw0KKw0KKwltZW1zZXQoJnUsIDAsIHNp
emVvZih1KSk7DQogDQogCW5mbmxfZmlsbF9oZHIoaC0+bmZubHNzaCwgJnUubm1oLCAwLCBwZiwg
Z3JvdXBudW0sDQogCQkgICAgICBORlVMTkxfTVNHX0NPTkZJRywgTkxNX0ZfUkVRVUVTVHxOTE1f
Rl9BQ0spOw0KQEAgLTQ2OSwxMiArNDcxLDE0IEBAIGludCBuZmxvZ19zZXRfbW9kZShzdHJ1Y3Qg
bmZsb2dfZ19oYW5kbGUNCiAJCXN0cnVjdCBubG1zZ2hkciBubWg7DQogCX0gdTsNCiAJc3RydWN0
IG5mdWxubF9tc2dfY29uZmlnX21vZGUgcGFyYW1zOw0KLQ0KKwltZW1zZXQoJnUsIDAsIHNpemVv
Zih1KSk7DQorDQogCW5mbmxfZmlsbF9oZHIoZ2gtPmgtPm5mbmxzc2gsICZ1Lm5taCwgMCwgQUZf
VU5TUEVDLCBnaC0+aWQsDQogCQkgICAgICBORlVMTkxfTVNHX0NPTkZJRywgTkxNX0ZfUkVRVUVT
VHxOTE1fRl9BQ0spOw0KIA0KIAlwYXJhbXMuY29weV9yYW5nZSA9IGh0b25sKHJhbmdlKTsJLyog
Y29weV9yYW5nZSBpcyBzaG9ydCAqLw0KIAlwYXJhbXMuY29weV9tb2RlID0gbW9kZTsNCisJcGFy
YW1zLl9wYWQgPSAodV9pbnQ4X3QpIDA7DQogCW5mbmxfYWRkYXR0cl9sKCZ1Lm5taCwgc2l6ZW9m
KHUpLCBORlVMQV9DRkdfTU9ERSwgJnBhcmFtcywNCiAJCSAgICAgICBzaXplb2YocGFyYW1zKSk7
DQogDQpAQCAtNTAwLDYgKzUwNCw4IEBAIGludCBuZmxvZ19zZXRfdGltZW91dChzdHJ1Y3QgbmZs
b2dfZ19oYW4NCiAJCXN0cnVjdCBubG1zZ2hkciBubWg7DQogCX0gdTsNCiANCisJbWVtc2V0KCZ1
LCAwLCBzaXplb2YodSkpOw0KKw0KIAluZm5sX2ZpbGxfaGRyKGdoLT5oLT5uZm5sc3NoLCAmdS5u
bWgsIDAsIEFGX1VOU1BFQywgZ2gtPmlkLA0KIAkJICAgICAgTkZVTE5MX01TR19DT05GSUcsIE5M
TV9GX1JFUVVFU1R8TkxNX0ZfQUNLKTsNCiANCkBAIC01MjUsNiArNTMxLDggQEAgaW50IG5mbG9n
X3NldF9xdGhyZXNoKHN0cnVjdCBuZmxvZ19nX2hhbg0KIAkJc3RydWN0IG5sbXNnaGRyIG5taDsN
CiAJfSB1Ow0KIA0KKwltZW1zZXQoJnUsIDAsIHNpemVvZih1KSk7DQorDQogCW5mbmxfZmlsbF9o
ZHIoZ2gtPmgtPm5mbmxzc2gsICZ1Lm5taCwgMCwgQUZfVU5TUEVDLCBnaC0+aWQsDQogCQkgICAg
ICBORlVMTkxfTVNHX0NPTkZJRywgTkxNX0ZfUkVRVUVTVHxOTE1fRl9BQ0spOw0KIA0KQEAgLTU1
Myw4ICs1NjEsMTAgQEAgaW50IG5mbG9nX3NldF9ubGJ1ZnNpeihzdHJ1Y3QgbmZsb2dfZ19oYQ0K
IAkJY2hhciBidWZbTkZOTF9IRUFERVJfTEVOK05GQV9MRU5HVEgoc2l6ZW9mKHVfaW50MzJfdCkp
XTsNCiAJCXN0cnVjdCBubG1zZ2hkciBubWg7DQogCX0gdTsNCi0JaW50IHN0YXR1czsNCisJaW50
IHN0YXR1cyA9IDA7DQogDQorCW1lbXNldCgmdSwgMCwgc2l6ZW9mKHUpKTsNCisNCiAJbmZubF9m
aWxsX2hkcihnaC0+aC0+bmZubHNzaCwgJnUubm1oLCAwLCBBRl9VTlNQRUMsIGdoLT5pZCwNCiAJ
CSAgICAgIE5GVUxOTF9NU0dfQ09ORklHLCBOTE1fRl9SRVFVRVNUfE5MTV9GX0FDSyk7DQogDQpA
QCAtNTg4LDYgKzU5OCw4IEBAIGludCBuZmxvZ19zZXRfZmxhZ3Moc3RydWN0IG5mbG9nX2dfaGFu
ZGwNCiAJCXN0cnVjdCBubG1zZ2hkciBubWg7DQogCX0gdTsNCiANCisJbWVtc2V0KCZ1LCAwLCBz
aXplb2YodSkpOw0KKw0KIAluZm5sX2ZpbGxfaGRyKGdoLT5oLT5uZm5sc3NoLCAmdS5ubWgsIDAs
IEFGX1VOU1BFQywgZ2gtPmlkLA0KIAkJICAgICAgTkZVTE5MX01TR19DT05GSUcsIE5MTV9GX1JF
UVVFU1R8TkxNX0ZfQUNLKTsNCiANCg==
--047d7b2e09d121f35504f17d82c8--
