From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 0/1] Conntrack event generation control, kernel part
Date: Tue, 12 May 2009 15:19:50 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0905121515530.28379@blackhole.kfki.hu>
References: <alpine.DEB.2.00.0905121348460.28379@blackhole.kfki.hu> <alpine.LSU.2.00.0905121445460.31110@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:39524 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbZELNTu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 May 2009 09:19:50 -0400
In-Reply-To: <alpine.LSU.2.00.0905121445460.31110@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

On Tue, 12 May 2009, Jan Engelhardt wrote:

> 
> On Tuesday 2009-05-12 13:52, Jozsef Kadlecsik wrote:
> 
> >diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
> >index d6e5ab4..86bc5ea 100644
> >--- a/net/netfilter/xt_CONNMARK.c
> >+++ b/net/netfilter/xt_CONNMARK.c
> >+
> >+struct compat_xt_connmark_tginfo1 {
> >+	__u32 ctmark, ctmask, nfmask;
> >+	__u8 mode;
> >+	__u8 __pad1;
> >+	__u16 __pad2;
> >+};
> 
> v1 does not need a compat mode, because it does not use 'int' or 'long'.
> Note: 'compat' here means "32-bit userspace with a 64-bit kernel". It
> does not mean converting v1 to v2.

Ahh, I'm blind, thanks! And the comments on the userspace part too - I'm 
going to fix and resend the patches.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
