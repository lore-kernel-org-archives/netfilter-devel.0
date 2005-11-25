From: Krzysztof Oledzki <olenf@ans.pl>
Subject: [PATCH] Spelling fix (Badd) in libnfnetlink
Date: Fri, 25 Nov 2005 12:41:06 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0511251237070.11184@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-392309121-1132918866=:11184"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@eurodev.net>
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

---187430788-392309121-1132918866=:11184
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

Attached (and inlined) patch fix spelling in libnfnetlink.

[LIBNFNETLINK] Spelling fix (Badd)

Spelling fix: s/Badd/Bad/

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>

Index: src/libnfnetlink.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- src/libnfnetlink.c=09(revision 6281)
+++ src/libnfnetlink.c=09(working copy)
@@ -113,7 +113,7 @@
  =09=09return -1;
  =09}
  =09if (nfnlh->local.nl_family !=3D AF_NETLINK) {
-=09=09nfnl_error("Badd address family %d", nfnlh->local.nl_family);
+=09=09nfnl_error("Bad address family %d", nfnlh->local.nl_family);
  =09=09return -1;
  =09}
  =09nfnlh->seq =3D time(NULL);

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-392309121-1132918866=:11184
Content-Type: TEXT/PLAIN; charset=US-ASCII;
	name=spelling-fix-libnfnetlink.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0511251241060.11184@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=spelling-fix-libnfnetlink.patch

DQpbTElCTkZORVRMSU5LXSBTcGVsbGluZyBmaXggKEJhZGQpDQoNClNwZWxs
aW5nIGZpeDogcy9CYWRkL0JhZC8NCg0KU2lnbmVkLW9mZi1ieTogS3J6eXN6
dG9mIFBpb3RyIE9sZWR6a2kgPG9sZUBhbnMucGw+DQoNCkluZGV4OiBzcmMv
bGlibmZuZXRsaW5rLmMNCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCi0tLSBz
cmMvbGlibmZuZXRsaW5rLmMJKHJldmlzaW9uIDYyODEpDQorKysgc3JjL2xp
Ym5mbmV0bGluay5jCSh3b3JraW5nIGNvcHkpDQpAQCAtMTEzLDcgKzExMyw3
IEBADQogCQlyZXR1cm4gLTE7DQogCX0NCiAJaWYgKG5mbmxoLT5sb2NhbC5u
bF9mYW1pbHkgIT0gQUZfTkVUTElOSykgew0KLQkJbmZubF9lcnJvcigiQmFk
ZCBhZGRyZXNzIGZhbWlseSAlZCIsIG5mbmxoLT5sb2NhbC5ubF9mYW1pbHkp
Ow0KKwkJbmZubF9lcnJvcigiQmFkIGFkZHJlc3MgZmFtaWx5ICVkIiwgbmZu
bGgtPmxvY2FsLm5sX2ZhbWlseSk7DQogCQlyZXR1cm4gLTE7DQogCX0NCiAJ
bmZubGgtPnNlcSA9IHRpbWUoTlVMTCk7DQo=

---187430788-392309121-1132918866=:11184--
