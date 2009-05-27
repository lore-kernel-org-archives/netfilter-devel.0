From: Jan Engelhardt <jengelh@medozas.de>
Subject: ipset: bool type always overridden
Date: Wed, 27 May 2009 14:43:35 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0905271440590.29172@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0905271400540.26986@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38836 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761630AbZE0Mne (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 May 2009 08:43:34 -0400
In-Reply-To: <alpine.LSU.2.00.0905271400540.26986@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



>+++ b/extensions/ipset/ip_set_setlist.c
>+#ifndef bool
>+#define bool   int
>+#endif

Is wrong too, since bool is not a define in the first place. If things=20
go bad, it causes external functions to suddenly be accessed with a=20
different ABI than they actually have.

You will need to check for 2.6.18 instead:

#if LINUX_VERSION_CODE <=3D KERNEL_VERSION(2, 6, 18)
typedef _Bool bool;
enum { false =3D 0, true =3D 1, };
#endif
	=E2=80=94from xtables-addons/extensions/compat_xtnu.h
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
