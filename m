From: Ivan Homoliak <xhomol11@gmail.com>
Subject: [PATCH]: libnetfilter_log: Uninitialized values in libnetfilter_log.c
Date: Fri, 31 Jan 2014 11:39:09 +0100
Message-ID: <CA+J3vc+YmPjtr2sJqR39cQSLOO+xmVK=RLChSRgv_+LN2tuRsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7bd6b828bfedbe04f141c8e8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:64089 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932256AbaAaKjL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 31 Jan 2014 05:39:11 -0500
Received: by mail-pa0-f52.google.com with SMTP id bj1so4284284pad.39
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jan 2014 02:39:10 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--047d7bd6b828bfedbe04f141c8e8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Unitialized values in libnetfilter.log.c which were discovered by
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

--047d7bd6b828bfedbe04f141c8e8
Content-Type: text/x-patch; charset=US-ASCII; name="libnetfilter_log.c.patch"
Content-Disposition: attachment; filename="libnetfilter_log.c.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hr3bjhza0

LS0tIC4vc3JjL2xpYm5ldGZpbHRlcl9sb2cuYwkyMDEwLTExLTA0IDAwOjE5OjQ1LjAwMDAwMDAw
MCArMDEwMAorKysgLi4vLi4vbGlibmV0ZmlsdGVyX2xvZy0xLjAuMS9zcmMvbGlibmV0ZmlsdGVy
X2xvZy5jCTIwMTQtMDEtMDMgMTA6NDg6MzQuNTkyNzgzMzg4ICswMTAwCkBAIC0xMzMsNiArMTMz
LDggQEAgX19idWlsZF9zZW5kX2NmZ19tc2coc3RydWN0IG5mbG9nX2hhbmRsZQogCQlzdHJ1Y3Qg
bmxtc2doZHIgbm1oOwogCX0gdTsKIAlzdHJ1Y3QgbmZ1bG5sX21zZ19jb25maWdfY21kIGNtZDsK
KyAgICAgICAgCisgICAgICAgIG1lbXNldCgmdSwgMCwgc2l6ZW9mKHUpKTsgLy9paG9tb2xpYWsJ
ICAgICAgICAKIAogCW5mbmxfZmlsbF9oZHIoaC0+bmZubHNzaCwgJnUubm1oLCAwLCBwZiwgZ3Jv
dXBudW0sCiAJCSAgICAgIE5GVUxOTF9NU0dfQ09ORklHLCBOTE1fRl9SRVFVRVNUfE5MTV9GX0FD
Syk7CkBAIC00NjksMTIgKzQ3MSwxNCBAQCBpbnQgbmZsb2dfc2V0X21vZGUoc3RydWN0IG5mbG9n
X2dfaGFuZGxlCiAJCXN0cnVjdCBubG1zZ2hkciBubWg7CiAJfSB1OwogCXN0cnVjdCBuZnVsbmxf
bXNnX2NvbmZpZ19tb2RlIHBhcmFtczsKLQorICAgICAgICBtZW1zZXQoJnUsIDAsIHNpemVvZih1
KSk7IC8vaWhvbW9saWFrCQorICAgICAgICAKIAluZm5sX2ZpbGxfaGRyKGdoLT5oLT5uZm5sc3No
LCAmdS5ubWgsIDAsIEFGX1VOU1BFQywgZ2gtPmlkLAogCQkgICAgICBORlVMTkxfTVNHX0NPTkZJ
RywgTkxNX0ZfUkVRVUVTVHxOTE1fRl9BQ0spOwogCiAJcGFyYW1zLmNvcHlfcmFuZ2UgPSBodG9u
bChyYW5nZSk7CS8qIGNvcHlfcmFuZ2UgaXMgc2hvcnQgKi8KIAlwYXJhbXMuY29weV9tb2RlID0g
bW9kZTsKKyAgICAgICAgcGFyYW1zLl9wYWQgPSAodV9pbnQ4X3QpIDA7CiAJbmZubF9hZGRhdHRy
X2woJnUubm1oLCBzaXplb2YodSksIE5GVUxBX0NGR19NT0RFLCAmcGFyYW1zLAogCQkgICAgICAg
c2l6ZW9mKHBhcmFtcykpOwogCkBAIC01MDAsNiArNTA0LDggQEAgaW50IG5mbG9nX3NldF90aW1l
b3V0KHN0cnVjdCBuZmxvZ19nX2hhbgogCQlzdHJ1Y3Qgbmxtc2doZHIgbm1oOwogCX0gdTsKIAor
ICAgICAgICBtZW1zZXQoJnUsIDAsIHNpemVvZih1KSk7IC8vaWhvbW9saWFrCQorICAgICAgICAK
IAluZm5sX2ZpbGxfaGRyKGdoLT5oLT5uZm5sc3NoLCAmdS5ubWgsIDAsIEFGX1VOU1BFQywgZ2gt
PmlkLAogCQkgICAgICBORlVMTkxfTVNHX0NPTkZJRywgTkxNX0ZfUkVRVUVTVHxOTE1fRl9BQ0sp
OwogCkBAIC01MjUsNiArNTMxLDggQEAgaW50IG5mbG9nX3NldF9xdGhyZXNoKHN0cnVjdCBuZmxv
Z19nX2hhbgogCQlzdHJ1Y3Qgbmxtc2doZHIgbm1oOwogCX0gdTsKIAorICAgICAgICBtZW1zZXQo
JnUsIDAsIHNpemVvZih1KSk7IC8vaWhvbW9saWFrCisgICAgICAgIAogCW5mbmxfZmlsbF9oZHIo
Z2gtPmgtPm5mbmxzc2gsICZ1Lm5taCwgMCwgQUZfVU5TUEVDLCBnaC0+aWQsCiAJCSAgICAgIE5G
VUxOTF9NU0dfQ09ORklHLCBOTE1fRl9SRVFVRVNUfE5MTV9GX0FDSyk7CiAKQEAgLTU1Myw4ICs1
NjEsMTAgQEAgaW50IG5mbG9nX3NldF9ubGJ1ZnNpeihzdHJ1Y3QgbmZsb2dfZ19oYQogCQljaGFy
IGJ1ZltORk5MX0hFQURFUl9MRU4rTkZBX0xFTkdUSChzaXplb2YodV9pbnQzMl90KSldOwogCQlz
dHJ1Y3Qgbmxtc2doZHIgbm1oOwogCX0gdTsKLQlpbnQgc3RhdHVzOworCWludCBzdGF0dXMgPSAw
OyAvL2lob21vbGlhawogCisgICAgICAgIG1lbXNldCgmdSwgMCwgc2l6ZW9mKHUpKTsgLy9paG9t
b2xpYWsJCisgICAgICAgIAogCW5mbmxfZmlsbF9oZHIoZ2gtPmgtPm5mbmxzc2gsICZ1Lm5taCwg
MCwgQUZfVU5TUEVDLCBnaC0+aWQsCiAJCSAgICAgIE5GVUxOTF9NU0dfQ09ORklHLCBOTE1fRl9S
RVFVRVNUfE5MTV9GX0FDSyk7CiAKQEAgLTU4OCw2ICs1OTgsOCBAQCBpbnQgbmZsb2dfc2V0X2Zs
YWdzKHN0cnVjdCBuZmxvZ19nX2hhbmRsCiAJCXN0cnVjdCBubG1zZ2hkciBubWg7CiAJfSB1Owog
CisgICAgICAgIG1lbXNldCgmdSwgMCwgc2l6ZW9mKHUpKTsgLy9paG9tb2xpYWsKKwkKIAluZm5s
X2ZpbGxfaGRyKGdoLT5oLT5uZm5sc3NoLCAmdS5ubWgsIDAsIEFGX1VOU1BFQywgZ2gtPmlkLAog
CQkgICAgICBORlVMTkxfTVNHX0NPTkZJRywgTkxNX0ZfUkVRVUVTVHxOTE1fRl9BQ0spOwogCg==
--047d7bd6b828bfedbe04f141c8e8--
