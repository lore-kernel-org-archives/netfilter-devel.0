From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: iptables 1.3.7, kernel 2.6.19, ROUTE and Layer7 issues
Date: Thu, 28 Dec 2006 22:10:01 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0612282158360.16672@bizon.gios.gov.pl>
References: <54905.84.123.236.132.1165866276.squirrel@www.arcoscom.com>
	<57631.195.55.244.106.1165911878.squirrel@www.arcoscom.com>
	<457E6997.1050001@trash.net>
	<36479.195.55.244.106.1165998665.squirrel@www.arcoscom.com>
	<457FBBFD.6060009@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-2127577695-1167340201=:16672"
Cc: lartc@mailman.ds9a.nl, netfilter-devel@lists.netfilter.org,
	linux@arcoscom.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <457FBBFD.6060009@trash.net>
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

---187430788-2127577695-1167340201=:16672
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 13 Dec 2006, Patrick McHardy wrote:

> ArcosCom Linux User wrote:
>> Thanks for your response.
>>
>> I'm using multiple gateways for internet connection and having problems
>> with random disconection, and I not use ROUTE usually, but I was trying =
to
>> force only one gateway for one type of traffic (which the clients lost
>> conections and are having issues).
>>
>> I know I can use -j MARK or -j CONNMARK and this mark to filter, but I'm
>> using marks for another purposes and I can't use it for routing.
>
> Everything using marks supports bitmasks in 2.6.19.
>
>> The box is a dual xeon and the kernel has been compiled SMP enabled.
>>
>> I haven't tested ROUTE yet with this kernel (2.6.19), but with 2.6.18.x =
I
>> were having a problem with -j ROUTE in -t mangle and POSTROUTING chain.
>>
>> Perhaps ROUTE need a more in deepth revision?
>
> As I said, it needs to fill in the targetsize field and probably needs
> to adjust the target function signature.
>
>> Do I help more reporting the bug into netfilter-bugzilla?
>
> Its still down, but the ROUTE patch is unmaintained anyway.

How about attached (and inlined) patch. BTW - is it possible to add a=20
Kconfig entry after a specific text, like with Makefile.ladd?


[POM-NG] ROUTE: 2.6.19 compatibility fix

Make both IPv4 and IPv6 versions compatible with 2.6.19

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>

diff -Nur patch-o-matic-ng-20061221-orig/patchlets/ROUTE/linux-2.6/net/ipv4=
/netfilter/ipt_ROUTE.c patch-o-matic-ng-20061221/patchlets/ROUTE/linux-2.6/=
net/ipv4/netfilter/ipt_ROUTE.c
--- patch-o-matic-ng-20061221-orig/patchlets/ROUTE/linux-2.6/net/ipv4/netfi=
lter/ipt_ROUTE.c=092006-07-22 16:07:52.000000000 +0200
+++ patch-o-matic-ng-20061221/patchlets/ROUTE/linux-2.6/net/ipv4/netfilter/=
ipt_ROUTE.c=092006-12-28 21:13:07.000000000 +0100
@@ -17,6 +17,7 @@
  #include <linux/netfilter_ipv4/ipt_ROUTE.h>
  #include <linux/netdevice.h>
  #include <linux/route.h>
+#include <linux/version.h>
  #include <linux/if_arp.h>
  #include <net/ip.h>
  #include <net/route.h>
@@ -280,9 +281,15 @@
  =09=09=09=09     const struct net_device *in,
  =09=09=09=09     const struct net_device *out,
  =09=09=09=09     unsigned int hooknum,
+#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,17)
  =09=09=09=09     const struct xt_target *target,
+#endif
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)
  =09=09=09=09     const void *targinfo,
  =09=09=09=09     void *userinfo)
+#else
+=09=09=09=09     const void *targinfo)
+#endif
  {
  =09const struct ipt_route_target_info *route_info =3D targinfo;
  =09struct sk_buff *skb =3D *pskb;
@@ -401,10 +408,18 @@


  static int ipt_route_checkentry(const char *tablename,
+#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,16)
  =09=09=09=09const void *e,
+#else
+=09=09=09=09const struct ipt_ip *ip,
+#endif
+#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,17)
  =09=09=09=09const struct xt_target *target,
+#endif
  =09=09=09=09void *targinfo,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)
  =09=09=09=09unsigned int targinfosize,
+#endif
  =09=09=09=09unsigned int hook_mask)
  {
  =09if (strcmp(tablename, "mangle") !=3D 0) {
@@ -422,12 +437,14 @@
  =09=09return 0;
  =09}

+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)
  =09if (targinfosize !=3D IPT_ALIGN(sizeof(struct ipt_route_target_info)))=
 {
  =09=09printk(KERN_WARNING "ipt_ROUTE: targinfosize %u !=3D %Zu\n",
  =09=09       targinfosize,
  =09=09       IPT_ALIGN(sizeof(struct ipt_route_target_info)));
  =09=09return 0;
  =09}
+#endif

  =09return 1;
  }
@@ -436,7 +453,9 @@
  static struct ipt_target ipt_route_reg =3D {
  =09.name =3D "ROUTE",
  =09.target =3D ipt_route_target,
+#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,17)
  =09.targetsize =3D sizeof(struct ipt_route_target_info),
+#endif
  =09.checkentry =3D ipt_route_checkentry,
  =09.me =3D THIS_MODULE,
  };
diff -Nur patch-o-matic-ng-20061221-orig/patchlets/ROUTE/linux-2.6/net/ipv6=
/netfilter/Kconfig.ladd patch-o-matic-ng-20061221/patchlets/ROUTE/linux-2.6=
/net/ipv6/netfilter/Kconfig.ladd
--- patch-o-matic-ng-20061221-orig/patchlets/ROUTE/linux-2.6/net/ipv6/netfi=
lter/Kconfig.ladd=092004-05-06 14:41:19.000000000 +0200
+++ patch-o-matic-ng-20061221/patchlets/ROUTE/linux-2.6/net/ipv6/netfilter/=
Kconfig.ladd=092006-12-28 19:07:03.000000000 +0100
@@ -1,5 +1,5 @@
  config IP6_NF_TARGET_ROUTE
-=09tristate '    ROUTE target support'
+=09tristate 'ROUTE target support'
  =09depends on IP6_NF_MANGLE
  =09help
  =09  This option adds a `ROUTE' target, which enables you to setup unusua=
l
diff -Nur patch-o-matic-ng-20061221-orig/patchlets/ROUTE/linux-2.6/net/ipv6=
/netfilter/ip6t_ROUTE.c patch-o-matic-ng-20061221/patchlets/ROUTE/linux-2.6=
/net/ipv6/netfilter/ip6t_ROUTE.c
--- patch-o-matic-ng-20061221-orig/patchlets/ROUTE/linux-2.6/net/ipv6/netfi=
lter/ip6t_ROUTE.c=092006-08-08 11:56:40.000000000 +0200
+++ patch-o-matic-ng-20061221/patchlets/ROUTE/linux-2.6/net/ipv6/netfilter/=
ip6t_ROUTE.c=092006-12-28 21:13:16.000000000 +0100
@@ -15,6 +15,7 @@
  #include <linux/netfilter_ipv6/ip6_tables.h>
  #include <linux/netfilter_ipv6/ip6t_ROUTE.h>
  #include <linux/netdevice.h>
+#include <linux/version.h>
  #include <net/ipv6.h>
  #include <net/ndisc.h>
  #include <net/ip6_route.h>
@@ -192,9 +193,15 @@
  =09=09  const struct net_device *in,
  =09=09  const struct net_device *out,
  =09=09  unsigned int hooknum,
+#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,17)
  =09=09  const struct xt_target *target,
+#endif
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)
  =09=09  const void *targinfo,
  =09=09  void *userinfo)
+#else
+=09=09  const void *targinfo)
+#endif
  {
  =09const struct ip6t_route_target_info *route_info =3D targinfo;
  =09struct sk_buff *skb =3D *pskb;
@@ -260,10 +267,18 @@

  static int
  ip6t_route_checkentry(const char *tablename,
+#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,16)
  =09=09      const void *entry,
+#else
+=09=09      const struct ip6t_entry *entry
+#endif
+#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,17)
  =09=09      const struct xt_target *target,
+#endif
  =09=09      void *targinfo,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)
  =09=09      unsigned int targinfosize,
+#endif
  =09=09      unsigned int hook_mask)
  {
  =09if (strcmp(tablename, "mangle") !=3D 0) {
@@ -271,12 +286,14 @@
  =09=09return 0;
  =09}

+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)
  =09if (targinfosize !=3D IP6T_ALIGN(sizeof(struct ip6t_route_target_info)=
)) {
  =09=09printk(KERN_WARNING "ip6t_ROUTE: targinfosize %u !=3D %Zu\n",
  =09=09       targinfosize,
  =09=09       IP6T_ALIGN(sizeof(struct ip6t_route_target_info)));
  =09=09return 0;
  =09}
+#endif

  =09return 1;
  }
@@ -285,7 +302,9 @@
  static struct ip6t_target ip6t_route_reg =3D {
  =09.name       =3D "ROUTE",
  =09.target     =3D ip6t_route_target,
+#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,17)
  =09.targetsize =3D sizeof(struct ip6t_route_target_info),
+#endif
  =09.checkentry =3D ip6t_route_checkentry,
  =09.me         =3D THIS_MODULE
  };

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-2127577695-1167340201=:16672
Content-Type: APPLICATION/octet-stream; name=ROUTE-2.6.19-compat.patch.gz
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0612282210010.16672@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=ROUTE-2.6.19-compat.patch.gz

H4sIADgylEUCA72X+1PiSBDHf5a/os+rLUESTAIMD3VLa5fzKBUsH3dX96hc
DANMEZJUMnHVLf/365kECC8FFi67JTDT6W/3TPfkk79u2tdq6+IfuG0/3Dfq
YBRIQa+B7Q19i7NH5jD+Al32nMlcWwMKjx7vQ/PmqQSW2xFfCDzRIGSeG47v
cSh8Y2gWu8pk7ljPpR3V63bVx5c6XAavL+Er97pwwzweQNuhndcBgxPPoWeW
GxZ853Mm02HdLqitKAD0afdVTx2ib1t1e6qhaUQ3DF31AtY7ktMO5eGRzODI
YW70rKL2kUv5EfOfSuJLlzmcBviTm9KsYC/3u7HLjKqquwp3T7hRtYpqGKCT
ulapl42CNrogr+F8Jp/P7yCtWFo3VKMKhl7Xi6g+Ja2j9NkZqHpFIZDHvxU4
O8vAz8y1nahD4UQqTZybUmui0P+80LhDn5hNF84GXsTlTH52JqnGhXexrmkF
/sxUnPuCwbGGSM2oakoN8kZVV/SyzG4PLxCXjbXPIeRBZHPAG804bjhkrrKK
Gcqk7SI3lP0CzOXQ97yBGw0VkWcXrpqthz/M3xq3d812y/zS/tqAz6dw2bht
Na5Gw1lDIYpeyS1TfuYmt4Ie5XAYfwrf1MV2W6pxslCiNi/x5LFO7Ja5XS+d
VDwThTQQMzkh6YQ0k3/XQW4cGXxHX1NpiOKRG5RkY4ob4DAekt9PYeTnGG9O
bgsH5mOEB8thOHhEi0MfP4/lBpc03Fks5pJWVfSq3GHxL+SijeReTCTtPrUH
1OXBSzYOyu5bgYgbjz7XGtK1t4ska5leBellskpz2TMfK8z/ePc+qJBVi0Ma
z27wZhUzVeEjZyF7pTNqc51gDq1wkIurAYWzGLU99LOTdYf9oeX2HLqfg59O
Qcuhpdxbw1B0A/e2WFH0UtK9AeVR4IImquMNt3qDXEQM6fiFaPPm3jy/al60
smLE62bfK9hcLieT2fOxL/ggK5TM389vW83WBeyPD8j61CrBp0gIffoz+tvd
l00G8TW9lJPxdUM6nl+e8b7gr2RGx5m3eHmLBE/8fKlcxCNSLG7SNCmZpKom
igHtYf99F/4KYuvwx77MVWZUSOxP52Lc7CRM/MnVO4VVViFdioVJv09FNBmW
Mcsk7n9t3pnX7a8PVw0cfDveIseQ1NP5Etu2y3oFx+p0fuSJv8znVkhmmXPB
EyVVK6saAb1ULyFS1LaNMu9pj1hGrwmM0oqLWUYpI8oo8bM+doCNRMzWL+b9
+e1F4z5uzYy6xwMmCp7CgWg2OQpJ/YaR73sBP8AjfGK12AL2OtTHigvBc0dC
1+eti6sGTvWp4+MHwH2foYHPkXAAswnBgn+lv4PEoQLf+szuA56HeCiG8OJF
wD0IsWd9RIsojCxnRzXJfLIVuF7mc+s1mXae4HUV/4Ou18ukXtJ2WZPz2mm+
1snimixLvi6vwtdESJjy0RguA+wZ65VxfEXoHqW9YBhP1tBeaE7MKe7Wa4bg
br1WnHD3x8i9Am1vFbR3y9jv4PV7ZL0JVJMtU7VBNEnVBqlMqDrF1Jm05o6w
GuZeMJJndnqp5t6TZFzxMz+2/zHQhrXexMY3bAO4Yf61cil0w+JX0E3B26jo
EryNKvkfwJssw1yyAXqTbbH3ulGtS99GVTwP8kXNWELfJIXfZIa/x/gdXwsh
PJ6Yi3cXJE7WRXGynMVhnFOKySWS/wctQpQj8xQAAA==

---187430788-2127577695-1167340201=:16672--
