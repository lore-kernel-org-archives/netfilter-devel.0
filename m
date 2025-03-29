Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CC517A2EB
	for <netfilter-devel@vger.kernel.org>; Sat, 29 Mar 2025 11:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743246541; cv=none; b=EwGKmvGfEbkUMsMx+q2Sd7T4RjmEBuKO+HVX17WELz3r8uZYLGSUwoT072b88+bzKJQnF1VbubGsfGPBm3f2jS8NHbC9YOCGiVDR52vz+ZwPZRDYUNj3mA/cVgO6mDlVzllEDvVV1SSNnqbaIvRHkEWfdN2CykTKyK2xyrBc02E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743246541; c=relaxed/simple;
	bh=1IwSrmqVqZKXuxfHtCT1DgTIj+JPfIRR9AkA/AoM6pI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=V/wAYRHB5SABoRvNx+a8RJnKJ52oHraNzJxvACXzdjZhlJuifMJL0f2HTr3A6W0fz5fB1ARztZmTPXdOzkmIUDXiCVy7MUGTyC0tiliZyO8SmebS4X0jCAD4D8jQbmv2nlyY9UxMMsRDzqn48/dWKoVyG6fbzcl7ASjKO3CpJBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=JUmKun0j; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="JUmKun0j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1743246536; x=1743851336; i=corubba@gmx.de;
	bh=t+QMWujyQoUDvsaj9khZLJ0gKjN8oabrqpFa7nrTs0k=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=JUmKun0jv8aYaBeerI/hk6vO7fbwen4vYs61voejZFZWoWcTGFBGcXPqTBW8XILj
	 rCtVg3Hu2vYpfS/FyFQcbKQg3M1TfsIm1fcPCOrKplcckwt+CUhh9x1vTRwPbY6pk
	 5k2KZhQsoeoWrxHlFPYybrfFsYfQ+jA7QWPgKMrvQ/3nWESjlFbJX/KxjwMnY9xR2
	 K5V/xmWMBFZr4F8jvlomsBHaBrz88LEDwJ3OmolVbzbd2veCbulSnm2VsPbJ2ykma
	 0hqKHAG1a4H1TbHI6joIG14TdhXjyIrSoObBBj0KtsB2mMtNAphbLm1Yf5ehnqcIQ
	 kKNfx5h19TuWkRrgwg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from 127.0.0.1 ([94.134.25.34]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MvbG2-1t5pPC0kbO-014x7B for
 <netfilter-devel@vger.kernel.org>; Sat, 29 Mar 2025 12:08:56 +0100
Message-ID: <c08b266d-eea9-49b2-97bc-adf0f3137c7b@gmx.de>
Date: Sat, 29 Mar 2025 12:08:55 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: [PATCH ulogd2 2/2] ulogd: remove libipulog
From: Corubba Smith <corubba@gmx.de>
To: netfilter-devel@vger.kernel.org
References: <23db0352-9525-427b-a936-c8ef87e4d5b7@gmx.de>
Content-Language: de-CH
In-Reply-To: <23db0352-9525-427b-a936-c8ef87e4d5b7@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:3NEKctQr3MhUl6cGfDAOFb5F92o0IEcdnomKmiluG0jDinsMwji
 F0awFAyLZXaxIuRzOyf7MGitzgn3XDXKV6OolsnKQfAeDDx9vK6dFaWqGcPKPtM3XzEAGZZ
 QIuibcCZGuGr+fx1/BVtMJ+5vK4r2k5BWZ6M9Rd1RHW3Wdff36tzYuAJuQE4fzZcWeZE+nt
 YoX6VY0oaBcvLX71Mznzw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:0h4pgUJS8vE=;YDnsFMttso5yPvDWp/wrkXiMorM
 B6Urs9M9G5uhAN1iDUshREYsZoCr3WreSYrJ4OuvPXeML6sg7YFUZt5v+emqoBhzEKSE56ZaW
 5qN71K3BGlH9RsbcyOaq0HVTZ/4rIA9QahVCeKVxj8v+9yXP11M0Oi7aBybj/LNMhiOndNJV4
 nKeCEemhwFCdzFP5edZCVJC+38+srkBTLtAxwaf9Txp66dvAwnfZMTcxjlhWpDjGcYIUagRld
 fYxe9vvJqoeRIQ/jXyBlmZDsCum1altetrypX2oSw3YNjb+YM+IlQdQ5+7k3WfAmpTfISBMms
 lk4mBus/uUVg0wLN5zzcGQNzU0BU6q0cwEm2wBI2d6YhrHU+3bABFxHj3+A0hiDIAqbXnVfHw
 fp4y8idN708ThW2BBUaqAonXHTPiIRuS7qBU5Sx2I3tS+7dS9qxZVs7ivPzxGc1avLkdTbm3V
 oKSdrtOt8EcClRikOTiD21938oAK5B+hd9BSPn63tjqz7QpXX1weYNPit9GNVzok4xL92PLEv
 C1Lkm0PjUWuL1VPFmRBzMZYR57AIrz/SN/HlPKFAmjlkKJlTtGnuCZgY33k54PsaoRSaTPYnu
 REL/Lx7QtyVT1Lnrcwh1s3YEJ5d3CV/hKuakCShpkrSfusOmn2wtKfj4EGYGahQulpAgpDY81
 Q0uPHuzwrYtNK9BA0737Ubo/GQSrNweo0HoSYskQNRzg24BOCBH4SbuwPMFdGL5yJyYFmBIjT
 qPnkDUybffXxZpeTo6B28xnFKYZj9mLneoKecERREqDi20qehAMiS5/q5Y1q2cMK8f/Es6EUp
 ytvrik74/BjtbjHfhsw3ovsv7K/9w8b4t3Rj6tiGVUJXecQXXLupHWPoG2cfxGIaj/73eLsO4
 ua1Yc8D1AZ+ece/+E0cmSjjNY3p8ByBlkwGc4ExG8VXhAEzpzb5NtbnslE1DdKOGKjIMyz/k5
 +h7tBnysevWB6aB5Toexud3EUz7bDTFPPxojd6telEe/DjpDYQtetxJfBKDnPpVhAxLJuwuZD
 wK3CXw/Ru4pQPIi6PSKZN5j1lBkNNfKN5eJPOgilNQGKOC4FuyHB6LKTlsEb8viVOKCmkUDXg
 q2vPnIIbFGJpqN1UMSHxSJQBKRsMMkDk8ZMHavEMHdWhoYnjdv1+2flnL5pnH/dmIaMMz6hVN
 wXZnPGsQACaQbo5qb5DM/fXS1ADKxKVNBGYHMhhuVS3eEndDzm9FUKk2Ys8Pj4NR1uj3Qbk76
 d7q7XL79JTVkw6H1d0SLNKV0lHaAo2MObHLf1ZOz32DZv1NhNTO4pbcsKY4S1idVa1up0gu/4
 qc28BvPqidTKRApxxwtqNYOlqfdxBo1jsubDk65VgYTRYQQ3Qd8PbcwPjoPmgwrLGzUBNq+VD
 TrJH3c1PnavqPiXAVDDR5CPKfYqykCEco0nlfcpW1l57yGL97podQUfUo0+NQltrLDERXumt1
 3SNng9FcCobmvpY05My8MaYnE++4=

The ULOG target was removed from linux kernel with 7200135bc1e6
("netfilter: kill ulog targets") aka v3.17, so remove the userspace
library for it. libnetfilter_log provides the same functionality for
NFLOG, and also a compatibility layer to use NFLOG through the libipulog
api.

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
 Makefile.am                              |   2 +-
 configure.ac                             |   3 -
 include/Makefile.am                      |   2 +-
 include/libipulog/Makefile.am            |   1 -
 include/libipulog/libipulog.h            |  57 -----
 include/linux/Makefile.am                |   3 +-
 include/linux/netfilter_ipv4/Makefile.am |   1 -
 include/linux/netfilter_ipv4/ipt_ULOG.h  |  49 -----
 libipulog/Makefile.am                    |   5 -
 libipulog/libipulog.c                    | 260 -----------------------
 libipulog/ulog_test.c                    |  83 --------
 11 files changed, 3 insertions(+), 463 deletions(-)
 delete mode 100644 include/libipulog/Makefile.am
 delete mode 100644 include/libipulog/libipulog.h
 delete mode 100644 include/linux/netfilter_ipv4/Makefile.am
 delete mode 100644 include/linux/netfilter_ipv4/ipt_ULOG.h
 delete mode 100644 libipulog/Makefile.am
 delete mode 100644 libipulog/libipulog.c
 delete mode 100644 libipulog/ulog_test.c

diff --git a/Makefile.am b/Makefile.am
index bf390a4..b8d8db3 100644
=2D-- a/Makefile.am
+++ b/Makefile.am
@@ -1,4 +1,4 @@
-SUBDIRS =3D include libipulog src input filter output
+SUBDIRS =3D include src input filter output

 ACLOCAL_AMFLAGS =3D -I m4

diff --git a/configure.ac b/configure.ac
index dca8a2a..c4a84f3 100644
=2D-- a/configure.ac
+++ b/configure.ac
@@ -246,16 +246,13 @@ AC_CONFIG_FILES([Makefile
 		 filter/Makefile
 		 filter/raw2packet/Makefile
 		 include/Makefile
-		 include/libipulog/Makefile
 		 include/linux/Makefile
 		 include/linux/netfilter/Makefile
-		 include/linux/netfilter_ipv4/Makefile
 		 include/ulogd/Makefile
 		 input/Makefile
 		 input/flow/Makefile
 		 input/packet/Makefile
 		 input/sum/Makefile
-		 libipulog/Makefile
 		 output/Makefile
 		 output/dbi/Makefile
 		 output/ipfix/Makefile
diff --git a/include/Makefile.am b/include/Makefile.am
index c62b497..49b5697 100644
=2D-- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -1 +1 @@
-SUBDIRS =3D ulogd libipulog linux
+SUBDIRS =3D ulogd linux
diff --git a/include/libipulog/Makefile.am b/include/libipulog/Makefile.am
deleted file mode 100644
index 80d16b1..0000000
=2D-- a/include/libipulog/Makefile.am
+++ /dev/null
@@ -1 +0,0 @@
-noinst_HEADERS =3D libipulog.h
diff --git a/include/libipulog/libipulog.h b/include/libipulog/libipulog.h
deleted file mode 100644
index 21b4315..0000000
=2D-- a/include/libipulog/libipulog.h
+++ /dev/null
@@ -1,57 +0,0 @@
-#ifndef _LIBIPULOG_H
-#define _LIBIPULOG_H
-
-#include <errno.h>
-#include <unistd.h>
-#include <fcntl.h>
-#include <sys/socket.h>
-#include <sys/uio.h>
-#include <stdint.h>
-#include <linux/netlink.h>
-#include <net/if.h>
-#include <linux/netfilter_ipv4/ipt_ULOG.h>
-
-/* FIXME: glibc sucks */
-#ifndef MSG_TRUNC
-#define MSG_TRUNC	0x20
-#endif
-
-struct ipulog_handle;
-extern int ipulog_errno;
-
-uint32_t ipulog_group2gmask(uint32_t group);
-
-struct ipulog_handle *ipulog_create_handle(uint32_t gmask, uint32_t rmem)=
;
-
-void ipulog_destroy_handle(struct ipulog_handle *h);
-
-ssize_t ipulog_read(struct ipulog_handle *h,
-		    unsigned char *buf, size_t len);
-
-ulog_packet_msg_t *ipulog_get_packet(struct ipulog_handle *h,
-				     const unsigned char *buf,
-				     size_t len);
-
-char *ipulog_strerror(int errcode);
-
-int ipulog_get_fd(struct ipulog_handle *h);
-
-void ipulog_perror(const char *s);
-
-enum
-{
-	IPULOG_ERR_NONE =3D 0,
-	IPULOG_ERR_IMPL,
-	IPULOG_ERR_HANDLE,
-	IPULOG_ERR_SOCKET,
-	IPULOG_ERR_BIND,
-	IPULOG_ERR_RECVBUF,
-	IPULOG_ERR_RECV,
-	IPULOG_ERR_NLEOF,
-	IPULOG_ERR_TRUNC,
-	IPULOG_ERR_INVGR,
-	IPULOG_ERR_INVNL,
-};
-#define IPULOG_MAXERR IPULOG_ERR_INVNL
-
-#endif /* _LIBULOG_H */
diff --git a/include/linux/Makefile.am b/include/linux/Makefile.am
index 18af1c2..38eb109 100644
=2D-- a/include/linux/Makefile.am
+++ b/include/linux/Makefile.am
@@ -1,2 +1 @@
-SUBDIRS =3D netfilter		\
-	  netfilter_ipv4
+SUBDIRS =3D netfilter
diff --git a/include/linux/netfilter_ipv4/Makefile.am b/include/linux/netf=
ilter_ipv4/Makefile.am
deleted file mode 100644
index 41819a3..0000000
=2D-- a/include/linux/netfilter_ipv4/Makefile.am
+++ /dev/null
@@ -1 +0,0 @@
-noinst_HEADERS =3D ipt_ULOG.h
diff --git a/include/linux/netfilter_ipv4/ipt_ULOG.h b/include/linux/netfi=
lter_ipv4/ipt_ULOG.h
deleted file mode 100644
index 417aad2..0000000
=2D-- a/include/linux/netfilter_ipv4/ipt_ULOG.h
+++ /dev/null
@@ -1,49 +0,0 @@
-/* Header file for IP tables userspace logging, Version 1.8
- *
- * (C) 2000-2002 by Harald Welte <laforge@gnumonks.org>
- *
- * Distributed under the terms of GNU GPL */
-
-#ifndef _IPT_ULOG_H
-#define _IPT_ULOG_H
-
-#ifndef NETLINK_NFLOG
-#define NETLINK_NFLOG 	5
-#endif
-
-#define ULOG_DEFAULT_NLGROUP	1
-#define ULOG_DEFAULT_QTHRESHOLD	1
-
-#define ULOG_MAC_LEN	80
-#define ULOG_PREFIX_LEN	32
-
-#define ULOG_MAX_QLEN	50
-/* Why 50? Well... there is a limit imposed by the slab cache 131000
- * bytes. So the multipart netlink-message has to be < 131000 bytes.
- * Assuming a standard ethernet-mtu of 1500, we could define this up
- * to 80... but even 50 seems to be big enough. */
-
-/* private data structure for each rule with a ULOG target */
-struct ipt_ulog_info {
-	unsigned int nl_group;
-	size_t copy_range;
-	size_t qthreshold;
-	char prefix[ULOG_PREFIX_LEN];
-};
-
-/* Format of the ULOG packets passed through netlink */
-typedef struct ulog_packet_msg {
-	unsigned long mark;
-	long timestamp_sec;
-	long timestamp_usec;
-	unsigned int hook;
-	char indev_name[IFNAMSIZ];
-	char outdev_name[IFNAMSIZ];
-	size_t data_len;
-	char prefix[ULOG_PREFIX_LEN];
-	unsigned char mac_len;
-	unsigned char mac[ULOG_MAC_LEN];
-	unsigned char payload[0];
-} ulog_packet_msg_t;
-
-#endif /*_IPT_ULOG_H*/
diff --git a/libipulog/Makefile.am b/libipulog/Makefile.am
deleted file mode 100644
index 708975a..0000000
=2D-- a/libipulog/Makefile.am
+++ /dev/null
@@ -1,5 +0,0 @@
-include $(top_srcdir)/Make_global.am
-
-noinst_LTLIBRARIES =3D libipulog.la
-
-libipulog_la_SOURCES =3D libipulog.c
diff --git a/libipulog/libipulog.c b/libipulog/libipulog.c
deleted file mode 100644
index b49f7f2..0000000
=2D-- a/libipulog/libipulog.c
+++ /dev/null
@@ -1,260 +0,0 @@
-/*
- * libipulog.c
- *
- * netfilter ULOG userspace library.
- *
- * (C) 2000-2001 by Harald Welte <laforge@gnumonks.org>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2
- *  as published by the Free Software Foundation
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 =
 USA
- *
- * This library is still under development, so be aware of sudden interfa=
ce
- * changes
- *
- */
-
-#include <stdlib.h>
-#include <stdio.h>
-#include <string.h>
-#include <unistd.h>
-#include <net/if.h>
-#include <libipulog/libipulog.h>
-
-struct ipulog_handle
-{
-	int fd;
-	uint8_t blocking;
-	struct sockaddr_nl local;
-	struct sockaddr_nl peer;
-	struct nlmsghdr* last_nlhdr;
-};
-
-/* internal */
-
-
-int ipulog_errno =3D IPULOG_ERR_NONE;
-
-struct ipulog_errmap_t
-{
-	int errcode;
-	char *message;
-} ipulog_errmap[] =3D
-{
-	{ IPULOG_ERR_NONE, "No error" },
-	{ IPULOG_ERR_IMPL, "Not implemented yet" },
-	{ IPULOG_ERR_HANDLE, "Unable to create netlink handle" },
-	{ IPULOG_ERR_SOCKET, "Unable to create netlink socket" },
-	{ IPULOG_ERR_BIND, "Unable to bind netlink socket" },
-	{ IPULOG_ERR_RECVBUF, "Receive buffer size invalid" },
-	{ IPULOG_ERR_RECV, "Error during netlink receive" },
-	{ IPULOG_ERR_NLEOF, "Received EOF on netlink socket" },
-	{ IPULOG_ERR_TRUNC, "Receive message truncated" },
-	{ IPULOG_ERR_INVGR, "Invalid group specified" },
-	{ IPULOG_ERR_INVNL, "Invalid netlink message" },
-};
-
-static ssize_t
-ipulog_netlink_recvfrom(const struct ipulog_handle *h,
-			unsigned char *buf, size_t len)
-{
-	socklen_t addrlen;
-	int status;
-	struct nlmsghdr *nlh;
-
-	if (len < sizeof(struct nlmsgerr)) {
-		ipulog_errno =3D IPULOG_ERR_RECVBUF;
-		return -1;
-	}
-	addrlen =3D sizeof(h->peer);
-	status =3D recvfrom(h->fd, buf, len, 0, (struct sockaddr *)&h->peer,
-			&addrlen);
-	if (status < 0) {
-		ipulog_errno =3D IPULOG_ERR_RECV;
-		return status;
-	}
-	if (addrlen !=3D sizeof (h->peer)) {
-		ipulog_errno =3D IPULOG_ERR_RECV;
-		return -1;
-	}
-	if (h->peer.nl_pid !=3D 0) {
-		ipulog_errno =3D IPULOG_ERR_RECV;
-		return -1;
-	}
-	if (status =3D=3D 0) {
-		ipulog_errno =3D IPULOG_ERR_NLEOF;
-		return -1;
-	}
-	nlh =3D (struct nlmsghdr *)buf;
-	if (nlh->nlmsg_flags & MSG_TRUNC || (size_t) status > len) {
-		ipulog_errno =3D IPULOG_ERR_TRUNC;
-		return -1;
-	}
-	return status;
-}
-
-/* public */
-
-char *ipulog_strerror(int errcode)
-{
-	if (errcode < 0 || errcode > IPULOG_MAXERR)
-		errcode =3D IPULOG_ERR_IMPL;
-	return ipulog_errmap[errcode].message;
-}
-
-/* convert a netlink group (1-32) to a group_mask suitable for create_han=
dle */
-uint32_t ipulog_group2gmask(uint32_t group)
-{
-	if (group < 1 || group > 32)
-	{
-		ipulog_errno =3D IPULOG_ERR_INVGR;
-		return 0;
-	}
-	return (1 << (group - 1));
-}
-
-/* create a ipulog handle for the reception of packets sent to gmask */
-struct ipulog_handle *ipulog_create_handle(uint32_t gmask,
-					   uint32_t rcvbufsize)
-{
-	struct ipulog_handle *h;
-	int status;
-
-	h =3D (struct ipulog_handle *) malloc(sizeof(struct ipulog_handle));
-	if (h =3D=3D NULL)
-	{
-		ipulog_errno =3D IPULOG_ERR_HANDLE;
-		return NULL;
-	}
-	memset(h, 0, sizeof(struct ipulog_handle));
-	h->fd =3D socket(PF_NETLINK, SOCK_RAW, NETLINK_NFLOG);
-	if (h->fd =3D=3D -1)
-	{
-		ipulog_errno =3D IPULOG_ERR_SOCKET;
-		close(h->fd);
-		free(h);
-		return NULL;
-	}
-	memset(&h->local, 0, sizeof(struct sockaddr_nl));
-	h->local.nl_family =3D AF_NETLINK;
-	h->local.nl_pid =3D getpid();
-	h->local.nl_groups =3D gmask;
-	status =3D bind(h->fd, (struct sockaddr *)&h->local, sizeof(h->local));
-	if (status =3D=3D -1)
-	{
-		ipulog_errno =3D IPULOG_ERR_BIND;
-		close(h->fd);
-		free(h);
-		return NULL;
-	}
-	memset(&h->peer, 0, sizeof(struct sockaddr_nl));
-	h->peer.nl_family =3D AF_NETLINK;
-	h->peer.nl_pid =3D 0;
-	h->peer.nl_groups =3D gmask;
-
-	status =3D setsockopt(h->fd, SOL_SOCKET, SO_RCVBUF, &rcvbufsize,
-			    sizeof(rcvbufsize));
-	if (status =3D=3D -1)
-	{
-		ipulog_errno =3D IPULOG_ERR_RECVBUF;
-		close(h->fd);
-		free(h);
-		return NULL;
-	}
-
-	return h;
-}
-
-/* destroy a ipulog handle */
-void ipulog_destroy_handle(struct ipulog_handle *h)
-{
-	close(h->fd);
-	free(h);
-}
-
-#if 0
-int ipulog_set_mode()
-{
-}
-#endif
-
-/* do a BLOCKING read on an ipulog handle */
-ssize_t ipulog_read(struct ipulog_handle *h, unsigned char *buf,
-		    size_t len)
-{
-	return ipulog_netlink_recvfrom(h, buf, len);
-}
-
-/* get a pointer to the actual start of the ipulog packet,
-   use this to strip netlink header */
-ulog_packet_msg_t *ipulog_get_packet(struct ipulog_handle *h,
-				     const unsigned char *buf,
-				     size_t len)
-{
-	struct nlmsghdr *nlh;
-	size_t remain_len;
-
-	/* if last header in handle not inside this buffer,
-	 * drop reference to last header */
-	if ((unsigned char *)h->last_nlhdr > (buf + len) ||
-	    (unsigned char *)h->last_nlhdr < buf) {
-		h->last_nlhdr =3D NULL;
-	}
-
-	if (!h->last_nlhdr) {
-		/* fist message in buffer */
-		nlh =3D (struct nlmsghdr *) buf;
-		if (!NLMSG_OK(nlh, len)) {
-			/* ERROR */
-			ipulog_errno =3D IPULOG_ERR_INVNL;
-			return NULL;
-		}
-	} else {
-		/* we are in n-th part of multilink message */
-		if (h->last_nlhdr->nlmsg_type =3D=3D NLMSG_DONE ||
-		    !(h->last_nlhdr->nlmsg_flags & NLM_F_MULTI)) {
-			/* if last part in multilink message,
-			 * or no multipart message at all: return */
-			h->last_nlhdr =3D NULL;
-			return NULL;
-		}
-
-		/* calculate remaining lenght from lasthdr to end of buffer */
-		remain_len =3D (len -
-				((unsigned char *)h->last_nlhdr - buf));
-		nlh =3D NLMSG_NEXT(h->last_nlhdr, remain_len);
-	}
-
-	h->last_nlhdr =3D nlh;
-
-	return NLMSG_DATA(nlh);
-}
-
-/* print a human readable description of the last error to stderr */
-void ipulog_perror(const char *s)
-{
-	if (s)
-		fputs(s, stderr);
-	else
-		fputs("ERROR", stderr);
-	if (ipulog_errno)
-		fprintf(stderr, ": %s", ipulog_strerror(ipulog_errno));
-	if (errno)
-		fprintf(stderr, ": %s", strerror(errno));
-	fputc('\n', stderr);
-}
-
-int ipulog_get_fd(struct ipulog_handle *h)
-{
-	return h->fd;
-}
-
diff --git a/libipulog/ulog_test.c b/libipulog/ulog_test.c
deleted file mode 100644
index 0665717..0000000
=2D-- a/libipulog/ulog_test.c
+++ /dev/null
@@ -1,83 +0,0 @@
-/* ulog_test
- *
- * small testing program for libipulog, part of the netfilter ULOG target
- * for the linux 2.4 netfilter subsystem.
- *
- * (C) 2000 by Harald Welte <laforge@gnumonks.org>
- *
- * this code is released under the terms of GNU GPL
- *
- */
-
-#include <stdio.h>
-#include <stdlib.h>
-#include <libipulog/libipulog.h>
-
-#define MYBUFSIZ 2048
-
-/* prints some logging about a single packet */
-void handle_packet(ulog_packet_msg_t *pkt)
-{
-	unsigned char *p;
-	int i;
-
-	printf("Hook=3D%u Mark=3D%lu len=3D%d ",
-	       pkt->hook, pkt->mark, pkt->data_len);
-	if (strlen(pkt->prefix))
-		printf("Prefix=3D%s ", pkt->prefix);
-
-	if (pkt->mac_len)
-	{
-		printf("mac=3D");
-		p =3D pkt->mac;
-		for (i =3D 0; i < pkt->mac_len; i++, p++)
-			printf("%02x%c", *p, i=3D=3Dpkt->mac_len-1 ? ' ':':');
-	}
-	printf("\n");
-
-}
-
-int main(int argc, char *argv[])
-{
-	struct ipulog_handle *h;
-	unsigned char* buf;
-	int len;
-	ulog_packet_msg_t *upkt;
-	int i;
-
-	if (argc !=3D 4) {
-		fprintf(stderr, "Usage: %s count group timeout\n", argv[0]);
-		exit(1);
-	}
-
-	/* allocate a receive buffer */
-	buf =3D (unsigned char *) malloc(MYBUFSIZ);
-
-	/* create ipulog handle */
-	h =3D ipulog_create_handle(ipulog_group2gmask(atoi(argv[2])));
-	if (!h)
-	{
-		/* if some error occurrs, print it to stderr */
-		ipulog_perror(NULL);
-		exit(1);
-	}
-
-	alarm(atoi(argv[3]));
-
-	/* loop receiving packets and handling them over to handle_packet */
-	for (i =3D 0; i < atoi(argv[1]); i++) {
-		len =3D ipulog_read(h, buf, MYBUFSIZ);
-		if (len <=3D 0) {
-			ipulog_perror("ulog_test: short read");
-			exit(1);
-		}
-		printf("%d bytes received\n", len);
-		while (upkt =3D ipulog_get_packet(h, buf, len)) {
-			handle_packet(upkt);
-		}
-	}
-
-	/* just to give it a cleaner look */
-	ipulog_destroy_handle(h);
-	return 0;
-}
=2D-
2.49.0
