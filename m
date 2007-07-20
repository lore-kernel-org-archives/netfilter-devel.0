From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: connbytes & 64bit counters
Date: Sat, 21 Jul 2007 00:13:06 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707202350290.4877@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0610250035100.23937@bizon.gios.gov.pl>
	<453FE325.1040502@trash.net>
	<Pine.LNX.4.64.0610281716090.19053@bizon.gios.gov.pl>
	<45462043.5010207@trash.net>
	<Pine.LNX.4.64.0610302055060.3941@bizon.gios.gov.pl>
	<4565AAC7.8050702@trash.net> <45660CD5.1090405@netfilter.org>
	<4566B6B6.4060808@trash.net>
	<Pine.LNX.4.64.0612250252060.27316@bizon.gios.gov.pl>
	<45A4EBC8.60304@trash.net>
	<Pine.LNX.4.64.0701151141410.13986@bizon.gios.gov.pl>
	<45AB919A.4030100@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1383340408-1184969586=:4877"
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Krzysztof Oledzki <olenf@ans.pl>, Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45AB919A.4030100@trash.net>
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

---187430788-1383340408-1184969586=:4877
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 15 Jan 2007, Patrick McHardy wrote:

> Krzysztof Oledzki wrote:
>> On Wed, 10 Jan 2007, Patrick McHardy wrote:
>>
>>>> linux-2.6.19.1-64bitconntrack/net/ipv4/netfilter/ip_conntrack_core.c
>>>> 2006-12-22 21:13:35.000000000 +0100
>>>> @@ -1148,9 +1148,6 @@
>>>>          ct->counters[CTINFO2DIR(ctinfo)].packets++;
>>>>          ct->counters[CTINFO2DIR(ctinfo)].bytes +=3D
>>>>                          ntohs(skb->nh.iph->tot_len);
>>>> -        if ((ct->counters[CTINFO2DIR(ctinfo)].packets & 0x80000000)
>>>> -            || (ct->counters[CTINFO2DIR(ctinfo)].bytes & 0x80000000))
>>>> -            event |=3D IPCT_COUNTER_FILLING;
>>>
>>>
>>>
>>> This was actually broken before, since the counters are not
>>> reset (they just overflow) an event was generated for every
>>> packet until the overflow once they reached 2^31. Anyway,
>>> I'm not sure how ulogd2 uses these counters, Harald, is it
>>> necessary to receive period updates?
>>
>>
>> If we remove IPCT_COUNTER_FILLING there is no other solution than also
>> drop this part of the code.
>
> Let's wait what Harald says about ulogd2, I'm not sure whether we need
> to keep this.
>
>> BTW: what about CTA_COUNTERS32_*? Should we also drop that attributes?
>
> They should be kept to make sure the value are not reused. Please just
> add a comment stating that they are not used anymore.
>

Getting back to this old thread... How about attached (and inlined) patch?

  - for 2.6.22 and current linux-2.6.git kernels with ip_conntrack removed
  - removes IPCT_COUNTER_FILLING
  - comments CTA_COUNTERS32_*


[NETFILTER]: Reimplementation of 64bit counters for bytes/packets accountin=
g

Initially netfilter has had 64bit counters for conntrack-based accounting, =
but
it was changed in 2.6.14 to save memory. Unfortunately in-kernel 64bit coun=
ters are
still required, for example for the "connbytes" extension.

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/=
netfilter/nf_conntrack_common.h
index 9e0dae0..7a29936 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -122,10 +122,6 @@ enum ip_conntrack_events
  =09IPCT_NATINFO_BIT =3D 10,
  =09IPCT_NATINFO =3D (1 << IPCT_NATINFO_BIT),

-=09/* Counter highest bit has been set */
-=09IPCT_COUNTER_FILLING_BIT =3D 11,
-=09IPCT_COUNTER_FILLING =3D (1 << IPCT_COUNTER_FILLING_BIT),
-
  =09/* Mark is set */
  =09IPCT_MARK_BIT =3D 12,
  =09IPCT_MARK =3D (1 << IPCT_MARK_BIT),
@@ -139,8 +135,8 @@ enum ip_conntrack_expect_events {
  #ifdef __KERNEL__
  struct ip_conntrack_counter
  {
-=09u_int32_t packets;
-=09u_int32_t bytes;
+=09u_int64_t packets;
+=09u_int64_t bytes;
  };

  struct ip_conntrack_stat
diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/linux/=
netfilter/nfnetlink_conntrack.h
index d7c3503..75f3df8 100644
--- a/include/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/linux/netfilter/nfnetlink_conntrack.h
@@ -93,10 +93,10 @@ enum ctattr_protoinfo_tcp {

  enum ctattr_counters {
  =09CTA_COUNTERS_UNSPEC,
-=09CTA_COUNTERS_PACKETS,=09=09/* old 64bit counters */
-=09CTA_COUNTERS_BYTES,=09=09/* old 64bit counters */
-=09CTA_COUNTERS32_PACKETS,
-=09CTA_COUNTERS32_BYTES,
+=09CTA_COUNTERS_PACKETS,=09=09/* 64bit counters */
+=09CTA_COUNTERS_BYTES,=09=09/* 64bit counters */
+=09CTA_COUNTERS32_PACKETS,=09=09/* 32bit counters, unused */
+=09CTA_COUNTERS32_BYTES,=09=09/* 32bit counters, unused */
  =09__CTA_COUNTERS_MAX
  };
  #define CTA_COUNTERS_MAX (__CTA_COUNTERS_MAX - 1)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack=
_core.c
index 3d14110..7fd9f54 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -773,9 +773,6 @@ void __nf_ct_refresh_acct(struct nf_conn *ct,
  =09=09ct->counters[CTINFO2DIR(ctinfo)].bytes +=3D
  =09=09=09skb->len - skb_network_offset(skb);

-=09=09if ((ct->counters[CTINFO2DIR(ctinfo)].packets & 0x80000000)
-=09=09    || (ct->counters[CTINFO2DIR(ctinfo)].bytes & 0x80000000))
-=09=09=09event |=3D IPCT_COUNTER_FILLING;
  =09}
  #endif

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntr=
ack_netlink.c
index 6f89b10..1967fed 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -204,13 +204,13 @@ ctnetlink_dump_counters(struct sk_buff *skb, const st=
ruct nf_conn *ct,
  {
  =09enum ctattr_type type =3D dir ? CTA_COUNTERS_REPLY: CTA_COUNTERS_ORIG;
  =09struct nfattr *nest_count =3D NFA_NEST(skb, type);
-=09__be32 tmp;
+=09__be64 tmp;

-=09tmp =3D htonl(ct->counters[dir].packets);
-=09NFA_PUT(skb, CTA_COUNTERS32_PACKETS, sizeof(u_int32_t), &tmp);
+=09tmp =3D cpu_to_be64(ct->counters[dir].packets);
+=09NFA_PUT(skb, CTA_COUNTERS_PACKETS, sizeof(__be64), &tmp);

-=09tmp =3D htonl(ct->counters[dir].bytes);
-=09NFA_PUT(skb, CTA_COUNTERS32_BYTES, sizeof(u_int32_t), &tmp);
+=09tmp =3D cpu_to_be64(ct->counters[dir].bytes);
+=09NFA_PUT(skb, CTA_COUNTERS_BYTES, sizeof(__be64), &tmp);

  =09NFA_NEST_END(skb, nest_count);



Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1383340408-1184969586=:4877
Content-Type: TEXT/PLAIN; charset=US-ASCII;
	name=0080-netfilter-64bitcounters-2.6.22.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0707210013060.4877@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment;
	filename=0080-netfilter-64bitcounters-2.6.22.patch

W05FVEZJTFRFUl06IFJlaW1wbGVtZW50YXRpb24gb2YgNjRiaXQgY291bnRl
cnMgZm9yIGJ5dGVzL3BhY2tldHMgYWNjb3VudGluZw0KICAgIA0KSW5pdGlh
bGx5IG5ldGZpbHRlciBoYXMgaGFkIDY0Yml0IGNvdW50ZXJzIGZvciBjb25u
dHJhY2stYmFzZWQgYWNjb3VudGluZywgYnV0DQppdCB3YXMgY2hhbmdlZCBp
biAyLjYuMTQgdG8gc2F2ZSBtZW1vcnkuIFVuZm9ydHVuYXRlbHkgaW4ta2Vy
bmVsIDY0Yml0IGNvdW50ZXJzIGFyZQ0Kc3RpbGwgcmVxdWlyZWQsIGZvciBl
eGFtcGxlIGZvciB0aGUgImNvbm5ieXRlcyIgZXh0ZW5zaW9uLg0KICAgIA0K
U2lnbmVkLW9mZi1ieTogS3J6eXN6dG9mIFBpb3RyIE9sZWR6a2kgPG9sZUBh
bnMucGw+DQoNCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L25ldGZpbHRl
ci9uZl9jb25udHJhY2tfY29tbW9uLmggYi9pbmNsdWRlL2xpbnV4L25ldGZp
bHRlci9uZl9jb25udHJhY2tfY29tbW9uLmgNCmluZGV4IDllMGRhZTAuLjdh
Mjk5MzYgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L25ldGZpbHRlci9u
Zl9jb25udHJhY2tfY29tbW9uLmgNCisrKyBiL2luY2x1ZGUvbGludXgvbmV0
ZmlsdGVyL25mX2Nvbm50cmFja19jb21tb24uaA0KQEAgLTEyMiwxMCArMTIy
LDYgQEAgZW51bSBpcF9jb25udHJhY2tfZXZlbnRzDQogCUlQQ1RfTkFUSU5G
T19CSVQgPSAxMCwNCiAJSVBDVF9OQVRJTkZPID0gKDEgPDwgSVBDVF9OQVRJ
TkZPX0JJVCksDQogDQotCS8qIENvdW50ZXIgaGlnaGVzdCBiaXQgaGFzIGJl
ZW4gc2V0ICovDQotCUlQQ1RfQ09VTlRFUl9GSUxMSU5HX0JJVCA9IDExLA0K
LQlJUENUX0NPVU5URVJfRklMTElORyA9ICgxIDw8IElQQ1RfQ09VTlRFUl9G
SUxMSU5HX0JJVCksDQotDQogCS8qIE1hcmsgaXMgc2V0ICovDQogCUlQQ1Rf
TUFSS19CSVQgPSAxMiwNCiAJSVBDVF9NQVJLID0gKDEgPDwgSVBDVF9NQVJL
X0JJVCksDQpAQCAtMTM5LDggKzEzNSw4IEBAIGVudW0gaXBfY29ubnRyYWNr
X2V4cGVjdF9ldmVudHMgew0KICNpZmRlZiBfX0tFUk5FTF9fDQogc3RydWN0
IGlwX2Nvbm50cmFja19jb3VudGVyDQogew0KLQl1X2ludDMyX3QgcGFja2V0
czsNCi0JdV9pbnQzMl90IGJ5dGVzOw0KKwl1X2ludDY0X3QgcGFja2V0czsN
CisJdV9pbnQ2NF90IGJ5dGVzOw0KIH07DQogDQogc3RydWN0IGlwX2Nvbm50
cmFja19zdGF0DQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9uZXRmaWx0
ZXIvbmZuZXRsaW5rX2Nvbm50cmFjay5oIGIvaW5jbHVkZS9saW51eC9uZXRm
aWx0ZXIvbmZuZXRsaW5rX2Nvbm50cmFjay5oDQppbmRleCBkN2MzNTAzLi43
NWYzZGY4IDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC9uZXRmaWx0ZXIv
bmZuZXRsaW5rX2Nvbm50cmFjay5oDQorKysgYi9pbmNsdWRlL2xpbnV4L25l
dGZpbHRlci9uZm5ldGxpbmtfY29ubnRyYWNrLmgNCkBAIC05MywxMCArOTMs
MTAgQEAgZW51bSBjdGF0dHJfcHJvdG9pbmZvX3RjcCB7DQogDQogZW51bSBj
dGF0dHJfY291bnRlcnMgew0KIAlDVEFfQ09VTlRFUlNfVU5TUEVDLA0KLQlD
VEFfQ09VTlRFUlNfUEFDS0VUUywJCS8qIG9sZCA2NGJpdCBjb3VudGVycyAq
Lw0KLQlDVEFfQ09VTlRFUlNfQllURVMsCQkvKiBvbGQgNjRiaXQgY291bnRl
cnMgKi8NCi0JQ1RBX0NPVU5URVJTMzJfUEFDS0VUUywNCi0JQ1RBX0NPVU5U
RVJTMzJfQllURVMsDQorCUNUQV9DT1VOVEVSU19QQUNLRVRTLAkJLyogNjRi
aXQgY291bnRlcnMgKi8NCisJQ1RBX0NPVU5URVJTX0JZVEVTLAkJLyogNjRi
aXQgY291bnRlcnMgKi8NCisJQ1RBX0NPVU5URVJTMzJfUEFDS0VUUywJCS8q
IDMyYml0IGNvdW50ZXJzLCB1bnVzZWQgKi8NCisJQ1RBX0NPVU5URVJTMzJf
QllURVMsCQkvKiAzMmJpdCBjb3VudGVycywgdW51c2VkICovDQogCV9fQ1RB
X0NPVU5URVJTX01BWA0KIH07DQogI2RlZmluZSBDVEFfQ09VTlRFUlNfTUFY
IChfX0NUQV9DT1VOVEVSU19NQVggLSAxKQ0KZGlmZiAtLWdpdCBhL25ldC9u
ZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2NvcmUuYyBiL25ldC9uZXRmaWx0ZXIv
bmZfY29ubnRyYWNrX2NvcmUuYw0KaW5kZXggM2QxNDExMC4uN2ZkOWY1NCAx
MDA2NDQNCi0tLSBhL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2NvcmUu
Yw0KKysrIGIvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfY29yZS5jDQpA
QCAtNzczLDkgKzc3Myw2IEBAIHZvaWQgX19uZl9jdF9yZWZyZXNoX2FjY3Qo
c3RydWN0IG5mX2Nvbm4gKmN0LA0KIAkJY3QtPmNvdW50ZXJzW0NUSU5GTzJE
SVIoY3RpbmZvKV0uYnl0ZXMgKz0NCiAJCQlza2ItPmxlbiAtIHNrYl9uZXR3
b3JrX29mZnNldChza2IpOw0KIA0KLQkJaWYgKChjdC0+Y291bnRlcnNbQ1RJ
TkZPMkRJUihjdGluZm8pXS5wYWNrZXRzICYgMHg4MDAwMDAwMCkNCi0JCSAg
ICB8fCAoY3QtPmNvdW50ZXJzW0NUSU5GTzJESVIoY3RpbmZvKV0uYnl0ZXMg
JiAweDgwMDAwMDAwKSkNCi0JCQlldmVudCB8PSBJUENUX0NPVU5URVJfRklM
TElORzsNCiAJfQ0KICNlbmRpZg0KIA0KZGlmZiAtLWdpdCBhL25ldC9uZXRm
aWx0ZXIvbmZfY29ubnRyYWNrX25ldGxpbmsuYyBiL25ldC9uZXRmaWx0ZXIv
bmZfY29ubnRyYWNrX25ldGxpbmsuYw0KaW5kZXggNmY4OWIxMC4uMTk2N2Zl
ZCAxMDA2NDQNCi0tLSBhL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX25l
dGxpbmsuYw0KKysrIGIvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfbmV0
bGluay5jDQpAQCAtMjA0LDEzICsyMDQsMTMgQEAgY3RuZXRsaW5rX2R1bXBf
Y291bnRlcnMoc3RydWN0IHNrX2J1ZmYgKnNrYiwgY29uc3Qgc3RydWN0IG5m
X2Nvbm4gKmN0LA0KIHsNCiAJZW51bSBjdGF0dHJfdHlwZSB0eXBlID0gZGly
ID8gQ1RBX0NPVU5URVJTX1JFUExZOiBDVEFfQ09VTlRFUlNfT1JJRzsNCiAJ
c3RydWN0IG5mYXR0ciAqbmVzdF9jb3VudCA9IE5GQV9ORVNUKHNrYiwgdHlw
ZSk7DQotCV9fYmUzMiB0bXA7DQorCV9fYmU2NCB0bXA7DQogDQotCXRtcCA9
IGh0b25sKGN0LT5jb3VudGVyc1tkaXJdLnBhY2tldHMpOw0KLQlORkFfUFVU
KHNrYiwgQ1RBX0NPVU5URVJTMzJfUEFDS0VUUywgc2l6ZW9mKHVfaW50MzJf
dCksICZ0bXApOw0KKwl0bXAgPSBjcHVfdG9fYmU2NChjdC0+Y291bnRlcnNb
ZGlyXS5wYWNrZXRzKTsNCisJTkZBX1BVVChza2IsIENUQV9DT1VOVEVSU19Q
QUNLRVRTLCBzaXplb2YoX19iZTY0KSwgJnRtcCk7DQogDQotCXRtcCA9IGh0
b25sKGN0LT5jb3VudGVyc1tkaXJdLmJ5dGVzKTsNCi0JTkZBX1BVVChza2Is
IENUQV9DT1VOVEVSUzMyX0JZVEVTLCBzaXplb2YodV9pbnQzMl90KSwgJnRt
cCk7DQorCXRtcCA9IGNwdV90b19iZTY0KGN0LT5jb3VudGVyc1tkaXJdLmJ5
dGVzKTsNCisJTkZBX1BVVChza2IsIENUQV9DT1VOVEVSU19CWVRFUywgc2l6
ZW9mKF9fYmU2NCksICZ0bXApOw0KIA0KIAlORkFfTkVTVF9FTkQoc2tiLCBu
ZXN0X2NvdW50KTsNCiANCg==

---187430788-1383340408-1184969586=:4877--
