From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: connbytes & 64bit counters
Date: Sat, 21 Jul 2007 00:42:53 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707210038370.7261@bizon.gios.gov.pl>
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
	<Pine.LNX.4.64.0707202350290.4877@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-453885848-1184971373=:7261"
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Krzysztof Oledzki <olenf@ans.pl>, Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707202350290.4877@bizon.gios.gov.pl>
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

---187430788-453885848-1184971373=:7261
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sat, 21 Jul 2007, Krzysztof Oledzki wrote:

>
>
> On Mon, 15 Jan 2007, Patrick McHardy wrote:
>
>> Krzysztof Oledzki wrote:
>>> On Wed, 10 Jan 2007, Patrick McHardy wrote:
>>>=20
>>>>> linux-2.6.19.1-64bitconntrack/net/ipv4/netfilter/ip_conntrack_core.c
>>>>> 2006-12-22 21:13:35.000000000 +0100
>>>>> @@ -1148,9 +1148,6 @@
>>>>>          ct->counters[CTINFO2DIR(ctinfo)].packets++;
>>>>>          ct->counters[CTINFO2DIR(ctinfo)].bytes +=3D
>>>>>                          ntohs(skb->nh.iph->tot_len);
>>>>> -        if ((ct->counters[CTINFO2DIR(ctinfo)].packets & 0x80000000)
>>>>> -            || (ct->counters[CTINFO2DIR(ctinfo)].bytes & 0x80000000)=
)
>>>>> -            event |=3D IPCT_COUNTER_FILLING;
>>>>=20
>>>>=20
>>>>=20
>>>> This was actually broken before, since the counters are not
>>>> reset (they just overflow) an event was generated for every
>>>> packet until the overflow once they reached 2^31. Anyway,
>>>> I'm not sure how ulogd2 uses these counters, Harald, is it
>>>> necessary to receive period updates?
>>>=20
>>>=20
>>> If we remove IPCT_COUNTER_FILLING there is no other solution than also
>>> drop this part of the code.
>>=20
>> Let's wait what Harald says about ulogd2, I'm not sure whether we need
>> to keep this.
>>=20
>>> BTW: what about CTA_COUNTERS32_*? Should we also drop that attributes?
>>=20
>> They should be kept to make sure the value are not reused. Please just
>> add a comment stating that they are not used anymore.
>>=20
>
> Getting back to this old thread... How about attached (and inlined) patch=
?
>
> - for 2.6.22 and current linux-2.6.git kernels with ip_conntrack removed
> - removes IPCT_COUNTER_FILLING
> - comments CTA_COUNTERS32_*

Errr, incomplete patch, sorry... This one should work.

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
index aa086c8..25e027f 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -806,9 +806,6 @@ void __nf_ct_refresh_acct(struct nf_conn *ct,
  =09=09ct->counters[CTINFO2DIR(ctinfo)].bytes +=3D
  =09=09=09skb->len - skb_network_offset(skb);

-=09=09if ((ct->counters[CTINFO2DIR(ctinfo)].packets & 0x80000000)
-=09=09    || (ct->counters[CTINFO2DIR(ctinfo)].bytes & 0x80000000))
-=09=09=09event |=3D IPCT_COUNTER_FILLING;
  =09}
  #endif

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntr=
ack_netlink.c
index 6f89b10..b53284f 100644
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

@@ -397,10 +397,6 @@ static int ctnetlink_conntrack_event(struct notifier_b=
lock *this,
  =09=09=09goto nfattr_failure;
  #endif

-=09=09if (events & IPCT_COUNTER_FILLING &&
-=09=09    (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
-=09=09     ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0))
-=09=09=09goto nfattr_failure;
  =09}

  =09nlh->nlmsg_len =3D skb->tail - b;


Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-453885848-1184971373=:7261
Content-Type: TEXT/PLAIN; charset=US-ASCII;
	name=0080-netfilter-64bitcounters-2.6.22a.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0707210042530.7261@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment;
	filename=0080-netfilter-64bitcounters-2.6.22a.patch

W05FVEZJTFRFUl06IFJlaW1wbGVtZW50YXRpb24gb2YgNjRiaXQgY291bnRl
cnMgZm9yIGJ5dGVzL3BhY2tldHMgYWNjb3VudGluZw0KDQpJbml0aWFsbHkg
bmV0ZmlsdGVyIGhhcyBoYWQgNjRiaXQgY291bnRlcnMgZm9yIGNvbm50cmFj
ay1iYXNlZCBhY2NvdW50aW5nLCBidXQNCml0IHdhcyBjaGFuZ2VkIGluIDIu
Ni4xNCB0byBzYXZlIG1lbW9yeS4gVW5mb3J0dW5hdGVseSBpbi1rZXJuZWwg
NjRiaXQgY291bnRlcnMgYXJlDQpzdGlsbCByZXF1aXJlZCwgZm9yIGV4YW1w
bGUgZm9yIHRoZSAiY29ubmJ5dGVzIiBleHRlbnNpb24uDQoNClNpZ25lZC1v
ZmYtYnk6IEtyenlzenRvZiBQaW90ciBPbGVkemtpIDxvbGVAYW5zLnBsPg0K
DQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9uZXRmaWx0ZXIvbmZfY29u
bnRyYWNrX2NvbW1vbi5oIGIvaW5jbHVkZS9saW51eC9uZXRmaWx0ZXIvbmZf
Y29ubnRyYWNrX2NvbW1vbi5oDQppbmRleCA5ZTBkYWUwLi43YTI5OTM2IDEw
MDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC9uZXRmaWx0ZXIvbmZfY29ubnRy
YWNrX2NvbW1vbi5oDQorKysgYi9pbmNsdWRlL2xpbnV4L25ldGZpbHRlci9u
Zl9jb25udHJhY2tfY29tbW9uLmgNCkBAIC0xMjIsMTAgKzEyMiw2IEBAIGVu
dW0gaXBfY29ubnRyYWNrX2V2ZW50cw0KIAlJUENUX05BVElORk9fQklUID0g
MTAsDQogCUlQQ1RfTkFUSU5GTyA9ICgxIDw8IElQQ1RfTkFUSU5GT19CSVQp
LA0KIA0KLQkvKiBDb3VudGVyIGhpZ2hlc3QgYml0IGhhcyBiZWVuIHNldCAq
Lw0KLQlJUENUX0NPVU5URVJfRklMTElOR19CSVQgPSAxMSwNCi0JSVBDVF9D
T1VOVEVSX0ZJTExJTkcgPSAoMSA8PCBJUENUX0NPVU5URVJfRklMTElOR19C
SVQpLA0KLQ0KIAkvKiBNYXJrIGlzIHNldCAqLw0KIAlJUENUX01BUktfQklU
ID0gMTIsDQogCUlQQ1RfTUFSSyA9ICgxIDw8IElQQ1RfTUFSS19CSVQpLA0K
QEAgLTEzOSw4ICsxMzUsOCBAQCBlbnVtIGlwX2Nvbm50cmFja19leHBlY3Rf
ZXZlbnRzIHsNCiAjaWZkZWYgX19LRVJORUxfXw0KIHN0cnVjdCBpcF9jb25u
dHJhY2tfY291bnRlcg0KIHsNCi0JdV9pbnQzMl90IHBhY2tldHM7DQotCXVf
aW50MzJfdCBieXRlczsNCisJdV9pbnQ2NF90IHBhY2tldHM7DQorCXVfaW50
NjRfdCBieXRlczsNCiB9Ow0KIA0KIHN0cnVjdCBpcF9jb25udHJhY2tfc3Rh
dA0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvbmV0ZmlsdGVyL25mbmV0
bGlua19jb25udHJhY2suaCBiL2luY2x1ZGUvbGludXgvbmV0ZmlsdGVyL25m
bmV0bGlua19jb25udHJhY2suaA0KaW5kZXggZDdjMzUwMy4uNzVmM2RmOCAx
MDA2NDQNCi0tLSBhL2luY2x1ZGUvbGludXgvbmV0ZmlsdGVyL25mbmV0bGlu
a19jb25udHJhY2suaA0KKysrIGIvaW5jbHVkZS9saW51eC9uZXRmaWx0ZXIv
bmZuZXRsaW5rX2Nvbm50cmFjay5oDQpAQCAtOTMsMTAgKzkzLDEwIEBAIGVu
dW0gY3RhdHRyX3Byb3RvaW5mb190Y3Agew0KIA0KIGVudW0gY3RhdHRyX2Nv
dW50ZXJzIHsNCiAJQ1RBX0NPVU5URVJTX1VOU1BFQywNCi0JQ1RBX0NPVU5U
RVJTX1BBQ0tFVFMsCQkvKiBvbGQgNjRiaXQgY291bnRlcnMgKi8NCi0JQ1RB
X0NPVU5URVJTX0JZVEVTLAkJLyogb2xkIDY0Yml0IGNvdW50ZXJzICovDQot
CUNUQV9DT1VOVEVSUzMyX1BBQ0tFVFMsDQotCUNUQV9DT1VOVEVSUzMyX0JZ
VEVTLA0KKwlDVEFfQ09VTlRFUlNfUEFDS0VUUywJCS8qIDY0Yml0IGNvdW50
ZXJzICovDQorCUNUQV9DT1VOVEVSU19CWVRFUywJCS8qIDY0Yml0IGNvdW50
ZXJzICovDQorCUNUQV9DT1VOVEVSUzMyX1BBQ0tFVFMsCQkvKiAzMmJpdCBj
b3VudGVycywgdW51c2VkICovDQorCUNUQV9DT1VOVEVSUzMyX0JZVEVTLAkJ
LyogMzJiaXQgY291bnRlcnMsIHVudXNlZCAqLw0KIAlfX0NUQV9DT1VOVEVS
U19NQVgNCiB9Ow0KICNkZWZpbmUgQ1RBX0NPVU5URVJTX01BWCAoX19DVEFf
Q09VTlRFUlNfTUFYIC0gMSkNCmRpZmYgLS1naXQgYS9uZXQvbmV0ZmlsdGVy
L25mX2Nvbm50cmFja19jb3JlLmMgYi9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50
cmFja19jb3JlLmMNCmluZGV4IGFhMDg2YzguLjI1ZTAyN2YgMTAwNjQ0DQot
LS0gYS9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19jb3JlLmMNCisrKyBi
L25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2NvcmUuYw0KQEAgLTgwNiw5
ICs4MDYsNiBAQCB2b2lkIF9fbmZfY3RfcmVmcmVzaF9hY2N0KHN0cnVjdCBu
Zl9jb25uICpjdCwNCiAJCWN0LT5jb3VudGVyc1tDVElORk8yRElSKGN0aW5m
byldLmJ5dGVzICs9DQogCQkJc2tiLT5sZW4gLSBza2JfbmV0d29ya19vZmZz
ZXQoc2tiKTsNCiANCi0JCWlmICgoY3QtPmNvdW50ZXJzW0NUSU5GTzJESVIo
Y3RpbmZvKV0ucGFja2V0cyAmIDB4ODAwMDAwMDApDQotCQkgICAgfHwgKGN0
LT5jb3VudGVyc1tDVElORk8yRElSKGN0aW5mbyldLmJ5dGVzICYgMHg4MDAw
MDAwMCkpDQotCQkJZXZlbnQgfD0gSVBDVF9DT1VOVEVSX0ZJTExJTkc7DQog
CX0NCiAjZW5kaWYNCiANCmRpZmYgLS1naXQgYS9uZXQvbmV0ZmlsdGVyL25m
X2Nvbm50cmFja19uZXRsaW5rLmMgYi9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50
cmFja19uZXRsaW5rLmMNCmluZGV4IDZmODliMTAuLmI1MzI4NGYgMTAwNjQ0
DQotLS0gYS9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19uZXRsaW5rLmMN
CisrKyBiL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX25ldGxpbmsuYw0K
QEAgLTIwNCwxMyArMjA0LDEzIEBAIGN0bmV0bGlua19kdW1wX2NvdW50ZXJz
KHN0cnVjdCBza19idWZmICpza2IsIGNvbnN0IHN0cnVjdCBuZl9jb25uICpj
dCwNCiB7DQogCWVudW0gY3RhdHRyX3R5cGUgdHlwZSA9IGRpciA/IENUQV9D
T1VOVEVSU19SRVBMWTogQ1RBX0NPVU5URVJTX09SSUc7DQogCXN0cnVjdCBu
ZmF0dHIgKm5lc3RfY291bnQgPSBORkFfTkVTVChza2IsIHR5cGUpOw0KLQlf
X2JlMzIgdG1wOw0KKwlfX2JlNjQgdG1wOw0KIA0KLQl0bXAgPSBodG9ubChj
dC0+Y291bnRlcnNbZGlyXS5wYWNrZXRzKTsNCi0JTkZBX1BVVChza2IsIENU
QV9DT1VOVEVSUzMyX1BBQ0tFVFMsIHNpemVvZih1X2ludDMyX3QpLCAmdG1w
KTsNCisJdG1wID0gY3B1X3RvX2JlNjQoY3QtPmNvdW50ZXJzW2Rpcl0ucGFj
a2V0cyk7DQorCU5GQV9QVVQoc2tiLCBDVEFfQ09VTlRFUlNfUEFDS0VUUywg
c2l6ZW9mKF9fYmU2NCksICZ0bXApOw0KIA0KLQl0bXAgPSBodG9ubChjdC0+
Y291bnRlcnNbZGlyXS5ieXRlcyk7DQotCU5GQV9QVVQoc2tiLCBDVEFfQ09V
TlRFUlMzMl9CWVRFUywgc2l6ZW9mKHVfaW50MzJfdCksICZ0bXApOw0KKwl0
bXAgPSBjcHVfdG9fYmU2NChjdC0+Y291bnRlcnNbZGlyXS5ieXRlcyk7DQor
CU5GQV9QVVQoc2tiLCBDVEFfQ09VTlRFUlNfQllURVMsIHNpemVvZihfX2Jl
NjQpLCAmdG1wKTsNCiANCiAJTkZBX05FU1RfRU5EKHNrYiwgbmVzdF9jb3Vu
dCk7DQogDQpAQCAtMzk3LDEwICszOTcsNiBAQCBzdGF0aWMgaW50IGN0bmV0
bGlua19jb25udHJhY2tfZXZlbnQoc3RydWN0IG5vdGlmaWVyX2Jsb2NrICp0
aGlzLA0KIAkJCWdvdG8gbmZhdHRyX2ZhaWx1cmU7DQogI2VuZGlmDQogDQot
CQlpZiAoZXZlbnRzICYgSVBDVF9DT1VOVEVSX0ZJTExJTkcgJiYNCi0JCSAg
ICAoY3RuZXRsaW5rX2R1bXBfY291bnRlcnMoc2tiLCBjdCwgSVBfQ1RfRElS
X09SSUdJTkFMKSA8IDAgfHwNCi0JCSAgICAgY3RuZXRsaW5rX2R1bXBfY291
bnRlcnMoc2tiLCBjdCwgSVBfQ1RfRElSX1JFUExZKSA8IDApKQ0KLQkJCWdv
dG8gbmZhdHRyX2ZhaWx1cmU7DQogCX0NCiANCiAJbmxoLT5ubG1zZ19sZW4g
PSBza2ItPnRhaWwgLSBiOw0K

---187430788-453885848-1184971373=:7261--
