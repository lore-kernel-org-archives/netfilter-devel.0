From: Krzysztof Oledzki <olenf@ans.pl>
Subject: ipt_time fixes (resend, sorry)
Date: Fri, 14 Jan 2005 15:04:38 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0501141503220.9908@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1984269934-1105709416=:6119"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Fabrice MARIE <fabrice@netfilter.org>
Content-ID: <Pine.LNX.4.61.0501141503221.9908@bizon.gios.gov.pl>
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

---187430788-1984269934-1105709416=:6119
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-2; FORMAT=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <Pine.LNX.4.61.0501141503222.9908@bizon.gios.gov.pl>

Hello,

My two patches fixes two problem I have just found. I tried to=20
migrate from 2.4.x to the 2.6.11-rc1 kernel. Patches are against=20
patch-o-matic-ng-20050105 but can be cleanly applied to the latest=20
patch-o-matic-ng (20050113).

1. Fix compilation, without this patch I got:

net/ipv4/netfilter/ipt_time.c:128: warning: initialization makes integer fr=
om pointer without a cast
net/ipv4/netfilter/ipt_time.c:128: error: initializer element is not comput=
able at load time
net/ipv4/netfilter/ipt_time.c:128: error: (near initialization for `time_ma=
tch.revision')
net/ipv4/netfilter/ipt_time.c:128: warning: initialization from incompatibl=
e pointer type
net/ipv4/netfilter/ipt_time.c:128: warning: initialization from incompatibl=
e pointer type
make[3]: *** [net/ipv4/netfilter/ipt_time.o] Error 1
make[2]: *** [net/ipv4/netfilter] Error 2
make[1]: *** [net/ipv4] Error 2
make: *** [net] Error 2

Anyway, should we use "match"/"checkentry" or "&match"/"&checkentry"?
I noticed different netfilter modules use different syntax.

diff -Nur patch-o-matic-ng-20050105-orig/time/linux/net/ipv4/netfilter/ipt_=
time.c patch-o-matic-ng-20050105/time/linux/net/ipv4/netfilter/ipt_time.c
--- patch-o-matic-ng-20050105-orig/time/linux/net/ipv4/netfilter/ipt_time.c=
=092004-05-05 12:11:24.000000000 +0200
+++ patch-o-matic-ng-20050105/time/linux/net/ipv4/netfilter/ipt_time.c=0920=
05-01-14 12:15:09.000000000 +0100
@@ -48,8 +48,6 @@
         const struct net_device *out,
         const void *matchinfo,
         int offset,
-      const void *hdr,
-      u_int16_t datalen,
         int *hotdrop)
   {
   =09const struct ipt_time_info *info =3D matchinfo;   /* match info for r=
ule */
@@ -124,8 +122,12 @@
   =09return 1;
   }

-static struct ipt_match time_match
-=3D { { NULL, NULL }, "time", &match, &checkentry, NULL, THIS_MODULE };
+static struct ipt_match time_match =3D {
+=09.name=09=09=3D "time",
+=09.match=09=09=3D match,
+=09.checkentry=09=3D checkentry,
+=09.me=09=09=3D THIS_MODULE,
+};

   static int __init init(void)
   {


2. Fix time match when skb->stamp.tv_sec is 0. I don't know why but on=20
2.6.11-rc1 (and probably others 2.6.x kernels) skb->stamp.tv_sec seems to=
=20
be allways 0, even on PRE_ROUTING and LOCAL_IN. So I fixed it by allways=20
use kernel time byt only if skb->stamp.tv_sec is 0 (like in ULOG). With=20
such modification we no longer needs kerneltime in the "struct ipt_time_inf=
o"
but I'm afraid we should keep it for binary compability, shouldn't we?

BTW, why we cannot use ipt_time on POSTROUTING?

diff -Nur patch-o-matic-ng-20050105-orig/time/linux/include/linux/netfilter=
_ipv4/ipt_time.h patch-o-matic-ng-20050105/time/linux/include/linux/netfilt=
er_ipv4/ipt_time.h
--- patch-o-matic-ng-20050105-orig/time/linux/include/linux/netfilter_ipv4/=
ipt_time.h=092004-05-05 12:11:24.000000000 +0200
+++ patch-o-matic-ng-20050105/time/linux/include/linux/netfilter_ipv4/ipt_t=
ime.h=092005-01-14 13:48:46.000000000 +0100
@@ -6,7 +6,10 @@
   =09u_int8_t  days_match;   /* 1 bit per day. -SMTWTFS                   =
   */
   =09u_int16_t time_start;   /* 0 < time_start < 23*60+59 =3D 1439        =
     */
   =09u_int16_t time_stop;    /* 0:0 < time_stat < 23:59                   =
   */
+
+=09=09=09=09/* FIXME: Keep this one for userspace iptables binary compabil=
ity: */
   =09u_int8_t  kerneltime;   /* ignore skb time (and use kerneltime) or no=
t. */
+
   =09time_t    date_start;
   =09time_t    date_stop;
   };
diff -Nur patch-o-matic-ng-20050105-orig/time/linux/net/ipv4/netfilter/ipt_=
time.c patch-o-matic-ng-20050105/time/linux/net/ipv4/netfilter/ipt_time.c
--- patch-o-matic-ng-20050105-orig/time/linux/net/ipv4/netfilter/ipt_time.c=
=092005-01-14 12:15:09.000000000 +0100
+++ patch-o-matic-ng-20050105/time/linux/net/ipv4/netfilter/ipt_time.c=0920=
05-01-14 13:46:47.000000000 +0100
@@ -57,13 +57,11 @@
   =09struct timeval kerneltimeval;
   =09time_t packet_local_time;

-=09/* if kerneltime=3D1, we don't read the skb->timestamp but kernel time =
instead */
-=09if (info->kerneltime)
-=09{
+=09/* We might not have a timestamp, get one */
+=09if (skb->stamp.tv_sec =3D=3D 0) {
   =09=09do_gettimeofday(&kerneltimeval);
   =09=09packet_local_time =3D kerneltimeval.tv_sec;
-=09}
-=09else
+=09} else
   =09=09packet_local_time =3D skb->stamp.tv_sec;

   =09/* First we make sure we are in the date start-stop boundaries */
@@ -102,11 +100,6 @@
   =09=09printk("ipt_time: error, only valid for PRE_ROUTING, LOCAL_IN, FOR=
WARD and OUTPUT)\n");
   =09=09return 0;
   =09}
-=09/* we use the kerneltime if we are in forward or output */
-=09info->kerneltime =3D 1;
-=09if (hook_mask & ~((1 << NF_IP_FORWARD) | (1 << NF_IP_LOCAL_OUT)))=20
-=09=09/* we use the skb time */
-=09=09info->kerneltime =3D 0;

   =09/* Check the size */
   =09if (matchsize !=3D IPT_ALIGN(sizeof(struct ipt_time_info)))


Both patches are atatched. Tested on 2.6.11-rc1.

Best regards,


  =09=09=09Krzysztof Ol=EAdzki
---187430788-1984269934-1105709416=:6119
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; NAME="10-ipt_time-fix-struct.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.61.0501141430160.6119@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME="10-ipt_time-fix-struct.patch"

ZGlmZiAtTnVyIHBhdGNoLW8tbWF0aWMtbmctMjAwNTAxMDUtb3JpZy90aW1l
L2xpbnV4L25ldC9pcHY0L25ldGZpbHRlci9pcHRfdGltZS5jIHBhdGNoLW8t
bWF0aWMtbmctMjAwNTAxMDUvdGltZS9saW51eC9uZXQvaXB2NC9uZXRmaWx0
ZXIvaXB0X3RpbWUuYw0KLS0tIHBhdGNoLW8tbWF0aWMtbmctMjAwNTAxMDUt
b3JpZy90aW1lL2xpbnV4L25ldC9pcHY0L25ldGZpbHRlci9pcHRfdGltZS5j
CTIwMDQtMDUtMDUgMTI6MTE6MjQuMDAwMDAwMDAwICswMjAwDQorKysgcGF0
Y2gtby1tYXRpYy1uZy0yMDA1MDEwNS90aW1lL2xpbnV4L25ldC9pcHY0L25l
dGZpbHRlci9pcHRfdGltZS5jCTIwMDUtMDEtMTQgMTI6MTU6MDkuMDAwMDAw
MDAwICswMTAwDQpAQCAtNDgsOCArNDgsNiBAQA0KICAgICAgIGNvbnN0IHN0
cnVjdCBuZXRfZGV2aWNlICpvdXQsDQogICAgICAgY29uc3Qgdm9pZCAqbWF0
Y2hpbmZvLA0KICAgICAgIGludCBvZmZzZXQsDQotICAgICAgY29uc3Qgdm9p
ZCAqaGRyLA0KLSAgICAgIHVfaW50MTZfdCBkYXRhbGVuLA0KICAgICAgIGlu
dCAqaG90ZHJvcCkNCiB7DQogCWNvbnN0IHN0cnVjdCBpcHRfdGltZV9pbmZv
ICppbmZvID0gbWF0Y2hpbmZvOyAgIC8qIG1hdGNoIGluZm8gZm9yIHJ1bGUg
Ki8NCkBAIC0xMjQsOCArMTIyLDEyIEBADQogCXJldHVybiAxOw0KIH0NCiAN
Ci1zdGF0aWMgc3RydWN0IGlwdF9tYXRjaCB0aW1lX21hdGNoDQotPSB7IHsg
TlVMTCwgTlVMTCB9LCAidGltZSIsICZtYXRjaCwgJmNoZWNrZW50cnksIE5V
TEwsIFRISVNfTU9EVUxFIH07DQorc3RhdGljIHN0cnVjdCBpcHRfbWF0Y2gg
dGltZV9tYXRjaCA9IHsNCisJLm5hbWUJCT0gInRpbWUiLA0KKwkubWF0Y2gJ
CT0gbWF0Y2gsDQorCS5jaGVja2VudHJ5CT0gY2hlY2tlbnRyeSwNCisJLm1l
CQk9IFRISVNfTU9EVUxFLA0KK307DQogDQogc3RhdGljIGludCBfX2luaXQg
aW5pdCh2b2lkKQ0KIHsNCg==

---187430788-1984269934-1105709416=:6119
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII;
	NAME="20-ipt_time-fix-timestamp.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.61.0501141430161.6119@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME="20-ipt_time-fix-timestamp.patch"

ZGlmZiAtTnVyIHBhdGNoLW8tbWF0aWMtbmctMjAwNTAxMDUtb3JpZy90aW1l
L2xpbnV4L2luY2x1ZGUvbGludXgvbmV0ZmlsdGVyX2lwdjQvaXB0X3RpbWUu
aCBwYXRjaC1vLW1hdGljLW5nLTIwMDUwMTA1L3RpbWUvbGludXgvaW5jbHVk
ZS9saW51eC9uZXRmaWx0ZXJfaXB2NC9pcHRfdGltZS5oDQotLS0gcGF0Y2gt
by1tYXRpYy1uZy0yMDA1MDEwNS1vcmlnL3RpbWUvbGludXgvaW5jbHVkZS9s
aW51eC9uZXRmaWx0ZXJfaXB2NC9pcHRfdGltZS5oCTIwMDQtMDUtMDUgMTI6
MTE6MjQuMDAwMDAwMDAwICswMjAwDQorKysgcGF0Y2gtby1tYXRpYy1uZy0y
MDA1MDEwNS90aW1lL2xpbnV4L2luY2x1ZGUvbGludXgvbmV0ZmlsdGVyX2lw
djQvaXB0X3RpbWUuaAkyMDA1LTAxLTE0IDEzOjQ4OjQ2LjAwMDAwMDAwMCAr
MDEwMA0KQEAgLTYsNyArNiwxMCBAQA0KIAl1X2ludDhfdCAgZGF5c19tYXRj
aDsgICAvKiAxIGJpdCBwZXIgZGF5LiAtU01UV1RGUyAgICAgICAgICAgICAg
ICAgICAgICAqLw0KIAl1X2ludDE2X3QgdGltZV9zdGFydDsgICAvKiAwIDwg
dGltZV9zdGFydCA8IDIzKjYwKzU5ID0gMTQzOSAgICAgICAgICAgICAqLw0K
IAl1X2ludDE2X3QgdGltZV9zdG9wOyAgICAvKiAwOjAgPCB0aW1lX3N0YXQg
PCAyMzo1OSAgICAgICAgICAgICAgICAgICAgICAqLw0KKw0KKwkJCQkvKiBG
SVhNRTogS2VlcCB0aGlzIG9uZSBmb3IgdXNlcnNwYWNlIGlwdGFibGVzIGJp
bmFyeSBjb21wYWJpbGl0eTogKi8NCiAJdV9pbnQ4X3QgIGtlcm5lbHRpbWU7
ICAgLyogaWdub3JlIHNrYiB0aW1lIChhbmQgdXNlIGtlcm5lbHRpbWUpIG9y
IG5vdC4gKi8NCisNCiAJdGltZV90ICAgIGRhdGVfc3RhcnQ7DQogCXRpbWVf
dCAgICBkYXRlX3N0b3A7DQogfTsNCmRpZmYgLU51ciBwYXRjaC1vLW1hdGlj
LW5nLTIwMDUwMTA1LW9yaWcvdGltZS9saW51eC9uZXQvaXB2NC9uZXRmaWx0
ZXIvaXB0X3RpbWUuYyBwYXRjaC1vLW1hdGljLW5nLTIwMDUwMTA1L3RpbWUv
bGludXgvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwdF90aW1lLmMNCi0tLSBwYXRj
aC1vLW1hdGljLW5nLTIwMDUwMTA1LW9yaWcvdGltZS9saW51eC9uZXQvaXB2
NC9uZXRmaWx0ZXIvaXB0X3RpbWUuYwkyMDA1LTAxLTE0IDEyOjE1OjA5LjAw
MDAwMDAwMCArMDEwMA0KKysrIHBhdGNoLW8tbWF0aWMtbmctMjAwNTAxMDUv
dGltZS9saW51eC9uZXQvaXB2NC9uZXRmaWx0ZXIvaXB0X3RpbWUuYwkyMDA1
LTAxLTE0IDEzOjQ2OjQ3LjAwMDAwMDAwMCArMDEwMA0KQEAgLTU3LDEzICs1
NywxMSBAQA0KIAlzdHJ1Y3QgdGltZXZhbCBrZXJuZWx0aW1ldmFsOw0KIAl0
aW1lX3QgcGFja2V0X2xvY2FsX3RpbWU7DQogDQotCS8qIGlmIGtlcm5lbHRp
bWU9MSwgd2UgZG9uJ3QgcmVhZCB0aGUgc2tiLT50aW1lc3RhbXAgYnV0IGtl
cm5lbCB0aW1lIGluc3RlYWQgKi8NCi0JaWYgKGluZm8tPmtlcm5lbHRpbWUp
DQotCXsNCisJLyogV2UgbWlnaHQgbm90IGhhdmUgYSB0aW1lc3RhbXAsIGdl
dCBvbmUgKi8NCisJaWYgKHNrYi0+c3RhbXAudHZfc2VjID09IDApIHsNCiAJ
CWRvX2dldHRpbWVvZmRheSgma2VybmVsdGltZXZhbCk7DQogCQlwYWNrZXRf
bG9jYWxfdGltZSA9IGtlcm5lbHRpbWV2YWwudHZfc2VjOw0KLQl9DQotCWVs
c2UNCisJfSBlbHNlDQogCQlwYWNrZXRfbG9jYWxfdGltZSA9IHNrYi0+c3Rh
bXAudHZfc2VjOw0KIA0KIAkvKiBGaXJzdCB3ZSBtYWtlIHN1cmUgd2UgYXJl
IGluIHRoZSBkYXRlIHN0YXJ0LXN0b3AgYm91bmRhcmllcyAqLw0KQEAgLTEw
MiwxMSArMTAwLDYgQEANCiAJCXByaW50aygiaXB0X3RpbWU6IGVycm9yLCBv
bmx5IHZhbGlkIGZvciBQUkVfUk9VVElORywgTE9DQUxfSU4sIEZPUldBUkQg
YW5kIE9VVFBVVClcbiIpOw0KIAkJcmV0dXJuIDA7DQogCX0NCi0JLyogd2Ug
dXNlIHRoZSBrZXJuZWx0aW1lIGlmIHdlIGFyZSBpbiBmb3J3YXJkIG9yIG91
dHB1dCAqLw0KLQlpbmZvLT5rZXJuZWx0aW1lID0gMTsNCi0JaWYgKGhvb2tf
bWFzayAmIH4oKDEgPDwgTkZfSVBfRk9SV0FSRCkgfCAoMSA8PCBORl9JUF9M
T0NBTF9PVVQpKSkgDQotCQkvKiB3ZSB1c2UgdGhlIHNrYiB0aW1lICovDQot
CQlpbmZvLT5rZXJuZWx0aW1lID0gMDsNCiANCiAJLyogQ2hlY2sgdGhlIHNp
emUgKi8NCiAJaWYgKG1hdGNoc2l6ZSAhPSBJUFRfQUxJR04oc2l6ZW9mKHN0
cnVjdCBpcHRfdGltZV9pbmZvKSkpDQo=

---187430788-1984269934-1105709416=:6119--
