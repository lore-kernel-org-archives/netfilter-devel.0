From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: ipt_time fixes (resend, sorry)
Date: Tue, 5 Apr 2005 10:18:34 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0504051006020.4373@bizon.gios.gov.pl>
References: <Pine.LNX.4.61.0501141503220.9908@bizon.gios.gov.pl>
	<20050114143722.GA10088@ti64.telemetry-investments.com>
	<Pine.LNX.4.61.0501141542230.3572@bizon.gios.gov.pl>
	<57991.142.169.215.10.1105716756.squirrel@142.169.215.10>
	<Pine.LNX.4.61.0501141622190.4865@bizon.gios.gov.pl>
	<20050201120618.GA6878@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-97377304-1112689114=:4373"
Cc: netfilter-devel@lists.netfilter.org, Fabrice MARIE <fabrice@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050201120618.GA6878@sunbeam.de.gnumonks.org>
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

---187430788-97377304-1112689114=:4373
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 1 Feb 2005, Harald Welte wrote:

> On Fri, Jan 14, 2005 at 04:24:01PM +0100, Krzysztof Oledzki wrote:
>> OK, How about...
>
> Could you please coordinate with Fabrice Marie (the author of the
> module?) and send me (personally) the final patch?

Hello,

I think it is good time to commit my ipt_time-fix-timestamp2.patch. I=20
believe it was ACKed by the author of ipt_time module:

---------- Forwarded message ----------
Date: Tue, 15 Feb 2005 23:23:08 +0800
From: Fabrice MARIE <fabrice@netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
Cc: netfilter-devel@lists.netfilter.org
Subject: Re: ipt_time fixes (resend, sorry)


Hello,

On Tuesday 15 February 2005 09:20, Krzysztof Oledzki wrote:
> Any progress? ;-)

Yep. Sorry for the delay. The patch looks alright although I didn't test=20
it.

-------- Forwarded message end --------

This patch fixes time match when skb->stamp.tv_sec is 0, due to timestamp=
=20
optimization. It also simplifies time read logic. I believe this patch=20
does not break anything, even binary iptables.


diff -Nur patch-o-matic-ng-20050113-orig/time/linux-2.6/include/linux/netfi=
lter_ipv4/ipt_time.h patch-o-matic-ng-20050113/time/linux-2.6/include/linux=
/netfilter_ipv4/ipt_time.h
--- patch-o-matic-ng-20050113-orig/time/linux-2.6/include/linux/netfilter_i=
pv4/ipt_time.h=092004-05-05 12:11:24.000000000 +0200
+++ patch-o-matic-ng-20050113/time/linux-2.6/include/linux/netfilter_ipv4/i=
pt_time.h=092005-01-14 16:06:54.000000000 +0100
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
diff -Nur patch-o-matic-ng-20050113-orig/time/linux-2.6/net/ipv4/netfilter/=
ipt_time.c patch-o-matic-ng-20050113/time/linux-2.6/net/ipv4/netfilter/ipt_=
time.c
--- patch-o-matic-ng-20050113-orig/time/linux-2.6/net/ipv4/netfilter/ipt_ti=
me.c=092004-05-05 12:11:24.000000000 +0200
+++ patch-o-matic-ng-20050113/time/linux-2.6/net/ipv4/netfilter/ipt_time.c=
=092005-01-14 16:15:30.000000000 +0100
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
---187430788-97377304-1112689114=:4373
Content-Type: TEXT/PLAIN; charset=US-ASCII;
	name=40-ipt_time-fix-timestamp2.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.62.0504051018340.4373@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=40-ipt_time-fix-timestamp2.patch

ZGlmZiAtTnVyIHBhdGNoLW8tbWF0aWMtbmctMjAwNTAxMTMtb3JpZy90aW1l
L2xpbnV4LTIuNi9pbmNsdWRlL2xpbnV4L25ldGZpbHRlcl9pcHY0L2lwdF90
aW1lLmggcGF0Y2gtby1tYXRpYy1uZy0yMDA1MDExMy90aW1lL2xpbnV4LTIu
Ni9pbmNsdWRlL2xpbnV4L25ldGZpbHRlcl9pcHY0L2lwdF90aW1lLmgNCi0t
LSBwYXRjaC1vLW1hdGljLW5nLTIwMDUwMTEzLW9yaWcvdGltZS9saW51eC0y
LjYvaW5jbHVkZS9saW51eC9uZXRmaWx0ZXJfaXB2NC9pcHRfdGltZS5oCTIw
MDQtMDUtMDUgMTI6MTE6MjQuMDAwMDAwMDAwICswMjAwDQorKysgcGF0Y2gt
by1tYXRpYy1uZy0yMDA1MDExMy90aW1lL2xpbnV4LTIuNi9pbmNsdWRlL2xp
bnV4L25ldGZpbHRlcl9pcHY0L2lwdF90aW1lLmgJMjAwNS0wMS0xNCAxNjow
Njo1NC4wMDAwMDAwMDAgKzAxMDANCkBAIC02LDcgKzYsMTAgQEANCiAJdV9p
bnQ4X3QgIGRheXNfbWF0Y2g7ICAgLyogMSBiaXQgcGVyIGRheS4gLVNNVFdU
RlMgICAgICAgICAgICAgICAgICAgICAgKi8NCiAJdV9pbnQxNl90IHRpbWVf
c3RhcnQ7ICAgLyogMCA8IHRpbWVfc3RhcnQgPCAyMyo2MCs1OSA9IDE0Mzkg
ICAgICAgICAgICAgKi8NCiAJdV9pbnQxNl90IHRpbWVfc3RvcDsgICAgLyog
MDowIDwgdGltZV9zdGF0IDwgMjM6NTkgICAgICAgICAgICAgICAgICAgICAg
Ki8NCisNCisJCQkJLyogRklYTUU6IEtlZXAgdGhpcyBvbmUgZm9yIHVzZXJz
cGFjZSBpcHRhYmxlcyBiaW5hcnkgY29tcGFiaWxpdHk6ICovDQogCXVfaW50
OF90ICBrZXJuZWx0aW1lOyAgIC8qIGlnbm9yZSBza2IgdGltZSAoYW5kIHVz
ZSBrZXJuZWx0aW1lKSBvciBub3QuICovDQorDQogCXRpbWVfdCAgICBkYXRl
X3N0YXJ0Ow0KIAl0aW1lX3QgICAgZGF0ZV9zdG9wOw0KIH07DQpkaWZmIC1O
dXIgcGF0Y2gtby1tYXRpYy1uZy0yMDA1MDExMy1vcmlnL3RpbWUvbGludXgt
Mi42L25ldC9pcHY0L25ldGZpbHRlci9pcHRfdGltZS5jIHBhdGNoLW8tbWF0
aWMtbmctMjAwNTAxMTMvdGltZS9saW51eC0yLjYvbmV0L2lwdjQvbmV0Zmls
dGVyL2lwdF90aW1lLmMNCi0tLSBwYXRjaC1vLW1hdGljLW5nLTIwMDUwMTEz
LW9yaWcvdGltZS9saW51eC0yLjYvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwdF90
aW1lLmMJMjAwNC0wNS0wNSAxMjoxMToyNC4wMDAwMDAwMDAgKzAyMDANCisr
KyBwYXRjaC1vLW1hdGljLW5nLTIwMDUwMTEzL3RpbWUvbGludXgtMi42L25l
dC9pcHY0L25ldGZpbHRlci9pcHRfdGltZS5jCTIwMDUtMDEtMTQgMTY6MTU6
MzAuMDAwMDAwMDAwICswMTAwDQpAQCAtNTYsMjQgKzU2LDE3IEBADQogCXN0
cnVjdCB0bSBjdXJyZW50dGltZTsgICAgICAgICAgICAgICAgICAgICAgICAg
IC8qIHRpbWUgaHVtYW4gcmVhZGFibGUgKi8NCiAJdV9pbnQ4X3QgZGF5c19v
Zl93ZWVrWzddID0gezY0LCAzMiwgMTYsIDgsIDQsIDIsIDF9Ow0KIAl1X2lu
dDE2X3QgcGFja2V0X3RpbWU7DQotCXN0cnVjdCB0aW1ldmFsIGtlcm5lbHRp
bWV2YWw7DQotCXRpbWVfdCBwYWNrZXRfbG9jYWxfdGltZTsNCiANCi0JLyog
aWYga2VybmVsdGltZT0xLCB3ZSBkb24ndCByZWFkIHRoZSBza2ItPnRpbWVz
dGFtcCBidXQga2VybmVsIHRpbWUgaW5zdGVhZCAqLw0KLQlpZiAoaW5mby0+
a2VybmVsdGltZSkNCi0Jew0KLQkJZG9fZ2V0dGltZW9mZGF5KCZrZXJuZWx0
aW1ldmFsKTsNCi0JCXBhY2tldF9sb2NhbF90aW1lID0ga2VybmVsdGltZXZh
bC50dl9zZWM7DQotCX0NCi0JZWxzZQ0KLQkJcGFja2V0X2xvY2FsX3RpbWUg
PSBza2ItPnN0YW1wLnR2X3NlYzsNCisJLyogV2UgbWlnaHQgbm90IGhhdmUg
YSB0aW1lc3RhbXAsIGdldCBvbmUgKi8NCisJaWYgKHNrYi0+c3RhbXAudHZf
c2VjID09IDApDQorCQlkb19nZXR0aW1lb2ZkYXkoKHN0cnVjdCB0aW1ldmFs
ICopJnNrYi0+c3RhbXApOw0KIA0KIAkvKiBGaXJzdCB3ZSBtYWtlIHN1cmUg
d2UgYXJlIGluIHRoZSBkYXRlIHN0YXJ0LXN0b3AgYm91bmRhcmllcyAqLw0K
LQlpZiAoKHBhY2tldF9sb2NhbF90aW1lIDwgaW5mby0+ZGF0ZV9zdGFydCkg
fHwgKHBhY2tldF9sb2NhbF90aW1lID4gaW5mby0+ZGF0ZV9zdG9wKSkNCisJ
aWYgKChza2ItPnN0YW1wLnR2X3NlYyA8IGluZm8tPmRhdGVfc3RhcnQpIHx8
IChza2ItPnN0YW1wLnR2X3NlYyA+IGluZm8tPmRhdGVfc3RvcCkpDQogCQly
ZXR1cm4gMDsgLyogV2UgYXJlIG91dHNpZGUgdGhlIGRhdGUgYm91bmRhcmll
cyAqLw0KIA0KIAkvKiBUcmFuc2Zvcm0gdGhlIHRpbWVzdGFtcCBvZiB0aGUg
cGFja2V0LCBpbiBhIGh1bWFuIHJlYWRhYmxlIGZvcm0gKi8NCi0JbG9jYWx0
aW1lKCZwYWNrZXRfbG9jYWxfdGltZSwgJmN1cnJlbnR0aW1lKTsNCisJbG9j
YWx0aW1lKCZza2ItPnN0YW1wLnR2X3NlYywgJmN1cnJlbnR0aW1lKTsNCiAN
CiAJLyogY2hlY2sgaWYgd2UgbWF0Y2ggdGhpcyB0aW1lc3RhbXAsIHdlIHN0
YXJ0IGJ5IHRoZSBkYXlzLi4uICovDQogCWlmICgoZGF5c19vZl93ZWVrW2N1
cnJlbnR0aW1lLnRtX3dkYXldICYgaW5mby0+ZGF5c19tYXRjaCkgIT0gZGF5
c19vZl93ZWVrW2N1cnJlbnR0aW1lLnRtX3dkYXldKQ0KQEAgLTEwNCwxMSAr
OTcsNiBAQA0KIAkJcHJpbnRrKCJpcHRfdGltZTogZXJyb3IsIG9ubHkgdmFs
aWQgZm9yIFBSRV9ST1VUSU5HLCBMT0NBTF9JTiwgRk9SV0FSRCBhbmQgT1VU
UFVUKVxuIik7DQogCQlyZXR1cm4gMDsNCiAJfQ0KLQkvKiB3ZSB1c2UgdGhl
IGtlcm5lbHRpbWUgaWYgd2UgYXJlIGluIGZvcndhcmQgb3Igb3V0cHV0ICov
DQotCWluZm8tPmtlcm5lbHRpbWUgPSAxOw0KLQlpZiAoaG9va19tYXNrICYg
figoMSA8PCBORl9JUF9GT1JXQVJEKSB8ICgxIDw8IE5GX0lQX0xPQ0FMX09V
VCkpKSANCi0JCS8qIHdlIHVzZSB0aGUgc2tiIHRpbWUgKi8NCi0JCWluZm8t
Pmtlcm5lbHRpbWUgPSAwOw0KIA0KIAkvKiBDaGVjayB0aGUgc2l6ZSAqLw0K
IAlpZiAobWF0Y2hzaXplICE9IElQVF9BTElHTihzaXplb2Yoc3RydWN0IGlw
dF90aW1lX2luZm8pKSkNCg==

---187430788-97377304-1112689114=:4373--
