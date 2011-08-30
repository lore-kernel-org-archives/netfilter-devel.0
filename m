From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset 6.8 patches
Date: Tue, 30 Aug 2011 09:47:47 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1108300942190.26239@blackhole.kfki.hu>
References: <1314552769-19143-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:52747 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423Ab1H3Hrs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Aug 2011 03:47:48 -0400
In-Reply-To: <1314552769-19143-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

On Sun, 28 Aug 2011, Jan Engelhardt wrote:

> Jan Engelhardt (3):
>       ipset: use NFPROTO_ constants

I don't really like the NFPROTO_X_IPV46 identifier either. Could you name 
it NFPROTO_IPSET_IPV46 or suggest a better one?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
