From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: ipt_time fixes (resend, sorry)
Date: Fri, 14 Jan 2005 16:24:01 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0501141622190.4865@bizon.gios.gov.pl>
References: <Pine.LNX.4.61.0501141503220.9908@bizon.gios.gov.pl>   
	<20050114143722.GA10088@ti64.telemetry-investments.com>   
	<Pine.LNX.4.61.0501141542230.3572@bizon.gios.gov.pl>
	<57991.142.169.215.10.1105716756.squirrel@142.169.215.10>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-965934004-1105716241=:4865"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Samuel Jean <sj-netfilter@cookinglinux.org>
In-Reply-To: <57991.142.169.215.10.1105716756.squirrel@142.169.215.10>
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

---187430788-965934004-1105716241=:4865
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 14 Jan 2005, Samuel Jean wrote:

> On Fri, January 14, 2005 9:48 am, Krzysztof Oledzki said:
>>> This is most likely due to Andi Kleen's net timestamp optimization,
>>> which
>>> avoids calling gettimeofday in the network fastpath unless it is needed=
=2E
>>
>> I see... So, where we should fix this in netfilter code?
>
> Am sorry, I haven't looked much at your patches. But here's my opinion.
>
> Netfilter shouldn't enable this for the unique reason a match/target
> will possibly rely on this.
>
> I think it's the job of the first rule (of a given module) seeing that
> 'new' packet to keep counting the last-seen time. Yes, the stamp is a bit
> later than it should. But that's not dramatic and still consistant among
> multiple rules (of a common module) needing that reference.

OK, How about...

diff -Nur patch-o-matic-ng-20050113-orig/time/linux/include/linux/netfilter=
_ipv4/ipt_time.h patch-o-matic-ng-20050113/time/linux/include/linux/netfilt=
er_ipv4/ipt_time.h
--- patch-o-matic-ng-20050113-orig/time/linux/include/linux/netfilter_ipv4/=
ipt_time.h=092004-05-05 12:11:24.000000000 +0200
+++ patch-o-matic-ng-20050113/time/linux/include/linux/netfilter_ipv4/ipt_t=
ime.h=092005-01-14 16:06:54.000000000 +0100
@@ -6,7 +6,10 @@
  =09u_int8_t  days_match;   /* 1 bit per day. -SMTWTFS                    =
  */
  =09u_int16_t time_start;   /* 0 < time_start < 23*60+59 =3D 1439         =
    */
  =09u_int16_t time_stop;    /* 0:0 < time_stat < 23:59                    =
  */
+
+=09=09=09=09/* FIXME: Keep this one for userspace iptables binary compabil=
ity: */
  =09u_int8_t  kerneltime;   /* ignore skb time (and use kerneltime) or not=
=2E */
+
  =09time_t    date_start;
  =09time_t    date_stop;
  };
diff -Nur patch-o-matic-ng-20050113-orig/time/linux/net/ipv4/netfilter/ipt_=
time.c patch-o-matic-ng-20050113/time/linux/net/ipv4/netfilter/ipt_time.c
--- patch-o-matic-ng-20050113-orig/time/linux/net/ipv4/netfilter/ipt_time.c=
=092004-05-05 12:11:24.000000000 +0200
+++ patch-o-matic-ng-20050113/time/linux/net/ipv4/netfilter/ipt_time.c=0920=
05-01-14 16:15:30.000000000 +0100
@@ -56,24 +56,17 @@
  =09struct tm currenttime;                          /* time human readable=
 */
  =09u_int8_t days_of_week[7] =3D {64, 32, 16, 8, 4, 2, 1};
  =09u_int16_t packet_time;
-=09struct timeval kerneltimeval;
-=09time_t packet_local_time;

-=09/* if kerneltime=3D1, we don't read the skb->timestamp but kernel time =
instead */
-=09if (info->kerneltime)
-=09{
-=09=09do_gettimeofday(&kerneltimeval);
-=09=09packet_local_time =3D kerneltimeval.tv_sec;
-=09}
-=09else
-=09=09packet_local_time =3D skb->stamp.tv_sec;
+=09/* We might not have a timestamp, get one */
+=09if (skb->stamp.tv_sec =3D=3D 0)
+=09=09do_gettimeofday((struct timeval *)&skb->stamp);

  =09/* First we make sure we are in the date start-stop boundaries */
-=09if ((packet_local_time < info->date_start) || (packet_local_time > info=
->date_stop))
+=09if ((skb->stamp.tv_sec < info->date_start) || (skb->stamp.tv_sec > info=
->date_stop))
  =09=09return 0; /* We are outside the date boundaries */

  =09/* Transform the timestamp of the packet, in a human readable form */
-=09localtime(&packet_local_time, &currenttime);
+=09localtime(&skb->stamp.tv_sec, &currenttime);

  =09/* check if we match this timestamp, we start by the days... */
  =09if ((days_of_week[currenttime.tm_wday] & info->days_match) !=3D days_o=
f_week[currenttime.tm_wday])
@@ -104,11 +97,6 @@
  =09=09printk("ipt_time: error, only valid for PRE_ROUTING, LOCAL_IN, FORW=
ARD and OUTPUT)\n");
  =09=09return 0;
  =09}
-=09/* we use the kerneltime if we are in forward or output */
-=09info->kerneltime =3D 1;
-=09if (hook_mask & ~((1 << NF_IP_FORWARD) | (1 << NF_IP_LOCAL_OUT)))=20
-=09=09/* we use the skb time */
-=09=09info->kerneltime =3D 0;

  =09/* Check the size */
  =09if (matchsize !=3D IPT_ALIGN(sizeof(struct ipt_time_info)))

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-965934004-1105716241=:4865
Content-Type: TEXT/PLAIN; charset=US-ASCII;
	name="20-ipt_time-fix-timestamp2.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.61.0501141624010.4865@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename="20-ipt_time-fix-timestamp2.patch"

ZGlmZiAtTnVyIHBhdGNoLW8tbWF0aWMtbmctMjAwNTAxMTMtb3JpZy90aW1l
L2xpbnV4L2luY2x1ZGUvbGludXgvbmV0ZmlsdGVyX2lwdjQvaXB0X3RpbWUu
aCBwYXRjaC1vLW1hdGljLW5nLTIwMDUwMTEzL3RpbWUvbGludXgvaW5jbHVk
ZS9saW51eC9uZXRmaWx0ZXJfaXB2NC9pcHRfdGltZS5oDQotLS0gcGF0Y2gt
by1tYXRpYy1uZy0yMDA1MDExMy1vcmlnL3RpbWUvbGludXgvaW5jbHVkZS9s
aW51eC9uZXRmaWx0ZXJfaXB2NC9pcHRfdGltZS5oCTIwMDQtMDUtMDUgMTI6
MTE6MjQuMDAwMDAwMDAwICswMjAwDQorKysgcGF0Y2gtby1tYXRpYy1uZy0y
MDA1MDExMy90aW1lL2xpbnV4L2luY2x1ZGUvbGludXgvbmV0ZmlsdGVyX2lw
djQvaXB0X3RpbWUuaAkyMDA1LTAxLTE0IDE2OjA2OjU0LjAwMDAwMDAwMCAr
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
LW5nLTIwMDUwMTEzLW9yaWcvdGltZS9saW51eC9uZXQvaXB2NC9uZXRmaWx0
ZXIvaXB0X3RpbWUuYyBwYXRjaC1vLW1hdGljLW5nLTIwMDUwMTEzL3RpbWUv
bGludXgvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwdF90aW1lLmMNCi0tLSBwYXRj
aC1vLW1hdGljLW5nLTIwMDUwMTEzLW9yaWcvdGltZS9saW51eC9uZXQvaXB2
NC9uZXRmaWx0ZXIvaXB0X3RpbWUuYwkyMDA0LTA1LTA1IDEyOjExOjI0LjAw
MDAwMDAwMCArMDIwMA0KKysrIHBhdGNoLW8tbWF0aWMtbmctMjAwNTAxMTMv
dGltZS9saW51eC9uZXQvaXB2NC9uZXRmaWx0ZXIvaXB0X3RpbWUuYwkyMDA1
LTAxLTE0IDE2OjE1OjMwLjAwMDAwMDAwMCArMDEwMA0KQEAgLTU2LDI0ICs1
NiwxNyBAQA0KIAlzdHJ1Y3QgdG0gY3VycmVudHRpbWU7ICAgICAgICAgICAg
ICAgICAgICAgICAgICAvKiB0aW1lIGh1bWFuIHJlYWRhYmxlICovDQogCXVf
aW50OF90IGRheXNfb2Zfd2Vla1s3XSA9IHs2NCwgMzIsIDE2LCA4LCA0LCAy
LCAxfTsNCiAJdV9pbnQxNl90IHBhY2tldF90aW1lOw0KLQlzdHJ1Y3QgdGlt
ZXZhbCBrZXJuZWx0aW1ldmFsOw0KLQl0aW1lX3QgcGFja2V0X2xvY2FsX3Rp
bWU7DQogDQotCS8qIGlmIGtlcm5lbHRpbWU9MSwgd2UgZG9uJ3QgcmVhZCB0
aGUgc2tiLT50aW1lc3RhbXAgYnV0IGtlcm5lbCB0aW1lIGluc3RlYWQgKi8N
Ci0JaWYgKGluZm8tPmtlcm5lbHRpbWUpDQotCXsNCi0JCWRvX2dldHRpbWVv
ZmRheSgma2VybmVsdGltZXZhbCk7DQotCQlwYWNrZXRfbG9jYWxfdGltZSA9
IGtlcm5lbHRpbWV2YWwudHZfc2VjOw0KLQl9DQotCWVsc2UNCi0JCXBhY2tl
dF9sb2NhbF90aW1lID0gc2tiLT5zdGFtcC50dl9zZWM7DQorCS8qIFdlIG1p
Z2h0IG5vdCBoYXZlIGEgdGltZXN0YW1wLCBnZXQgb25lICovDQorCWlmIChz
a2ItPnN0YW1wLnR2X3NlYyA9PSAwKQ0KKwkJZG9fZ2V0dGltZW9mZGF5KChz
dHJ1Y3QgdGltZXZhbCAqKSZza2ItPnN0YW1wKTsNCiANCiAJLyogRmlyc3Qg
d2UgbWFrZSBzdXJlIHdlIGFyZSBpbiB0aGUgZGF0ZSBzdGFydC1zdG9wIGJv
dW5kYXJpZXMgKi8NCi0JaWYgKChwYWNrZXRfbG9jYWxfdGltZSA8IGluZm8t
PmRhdGVfc3RhcnQpIHx8IChwYWNrZXRfbG9jYWxfdGltZSA+IGluZm8tPmRh
dGVfc3RvcCkpDQorCWlmICgoc2tiLT5zdGFtcC50dl9zZWMgPCBpbmZvLT5k
YXRlX3N0YXJ0KSB8fCAoc2tiLT5zdGFtcC50dl9zZWMgPiBpbmZvLT5kYXRl
X3N0b3ApKQ0KIAkJcmV0dXJuIDA7IC8qIFdlIGFyZSBvdXRzaWRlIHRoZSBk
YXRlIGJvdW5kYXJpZXMgKi8NCiANCiAJLyogVHJhbnNmb3JtIHRoZSB0aW1l
c3RhbXAgb2YgdGhlIHBhY2tldCwgaW4gYSBodW1hbiByZWFkYWJsZSBmb3Jt
ICovDQotCWxvY2FsdGltZSgmcGFja2V0X2xvY2FsX3RpbWUsICZjdXJyZW50
dGltZSk7DQorCWxvY2FsdGltZSgmc2tiLT5zdGFtcC50dl9zZWMsICZjdXJy
ZW50dGltZSk7DQogDQogCS8qIGNoZWNrIGlmIHdlIG1hdGNoIHRoaXMgdGlt
ZXN0YW1wLCB3ZSBzdGFydCBieSB0aGUgZGF5cy4uLiAqLw0KIAlpZiAoKGRh
eXNfb2Zfd2Vla1tjdXJyZW50dGltZS50bV93ZGF5XSAmIGluZm8tPmRheXNf
bWF0Y2gpICE9IGRheXNfb2Zfd2Vla1tjdXJyZW50dGltZS50bV93ZGF5XSkN
CkBAIC0xMDQsMTEgKzk3LDYgQEANCiAJCXByaW50aygiaXB0X3RpbWU6IGVy
cm9yLCBvbmx5IHZhbGlkIGZvciBQUkVfUk9VVElORywgTE9DQUxfSU4sIEZP
UldBUkQgYW5kIE9VVFBVVClcbiIpOw0KIAkJcmV0dXJuIDA7DQogCX0NCi0J
Lyogd2UgdXNlIHRoZSBrZXJuZWx0aW1lIGlmIHdlIGFyZSBpbiBmb3J3YXJk
IG9yIG91dHB1dCAqLw0KLQlpbmZvLT5rZXJuZWx0aW1lID0gMTsNCi0JaWYg
KGhvb2tfbWFzayAmIH4oKDEgPDwgTkZfSVBfRk9SV0FSRCkgfCAoMSA8PCBO
Rl9JUF9MT0NBTF9PVVQpKSkgDQotCQkvKiB3ZSB1c2UgdGhlIHNrYiB0aW1l
ICovDQotCQlpbmZvLT5rZXJuZWx0aW1lID0gMDsNCiANCiAJLyogQ2hlY2sg
dGhlIHNpemUgKi8NCiAJaWYgKG1hdGNoc2l6ZSAhPSBJUFRfQUxJR04oc2l6
ZW9mKHN0cnVjdCBpcHRfdGltZV9pbmZvKSkpDQo=

---187430788-965934004-1105716241=:4865--
