From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [ANNOUNCE] Release conntrack-tools 0.9.6
Date: Sun, 9 Mar 2008 20:31:15 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803092018460.24925@bizon.gios.gov.pl>
References: <47D28F29.6080707@netfilter.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1088713172-1205091075=:24925"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:45204 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbYCITba (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Mar 2008 15:31:30 -0400
In-Reply-To: <47D28F29.6080707@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1088713172-1205091075=:24925
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sat, 8 Mar 2008, Pablo Neira Ayuso wrote:

> Hi!
Hi,

> The netfilter project proudly presents another development release of
> the conntrack-tools. This release includes important improvements, new
> features and bugfixes:

<CUT>

I attached two patches to fix two warnings about shadowed declarations.

BTW: It seems there is somethig wrong with --dst-nat/--src-nat filtering:

# conntrack -L --src-nat|wc -l;conntrack -L --src-nat=3D1.2.3.4|wc -l;connt=
rack -L --src-nat=3D244.244.244.244|wc -l
5010
5010
5010

If I understand it properly "conntrack -L --src-nat=3DA.B.C.D" is supposed=
=20
to show only connections snated to A.B.C.D, but as you can see it ignores=
=20
this parameter and shows all snated connections.

From=20the other hand --dst-nat works in exactly opposite way: it filters=
=20
out all connections, even matching ones.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1088713172-1205091075=:24925
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=conntrack-tools-conf-shadows-a-global-declaration.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0803092031150.24925@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=conntrack-tools-conf-shadows-a-global-declaration.patch

ZGlmZiAtTnVyIGNvbm50cmFjay10b29scy0yMDA4MDMwOC1vcmlnL2luY2x1
ZGUvbmV0d29yay5oIGNvbm50cmFjay10b29scy0yMDA4MDMwOC9pbmNsdWRl
L25ldHdvcmsuaA0KLS0tIGNvbm50cmFjay10b29scy0yMDA4MDMwOC1vcmln
L2luY2x1ZGUvbmV0d29yay5oCTIwMDgtMDEtMjMgMTM6MzA6MzYuMDAwMDAw
MDAwICswMTAwDQorKysgY29ubnRyYWNrLXRvb2xzLTIwMDgwMzA4L2luY2x1
ZGUvbmV0d29yay5oCTIwMDgtMDMtMDggMTc6Mzk6NTYuMDAwMDAwMDAwICsw
MTAwDQpAQCAtNjEsNyArNjEsNyBAQA0KIA0KIHN0cnVjdCBtY2FzdF9jb25m
Ow0KIA0KLWludCBtY2FzdF9idWZmZXJlZF9pbml0KHN0cnVjdCBtY2FzdF9j
b25mICpjb25mKTsNCitpbnQgbWNhc3RfYnVmZmVyZWRfaW5pdChzdHJ1Y3Qg
bWNhc3RfY29uZiAqbWNvbmYpOw0KIHZvaWQgbWNhc3RfYnVmZmVyZWRfZGVz
dHJveSh2b2lkKTsNCiBpbnQgbWNhc3RfYnVmZmVyZWRfc2VuZF9uZXRtc2co
c3RydWN0IG1jYXN0X3NvY2sgKm0sIHZvaWQgKmRhdGEsIHNpemVfdCBsZW4p
Ow0KIHNzaXplX3QgbWNhc3RfYnVmZmVyZWRfcGVuZGluZ19uZXRtc2coc3Ry
dWN0IG1jYXN0X3NvY2sgKm0pOw0K

---187430788-1088713172-1205091075=:24925
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=conntrack-tools-state-shadows-a-global-declaration.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0803092031151.24925@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=conntrack-tools-state-shadows-a-global-declaration.patch

ZGlmZiAtTnVyIGNvbm50cmFjay10b29scy0yMDA4MDMwOC1vcmlnL2luY2x1
ZGUvc3RhdGVfaGVscGVyLmggY29ubnRyYWNrLXRvb2xzLTIwMDgwMzA4L2lu
Y2x1ZGUvc3RhdGVfaGVscGVyLmgNCi0tLSBjb25udHJhY2stdG9vbHMtMjAw
ODAzMDgtb3JpZy9pbmNsdWRlL3N0YXRlX2hlbHBlci5oCTIwMDgtMDMtMDgg
MTc6NTA6MTEuMDAwMDAwMDAwICswMTAwDQorKysgY29ubnRyYWNrLXRvb2xz
LTIwMDgwMzA4L2luY2x1ZGUvc3RhdGVfaGVscGVyLmgJMjAwOC0wMy0wOCAx
Nzo1MDo0MS4wMDAwMDAwMDAgKzAxMDANCkBAIC0xNyw2ICsxNyw2IEBADQog
fTsNCiANCiBpbnQgc3RhdGVfaGVscGVyX3ZlcmRpY3QoaW50IHR5cGUsIHN0
cnVjdCBuZl9jb25udHJhY2sgKmN0KTsNCi12b2lkIHN0YXRlX2hlbHBlcl9y
ZWdpc3RlcihzdHJ1Y3Qgc3RhdGVfcmVwbGljYXRpb25faGVscGVyICpoLCBp
bnQgc3RhdGUpOw0KK3ZvaWQgc3RhdGVfaGVscGVyX3JlZ2lzdGVyKHN0cnVj
dCBzdGF0ZV9yZXBsaWNhdGlvbl9oZWxwZXIgKmgsIGludCBoX3N0YXRlKTsN
CiANCiAjZW5kaWYNCg==

---187430788-1088713172-1205091075=:24925--
