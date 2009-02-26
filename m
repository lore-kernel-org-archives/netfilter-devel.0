From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [patch 5/7] make netfilter use strict integer types
Date: Thu, 26 Feb 2009 01:10:25 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902260104220.20789@fbirervta.pbzchgretzou.qr>
References: <20090225235138.062045835@arndb.de> <20090225235515.682333715@arndb.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>,
	Kyle McMartin <kyle@infradead.org>,
	Ingo Molnar <mingo@elte.hu>,
	Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
	mingo@redhat.com, dwmw2@infradead.org,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: arnd@arndb.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37360 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbZBZAK2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Feb 2009 19:10:28 -0500
In-Reply-To: <20090225235515.682333715@arndb.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-02-26 00:51, arnd@arndb.de wrote:

>Netfilter traditionally uses BSD integer types in its
>interface headers. This changes it to use the Linux
>strict integer types, like everyone else.

I _strongly disagree_ with this move. Userspace also has the uintX
types via <stdint.h>/<cstdint>, and now you are adding a dependency
on linux/types.h, not to mention that your step can lead to compile
time piling up.

IMHO, __uXX should be replaced by uintX_t, but a move this great I
will leave to future generations because there is just too much
persisting opinions wrt. such proposal. As such I'd like to join
and persist on my position and that uintX that we have should be kept.


>index a049df4..3066789 100644
>--- a/include/linux/netfilter/nf_conntrack_tcp.h
>+++ b/include/linux/netfilter/nf_conntrack_tcp.h
>@@ -2,6 +2,8 @@
> #define _NF_CONNTRACK_TCP_H
> /* TCP tracking. */
> 
>+#include <linux/types.h>
>+
> /* This is exposed to userspace (ctnetlink) */
> enum tcp_conntrack {
> 	TCP_CONNTRACK_NONE,
>@@ -34,8 +36,8 @@ enum tcp_conntrack {
> #define IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED	0x10
> 
> struct nf_ct_tcp_flags {
>-	u_int8_t flags;
>-	u_int8_t mask;
>+	__u8 flags;
>+	__u8 mask;
> };
> 
> #ifdef __KERNEL__
