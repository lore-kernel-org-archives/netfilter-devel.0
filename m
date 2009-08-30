From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] TProxy: added IPv6 support for socket match
Date: Sun, 30 Aug 2009 14:26:59 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0908301426390.4073@fbirervta.pbzchgretzou.qr>
References: <cover.1251439150.git.bazsi@balabit.hu> <611922658001654b08214cc17ac47e2aa53f88fb.1251439150.git.bazsi@balabit.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, tproxy@lists.balabit.hu,
	Harry Mason <harry.mason@smoothwall.net>
To: Balazs Scheidler <bazsi@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49916 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbZH3M07 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Aug 2009 08:26:59 -0400
In-Reply-To: <611922658001654b08214cc17ac47e2aa53f88fb.1251439150.git.bazsi@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-08-28 07:56, Balazs Scheidler wrote:
>+++ b/include/linux/netfilter/xt_socket.h
>@@ -0,0 +1,8 @@
>+#ifndef _XT_SOCKET_H_match
>+#define _XT_SOCKET_H_match
>+
>+struct xt_socket_match_info1 {
>+	__u8 transparent:1;
>+};
>+
>+#endif /* _XT_SOCKET_H_match */

Bitfields are a no-no in the ABI.
