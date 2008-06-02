From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: [PATCH] netfilter ulog byte alignment problem
Date: Mon, 02 Jun 2008 18:05:48 +0100
Message-ID: <1212426348.31217.30.camel@pumper.lan.luxnet.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45298 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752913AbYFBRFz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:05:55 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I am using libipulog on an XScale IXP422 processor (big endian ARM). I
call ipulog_get_packet to decode the multipart message and then access
the fields in the packet (ulog_packet_msg_t). Accessing fields 'mac' an=
d
'payload' does not give me the right data. The data is actually there,
but an access to the arrays ends up at a wrong location. Manually addin=
g
an offset leads to the correct position (e.g. pkt->payload[-66] instead
of pkt->payload[0] for the first byte of the IP packet).

I tracked the issue down to a byte alignment problem in
ulog_packet_msg_t (include/linux/netfilter_ipv4/ipt_ULOG.h). Setting
attributes 'packed' or 'aligned' or using 'size_t' instead of 'unsigned
char' for field 'mac_len' solved the problem. It seems necessary to hel=
p
the compiler doing things right.

This patch requires applications to be recompiled against the new heade=
r
file. Let me know what you think.

linux 2.6.25.4
libipulog r6382
=EF=BB=BFarmeb-linux-gcc 4.2.4
CFLAGS -pipe -march=3Darmv5te -mtune=3Dxscale -funit-at-a-time
-fhonour-copts -msoft-float

Signed-off-by: Fabian Hugelshofer <hugelshofer2006@gmx.ch>

--- linux-2.6.25.4/include/linux/netfilter_ipv4/ipt_ULOG.h.orig	2008-06=
-02 15:39:22.000000000 +0100
+++ linux-2.6.25.4/include/linux/netfilter_ipv4/ipt_ULOG.h	2008-06-02 1=
5:36:34.000000000 +0100
@@ -44,6 +44,6 @@
 	unsigned char mac_len;
 	unsigned char mac[ULOG_MAC_LEN];
 	unsigned char payload[0];
-} ulog_packet_msg_t;
+} ulog_packet_msg_t __attribute__ ((packed));
=20
 #endif /*_IPT_ULOG_H*/


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
