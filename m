From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: [0/3] libnfnetlink and libnetfilter-(conntrack|log): byte
	alignment issues
Date: Tue, 03 Jun 2008 11:20:10 +0100
Message-ID: <1212488410.29489.39.camel@pumper.lan.luxnet.ch>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33660 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750825AbYFCKUW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2008 06:20:22 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I am using libnfnetlink, libnetfilter-conntrack and libnetfilter-log on
an XScale IXP422 processor (big endian ARM) and discovered byte
alignment bugs in these libraries.

An example from libnetfilter_log.c:
char buf[NFNL_HEADER_LEN + ...];
struct nlmsghdr *nmh = (struct nlmsghdr *) buf;

Casting a pointer to a byte array to an arbitrary struct without
checking byte alignment is not portable. If buf starts at an odd memory
address and the struct has to be aligned, this results in
non-deterministic behavior. No problems occur on i386, whereas it breaks
e.g. on my platform. See my posting "libnfnetlink: Strange behaviour in
nfnl_fill_hdr" from 05/13/2008.

I wrote three patches, which properly align the used buffers. I did not
analyze the code further. There are definitely more issues:

libnetfilter-log is still broken. To test I used nfulnl_test. With my
patches it reaches at least the main loop (without it breaks at
nflog_unbind_pf()). Decoding the packet from the byte buffer still
suffers from alignment problems, because again the char* is casted to a
struct* without alignment checking. A segfault occurs while calling
nflog_get_payload(ldata, payload) but the other calls are suspicious as
well. I did not elaborate further on this and don't plan to so for the
moment.

# nfulnl_test
unbinding existing nf_log handler for AF_INET (if any)
binding nfnetlink_log to AF_INET
binding this socket to group 0
binding this socket to group 100
setting copy_packet mode
registering callback for group 0
going into main loop
pkt received (len=176)
Segmentation fault

Versions:
libnfnetlink-0.0.38
libnetfilter_log 0.0.13
libnetfilter_conntrack-0.0.89
armeb-linux-gcc 4.2.4
CFLAGS -pipe -march=armv5te -mtune=xscale -funit-at-a-time
-fhonour-copts -msoft-float

