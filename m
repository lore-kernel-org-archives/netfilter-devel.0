From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Fix output of conntrack -L/conntrack -L -i
Date: Wed, 2 Nov 2005 20:22:10 +0100 (CET)
Message-ID: <Pine.LNX.4.63.0511022014570.22508@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1308034668-1130959330=:22508"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
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

---187430788-1308034668-1130959330=:22508
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

Attached (and inlined) patch fixes output of conntrack -L/conntrack -L -i=
=20
by removing space character after last field. Now it should be 100%=20
compatible with /proc/net/ip_conntrack.

Index: src/libnetfilter_conntrack.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- src/libnetfilter_conntrack.c=09(revision 4429)
+++ src/libnetfilter_conntrack.c=09(working copy)
@@ -605,6 +605,8 @@
  =09int size;

  =09size =3D nfct_sprintf_conntrack(buf, arg, flags);
+=09if (size && buf[size-1]=3D=3D' ') size--;=09=09=09/* remove last space =
*/
+
  =09sprintf(buf+size, "\n");
  =09fprintf(stdout, buf);

@@ -617,6 +619,8 @@
  =09int size;

  =09size =3D nfct_sprintf_conntrack_id(buf, arg, flags);
+=09if (size && buf[size]=3D=3D' ') size--;=09=09=09/* remove last space */
+
  =09sprintf(buf+size, "\n");
  =09fprintf(stdout, buf);



Best regards,

 =09=09=09Krzysztof Ol=EAdzki

---187430788-1308034668-1130959330=:22508
Content-Type: TEXT/PLAIN; charset=US-ASCII;
	name=libnetfilter_conntrack-remove-last-space.diff
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.63.0511022022100.22508@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment;
	filename=libnetfilter_conntrack-remove-last-space.diff

SW5kZXg6IHNyYy9saWJuZXRmaWx0ZXJfY29ubnRyYWNrLmMNCj09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT0NCi0tLSBzcmMvbGlibmV0ZmlsdGVyX2Nvbm50cmFj
ay5jCShyZXZpc2lvbiA0NDI5KQ0KKysrIHNyYy9saWJuZXRmaWx0ZXJfY29u
bnRyYWNrLmMJKHdvcmtpbmcgY29weSkNCkBAIC02MDUsNiArNjA1LDggQEAN
CiAJaW50IHNpemU7DQogDQogCXNpemUgPSBuZmN0X3NwcmludGZfY29ubnRy
YWNrKGJ1ZiwgYXJnLCBmbGFncyk7DQorCWlmIChzaXplICYmIGJ1ZltzaXpl
LTFdPT0nICcpIHNpemUtLTsJCQkvKiByZW1vdmUgbGFzdCBzcGFjZSAqLw0K
Kw0KIAlzcHJpbnRmKGJ1ZitzaXplLCAiXG4iKTsNCiAJZnByaW50ZihzdGRv
dXQsIGJ1Zik7DQogDQpAQCAtNjE3LDYgKzYxOSw4IEBADQogCWludCBzaXpl
Ow0KIA0KIAlzaXplID0gbmZjdF9zcHJpbnRmX2Nvbm50cmFja19pZChidWYs
IGFyZywgZmxhZ3MpOw0KKwlpZiAoc2l6ZSAmJiBidWZbc2l6ZV09PScgJykg
c2l6ZS0tOwkJCS8qIHJlbW92ZSBsYXN0IHNwYWNlICovDQorDQogCXNwcmlu
dGYoYnVmK3NpemUsICJcbiIpOw0KIAlmcHJpbnRmKHN0ZG91dCwgYnVmKTsN
CiANCg==

---187430788-1308034668-1130959330=:22508--
