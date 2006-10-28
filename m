From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: connbytes & 64bit counters
Date: Sat, 28 Oct 2006 18:48:55 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0610281716090.19053@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0610250035100.23937@bizon.gios.gov.pl>
	<453FE325.1040502@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-377081269-1162054135=:19053"
Cc: netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <453FE325.1040502@trash.net>
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

---187430788-377081269-1162054135=:19053
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 26 Oct 2006, Patrick McHardy wrote:

> Krzysztof Oledzki wrote:
>> Hello,
>>
>> It seems there is something wrong with connbytes and 64bit conters.
>>
>> The "iptables" manual mention that counters are 64bit, so there should
>> be no problem with overflows, but it seems it might not be true. My
>> firewall puts long living ftp & http connections to a different TC class
>> when they reach 256MB, but aftear they reach 4GB (probably) they go back
>> to the default class, with no speed limit.
>>
>> After some researches I found that ip_conntrack_counter structure
>> defined in nf_conntrack_common.h uses u_int32_t. I always thought that
>> netfilter has 64bit counters, hasn't it? And I'm quite sure it used to
>> work when I set up my firewall, about 1 year ago. Stange...
>
>
> It was changed to save some memory in struct ip_conntrack.
> The idea was mainly that its only used for ctnetlink and
> it is possible to send events before overflow. Obviously,
> this wasn't true (besides the fact that events are unreliable).
> Not sure what we should do about it ..

How about attached (and inlined for easy review) patch?

[NETFILTER] Reimplementation of 64bit counters for bytes/packets accounting

Initially netfilter has had 64bit counters for conntrack-based accounting, =
but
it was changed in 2.6.14 to save memory. Unfortunately in-kernel 64bit coun=
ters are
still required, for example for "connbytes" extension. Add possibility to c=
hoose
between 32 and 64bits but keep default 32bit counters.

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>

diff -Nur linux-2.6.19-rc3-orig/include/linux/netfilter/nf_conntrack_common=
=2Eh linux-2.6.19-rc3/include/linux/netfilter/nf_conntrack_common.h
--- linux-2.6.19-rc3-orig/include/linux/netfilter/nf_conntrack_common.h=092=
006-10-24 01:02:02.000000000 +0200
+++ linux-2.6.19-rc3/include/linux/netfilter/nf_conntrack_common.h=092006-1=
0-28 17:42:48.000000000 +0200
@@ -139,8 +139,13 @@
  #ifdef __KERNEL__
  struct ip_conntrack_counter
  {
+#if defined(CONFIG_IP_NF_CT_ACCT_64BIT_COUNTERS) || defined(CONFIG_NF_CT_A=
CCT_64BIT_COUNTERS)
+=09u_int64_t packets;
+=09u_int64_t bytes;
+#else
  =09u_int32_t packets;
  =09u_int32_t bytes;
+#endif
  };

  struct ip_conntrack_stat
diff -Nur linux-2.6.19-rc3-orig/include/linux/netfilter/nfnetlink_conntrack=
=2Eh linux-2.6.19-rc3/include/linux/netfilter/nfnetlink_conntrack.h
--- linux-2.6.19-rc3-orig/include/linux/netfilter/nfnetlink_conntrack.h=092=
006-10-24 01:02:02.000000000 +0200
+++ linux-2.6.19-rc3/include/linux/netfilter/nfnetlink_conntrack.h=092006-1=
0-25 14:55:19.000000000 +0200
@@ -89,8 +89,8 @@

  enum ctattr_counters {
  =09CTA_COUNTERS_UNSPEC,
-=09CTA_COUNTERS_PACKETS,=09=09/* old 64bit counters */
-=09CTA_COUNTERS_BYTES,=09=09/* old 64bit counters */
+=09CTA_COUNTERS_PACKETS,=09=09/* optional 64bit counters */
+=09CTA_COUNTERS_BYTES,=09=09/* optional 64bit counters */
  =09CTA_COUNTERS32_PACKETS,
  =09CTA_COUNTERS32_BYTES,
  =09__CTA_COUNTERS_MAX
diff -Nur linux-2.6.19-rc3-orig/net/ipv4/netfilter/Kconfig linux-2.6.19-rc3=
/net/ipv4/netfilter/Kconfig
--- linux-2.6.19-rc3-orig/net/ipv4/netfilter/Kconfig=092006-10-24 01:02:02.=
000000000 +0200
+++ linux-2.6.19-rc3/net/ipv4/netfilter/Kconfig=092006-10-28 18:44:16.00000=
0000 +0200
@@ -46,6 +46,21 @@

  =09  If unsure, say `N'.

+config IP_NF_CT_ACCT_64BIT_COUNTERS
+=09bool 'Enable 64bit counters for conntrack-based accounting'
+=09depends on IP_NF_CT_ACCT
+=09default n
+=09help
+=09  Use 64 bit counters for bytes/packets accounting instead of default 3=
2.
+
+=09  This will make every connection entry larger by 16 bytes, enlarging
+=09  it by about 5%.
+=20
+=09  Say Y if you have plenty of RAM and want to be able to detect
+=09  long-lived connections, using for example "connbytes" extension.
+
+=09  If unsure, say N.
+
  config IP_NF_CONNTRACK_MARK
  =09bool  'Connection mark tracking support'
  =09depends on IP_NF_CONNTRACK
diff -Nur linux-2.6.19-rc3-orig/net/ipv4/netfilter/ip_conntrack_core.c linu=
x-2.6.19-rc3/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.6.19-rc3-orig/net/ipv4/netfilter/ip_conntrack_core.c=092006-10-=
24 01:02:02.000000000 +0200
+++ linux-2.6.19-rc3/net/ipv4/netfilter/ip_conntrack_core.c=092006-10-28 17=
:44:28.000000000 +0200
@@ -1148,9 +1148,15 @@
  =09=09ct->counters[CTINFO2DIR(ctinfo)].packets++;
  =09=09ct->counters[CTINFO2DIR(ctinfo)].bytes +=3D
  =09=09=09=09=09=09ntohs(skb->nh.iph->tot_len);
+#ifdef CONFIG_IP_NF_CT_ACCT_64BIT_COUNTERS
+=09=09if ((ct->counters[CTINFO2DIR(ctinfo)].packets & 0x8000000000000000LL=
)
+=09=09   || (ct->counters[CTINFO2DIR(ctinfo)].bytes & 0x8000000000000000LL=
))
+=09=09=09event |=3D IPCT_COUNTER_FILLING;
+#else
  =09=09if ((ct->counters[CTINFO2DIR(ctinfo)].packets & 0x80000000)
  =09=09    || (ct->counters[CTINFO2DIR(ctinfo)].bytes & 0x80000000))
  =09=09=09event |=3D IPCT_COUNTER_FILLING;
+#endif
  =09}
  #endif

diff -Nur linux-2.6.19-rc3-orig/net/ipv4/netfilter/ip_conntrack_netlink.c l=
inux-2.6.19-rc3/net/ipv4/netfilter/ip_conntrack_netlink.c
--- linux-2.6.19-rc3-orig/net/ipv4/netfilter/ip_conntrack_netlink.c=092006-=
10-24 01:02:02.000000000 +0200
+++ linux-2.6.19-rc3/net/ipv4/netfilter/ip_conntrack_netlink.c=092006-10-28=
 18:23:06.000000000 +0200
@@ -185,6 +185,15 @@
  {
  =09enum ctattr_type type =3D dir ? CTA_COUNTERS_REPLY: CTA_COUNTERS_ORIG;
  =09struct nfattr *nest_count =3D NFA_NEST(skb, type);
+#ifdef CONFIG_IP_NF_CT_ACCT_64BIT_COUNTERS
+=09__be64 tmp;
+
+=09tmp =3D cpu_to_be64(ct->counters[dir].packets);
+=09NFA_PUT(skb, CTA_COUNTERS_PACKETS, sizeof(__be64), &tmp);
+
+=09tmp =3D cpu_to_be64(ct->counters[dir].bytes);
+=09NFA_PUT(skb, CTA_COUNTERS_BYTES, sizeof(__be64), &tmp);
+#else
  =09__be32 tmp;

  =09tmp =3D htonl(ct->counters[dir].packets);
@@ -192,6 +201,7 @@

  =09tmp =3D htonl(ct->counters[dir].bytes);
  =09NFA_PUT(skb, CTA_COUNTERS32_BYTES, sizeof(__be32), &tmp);
+#endif

  =09NFA_NEST_END(skb, nest_count);

diff -Nur linux-2.6.19-rc3-orig/net/netfilter/Kconfig linux-2.6.19-rc3/net/=
netfilter/Kconfig
--- linux-2.6.19-rc3-orig/net/netfilter/Kconfig=092006-10-24 01:02:02.00000=
0000 +0200
+++ linux-2.6.19-rc3/net/netfilter/Kconfig=092006-10-28 18:43:54.000000000 =
+0200
@@ -51,6 +51,21 @@

  =09  If unsure, say `N'.

+config NF_CT_ACCT_64BIT_COUNTERS
+=09bool 'Enable 64bit counters for conntrack-based accounting'
+=09depends on NF_CT_ACCT
+=09default n
+=09help
+=09  Use 64 bit counters for bytes/packets accounting instead of default 3=
2.
+
+=09  This will make every connection entry larger by 16 bytes, enlarging
+=09  it by about 5%.
+=20
+=09  Say Y if you have plenty of RAM and want to be able to detect
+=09  long-lived connections, using for example "connbytes" extension.
+
+=09  If unsure, say N.
+
  config NF_CONNTRACK_MARK
  =09bool  'Connection mark tracking support'
  =09depends on NF_CONNTRACK
diff -Nur linux-2.6.19-rc3-orig/net/netfilter/nf_conntrack_core.c linux-2.6=
=2E19-rc3/net/netfilter/nf_conntrack_core.c
--- linux-2.6.19-rc3-orig/net/netfilter/nf_conntrack_core.c=092006-10-24 01=
:02:02.000000000 +0200
+++ linux-2.6.19-rc3/net/netfilter/nf_conntrack_core.c=092006-10-28 17:44:1=
1.000000000 +0200
@@ -1412,9 +1412,15 @@
  =09=09ct->counters[CTINFO2DIR(ctinfo)].packets++;
  =09=09ct->counters[CTINFO2DIR(ctinfo)].bytes +=3D
  =09=09=09skb->len - (unsigned int)(skb->nh.raw - skb->data);
+#ifdef CONFIG_NF_CT_ACCT_64BIT_COUNTERS
+=09if ((ct->counters[CTINFO2DIR(ctinfo)].packets & 0x8000000000000000LL)
+=09    || (ct->counters[CTINFO2DIR(ctinfo)].bytes & 0x8000000000000000LL))
+=09=09event |=3D IPCT_COUNTER_FILLING;
+#else
  =09if ((ct->counters[CTINFO2DIR(ctinfo)].packets & 0x80000000)
  =09    || (ct->counters[CTINFO2DIR(ctinfo)].bytes & 0x80000000))
  =09=09event |=3D IPCT_COUNTER_FILLING;
+#endif
  =09}
  #endif

diff -Nur linux-2.6.19-rc3-orig/net/netfilter/nf_conntrack_netlink.c linux-=
2.6.19-rc3/net/netfilter/nf_conntrack_netlink.c
--- linux-2.6.19-rc3-orig/net/netfilter/nf_conntrack_netlink.c=092006-10-24=
 01:02:02.000000000 +0200
+++ linux-2.6.19-rc3/net/netfilter/nf_conntrack_netlink.c=092006-10-28 18:2=
4:12.000000000 +0200
@@ -194,13 +194,23 @@
  {
  =09enum ctattr_type type =3D dir ? CTA_COUNTERS_REPLY: CTA_COUNTERS_ORIG;
  =09struct nfattr *nest_count =3D NFA_NEST(skb, type);
-=09u_int32_t tmp;
+#ifdef CONFIG_NF_CT_ACCT_64BIT_COUNTERS
+=09__be64 tmp;
+
+=09tmp =3D cpu_to_be64(ct->counters[dir].packets);
+=09NFA_PUT(skb, CTA_COUNTERS_PACKETS, sizeof(__be64), &tmp);
+
+=09tmp =3D cpu_to_be64(ct->counters[dir].bytes);
+=09NFA_PUT(skb, CTA_COUNTERS_BYTES, sizeof(__be64), &tmp);
+#else
+=09__be32 tmp;

  =09tmp =3D htonl(ct->counters[dir].packets);
-=09NFA_PUT(skb, CTA_COUNTERS32_PACKETS, sizeof(u_int32_t), &tmp);
+=09NFA_PUT(skb, CTA_COUNTERS32_PACKETS, sizeof(__be32), &tmp);

  =09tmp =3D htonl(ct->counters[dir].bytes);
-=09NFA_PUT(skb, CTA_COUNTERS32_BYTES, sizeof(u_int32_t), &tmp);
+=09NFA_PUT(skb, CTA_COUNTERS32_BYTES, sizeof(__be32), &tmp);
+#endif

  =09NFA_NEST_END(skb, nest_count);

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-377081269-1162054135=:19053
Content-Type: APPLICATION/octet-stream; name=netfilter-64bitcounters-patch.gz
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0610281848550.19053@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=netfilter-64bitcounters-patch.gz

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

---187430788-377081269-1162054135=:19053--
