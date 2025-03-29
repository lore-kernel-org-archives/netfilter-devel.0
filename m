Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482011A8F61
	for <netfilter-devel@vger.kernel.org>; Sat, 29 Mar 2025 11:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743246469; cv=none; b=nSl3Q9w+xIxAW0ZwK0OATq4eERHerhtPvrJlaRmcCXo2rKi6pWrgGngj4PBuk6ol5JoJElZzGBNUZmYP/j6uZVSbvFtoXTZkNbZj3lCqb0YIEyeb5jc11WlX2aRYorGIqou5CL9LkLPEGDz3DOvaoC0rxrXMOsZqfRX6srkA4oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743246469; c=relaxed/simple;
	bh=7VVAKUdQ4yDudehslGOhXV0o5+ycnGS3auWRS92OEOk=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=aJYBRE0s/AnROZnfSMAFatC7TTi5r/EbwGG0bHFv7rrqu6ImjGAy4CbQeagrdjiVW0eHuq0Wdlfzs+KGUHJeTMvTxbGNEy2FlPJ41WFaxu9w3zuwT24JDGcHW17TVZA+SJ7ICgYjw2yR/eqQmTMjtByQZLrtq/bjDD2G/bXfHYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=had2pRb6; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="had2pRb6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1743246463; x=1743851263; i=corubba@gmx.de;
	bh=7XukwbXjdBptc2AMkCKWHC1zwiiEbAb0kENXxElAtCY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:From:Subject:
	 Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=had2pRb6WiNhJYaS38JFh8JQKm5CPnOLSpTnOGFVq34Wrgr1ZG2M+Nsc01OEx0W+
	 tgqpzSgkcVWpHQ6Y1aZxyIxKqY4helXOH+XzRQ69FjcZm8k5iZiXrMI9UpJbYAG+0
	 q9B/QK66PsVXu0O3EDyAgUZABS/fN4M6rLU6mccVaCC6Mjj/R3p9iuiBXI1UUKsb0
	 i7tfFLcLDQG9iU0ZfRWgH+wV1bEDszn43zdALLqvAeh6kzOdfpH+OUqsrHSmzq81f
	 tDTOOaoZAVOx9F2ZIZEj4CPI0oJ3MXfYPn14tiNeveqkp2DrC8tjVbYHMcAX4mkJe
	 mClbYAcsaqz5dtyQNA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from 127.0.0.1 ([94.134.25.34]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1My36N-1tC96O13WR-00ugu2 for
 <netfilter-devel@vger.kernel.org>; Sat, 29 Mar 2025 12:07:43 +0100
Message-ID: <23db0352-9525-427b-a936-c8ef87e4d5b7@gmx.de>
Date: Sat, 29 Mar 2025 12:07:06 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Language: de-CH
To: netfilter-devel@vger.kernel.org
From: Corubba Smith <corubba@gmx.de>
Subject: [PATCH ulogd2 1/2] ulog: remove input plugin
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:l2dLEhS5l4JcRUKvvxEwS+vNdX1qTI7vvUk+qvCSRs+YKaaSDW4
 GuIyMPkFrn3fILRDz0q8SbHS741nF0H8lmQkejnzpcB+odTDYm/Nzb+ePctGbZCq8jWaKBI
 KgW0aAt00/YwEEitMkbIbRsXA8wuAaFxZa6nhITc03P+xXyYcVM04spKM3jPIxxFyohsprf
 89iBhNy3dH3Nh+Md8cZSg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:rbWA+2k+s8g=;+DSpZy7e62NGCyXwPuRi7XLiMua
 4qjh9ciB+YeH9AC9Wne9DMSMVrefM2Q8WDxEvCbV/YOvkSnQVnhumpkwiFO1Tr/AZEyUTLQCf
 GSZeLo92qMaAY3f9xNvaceBgvH7m/bQLmfYmb85VrdtGW5xthuO3E+Kb9D1TSM1KSp/RVoUj6
 jtwB8TPHrSJ0tebqv0Tj0/4pv65Y+yVxyHu5PPoMylA5NAS/3lw1LLWuUhz49H76OuF2AcyLi
 qk7Ce+ap7pAn5RhKDs+phCxhL6v4MjCglMgHmEdiMSCusOXZHmD5+jQ7R1VEuo7ziEKMOqVKO
 Vklm8clmETDPaiwlHVzW3nJ6AQY43P9iUOWU/9X+6vGudNfpuzePkJrZHyt5U/HgYGcYKVG8i
 Y47tmUwHzzl4UsXDVneSMGclQuvbmaCBKU1ixTu21x3daMB4S+n+lUUE7neBwHFdd7/Scb8GC
 X+68enK/Mt3nIA23bQyhoNiuXwUjKqqRYkYf2k0Guhj74Ki5Dm5/boHL7tW6/fMDpHdYbbtME
 R38NxdoARjTEaEf1e1Lw9FMHm7BjZClxq1Iq1kD041WEgN+C/prwZuDdlQY8oo9h6JNWvxzQF
 E50Mru0pjMFxVNKl5+kTfdxXs1e5SS3Dj93EEi5qZ47mn42JJY/wgJFVfNt23viM7HP6X2ErV
 c1mO+Np7HYu2EkXP/uha9ewO2BLhecdgK/l7gTxF9XmIUeQAGFob2u3tDQi5+8x8cZiu0+qRT
 tDt3WSJS752b8Z+3B98/aJ7HstaSUtWzHXLu5SzYmx5F8VYVjne7Zvm1v+TOIjxRiU+PIUNcD
 pDXEKIyt0LlhEJEgrbIMzgODNfX0rdTktUe4o8xtkH4r+LY2mI+92mpw7NNDi/SJFrvWEzuUe
 k4h0V0KR+4q9XH4xaiPyDcOtaY7+vr0mOryVGau79xiDFuKUxDmrFMV7S0npp7j73RIWaEOV/
 6KOy03agRl9ztFKR1YfWwzXuEu9qG6Qbz5AzKNm3kq0ueNDB/diGNLZ13DvPt4DnnSMDYNSXy
 b0b5YOLRSlOMb42sTQum3xJ0FvKKKW6FnYg/WrvPdJT9bWDNeOfFtzs8w32Ohd7EeFTJ9+Jg3
 QW4BebplNfGY68Co+oBbaCCUiyGYQElcdwe8/pwBmUYgai+gFWoT0il5KeyZ9T73A78W6Pynq
 QUxnuVE5RvpXQVnGrXy1Y+G28lxCyz9jUr2RfN3FFkymvadCQAIqXgZdAGrpsNDpI7i/NpxBp
 wqVngQ8++Tc5xjjOiR34TVcH0JylDsL3C9YueKgiIyIG3zpFHxy3eSN75z8h/3vzeLO7FdfPS
 qsddlINRWZMU/ObUBsUz8PIpo0Em6KgG4M4tvsiVRTHNVHTFb/bQCNZuTOvJjHtWRNJR0Akec
 uGVxY7moWABYanA/iFDv591hI8TL4StCgduAE/IcTtaoFxZRI79z9UANsI3D8ZrogVHaNKLC/
 ngkbQlhEPLvKDyUJkTOeIDgCUx1c=

The ULOG target was removed from the linux kernel with 7200135bc1e6
("netfilter: kill ulog targets") aka v3.17, so remove the input plugin
for it. It's successor NFLOG should be used instead, which has its own
input plugin.

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
 README                           |   1 -
 TODO                             |   1 -
 configure.ac                     |   8 -
 doc/ulogd.sgml                   |  87 +-------
 filter/ulogd_filter_HWHDR.c      |   4 -
 include/ulogd/ulogd.h            |   3 +-
 input/packet/Makefile.am         |   8 -
 input/packet/ulogd_inppkt_ULOG.c | 332 -------------------------------
 ulogd.8                          |   2 +-
 ulogd.conf.in                    |   9 -
 10 files changed, 3 insertions(+), 452 deletions(-)
 delete mode 100644 input/packet/ulogd_inppkt_ULOG.c

diff --git a/README b/README
index 738a4c8..87c605f 100644
=2D-- a/README
+++ b/README
@@ -10,7 +10,6 @@ in the doc/ subdirectory.

 This packages is intended for doing all netfilter related logging inside =
a
 userspace process.  This includes
-	- logging of ruleset violations via ipt_ULOG (kernel 2.4.18+)
 	- logging of ruleset violations via nfnetlink_log (kernel 2.6.14+)
 	- logging of connection startup/teardown (kernel 2.6.14+)
 	- connection-based accounting  (kernel 2.6.14+)
diff --git a/TODO b/TODO
index d9c0fb3..44a6d5d 100644
=2D-- a/TODO
+++ b/TODO
@@ -1,4 +1,3 @@
 - add support for capabilities to run as non-root
 - support for static linking
=2D- issues with ulogd_BASE and partially copied packets (--ulog-cprange)
 - problem wrt. ulogd_BASE and fragments
diff --git a/configure.ac b/configure.ac
index 3c9249e..dca8a2a 100644
=2D-- a/configure.ac
+++ b/configure.ac
@@ -37,13 +37,6 @@ AC_CHECK_FUNCS([socket strerror])
 AC_SEARCH_LIBS([pthread_create], [pthread], [libpthread_LIBS=3D"$LIBS"; L=
IBS=3D""])
 AC_SUBST([libpthread_LIBS])

-AC_ARG_ENABLE([ulog],
-              [AS_HELP_STRING([--enable-ulog], [Enable ulog module [defau=
lt=3Dyes]])],
-              [enable_ulog=3D$enableval],
-              [enable_ulog=3Dyes])
-AS_IF([test "x$enable_ulog" !=3D "xyes"], [enable_ulog=3Dno])
-AM_CONDITIONAL([BUILD_ULOG], [test "x$enable_ulog" =3D "xyes"])
-
 dnl Check for the right nfnetlink version
 PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >=3D 1.0.1])

@@ -297,7 +290,6 @@ Ulogd configuration:
     NFLOG plugin:			${enable_nflog}
     NFCT plugin:			${enable_nfct}
     NFACCT plugin:			${enable_nfacct}
-    ULOG plugin:			${enable_ulog}
   Output plugins:
     PCAP plugin:			${enable_pcap}
     PGSQL plugin:			${enable_pgsql}
diff --git a/doc/ulogd.sgml b/doc/ulogd.sgml
index de799f4..076edda 100644
=2D-- a/doc/ulogd.sgml
+++ b/doc/ulogd.sgml
@@ -9,8 +9,7 @@
 <abstract>
 This is the documentation for <tt>ulogd-2.x</tt>, the second generation
 Netfilter Userspace logging daemon.  ulogd makes use of the Linux &gt;=3D=
 2.6.14
-nfnetlink_log and nfnetlink_conntrack subsystems, but also provides backw=
ards compatibility for Linux
-&gt;=3D 2.4.0 ipt_ULOG.
+nfnetlink_log and nfnetlink_conntrack subsystems.
 </abstract>

 <toc>
@@ -66,7 +65,6 @@ interconnected  by pointers.
 <sect1>Linux kernel
 <p>
 To use the NFCT or NFLOG input plugin, you will need a 2.6.14 or later ke=
rnel.
-For old-style ULOG logging, you need a kernel &gt;=3D 2.4.18.

 <sect1>Userspace libraries
 <p>
@@ -132,75 +130,6 @@ A string that is associated with every packet logged =
by this rule.  You can use
 this option to later tell from which rule the packet was logged.
 </descrip>

-<sect1>iptables ULOG target
-<sect2>Quick Setup
-<p>
-Just add rules using the ULOG target to your firewalling chain. A very ba=
sic
-example:
-<tscreen><verb>
-iptables -A FORWARD -j ULOG --ulog-nlgroup 32 --ulog-prefix foo
-</verb></tscreen>
-<p>
-To increase logging performance, try to use the
-<tscreen><verb>
=2D--ulog-qthreshold N
-</verb></tscreen>
-option (where 1 &lt; N &lt;=3D 50). The number you specify is the amount =
of packets
-batched together in one multipart netlink message. If you set this to 20,=
 the
-kernel schedules ulogd only once every 20 packets. All 20 packets are the=
n
-processed by ulogd. This reduces the number of context switches between k=
ernel
-and userspace.
-<p>
-Of course you can combine the ULOG target with the different netfilter ma=
tch
-modules.  For a more detailed description, have a look at the netfilter
-HOWTO's, available on the netfilter homepage.
-<sect2>ULOG target reference
-<p>
-<descrip>
-<tag>--ulog-nlgroup N</tag>
-The number of the netlink multicast group to which ULOG'ed packets are se=
nt.
-You will have to use the same group number in the ULOG target and ulogd i=
n
-order to make logging work.
-<tag>--ulog-cprange N</tag>
-Copyrange.  This works like the 'snaplen' parameter of tcpdump.  You can =
specify
-a number of bytes up to which the packet is copied.  If you say '40', you=
 will
-receive the first fourty bytes of every packet. Leave it to <tt>0</tt>
-<tag>--ulog-qthreshold N</tag>
-Queue threshold.  If a packet is matched by the iptables rule, and alread=
y N
-packets are in the queue, the queue is flushed to userspace.  You can use=
 this
-to implement a policy like: Use a big queue in order to gain high perform=
ance,
-but still have certain packets logged immediately to userspace.
-<tag>--ulog-prefix STRING</tag>
-A string that is associated with every packet logged by this rule.  You c=
an use
-this option to later tell from which rule the packet was logged.
-</descrip>
-
-<sect2>ipt_ULOG module parameters
-<p>
-The ipt_ULOG kernel module has a couple of module loadtime parameters whi=
ch can
-(and should) be tuned to accomodate the needs of the application:
-<descrip>
-<tag>nlbufsiz N</tag>
-Netlink buffer size. A buffer of the specified size N is allocated for ev=
ery
-netlink group that is used.  Please note that due to restrictions of the =
kernel
-memory allocator, we cannot have a buffer size &gt; 128kBytes.  Larger bu=
ffer
-sizes increase the performance, since less kernel/userspace context switc=
hes
-are needed for the same amount of packets.  The backside of this performa=
nce
-gain is a potentially larger delay. The default value is 4096 bytes, whic=
h is
-quite small.
-<tag>flushtimeout N</tag>
-The flushtimeout determines, after how many clock ticks (on alpha: 1ms, o=
n
-x86 and most other platforms: 10ms time units) the buffer/queue is to be
-flushed, even if it is not full.  This can be used to have the advantage =
of a
-large buffer, but still a finite maximum delay introduced.  The default v=
alue
-is set to 10 seconds.
-</descrip>
-Example:
-<tscreen><verb>
-modprobe ipt_ULOG nlbufsiz=3D65535 flushtimeout=3D100
-</verb></tscreen>
-This would use a buffer size of 64k and a flushtimeout of 100 clockticks =
(1 second on x86).
-
 <sect1>ulogd
 <p>
 ulogd is what this is all about, so let's describe it's configuration...
@@ -322,20 +251,6 @@ Specify the base socket buffer maximum size.



-<sect2>ulogd_inppkt_ULOG.so
-<p>
-The good old ipt_ULOG input plugin.  This basically emulates ulogd-1.x wh=
ich
-didn't have input plugins.
-<descrip>
-<tag>nlgroup</tag>
-The number of the netlink multicast group to which ULOG'ed packets are se=
nt.
-You will have to use the same group number in the ULOG target and nin the=
 input plugin.
-<tag>numeric_label</tag>
-You can use this label to store information relative to the logging. The =
administrator can define a convention which can be used later to differenc=
iate packet. For example, it can store the severity of the logged event.
-</descrip>
-
-
-

 <sect1>Interpreter plugins
 <p>
diff --git a/filter/ulogd_filter_HWHDR.c b/filter/ulogd_filter_HWHDR.c
index a5ee60d..4bbf20d 100644
=2D-- a/filter/ulogd_filter_HWHDR.c
+++ b/filter/ulogd_filter_HWHDR.c
@@ -198,11 +198,7 @@ static int interp_mac2str(struct ulogd_pluginstance *=
pi)
 		return ULOGD_IRET_ERR;

 	if (pp_is_valid(inp, KEY_RAW_TYPE))
-		/* NFLOG with Linux >=3D 2.6.27 case */
 		type =3D ikey_get_u16(&inp[KEY_RAW_TYPE]);
-	else if (ikey_get_u16(&inp[KEY_RAW_MACLEN]) =3D=3D ETH_HLEN)
-		/* ULOG case, treat ethernet encapsulation */
-		type =3D ARPHRD_ETHER;
 	else
 		type =3D ARPHRD_VOID;

diff --git a/include/ulogd/ulogd.h b/include/ulogd/ulogd.h
index 088d85d..5eafb21 100644
=2D-- a/include/ulogd/ulogd.h
+++ b/include/ulogd/ulogd.h
@@ -2,8 +2,7 @@
 #define _ULOGD_H
 /* ulogd
  *
- * userspace logging daemon for netfilter ULOG target
- * of the linux 2.4/2.6 netfilter subsystem.
+ * Userspace logging daemon for netfilter/iptables
  *
  * (C) 2000-2005 by Harald Welte <laforge@gnumonks.org>
  *
diff --git a/input/packet/Makefile.am b/input/packet/Makefile.am
index 851c608..20c51ec 100644
=2D-- a/input/packet/Makefile.am
+++ b/input/packet/Makefile.am
@@ -7,14 +7,6 @@ pkglib_LTLIBRARIES =3D ulogd_inppkt_UNIXSOCK.la
 ulogd_inppkt_UNIXSOCK_la_SOURCES =3D ulogd_inppkt_UNIXSOCK.c
 ulogd_inppkt_UNIXSOCK_la_LDFLAGS =3D -avoid-version -module

-if BUILD_ULOG
-pkglib_LTLIBRARIES +=3D ulogd_inppkt_ULOG.la
-
-ulogd_inppkt_ULOG_la_SOURCES =3D ulogd_inppkt_ULOG.c
-ulogd_inppkt_ULOG_la_LDFLAGS =3D -avoid-version -module
-ulogd_inppkt_ULOG_la_LIBADD =3D ../../libipulog/libipulog.la
-endif
-
 if BUILD_NFLOG
 pkglib_LTLIBRARIES +=3D ulogd_inppkt_NFLOG.la

diff --git a/input/packet/ulogd_inppkt_ULOG.c b/input/packet/ulogd_inppkt_=
ULOG.c
deleted file mode 100644
index 2eb994c..0000000
=2D-- a/input/packet/ulogd_inppkt_ULOG.c
+++ /dev/null
@@ -1,332 +0,0 @@
-/* ulogd_inppkt_ULOG.c - stackable input plugin for ULOG packets -> ulogd=
2
- *
- * (C) 2004-2005 by Harald Welte <laforge@gnumonks.org>
- */
-
-#include <unistd.h>
-#include <stdlib.h>
-#include <arpa/inet.h>
-#include <string.h>
-
-
-#include <ulogd/ulogd.h>
-#include <libipulog/libipulog.h>
-
-#ifndef ULOGD_NLGROUP_DEFAULT
-#define ULOGD_NLGROUP_DEFAULT	32
-#endif
-
-/* Size of the socket receive memory.  Should be at least the same size a=
s the
- * 'nlbufsiz' module loadtime parameter of ipt_ULOG.o
- * If you have _big_ in-kernel queues, you may have to increase this numb=
er.  (
- * --qthreshold 100 * 1500 bytes/packet =3D 150kB  */
-#define ULOGD_RMEM_DEFAULT	131071
-
-/* Size of the receive buffer for the netlink socket.  Should be at least=
 of
- * RMEM_DEFAULT size.  */
-#define ULOGD_BUFSIZE_DEFAULT	150000
-
-struct ulog_input {
-	struct ipulog_handle *libulog_h;
-	unsigned char *libulog_buf;
-	struct ulogd_fd ulog_fd;
-};
-
-/* configuration entries */
-
-static struct config_keyset libulog_kset =3D {
-	.num_ces =3D 4,
-	.ces =3D {
-	{
-		.key 	 =3D "bufsize",
-		.type 	 =3D CONFIG_TYPE_INT,
-		.options =3D CONFIG_OPT_NONE,
-		.u.value =3D ULOGD_BUFSIZE_DEFAULT,
-	},
-	{
-		.key	 =3D "nlgroup",
-		.type	 =3D CONFIG_TYPE_INT,
-		.options =3D CONFIG_OPT_NONE,
-		.u.value =3D ULOGD_NLGROUP_DEFAULT,
-	},
-	{
-		.key	 =3D "rmem",
-		.type	 =3D CONFIG_TYPE_INT,
-		.options =3D CONFIG_OPT_NONE,
-		.u.value =3D ULOGD_RMEM_DEFAULT,
-	},
-	{
-		.key	 =3D "numeric_label",
-		.type	 =3D CONFIG_TYPE_INT,
-		.options =3D CONFIG_OPT_NONE,
-		.u.value =3D 0,
-	},
-
-	}
-};
-enum ulog_keys {
-	ULOG_KEY_RAW_MAC =3D 0,
-	ULOG_KEY_RAW_PCKT,
-	ULOG_KEY_RAW_PCKTLEN,
-	ULOG_KEY_RAW_PCKTCOUNT,
-	ULOG_KEY_OOB_PREFIX,
-	ULOG_KEY_OOB_TIME_SEC,
-	ULOG_KEY_OOB_TIME_USEC,
-	ULOG_KEY_OOB_MARK,
-	ULOG_KEY_OOB_IN,
-	ULOG_KEY_OOB_OUT,
-	ULOG_KEY_OOB_HOOK,
-	ULOG_KEY_RAW_MAC_LEN,
-	ULOG_KEY_OOB_FAMILY,
-	ULOG_KEY_OOB_PROTOCOL,
-	ULOG_KEY_RAW_LABEL,
-};
-
-static struct ulogd_key output_keys[] =3D {
-	[ULOG_KEY_RAW_MAC] =3D {
-		.type =3D ULOGD_RET_RAW,
-		.flags =3D ULOGD_RETF_NONE,
-		.name =3D "raw.mac",
-		.ipfix =3D {
-			.vendor =3D IPFIX_VENDOR_IETF,
-			.field_id =3D IPFIX_sourceMacAddress,
-		},
-	},
-	[ULOG_KEY_RAW_PCKT] =3D {
-		.type =3D ULOGD_RET_RAW,
-		.flags =3D ULOGD_RETF_NONE,
-		.name =3D "raw.pkt",
-		.ipfix =3D {
-			.vendor =3D IPFIX_VENDOR_NETFILTER,
-			.field_id =3D 1,
-			},
-	},
-	[ULOG_KEY_RAW_PCKTLEN] =3D {
-		.type =3D ULOGD_RET_UINT32,
-		.flags =3D ULOGD_RETF_NONE,
-		.name =3D "raw.pktlen",
-		.ipfix =3D {
-			.vendor =3D IPFIX_VENDOR_IETF,
-			.field_id =3D 1
-		},
-	},
-	[ULOG_KEY_RAW_PCKTCOUNT] =3D {
-		.type =3D ULOGD_RET_UINT32,
-		.flags =3D ULOGD_RETF_NONE,
-		.name =3D "raw.pktcount",
-		.ipfix =3D {
-			.vendor =3D IPFIX_VENDOR_IETF,
-			.field_id =3D 2
-		},
-	},
-	[ULOG_KEY_OOB_PREFIX] =3D {
-		.type =3D ULOGD_RET_STRING,
-		.flags =3D ULOGD_RETF_NONE,
-		.name =3D "oob.prefix",
-	},
-	[ULOG_KEY_OOB_TIME_SEC] =3D {
-		.type =3D ULOGD_RET_UINT32,
-		.flags =3D ULOGD_RETF_NONE,
-		.name =3D "oob.time.sec",
-		.ipfix =3D {
-			.vendor =3D IPFIX_VENDOR_IETF,
-			.field_id =3D 22
-		},
-	},
-	[ULOG_KEY_OOB_TIME_USEC] =3D {
-		.type =3D ULOGD_RET_UINT32,
-		.flags =3D ULOGD_RETF_NONE,
-		.name =3D "oob.time.usec",
-	},
-	[ULOG_KEY_OOB_MARK] =3D {
-		.type =3D ULOGD_RET_UINT32,
-		.flags =3D ULOGD_RETF_NONE,
-		.name =3D "oob.mark",
-	},
-	[ULOG_KEY_OOB_IN] =3D {
-		.type =3D ULOGD_RET_STRING,
-		.flags =3D ULOGD_RETF_NONE,
-		.name =3D "oob.in",
-	},
-	[ULOG_KEY_OOB_OUT] =3D {
-		.type =3D ULOGD_RET_STRING,
-		.flags =3D ULOGD_RETF_NONE,
-		.name =3D "oob.out",
-	},
-	[ULOG_KEY_OOB_HOOK] =3D {
-		.type =3D ULOGD_RET_UINT8,
-		.flags =3D ULOGD_RETF_NONE,
-		.name =3D "oob.hook",
-		.ipfix =3D {
-			.vendor =3D IPFIX_VENDOR_NETFILTER,
-			.field_id =3D IPFIX_NF_hook,
-		},
-	},
-	[ULOG_KEY_RAW_MAC_LEN] =3D {
-		.type =3D ULOGD_RET_UINT16,
-		.flags =3D ULOGD_RETF_NONE,
-		.name =3D "raw.mac_len",
-	},
-	[ULOG_KEY_OOB_FAMILY] =3D {
-		.type =3D ULOGD_RET_UINT8,
-		.flags =3D ULOGD_RETF_NONE,
-		.name =3D "oob.family",
-	},
-	[ULOG_KEY_OOB_PROTOCOL] =3D {
-		.type =3D ULOGD_RET_UINT16,
-		.flags =3D ULOGD_RETF_NONE,
-		.name =3D "oob.protocol",
-	},
-	[ULOG_KEY_RAW_LABEL] =3D {
-		.type =3D ULOGD_RET_UINT8,
-		.flags =3D ULOGD_RETF_NONE,
-		.name =3D "raw.label",
-	},
-
-};
-
-static int interp_packet(struct ulogd_pluginstance *ip, ulog_packet_msg_t=
 *pkt)
-{
-	struct ulogd_key *ret =3D ip->output.keys;
-
-	if (pkt->mac_len) {
-		okey_set_ptr(&ret[ULOG_KEY_RAW_MAC], pkt->mac);
-		okey_set_u16(&ret[ULOG_KEY_RAW_MAC_LEN], pkt->mac_len);
-	}
-
-	okey_set_u8(&ret[ULOG_KEY_RAW_LABEL], ip->config_kset->ces[3].u.value);
-
-	/* include pointer to raw ipv4 packet */
-	okey_set_ptr(&ret[ULOG_KEY_RAW_PCKT], pkt->payload);
-	okey_set_u32(&ret[ULOG_KEY_RAW_PCKTLEN], pkt->data_len);
-	okey_set_u32(&ret[ULOG_KEY_RAW_PCKTCOUNT], 1);
-
-	okey_set_ptr(&ret[ULOG_KEY_OOB_PREFIX], pkt->prefix);
-
-	/* god knows why timestamp_usec contains crap if timestamp_sec =3D=3D 0
-	 * if (pkt->timestamp_sec || pkt->timestamp_usec) { */
-	if (pkt->timestamp_sec) {
-		okey_set_u32(&ret[ULOG_KEY_OOB_TIME_SEC], pkt->timestamp_sec);
-		okey_set_u32(&ret[ULOG_KEY_OOB_TIME_USEC], pkt->timestamp_usec);
-	} else {
-		ret[ULOG_KEY_OOB_TIME_SEC].flags &=3D ~ULOGD_RETF_VALID;
-		ret[ULOG_KEY_OOB_TIME_USEC].flags &=3D ~ULOGD_RETF_VALID;
-	}
-
-	okey_set_u32(&ret[ULOG_KEY_OOB_MARK], pkt->mark);
-	okey_set_ptr(&ret[ULOG_KEY_OOB_IN], pkt->indev_name);
-	okey_set_ptr(&ret[ULOG_KEY_OOB_OUT], pkt->outdev_name);
-
-	okey_set_u8(&ret[ULOG_KEY_OOB_HOOK], pkt->hook);
-
-	/* ULOG is IPv4 only */
-	okey_set_u8(&ret[ULOG_KEY_OOB_FAMILY], AF_INET);
-	/* Undef in ULOG but necessary */
-	okey_set_u16(&ret[ULOG_KEY_OOB_PROTOCOL], 0);
-
-	ulogd_propagate_results(ip);
-	return 0;
-}
-
-static int ulog_read_cb(int fd, unsigned int what, void *param)
-{
-	struct ulogd_pluginstance *upi =3D (struct ulogd_pluginstance *)param;
-	struct ulogd_pluginstance *npi =3D NULL;
-	struct ulog_input *u =3D (struct ulog_input *) &upi->private;
-	ulog_packet_msg_t *upkt;
-	int len;
-
-	if (!(what & ULOGD_FD_READ))
-		return 0;
-
-	while ((len =3D ipulog_read(u->libulog_h, u->libulog_buf,
-				 upi->config_kset->ces[0].u.value))) {
-		if (len <=3D 0) {
-			if (errno =3D=3D EAGAIN)
-				break;
-			/* this is not supposed to happen */
-			ulogd_log(ULOGD_ERROR, "ipulog_read =3D %d! "
-				  "ipulog_errno =3D %d (%s), "
-				  "errno =3D %d (%s)\n",
-				  len, ipulog_errno,
-				  ipulog_strerror(ipulog_errno),
-				  errno, strerror(errno));
-			break;
-		}
-		while ((upkt =3D ipulog_get_packet(u->libulog_h,
-						 u->libulog_buf, len))) {
-			/* since we support the re-use of one instance in
-			 * several different stacks, we duplicate the message
-			 * to let them know */
-			llist_for_each_entry(npi, &upi->plist, plist)
-				interp_packet(npi, upkt);
-			interp_packet(upi, upkt);
-		}
-	}
-	return 0;
-}
-
-static int init(struct ulogd_pluginstance *upi)
-{
-	struct ulog_input *ui =3D (struct ulog_input *) &upi->private;
-
-	ui->libulog_buf =3D malloc(upi->config_kset->ces[0].u.value);
-	if (!ui->libulog_buf) {
-		ulogd_log(ULOGD_ERROR, "Out of memory\n");
-		goto out_buf;
-	}
-
-	ui->libulog_h =3D ipulog_create_handle(
-				ipulog_group2gmask(upi->config_kset->ces[1].u.value),
-				upi->config_kset->ces[2].u.value);
-	if (!ui->libulog_h) {
-		ulogd_log(ULOGD_ERROR, "Can't create ULOG handle\n");
-		goto out_handle;
-	}
-
-	ui->ulog_fd.fd =3D ipulog_get_fd(ui->libulog_h);
-	ui->ulog_fd.cb =3D &ulog_read_cb;
-	ui->ulog_fd.data =3D upi;
-	ui->ulog_fd.when =3D ULOGD_FD_READ;
-
-	ulogd_register_fd(&ui->ulog_fd);
-
-	return 0;
-
-out_handle:
-	free(ui->libulog_buf);
-out_buf:
-	return -1;
-}
-
-static int fini(struct ulogd_pluginstance *pi)
-{
-	struct ulog_input *ui =3D (struct ulog_input *)pi->private;
-
-	ulogd_unregister_fd(&ui->ulog_fd);
-
-	return 0;
-}
-
-struct ulogd_plugin libulog_plugin =3D {
-	.name =3D "ULOG",
-	.input =3D {
-		.type =3D ULOGD_DTYPE_SOURCE,
-		.keys =3D NULL,
-		.num_keys =3D 0,
-	},
-	.output =3D {
-		.type =3D ULOGD_DTYPE_RAW,
-		.keys =3D output_keys,
-		.num_keys =3D ARRAY_SIZE(output_keys),
-	},
-	.start =3D &init,
-	.stop =3D &fini,
-	.config_kset =3D &libulog_kset,
-	.version =3D VERSION,
-};
-
-void __attribute__ ((constructor)) initializer(void)
-{
-	ulogd_register_plugin(&libulog_plugin);
-}
diff --git a/ulogd.8 b/ulogd.8
index 9d16aeb..03f0da6 100644
=2D-- a/ulogd.8
+++ b/ulogd.8
@@ -26,7 +26,7 @@ connection tracking, the Netfilter packet logging subsys=
tem and from
 the Netfilter accounting subsystem. You have to enable support for
 connection tracking event delivery; ctnetlink and the NFLOG target in
 your Linux kernel 2.6.x or load their respective modules. The deprecated
-ULOG target (which has been superseded by NFLOG) is also
+ULOG target (which has been superseded by NFLOG) is no longer
 supported.
 .PP
 The received messages can be logged into files or into a mySQL, sqlite3
diff --git a/ulogd.conf.in b/ulogd.conf.in
index 9a04bf7..6e0b7c7 100644
=2D-- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -26,7 +26,6 @@ logfile=3D"/var/log/ulogd.log"
 # 2. options for each plugin in seperate section below

 #plugin=3D"@pkglibdir@/ulogd_inppkt_NFLOG.so"
-#plugin=3D"@pkglibdir@/ulogd_inppkt_ULOG.so"
 #plugin=3D"@pkglibdir@/ulogd_inppkt_UNIXSOCK.so"
 #plugin=3D"@pkglibdir@/ulogd_inpflow_NFCT.so"
 #plugin=3D"@pkglibdir@/ulogd_filter_IFINDEX.so"
@@ -58,9 +57,6 @@ logfile=3D"/var/log/ulogd.log"
 # this is a stack for packet-based logging via LOGEMU
 #stack=3Dlog2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPK=
T,emu1:LOGEMU

-# this is a stack for ULOG packet-based logging via LOGEMU
-#stack=3Dulog1:ULOG,base1:BASE,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
-
 # this is a stack for packet-based logging via LOGEMU with filtering on M=
ARK
 #stack=3Dlog2:NFLOG,base1:BASE,mark1:MARK,ifi1:IFINDEX,ip2str1:IP2STR,pri=
nt1:PRINTPKT,emu1:LOGEMU

@@ -175,11 +171,6 @@ numeric_label=3D1 # you can label the log info based =
on the packet verdict
 #netlink_socket_buffer_maxsize=3D1085440
 #bind=3D1

-[ulog1]
-# netlink multicast group (the same as the iptables --ulog-nlgroup param)
-nlgroup=3D1
-#numeric_label=3D0 # optional argument
-
 [nuauth1]
 socket_path=3D"/tmp/nuauth_ulogd2.sock"

=2D-
2.49.0
