From: Ash Hughes <ashley.hughes@blueyonder.co.uk>
Subject: Re: [PATCH] userspace SSDP conntrack helper
Date: Sat, 08 Mar 2014 21:13:34 +0000
Message-ID: <531B87FE.9080500@blueyonder.co.uk>
References: <531B3E73.3080801@blueyonder.co.uk> <20140308163902.GA3590@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from know-smtprelay-omc-2.server.virginmedia.net ([80.0.253.66]:44643
	"EHLO know-smtprelay-omc-2.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbaCHVNg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Mar 2014 16:13:36 -0500
In-Reply-To: <20140308163902.GA3590@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Here is an updated version with fixed whitespace (sorry about that)
and works with multiple responses. I've mentioned SSDP in the manual
as well as adding some lines to the example config, but I can do
more if needed.

Ash

---
diff --git a/doc/helper/conntrackd.conf b/doc/helper/conntrackd.conf
index 358ad10..d2d94a9 100644
--- a/doc/helper/conntrackd.conf
+++ b/doc/helper/conntrackd.conf
@@ -70,6 +70,14 @@ Helper {
 			ExpectTimeout 300
 		}
 	}
+	Type ssdp inet udp {
+		QueueNum 5
+		QueueLen 10240
+		Policy ssdp {
+			ExpectMax 1
+			ExpectTimeout 300
+		}
+	}
 }

 #
diff --git a/doc/manual/conntrack-tools.tmpl b/doc/manual/conntrack-too=
ls.tmpl
index f21a4ff..d23dec5 100644
--- a/doc/manual/conntrack-tools.tmpl
+++ b/doc/manual/conntrack-tools.tmpl
@@ -890,6 +890,7 @@ maintainance.</para></listitem>
 <listitem><para>Oracle*TNS, to support its special <emphasis>Redirect<=
/emphasis> message.</para></listitem>
 <listitem><para>NFSv3, mind that version 4 does not require this helpe=
r.</para></listitem>
 <listitem><para>FTP (this helper is also available in kernel-space).</=
para></listitem>
+<listitem><para>SSDP.</para></listitem>
 </itemizedlist>

 <para>The following steps describe how to enable the RPC portmapper he=
lper for NFSv3 (this is similar for other helpers):</para>
diff --git a/src/helpers/Makefile.am b/src/helpers/Makefile.am
index fe28e83..78ef7aa 100644
--- a/src/helpers/Makefile.am
+++ b/src/helpers/Makefile.am
@@ -6,7 +6,8 @@ pkglib_LTLIBRARIES =3D ct_helper_amanda.la \
 		     ct_helper_rpc.la	\
 		     ct_helper_tftp.la	\
 		     ct_helper_tns.la	\
-		     ct_helper_sane.la
+		     ct_helper_sane.la	\
+		     ct_helper_ssdp.la

 ct_helper_amanda_la_SOURCES =3D amanda.c
 ct_helper_amanda_la_LDFLAGS =3D -avoid-version -module $(LIBNETFILTER_=
CONNTRACK_LIBS)
@@ -35,3 +36,7 @@ ct_helper_tns_la_CFLAGS =3D $(AM_CFLAGS) $(LIBNETFILT=
ER_CONNTRACK_CFLAGS)
 ct_helper_sane_la_SOURCES =3D sane.c
 ct_helper_sane_la_LDFLAGS =3D -avoid-version -module $(LIBNETFILTER_CO=
NNTRACK_LIBS)
 ct_helper_sane_la_CFLAGS =3D $(AM_CFLAGS) $(LIBNETFILTER_CONNTRACK_CFL=
AGS)
+
+ct_helper_ssdp_la_SOURCES =3D ssdp.c
+ct_helper_ssdp_la_LDFLAGS =3D -avoid-version -module $(LIBNETFILTER_CO=
NNTRACK_LIBS)
+ct_helper_ssdp_la_CFLAGS =3D $(AM_CFLAGS) $(LIBNETFILTER_CONNTRACK_CFL=
AGS)
diff --git a/src/helpers/ssdp.c b/src/helpers/ssdp.c
new file mode 100644
index 0000000..033359d
--- /dev/null
+++ b/src/helpers/ssdp.c
@@ -0,0 +1,135 @@
+/*
+ * SSDP connection tracking helper
+ * (SSDP =3D Simple Service Discovery Protocol)
+ * For documentation about SSDP see
+ * http://en.wikipedia.org/wiki/Simple_Service_Discovery_Protocol
+ *
+ * Copyright (C) 2014 Ashley Hughes <ashley.hughes@blueyonder.co.uk>
+ * Based on the SSDP conntrack helper (nf_conntrack_ssdp.c),
+ * :http://marc.info/?t=3D132945775100001&r=3D1&w=3D2
+ *  (C) 2012 Ian Pilcher <arequipeno@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "conntrackd.h"
+#include "helper.h"
+#include "myct.h"
+#include "log.h"
+#include <errno.h>
+#include <arpa/inet.h>
+#include <netinet/ip.h>
+#include <netinet/udp.h>
+#include <libmnl/libmnl.h>
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+#include <libnetfilter_queue/libnetfilter_queue.h>
+#include <libnetfilter_queue/libnetfilter_queue_tcp.h>
+#include <libnetfilter_queue/pktbuff.h>
+#include <linux/netfilter.h>
+
+#define SSDP_MCAST_ADDR		"239.255.255.250"
+#define UPNP_MCAST_LL_ADDR "FF02::C" /* link-local */
+#define UPNP_MCAST_SL_ADDR "FF05::C" /* site-local */
+
+#define SSDP_M_SEARCH		"M-SEARCH"
+#define SSDP_M_SEARCH_SIZE	(sizeof SSDP_M_SEARCH - 1)
+
+static int
+ssdp_helper_cb(struct pkt_buff *pkt, uint32_t protoff,
+		 struct myct *myct, uint32_t ctinfo)
+{
+
+	int ret =3D NF_ACCEPT;
+	union nfct_attr_grp_addr daddr, saddr, taddr;
+	struct iphdr *net_hdr =3D (struct iphdr *)pktb_network_header(pkt);
+	int good_packet =3D 0;
+	struct nf_expect *exp;
+	u_int16_t port;
+	unsigned int dataoff;
+	void *sb_ptr;
+
+	cthelper_get_addr_dst(myct->ct, MYCT_DIR_ORIG, &daddr);
+	switch(nfct_get_attr_u8(myct->ct, ATTR_L3PROTO)) {
+		case AF_INET:
+			inet_pton(AF_INET, SSDP_MCAST_ADDR, &(taddr.ip));
+			if (daddr.ip =3D=3D taddr.ip)
+				good_packet =3D 1;
+			break;
+		case AF_INET6:
+			inet_pton(AF_INET6, UPNP_MCAST_LL_ADDR, &(taddr.ip6));
+			if (daddr.ip6[0] =3D=3D taddr.ip6[0] && daddr.ip6[1] =3D=3D taddr.i=
p6[1]
+				&& daddr.ip6[2] =3D=3D taddr.ip6[2] && daddr.ip6[3] =3D=3D taddr.i=
p6[3]) {
+				good_packet =3D 1;
+				break;
+			}
+			inet_pton(AF_INET6, UPNP_MCAST_SL_ADDR, &(taddr.ip6));
+			if (daddr.ip6[0] =3D=3D taddr.ip6[0] && daddr.ip6[1] =3D=3D taddr.i=
p6[1]
+				&& daddr.ip6[2] =3D=3D taddr.ip6[2] && daddr.ip6[3] =3D=3D taddr.i=
p6[3]) {
+				good_packet =3D 1;
+				break;
+			}
+			break;
+		default:
+			break;
+	}
+
+	if (!good_packet) {
+		pr_debug("ssdp_help: destination address not multicast; ignoring\n")=
;
+		return NF_ACCEPT;
+	}
+
+	/* No data? Ignore */
+	dataoff =3D net_hdr->ihl*4 + sizeof(struct udphdr);
+	if (dataoff >=3D pktb_len(pkt)) {
+		pr_debug("ssdp_help: UDP payload too small for M-SEARCH; ignoring\n"=
);
+		return NF_ACCEPT;
+	}
+
+	sb_ptr =3D pktb_network_header(pkt) + dataoff;
+
+	if (memcmp(sb_ptr, SSDP_M_SEARCH, SSDP_M_SEARCH_SIZE) !=3D 0) {
+		pr_debug("ssdp_help: UDP payload does not begin with 'M-SEARCH'; ign=
oring\n");
+		return NF_ACCEPT;
+	}
+
+
+
+	cthelper_get_addr_src(myct->ct, MYCT_DIR_ORIG, &saddr);
+	cthelper_get_port_src(myct->ct, MYCT_DIR_ORIG, &port);
+
+	exp =3D nfexp_new();
+	if (exp =3D=3D NULL)
+		return NF_DROP;
+
+	if (cthelper_expect_init(exp, myct->ct, 0, NULL, &saddr,
+				 IPPROTO_UDP, NULL, &port, NF_CT_EXPECT_PERMANENT)) {
+		nfexp_destroy(exp);
+		return NF_DROP;
+	}
+
+	myct->exp =3D exp;
+
+	return ret;
+}
+
+static struct ctd_helper ssdp_helper =3D {
+	.name		=3D "ssdp",
+	.l4proto	=3D IPPROTO_UDP,
+	.priv_data_len	=3D 0,
+	.cb		=3D ssdp_helper_cb,
+	.policy		=3D {
+		[0] =3D {
+			.name			=3D "ssdp",
+			.expect_max		=3D 1,
+			.expect_timeout		=3D 5 * 60,
+		},
+	},
+};
+
+static void __attribute__ ((constructor)) ssdp_init(void)
+{
+	helper_register(&ssdp_helper);
+}
+

On 08/03/14 16:39, Pablo Neira Ayuso wrote:
> Hi,
>=20
> On Sat, Mar 08, 2014 at 03:59:47PM +0000, Ash Hughes wrote:
>> Hi,
>>
>> Here is a patch which adds a userspace conntrack helper for the SSDP
>> protocol. This is based on the code found at:
>>
>> http://marc.info/?t=3D132945775100001&r=3D1&w=3D2
>>
>> I'm not sure how to get my laptop to play at IPv6, so I've not teste=
d
>> this part, but I've tested the IPv4 section and it works. What more
>> needs to be done to get this merged in? :)
>=20
> A couple of things, first send me several pcap trace files with SSDP
> traffic for this protocol for my personal database, I used them to
> exercise this code.
>=20
> Secondly, fix coding style:
>=20
> http://lxr.free-electrons.com/source/Documentation/CodingStyle
>=20
> Specifically, indentation is broken, your editor is converting tabs
> into spaces.
>=20
> And please, slightly extend the manual.
>=20
>> diff --git a/src/helpers/Makefile.am b/src/helpers/Makefile.am
>> index fe28e83..947e58b 100644
>> --- a/src/helpers/Makefile.am
>> +++ b/src/helpers/Makefile.am
>> @@ -6,7 +6,8 @@ pkglib_LTLIBRARIES =3D ct_helper_amanda.la \
>>  		     ct_helper_rpc.la	\
>>  		     ct_helper_tftp.la	\
>>  		     ct_helper_tns.la	\
>> -		     ct_helper_sane.la
>> +		     ct_helper_sane.la  \
>> +             ct_helper_ssdp.la
>    ^=E2=81=BB----------^
>=20
> Same thing in the rest of the code.
>=20
> Thanks.
>=20
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
