From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: connbytes & 64bit counters
Date: Mon, 25 Dec 2006 02:59:59 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0612250252060.27316@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0610250035100.23937@bizon.gios.gov.pl>
	<453FE325.1040502@trash.net>
	<Pine.LNX.4.64.0610281716090.19053@bizon.gios.gov.pl>
	<45462043.5010207@trash.net>
	<Pine.LNX.4.64.0610302055060.3941@bizon.gios.gov.pl>
	<4565AAC7.8050702@trash.net> <45660CD5.1090405@netfilter.org>
	<4566B6B6.4060808@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1912582748-1167011999=:27316"
Cc: netfilter-devel@lists.netfilter.org, Krzysztof Oledzki <olenf@ans.pl>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4566B6B6.4060808@trash.net>
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

---187430788-1912582748-1167011999=:27316
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 24 Nov 2006, Patrick McHardy wrote:

> Pablo Neira Ayuso wrote:
>> Patrick McHardy wrote:
>>
>>>> What is wrong in sending 64 bit counters to userspace if we already ha=
ve
>>>> 64 bit counters in kernel?
>>>
>>>
>>> Nothing - but changing the API based on config options is bad design.
>>> I am fine with sending 64 bit unconditionally. But you need to make
>>> sure you don't send (32 bit) overflow events to userspace anymore.
>>
>>
>> They could be used to notify 64 bits overflow events. Userspace can
>> differenciate if the kernel is using 32 or 64 bits and interpret the
>> overflow event appropiately.
>
>
> Mhh .. even with 100gbit it will take about 50 years to overflow.
> I don't think we really need this.
>
>> Hm, why not default on 64 bits counters but still give the choice to
>> select 32 bits at compilation time? Some advanced users could still want
>> to compile 32 bits to save some memory (perhaps embedded stuff guys), so
>> I have the impression that this issue will be revisited sooner or later.
>> I can give a hand to Krzysztof and improve the patch to make it look
>> cleaner, although we will still need some ifdef's. Still not convinced?
>
>
> Config options for things like this are silly in my opinion, if we
> really want to save memory these counters should be selectable at
> runtime, most people don't need them, but distributions will probably
> enable them anyway (if not already then once programs using them
> appear). And people using them don't save anything, they have to
> keep copies in userspace to handle overflows, which needs even more
> memory.
>
> Given that their use of the 32 bit counters in libnetfilter_conntrack
> is broken anyway (incorrect byte order conversion) I think we should
> just get rid of them.

OK, maybe something like this can be accepted - no ifdefs, 64 bit=20
counters unconditionally for both ip_conntrack/nf_conntrack. If someone=20
needs to save memory it is IMHO better to simply disable accounting at=20
all.

[NETFILTER] Reimplementation of 64bit counters for bytes/packets accounting

Initially netfilter has had 64bit counters for conntrack-based accounting, =
but
it was changed in 2.6.14 to save memory. Unfortunately in-kernel 64bit coun=
ters are
still required, for example with "connbytes" extension.

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>

diff -Nur linux-2.6.19.1-orig/include/linux/netfilter/nf_conntrack_common.h=
 linux-2.6.19.1-64bitconntrack/include/linux/netfilter/nf_conntrack_common.=
h
--- linux-2.6.19.1-orig/include/linux/netfilter/nf_conntrack_common.h=09200=
6-12-11 20:32:53.000000000 +0100
+++ linux-2.6.19.1-64bitconntrack/include/linux/netfilter/nf_conntrack_comm=
on.h=092006-12-22 21:15:10.000000000 +0100
@@ -122,7 +122,7 @@
  =09IPCT_NATINFO_BIT =3D 10,
  =09IPCT_NATINFO =3D (1 << IPCT_NATINFO_BIT),

-=09/* Counter highest bit has been set */
+=09/* Counter highest bit has been set - UNUSED */
  =09IPCT_COUNTER_FILLING_BIT =3D 11,
  =09IPCT_COUNTER_FILLING =3D (1 << IPCT_COUNTER_FILLING_BIT),

@@ -139,8 +139,8 @@
  #ifdef __KERNEL__
  struct ip_conntrack_counter
  {
-=09u_int32_t packets;
-=09u_int32_t bytes;
+=09u_int64_t packets;
+=09u_int64_t bytes;
  };

  struct ip_conntrack_stat
diff -Nur linux-2.6.19.1-orig/include/linux/netfilter/nfnetlink_conntrack.h=
 linux-2.6.19.1-64bitconntrack/include/linux/netfilter/nfnetlink_conntrack.=
h
--- linux-2.6.19.1-orig/include/linux/netfilter/nfnetlink_conntrack.h=09200=
6-12-11 20:32:53.000000000 +0100
+++ linux-2.6.19.1-64bitconntrack/include/linux/netfilter/nfnetlink_conntra=
ck.h=092006-12-22 21:15:26.000000000 +0100
@@ -89,10 +89,10 @@

  enum ctattr_counters {
  =09CTA_COUNTERS_UNSPEC,
-=09CTA_COUNTERS_PACKETS,=09=09/* old 64bit counters */
-=09CTA_COUNTERS_BYTES,=09=09/* old 64bit counters */
-=09CTA_COUNTERS32_PACKETS,
-=09CTA_COUNTERS32_BYTES,
+=09CTA_COUNTERS_PACKETS,=09=09/* 64bit counters */
+=09CTA_COUNTERS_BYTES,=09=09/* 64bit counters */
+=09CTA_COUNTERS32_PACKETS,=09=09/* unused */
+=09CTA_COUNTERS32_BYTES,=09=09/* unused */
  =09__CTA_COUNTERS_MAX
  };
  #define CTA_COUNTERS_MAX (__CTA_COUNTERS_MAX - 1)
diff -Nur linux-2.6.19.1-orig/net/ipv4/netfilter/ip_conntrack_core.c linux-=
2.6.19.1-64bitconntrack/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.6.19.1-orig/net/ipv4/netfilter/ip_conntrack_core.c=092006-12-11=
 20:32:53.000000000 +0100
+++ linux-2.6.19.1-64bitconntrack/net/ipv4/netfilter/ip_conntrack_core.c=09=
2006-12-22 21:13:35.000000000 +0100
@@ -1148,9 +1148,6 @@
  =09=09ct->counters[CTINFO2DIR(ctinfo)].packets++;
  =09=09ct->counters[CTINFO2DIR(ctinfo)].bytes +=3D
  =09=09=09=09=09=09ntohs(skb->nh.iph->tot_len);
-=09=09if ((ct->counters[CTINFO2DIR(ctinfo)].packets & 0x80000000)
-=09=09    || (ct->counters[CTINFO2DIR(ctinfo)].bytes & 0x80000000))
-=09=09=09event |=3D IPCT_COUNTER_FILLING;
  =09}
  #endif

diff -Nur linux-2.6.19.1-orig/net/ipv4/netfilter/ip_conntrack_netlink.c lin=
ux-2.6.19.1-64bitconntrack/net/ipv4/netfilter/ip_conntrack_netlink.c
--- linux-2.6.19.1-orig/net/ipv4/netfilter/ip_conntrack_netlink.c=092006-12=
-11 20:32:53.000000000 +0100
+++ linux-2.6.19.1-64bitconntrack/net/ipv4/netfilter/ip_conntrack_netlink.c=
=092006-12-22 21:12:15.000000000 +0100
@@ -186,13 +186,13 @@
  {
  =09enum ctattr_type type =3D dir ? CTA_COUNTERS_REPLY: CTA_COUNTERS_ORIG;
  =09struct nfattr *nest_count =3D NFA_NEST(skb, type);
-=09__be32 tmp;
+=09__be64 tmp;

-=09tmp =3D htonl(ct->counters[dir].packets);
-=09NFA_PUT(skb, CTA_COUNTERS32_PACKETS, sizeof(__be32), &tmp);
+=09tmp =3D cpu_to_be64(ct->counters[dir].packets);
+=09NFA_PUT(skb, CTA_COUNTERS_PACKETS, sizeof(__be64), &tmp);

-=09tmp =3D htonl(ct->counters[dir].bytes);
-=09NFA_PUT(skb, CTA_COUNTERS32_BYTES, sizeof(__be32), &tmp);
+=09tmp =3D cpu_to_be64(ct->counters[dir].bytes);
+=09NFA_PUT(skb, CTA_COUNTERS_BYTES, sizeof(__be64), &tmp);

  =09NFA_NEST_END(skb, nest_count);

diff -Nur linux-2.6.19.1-orig/net/netfilter/nf_conntrack_core.c linux-2.6.1=
9.1-64bitconntrack/net/netfilter/nf_conntrack_core.c
--- linux-2.6.19.1-orig/net/netfilter/nf_conntrack_core.c=092006-12-11 20:3=
2:53.000000000 +0100
+++ linux-2.6.19.1-64bitconntrack/net/netfilter/nf_conntrack_core.c=092006-=
12-22 21:13:55.000000000 +0100
@@ -1411,9 +1411,6 @@
  =09=09ct->counters[CTINFO2DIR(ctinfo)].packets++;
  =09=09ct->counters[CTINFO2DIR(ctinfo)].bytes +=3D
  =09=09=09skb->len - (unsigned int)(skb->nh.raw - skb->data);
-=09if ((ct->counters[CTINFO2DIR(ctinfo)].packets & 0x80000000)
-=09    || (ct->counters[CTINFO2DIR(ctinfo)].bytes & 0x80000000))
-=09=09event |=3D IPCT_COUNTER_FILLING;
  =09}
  #endif

diff -Nur linux-2.6.19.1-orig/net/netfilter/nf_conntrack_netlink.c linux-2.=
6.19.1-64bitconntrack/net/netfilter/nf_conntrack_netlink.c
--- linux-2.6.19.1-orig/net/netfilter/nf_conntrack_netlink.c=092006-12-11 2=
0:32:53.000000000 +0100
+++ linux-2.6.19.1-64bitconntrack/net/netfilter/nf_conntrack_netlink.c=0920=
06-12-22 21:13:11.000000000 +0100
@@ -195,13 +195,13 @@
  {
  =09enum ctattr_type type =3D dir ? CTA_COUNTERS_REPLY: CTA_COUNTERS_ORIG;
  =09struct nfattr *nest_count =3D NFA_NEST(skb, type);
-=09u_int32_t tmp;
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
---187430788-1912582748-1167011999=:27316
Content-Type: APPLICATION/octet-stream; name=netfilter-64bitcounters.patch.gz
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0612250259590.27316@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=netfilter-64bitcounters.patch.gz

H4sIAGMvj0UCA91XbU/iShT+TH/FyW6yAWmBFuQqvlxdxBuitxLA5G42m6aU
qUwsU7adqrjuf79nplB5B0W9yW0C086c1+lzzjP9btba5/XLdq35A5qE9gce
6RPGbU59Br4L5VKHcnD8iHEShOD6AXSGnIT5ge3cEh6C7chFym4Upc4op7bn
DYER7lIPVaBnh/jrLjLk+IzxAO1oHTsk3QlTKnQirqD8PWo7PZvd4DJlYOTK
Ob0E3IfQviPQJ30/GObgmqE5HjGbE/RNmXZLAka8WZ92QJSQU8+DgPyMaEC6
qoyDPNgib7invAefRFQyxU+4wAkLcSdyitKiN4x0Nd91tc6wAhfB4zB85LhD
DerzAK480n28pXDoe+TEZmFu4B0rSpe6LmhmFIBHWfSgyfj3c7rmB/QmT5nj
RV2Sl2v5ZMvyzLWSrcG7fh8D6M1akLklYi+zpWiatn1EKaNQKGu6oek6GIVK
0ajsFnOF8QXZgl4oKNls9i0jT3waBhh6Rd+t6IU5nycngCKG+gdk4+HkRIFU
vVFtW+Zpu26eX1lf6204Ar2gzizgZFqHw0OYlc6gpKKl8jtQjeEEPXrTIyEH
ATEB8g4hDELCYSevZDcS1ODavG7VzoTGKIzq1bWJtWhhSV7Wzb/GcerqEoHp
eBdoy7jlhhT31T3cEDmIDflM3S5xwbIuak2zdmlZCoQ8iBwOdDC18zILBX5h
+pFFGS8aFodR+R9MTcqyOcDs5VS5NCk3OTmSg9/4W+w1xA706urBe5y8fTa3
RfUssPWK6llg5d2rZ5XPpHqM8sLq2dtXdXyOBwEWBQiL+uDga+GBlXTUXwjL
avt0DLyWdW22GrWqiqiYmm6cVi9q7ZaaEnXhe3NsgAUwo/H1W7v2AnmE39jH
/EpsCxG4PKZ5+9ml8ayTnYhFykcsEuy2SG7C6rMUpCxryvffp//EtfIZC5Yy
ArOrkJ7XwO6iZ9aUEEIkTwd3pQnczNR+QHLOGgRuZmRp0Wym/kbV8kJnozIp
Voq7i0lGL+2p+9hUxViOaSblcO14DI7vVUkgxlm9mXbwYOP6mR+5UUvMZg82
EpfNErJHIKTFxbjfC9PhbUc7Zr0cHfS0Y+5zyyMsI9pxirqQTm8aBXyBwsPe
KLWMUAe8np4gvWFgU/rSQIrc4QkSno4WkpJI+jdCmTDEJjaW7RA6anJbgzSx
82qcJhY+CKrz/kZoNbCvL0brXlnVi4jWeBRoFf17srHz4YCA/DuCLg3gz+lW
06w1Lr9VpueumnX5TkcszlxhCHYYnnhinkBT5vmpZdZabQFaVdqXSLWsDika
wPsDcTwQT+VS/CSOWniDqj3uM28aixhYAl9pR5hvXI+sL+nEENJH4rvp2GdG
hS9oPyP8xn6cQWRxX4aw0lt2ubeFvsqlZ1/rs5IltTanmDW2y2jsaVU+836m
s4HU+MVaNfMsNvD83qXI+upeeuDfkHpW6q+s5pWab1jFm/lJuGZ3SfWW8CtA
cI0Y35trJNVIhkFWwZNEOsLPYPH9ix/XPJNwT2Df46J86trclsDdjn22Jp83
5p4l7+4ltLPOxGsw+h5ks7GrBKm6vhip+7sxz8Tjf88zzx+oH0o1idv/E9u8
OqkPIpx/AfInxs7QFAAA

---187430788-1912582748-1167011999=:27316--
