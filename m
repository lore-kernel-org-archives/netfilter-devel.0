From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: Patch for ipt_time (to enable start > stop / crossing midnight)
Date: Wed, 4 Jan 2006 16:47:43 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0601041639400.19966@bizon.gios.gov.pl>
References: <20060104142750.GF15217@schlittermann.de>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1388332231-1136389663=:19966"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Heiko Schlittermann <hs@schlittermann.de>
In-Reply-To: <20060104142750.GF15217@schlittermann.de>
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

---187430788-1388332231-1136389663=:19966
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 4 Jan 2006, Heiko Schlittermann wrote:

> Hello,
>
> orginally sent to Fabrice but resending it here.  (Fabrice doesn't seem t=
o
> have time...., so I just subscribed here.)
>
>
> (Beside: I was wondering, why ipt_time is not part of the official
> 2.6. kernel -- did I miss something?)
>
>
> So I applied the `time' patch from current patch-o-matic (20060101).
>
>
> But with a rule like:
>
>    iptables -A INPUT -m time --timestart 21:00 --timestop 15:00 -j ...
>    (wrapping 'round midnight).
>
> I missed my target :)
>
>
> To enable times crossing midnight I hacked a bit in ipt_time.c. My diff
> is appended (against the patch-o-matic 20060101)..
>
> It would be nice if you could
>
>    1) check it
>    2) integrate it into the official patch-o-matic (and kernel tree?)

How about this (also attached) one? Untested, but should work.


[NETFILTER] Support for timestart > timestop in ipt_time (eg. 21:00 - 15:00=
)

Based on a patch from Heiko Schlittermann <hs@schlittermann.de>

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>

diff -Nur patch-o-matic-ng-20060103-orig/patchlets/time/linux/net/ipv4/netf=
ilter/ipt_time.c patch-o-matic-ng-20060103/patchlets/time/linux/net/ipv4/ne=
tfilter/ipt_time.c
--- patch-o-matic-ng-20060103-orig/patchlets/time/linux/net/ipv4/netfilter/=
ipt_time.c=092005-05-29 20:47:49.000000000 +0200
+++ patch-o-matic-ng-20060103/patchlets/time/linux/net/ipv4/netfilter/ipt_t=
ime.c=092006-01-04 16:42:01.000000000 +0100
@@ -81,8 +81,13 @@

  =09/* ... check the time now */
  =09packet_time =3D (currenttime.tm_hour * 60) + currenttime.tm_min;
-=09if ((packet_time < info->time_start) || (packet_time > info->time_stop)=
)
-=09=09return 0;
+=09if (info->time_start < info->time_stop) {
+=09=09if ((packet_time < info->time_start) || (packet_time > info->time_st=
op))
+=09=09=09return 0;
+=09} else {
+=09=09if ((packet_time < info->time_start) && (packet_time > info->time_st=
op))
+=09=09=09return 0;
+=09}

  =09/* here we match ! */
  =09return 1;
diff -Nur patch-o-matic-ng-20060103-orig/patchlets/time/linux-2.6/net/ipv4/=
netfilter/ipt_time.c patch-o-matic-ng-20060103/patchlets/time/linux-2.6/net=
/ipv4/netfilter/ipt_time.c
--- patch-o-matic-ng-20060103-orig/patchlets/time/linux-2.6/net/ipv4/netfil=
ter/ipt_time.c=092005-11-03 19:20:25.000000000 +0100
+++ patch-o-matic-ng-20060103/patchlets/time/linux-2.6/net/ipv4/netfilter/i=
pt_time.c=092006-01-04 16:35:25.000000000 +0100
@@ -72,8 +72,13 @@

  =09/* ... check the time now */
  =09packet_time =3D (currenttime.tm_hour * 60) + currenttime.tm_min;
-=09if ((packet_time < info->time_start) || (packet_time > info->time_stop)=
)
-=09=09return 0;
+=09if (info->time_start < info->time_stop) {
+=09=09if ((packet_time < info->time_start) || (packet_time > info->time_st=
op))
+=09=09=09return 0;
+=09} else {
+=09=09if ((packet_time < info->time_start) && (packet_time > info->time_st=
op))
+=09=09=09return 0;
+=09}

  =09/* here we match ! */
  =09return 1;


Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1388332231-1136389663=:19966
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=ipt_time-time-wrap.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0601041647430.19966@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=ipt_time-time-wrap.patch

DQpbTkVURklMVEVSXSBTdXBwb3J0IGZvciB0aW1lc3RhcnQgPiB0aW1lc3Rv
cCBpbiBpcHRfdGltZSAoZWcuIDIxOjAwIC0gMTU6MDApDQoNCkJhc2VkIG9u
IGEgcGF0Y2ggZnJvbSBIZWlrbyBTY2hsaXR0ZXJtYW5uIDxoc0BzY2hsaXR0
ZXJtYW5uLmRlPg0KDQpTaWduZWQtb2ZmLWJ5OiBLcnp5c3p0b2YgUGlvdHIg
T2xlZHpraSA8b2xlQGFucy5wbD4NCg0KZGlmZiAtTnVyIHBhdGNoLW8tbWF0
aWMtbmctMjAwNjAxMDMtb3JpZy9wYXRjaGxldHMvdGltZS9saW51eC9uZXQv
aXB2NC9uZXRmaWx0ZXIvaXB0X3RpbWUuYyBwYXRjaC1vLW1hdGljLW5nLTIw
MDYwMTAzL3BhdGNobGV0cy90aW1lL2xpbnV4L25ldC9pcHY0L25ldGZpbHRl
ci9pcHRfdGltZS5jDQotLS0gcGF0Y2gtby1tYXRpYy1uZy0yMDA2MDEwMy1v
cmlnL3BhdGNobGV0cy90aW1lL2xpbnV4L25ldC9pcHY0L25ldGZpbHRlci9p
cHRfdGltZS5jCTIwMDUtMDUtMjkgMjA6NDc6NDkuMDAwMDAwMDAwICswMjAw
DQorKysgcGF0Y2gtby1tYXRpYy1uZy0yMDA2MDEwMy9wYXRjaGxldHMvdGlt
ZS9saW51eC9uZXQvaXB2NC9uZXRmaWx0ZXIvaXB0X3RpbWUuYwkyMDA2LTAx
LTA0IDE2OjQyOjAxLjAwMDAwMDAwMCArMDEwMA0KQEAgLTgxLDggKzgxLDEz
IEBADQogDQogCS8qIC4uLiBjaGVjayB0aGUgdGltZSBub3cgKi8NCiAJcGFj
a2V0X3RpbWUgPSAoY3VycmVudHRpbWUudG1faG91ciAqIDYwKSArIGN1cnJl
bnR0aW1lLnRtX21pbjsNCi0JaWYgKChwYWNrZXRfdGltZSA8IGluZm8tPnRp
bWVfc3RhcnQpIHx8IChwYWNrZXRfdGltZSA+IGluZm8tPnRpbWVfc3RvcCkp
DQotCQlyZXR1cm4gMDsNCisJaWYgKGluZm8tPnRpbWVfc3RhcnQgPCBpbmZv
LT50aW1lX3N0b3ApIHsNCisJCWlmICgocGFja2V0X3RpbWUgPCBpbmZvLT50
aW1lX3N0YXJ0KSB8fCAocGFja2V0X3RpbWUgPiBpbmZvLT50aW1lX3N0b3Ap
KQ0KKwkJCXJldHVybiAwOw0KKwl9IGVsc2Ugew0KKwkJaWYgKChwYWNrZXRf
dGltZSA8IGluZm8tPnRpbWVfc3RhcnQpICYmIChwYWNrZXRfdGltZSA+IGlu
Zm8tPnRpbWVfc3RvcCkpDQorCQkJcmV0dXJuIDA7DQorCX0NCiANCiAJLyog
aGVyZSB3ZSBtYXRjaCAhICovDQogCXJldHVybiAxOw0KZGlmZiAtTnVyIHBh
dGNoLW8tbWF0aWMtbmctMjAwNjAxMDMtb3JpZy9wYXRjaGxldHMvdGltZS9s
aW51eC0yLjYvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwdF90aW1lLmMgcGF0Y2gt
by1tYXRpYy1uZy0yMDA2MDEwMy9wYXRjaGxldHMvdGltZS9saW51eC0yLjYv
bmV0L2lwdjQvbmV0ZmlsdGVyL2lwdF90aW1lLmMNCi0tLSBwYXRjaC1vLW1h
dGljLW5nLTIwMDYwMTAzLW9yaWcvcGF0Y2hsZXRzL3RpbWUvbGludXgtMi42
L25ldC9pcHY0L25ldGZpbHRlci9pcHRfdGltZS5jCTIwMDUtMTEtMDMgMTk6
MjA6MjUuMDAwMDAwMDAwICswMTAwDQorKysgcGF0Y2gtby1tYXRpYy1uZy0y
MDA2MDEwMy9wYXRjaGxldHMvdGltZS9saW51eC0yLjYvbmV0L2lwdjQvbmV0
ZmlsdGVyL2lwdF90aW1lLmMJMjAwNi0wMS0wNCAxNjozNToyNS4wMDAwMDAw
MDAgKzAxMDANCkBAIC03Miw4ICs3MiwxMyBAQA0KIA0KIAkvKiAuLi4gY2hl
Y2sgdGhlIHRpbWUgbm93ICovDQogCXBhY2tldF90aW1lID0gKGN1cnJlbnR0
aW1lLnRtX2hvdXIgKiA2MCkgKyBjdXJyZW50dGltZS50bV9taW47DQotCWlm
ICgocGFja2V0X3RpbWUgPCBpbmZvLT50aW1lX3N0YXJ0KSB8fCAocGFja2V0
X3RpbWUgPiBpbmZvLT50aW1lX3N0b3ApKQ0KLQkJcmV0dXJuIDA7DQorCWlm
IChpbmZvLT50aW1lX3N0YXJ0IDwgaW5mby0+dGltZV9zdG9wKSB7DQorCQlp
ZiAoKHBhY2tldF90aW1lIDwgaW5mby0+dGltZV9zdGFydCkgfHwgKHBhY2tl
dF90aW1lID4gaW5mby0+dGltZV9zdG9wKSkNCisJCQlyZXR1cm4gMDsNCisJ
fSBlbHNlIHsNCisJCWlmICgocGFja2V0X3RpbWUgPCBpbmZvLT50aW1lX3N0
YXJ0KSAmJiAocGFja2V0X3RpbWUgPiBpbmZvLT50aW1lX3N0b3ApKQ0KKwkJ
CXJldHVybiAwOw0KKwl9DQogDQogCS8qIGhlcmUgd2UgbWF0Y2ggISAqLw0K
IAlyZXR1cm4gMTsNCg==

---187430788-1388332231-1136389663=:19966--
