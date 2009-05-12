From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 0/1] Conntrack event generation control, kernel part
Date: Tue, 12 May 2009 14:46:47 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0905121445460.31110@fbirervta.pbzchgretzou.qr>
References: <alpine.DEB.2.00.0905121348460.28379@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39744 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbZELMqr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 May 2009 08:46:47 -0400
In-Reply-To: <alpine.DEB.2.00.0905121348460.28379@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-05-12 13:52, Jozsef Kadlecsik wrote:

>diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
>index d6e5ab4..86bc5ea 100644
>--- a/net/netfilter/xt_CONNMARK.c
>+++ b/net/netfilter/xt_CONNMARK.c
>+
>+struct compat_xt_connmark_tginfo1 {
>+	__u32 ctmark, ctmask, nfmask;
>+	__u8 mode;
>+	__u8 __pad1;
>+	__u16 __pad2;
>+};

v1 does not need a compat mode, because it does not use 'int' or 'long'.
Note: 'compat' here means "32-bit userspace with a 64-bit kernel". It
does not mean converting v1 to v2.
