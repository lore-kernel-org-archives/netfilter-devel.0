From: Krzysztof Oledzki <olenf@ans.pl>
Subject: New ROUTE patch does not work with conntrack+nat disabled
Date: Thu, 20 Jan 2005 14:23:29 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0501201253440.5089@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-416457481-1106227409=:5089"
Cc: Patrick Schaaf <bof@bof.de>, Cedric de Launois <delaunois@info.ucl.ac.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

---187430788-416457481-1106227409=:5089
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

ipt_ROUTE.c: In function `init':
ipt_ROUTE.c:405: structure has no member named `nat'
ipt_ROUTE.c:406: `IP_NAT_MANIP_SRC' undeclared (first use in this function)
ipt_ROUTE.c:406: (Each undeclared identifier is reported only once
ipt_ROUTE.c:406: for each function it appears in.)
ipt_ROUTE.c:406: `IP_NAT_MANIP_DST' undeclared (first use in this function)
make[3]: *** [ipt_ROUTE.o] Error 1
make[3]: Leaving directory `/usr/src/linux-2.4.29/net/ipv4/netfilter'
make[2]: *** [first_rule] Error 2
make[2]: Leaving directory `/usr/src/linux-2.4.29/net/ipv4/netfilter'
make[1]: *** [_subdir_ipv4/netfilter] Error 2
make[1]: Leaving directory `/usr/src/linux-2.4.29/net'
make: *** [_dir_net] Error 2

This is the problematic part of the code:
+       /* Set up fake conntrack (stolen from raw.patch):
+           - to never be deleted, not in any hashes */
+       atomic_set(&route_tee_track.ct_general.use, 1);
+       /*  - and look it like as a confirmed connection */
+       set_bit(IPS_CONFIRMED_BIT, &route_tee_track.status);
+       /*  - and prepare the ctinfo field for REJECT/NAT. */
+       route_tee_track.infos[IP_CT_NEW].master =3D
+       route_tee_track.infos[IP_CT_RELATED].master =3D
+       route_tee_track.infos[IP_CT_RELATED + IP_CT_IS_REPLY].master =3D
+               &route_tee_track.ct_general;
+       /* Initialize fake conntrack so that NAT will skip it */
+       route_tee_track.nat.info.initialized |=3D
+               (1 << IP_NAT_MANIP_SRC) | (1 << IP_NAT_MANIP_DST);
+


I'm afraid ipt_ROUTE.c is not the right place for such code. Oryginal=20
code (stolen from raw.patch) exists in ip_conntrack_core.c and=20
ip_nat_core.c.

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-416457481-1106227409=:5089--
