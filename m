From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: IPT [PATCH] yay, autotools!
Date: Thu, 29 Nov 2007 08:48:22 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711290846090.11843@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0711280140320.4181@fbirervta.pbzchgretzou.qr>
 <474D2B75.9070301@trash.net> <Pine.LNX.4.64.0711281149100.16364@fbirervta.pbzchgretzou.qr>
 <474D5010.10609@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:33174 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286AbXK2HsZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2007 02:48:25 -0500
In-Reply-To: <474D5010.10609@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 28 Nov 2007, Patrick McHardy wrote:

> > If I can throw the three .*-tests out, the better. But would need to
> > add ipt_condition.h, ip6t_conditoin, ipt_set and ipt_SET, which
> > all are not in the kernel at this point. Nuke the modules?
> 
> For condition, sure. For set lets hear Jozsef's opinion, but since
> the kernel has to be patched anyway I think it shouldn't be much
> trouble to move the userspace part to pomng as well if it can't
> be supported.

No problem from my part, go ahead.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
