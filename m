From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Change location of conntrack from bin to sbin
Date: Thu, 3 Nov 2005 07:16:26 +0100 (CET)
Message-ID: <Pine.LNX.4.63.0511030712270.7776@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1970215732-1130998586=:7776"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
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

---187430788-1970215732-1130998586=:7776
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello

Attached (and inlined) patch moves conntrack tool from bin to sbin=20
directory since this application is an administration utility and=20
it requires uid=3D=3D0 or CAP_NET_ADMIN.

Index: src/Makefile.am
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- src/Makefile.am=09(revision 4432)
+++ src/Makefile.am=09(working copy)
@@ -1,4 +1,4 @@
-bin_PROGRAMS =3D conntrack
+sbin_PROGRAMS =3D conntrack
  conntrack_SOURCES =3D conntrack.c

  INCLUDES=3D $(all_includes) -I$(top_srcdir)/include -I${KERNELDIR}


Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-1970215732-1130998586=:7776
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=conntrack-bin-sbin.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.63.0511030716260.7776@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=conntrack-bin-sbin.patch

SW5kZXg6IHNyYy9NYWtlZmlsZS5hbQ0KPT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PQ0KLS0tIHNyYy9NYWtlZmlsZS5hbQkocmV2aXNpb24gNDQzMikNCisrKyBz
cmMvTWFrZWZpbGUuYW0JKHdvcmtpbmcgY29weSkNCkBAIC0xLDQgKzEsNCBA
QA0KLWJpbl9QUk9HUkFNUyA9IGNvbm50cmFjaw0KK3NiaW5fUFJPR1JBTVMg
PSBjb25udHJhY2sNCiBjb25udHJhY2tfU09VUkNFUyA9IGNvbm50cmFjay5j
DQogDQogSU5DTFVERVM9ICQoYWxsX2luY2x1ZGVzKSAtSSQodG9wX3NyY2Rp
cikvaW5jbHVkZSAtSSR7S0VSTkVMRElSfQ0K

---187430788-1970215732-1130998586=:7776--
