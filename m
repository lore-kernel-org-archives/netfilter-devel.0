From: Eivind Naess <eivnaes@yahoo.com>
Subject: Found a dead-freeze bug, in xt_ipv4options.c -- patch provided
Date: Thu, 3 Nov 2011 09:28:46 -0700 (PDT)
Message-ID: <1320337726.52658.YahooMailNeo@web39415.mail.mud.yahoo.com>
Reply-To: Eivind Naess <eivnaes@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nm3-vm3.bullet.mail.ne1.yahoo.com ([98.138.91.133]:37250 "HELO
	nm3-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933454Ab1KCQ2s convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Nov 2011 12:28:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

All,

I found this bug running Ubuntu 11.10, I managed to hang the operating =
system with the CPU pegged at 100% after sending it a malformed IP opti=
on packet. I had installed  the xtables-addons-dmks package installed v=
ia apt-get. The Ubuntu 11.10 distribution runs with the "3.0.0-12 #20-U=
buntu SMP" kernel. AFAIK, there should be little modifications to the c=
ode compared what is installed in git repository available on the web.=20


To reproduce this issue:

1. Install Ubuntu 11.10
2. apt-get install xtables-addon-dmks
3. iptables -I INPUT 1 -m ipv4options --any -j LOG --log-prefix "PACKET=
 WITH IP-OPTIONS DETECTED"

On a different computer (attacker),
4. Download, and install the isic (ip stack integrity checker) from htt=
p://isic.sourceforge.net
5. Run a test of the ip-stack to the victim (Ubuntu 11.10) computer (at=
tacker: 192.168.111.100, victim: 192.168.111.200).

=A0=A0=A0 sudo tcpsic -s 192.168.111.100,69 -d 192.168.111.200 -x 2 -m =
1000 -T 30 -t 50
6. Victim PC freezes, no mouse, no movement; just dead.=20


=46urther investigation showed that the xt_ipv4options.ko module was th=
e culprit. The problem appeared to be that the ipv4option_rd() function=
 entered a infinite loop when an ip-option of length 0 was encountered.=
 I grepped the Linux kernel for similar code and modified the code in x=
t_ipv4options.c to correct this behavior. In addition, it seems like th=
e --any option wasn't working correctly to begin with.

Any chances for this patch being accepted?

Regards,

- Eivind


--- /tmp/tmp.13465.100=A0=A0=A0 2011-11-03 09:20:11.000000000 -0700
+++ xtables-addons/extensions/xt_ipv4options.c=A0=A0=A0 2011-11-02 13:0=
3:14.000000000 -0700
@@ -15,14 +15,32 @@
=A0#include "xt_ipv4options.h"
=A0#include "compat_xtables.h"
=A0
-static uint32_t ipv4options_rd(const uint8_t *data, int len)
+static uint32_t ipv4options_rd(const uint8_t *ptr, int len)
=A0{
=A0=A0=A0=A0 uint32_t opts =3D 0;
+=A0=A0=A0 uint32_t olen =3D 0;
=A0
=A0=A0=A0=A0 while (len >=3D 2) {
-=A0=A0=A0 =A0=A0=A0 opts |=3D 1 << (data[0] & 0x1F);
-=A0=A0=A0 =A0=A0=A0 len=A0 -=3D data[1];
-=A0=A0=A0 =A0=A0=A0 data +=3D data[1];
+=A0=A0=A0=20
+=A0=A0=A0 =A0=A0=A0 /* Handle special options */
+=A0=A0=A0 =A0=A0=A0 switch (*ptr) {
+=A0=A0=A0 =A0=A0=A0 case IPOPT_END:
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return opts;
+=A0=A0=A0 =A0=A0=A0 case IPOPT_NOOP:
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 len--;
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 ptr++;
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 continue;
+=A0=A0=A0 =A0=A0=A0 }
+=A0=A0=A0 =A0=A0=A0=20
+=A0=A0=A0 =A0=A0=A0 /* Get the length of the option */
+=A0=A0=A0 =A0=A0=A0 olen =3D ptr[1];
+=A0=A0=A0 =A0=A0=A0 if (olen < 2 || olen > len)
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return opts;
+=A0=A0=A0 =A0=A0=A0=20
+=A0=A0=A0 =A0=A0=A0 /* Set the option bit, and incr/decr the invariant=
s */
+=A0=A0=A0 =A0=A0=A0 opts |=3D 1 << (*ptr & 0x1F);
+=A0=A0=A0 =A0=A0=A0 len=A0 -=3D olen;
+=A0=A0=A0 =A0=A0=A0 ptr=A0 +=3D olen;
=A0=A0=A0=A0 }
=A0
=A0=A0=A0=A0 return opts;
@@ -36,13 +54,20 @@
=A0=A0=A0=A0 uint32_t opts =3D 0;
=A0=A0=A0=A0 uint16_t len=A0 =3D ip_hdrlen(skb) - sizeof(struct iphdr);
=A0
-=A0=A0=A0 if (len > 0)
+=A0=A0=A0 if (len > 0) {
=A0=A0=A0=A0 =A0=A0=A0 opts =3D ipv4options_rd((const void *)iph +
=A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0=A0=A0=A0 sizeof(struct iphdr), len);
+=A0=A0=A0 =A0=A0=A0 if(info->flags & XT_V4OPTS_ANY) {
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return=A0 !!opts; /* !! to make bool val=
ue */
+=A0=A0=A0 =A0=A0=A0 }else {
=A0
=A0=A0=A0=A0 opts ^=3D info->invert;
=A0=A0=A0=A0 opts &=3D info->map;
-=A0=A0=A0 return (info->flags & XT_V4OPTS_ANY) ? opts : opts =3D=3D in=
fo->map;
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return (opts =3D=3D info->map);
+=A0=A0=A0 =A0=A0=A0 }=A0=A0=A0 =A0=A0=A0=20
+=A0=A0=A0 }
+=A0=A0=A0=20
+=A0=A0=A0 return 0;
=A0}

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
