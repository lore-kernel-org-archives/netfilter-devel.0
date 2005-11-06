From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: Unable to handle kernel NULL pointer dereference at virtual
 address 00000000 after conntrack -I
Date: Sun, 6 Nov 2005 03:30:43 +0100 (CET)
Message-ID: <Pine.LNX.4.63.0511060256410.29836@bizon.gios.gov.pl>
References: <Pine.LNX.4.63.0511031408370.32626@bizon.gios.gov.pl>
	<436A6B39.3080508@eurodev.net>
	<Pine.LNX.4.63.0511060103230.27498@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-435299776-1131244243=:29836"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <Pine.LNX.4.63.0511060103230.27498@bizon.gios.gov.pl>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-435299776-1131244243=:29836
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sun, 6 Nov 2005, Krzysztof Oledzki wrote:

>
>
> On Thu, 3 Nov 2005, Pablo Neira wrote:
>
>> Krzysztof Oledzki wrote:
>>> # conntrack -I --orig-src 1.2.3.4 --orig-dst 1.2.3.5 --reply-src 2.3.4.=
5
>>> --reply-dst 2.3.4.5 -p tcp --orig-port-src 1 --orig-port-dst 2
>>> --reply-port-src 3 --reply-port-dst 4 -t 32323 -u ASSURED
>>=20
>> --state option is missing: Unfortunately conntrack forgot to check it
>> that such parameter was missing and ctnetlink didn't do that check
>> either. That's why it resulted in an oops :(
>>=20
>> I've just applied a patch for conntrack, refresh your working copy. So
>> you won't be able to reproduce that oops anymore.
>>=20
>> Anyway I'll send a patch for ctnetlink, that checking must be done in
>> kernel space as well.
>
> Simmilar problem, this time ICMP related:
>
> # conntrack -I -s=3D192.168.0.88 -d=3D192.168.31.255 -r=3D192.168.31.255=
=20
> -q=3D192.168.0.88 -p icmp -t 4 -u ASSURED --icmp-type 1  --icmp-code 3
>
> Unable to handle kernel NULL pointer dereference at virtual address 00000=
004
> printing eip:

OK. This patch (check-icmpid.patch) should fix it:

[NETFILTER] Check for ICMP_ID in icmp_nfattr_to_tuple

This patch fixes an userspace triggered oops. If there is no ICMP_ID
info the reference to attr will be NULL.

Signed-out-by: Krzysztof Piotr Oledzki <ole@ans.pl>

--- a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c=092005-11-06 02:17:29.00=
0000000 +0100
+++ b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c=092005-11-06 02:18:45.00=
0000000 +0100
@@ -296,7 +296,8 @@
  =09=09=09=09struct ip_conntrack_tuple *tuple)
  {
  =09if (!tb[CTA_PROTO_ICMP_TYPE-1]
-=09    || !tb[CTA_PROTO_ICMP_CODE-1])
+=09    || !tb[CTA_PROTO_ICMP_CODE-1]
+=09    || !tb[CTA_PROTO_ICMP_ID-1])
  =09=09return -1;

  =09tuple->dst.u.icmp.type =3D

Anyway, libnetfilter_conntrack_icmp.c should also be fixed. Currently=20
ICMP_ID is not addedd if TYPE is not 8 (ICMP ECHO). I beleve we should=20
simply skip this check (libnetfilter_conntrack_icmp-icmpid.patch):


Index: extensions/libnetfilter_conntrack_icmp.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- extensions/libnetfilter_conntrack_icmp.c=09(revision 4480)
+++ extensions/libnetfilter_conntrack_icmp.c=09(working copy)
@@ -38,10 +38,12 @@
  =09=09       &t->l4dst.icmp.code, sizeof(u_int8_t));
  =09nfnl_addattr_l(&req->nlh, size, CTA_PROTO_ICMP_TYPE,
  =09=09       &t->l4dst.icmp.type, sizeof(u_int8_t));
-=09/* This is an ICMP echo */
-=09if (t->l4dst.icmp.type =3D=3D 8)
-=09=09nfnl_addattr_l(&req->nlh, size, CTA_PROTO_ICMP_ID,
-=09=09=09       &t->l4src.icmp.id, sizeof(u_int16_t));
+
+=09/* The ID only makes sense for type=3D8 (ECHO) but we always
+=09 * want to set it or else kernel will reject such messages.
+=09 */
+=09nfnl_addattr_l(&req->nlh, size, CTA_PROTO_ICMP_ID,
+=09=09       &t->l4src.icmp.id, sizeof(u_int16_t));
  }

  static int print_proto(char *buf, struct nfct_tuple *t)

Best regards,


 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-435299776-1131244243=:29836
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=check-icmpid.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.63.0511060330430.29836@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=check-icmpid.patch

W05FVEZJTFRFUl0gQ2hlY2sgZm9yIElDTVBfSUQgaW4gaWNtcF9uZmF0dHJf
dG9fdHVwbGUNCg0KVGhpcyBwYXRjaCBmaXhlcyBhbiB1c2Vyc3BhY2UgdHJp
Z2dlcmVkIG9vcHMuIElmIHRoZXJlIGlzIG5vIElDTVBfSUQNCmluZm8gdGhl
IHJlZmVyZW5jZSB0byBhdHRyIHdpbGwgYmUgTlVMTC4NCg0KU2lnbmVkLW91
dC1ieTogS3J6eXN6dG9mIFBpb3RyIE9sZWR6a2kgPG9sZUBhbnMucGw+DQoN
Ci0tLSBhL25ldC9pcHY0L25ldGZpbHRlci9pcF9jb25udHJhY2tfcHJvdG9f
aWNtcC5jCTIwMDUtMTEtMDYgMDI6MTc6MjkuMDAwMDAwMDAwICswMTAwDQor
KysgYi9uZXQvaXB2NC9uZXRmaWx0ZXIvaXBfY29ubnRyYWNrX3Byb3RvX2lj
bXAuYwkyMDA1LTExLTA2IDAyOjE4OjQ1LjAwMDAwMDAwMCArMDEwMA0KQEAg
LTI5Niw3ICsyOTYsOCBAQA0KIAkJCQlzdHJ1Y3QgaXBfY29ubnRyYWNrX3R1
cGxlICp0dXBsZSkNCiB7DQogCWlmICghdGJbQ1RBX1BST1RPX0lDTVBfVFlQ
RS0xXQ0KLQkgICAgfHwgIXRiW0NUQV9QUk9UT19JQ01QX0NPREUtMV0pDQor
CSAgICB8fCAhdGJbQ1RBX1BST1RPX0lDTVBfQ09ERS0xXQ0KKwkgICAgfHwg
IXRiW0NUQV9QUk9UT19JQ01QX0lELTFdKQ0KIAkJcmV0dXJuIC0xOw0KIA0K
IAl0dXBsZS0+ZHN0LnUuaWNtcC50eXBlID0gDQo=

---187430788-435299776-1131244243=:29836
Content-Type: TEXT/PLAIN; charset=US-ASCII;
	name=libnetfilter_conntrack_icmp-icmpid.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.63.0511060330431.29836@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment;
	filename=libnetfilter_conntrack_icmp-icmpid.patch

SW5kZXg6IGV4dGVuc2lvbnMvbGlibmV0ZmlsdGVyX2Nvbm50cmFja19pY21w
LmMNCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT0NCi0tLSBleHRlbnNpb25zL2xp
Ym5ldGZpbHRlcl9jb25udHJhY2tfaWNtcC5jCShyZXZpc2lvbiA0NDgwKQ0K
KysrIGV4dGVuc2lvbnMvbGlibmV0ZmlsdGVyX2Nvbm50cmFja19pY21wLmMJ
KHdvcmtpbmcgY29weSkNCkBAIC0zOCwxMCArMzgsMTIgQEANCiAJCSAgICAg
ICAmdC0+bDRkc3QuaWNtcC5jb2RlLCBzaXplb2YodV9pbnQ4X3QpKTsNCiAJ
bmZubF9hZGRhdHRyX2woJnJlcS0+bmxoLCBzaXplLCBDVEFfUFJPVE9fSUNN
UF9UWVBFLA0KIAkJICAgICAgICZ0LT5sNGRzdC5pY21wLnR5cGUsIHNpemVv
Zih1X2ludDhfdCkpOw0KLQkvKiBUaGlzIGlzIGFuIElDTVAgZWNobyAqLw0K
LQlpZiAodC0+bDRkc3QuaWNtcC50eXBlID09IDgpDQotCQluZm5sX2FkZGF0
dHJfbCgmcmVxLT5ubGgsIHNpemUsIENUQV9QUk9UT19JQ01QX0lELA0KLQkJ
CSAgICAgICAmdC0+bDRzcmMuaWNtcC5pZCwgc2l6ZW9mKHVfaW50MTZfdCkp
Ow0KKw0KKwkvKiBUaGUgSUQgb25seSBtYWtlcyBzZW5zZSBmb3IgdHlwZT04
IChFQ0hPKSBidXQgd2UgYWx3YXlzDQorCSAqIHdhbnQgdG8gc2V0IGl0IG9y
IGVsc2Uga2VybmVsIHdpbGwgcmVqZWN0IHN1Y2ggbWVzc2FnZXMuDQorCSAq
Lw0KKwluZm5sX2FkZGF0dHJfbCgmcmVxLT5ubGgsIHNpemUsIENUQV9QUk9U
T19JQ01QX0lELA0KKwkJICAgICAgICZ0LT5sNHNyYy5pY21wLmlkLCBzaXpl
b2YodV9pbnQxNl90KSk7DQogfQ0KIA0KIHN0YXRpYyBpbnQgcHJpbnRfcHJv
dG8oY2hhciAqYnVmLCBzdHJ1Y3QgbmZjdF90dXBsZSAqdCkNCg==

---187430788-435299776-1131244243=:29836--
