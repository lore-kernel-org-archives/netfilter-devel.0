From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset: make header files usable from userspace
Date: Tue, 30 Aug 2011 09:41:47 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1108300938500.26239@blackhole.kfki.hu>
References: <1314541826-7448-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:44581 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423Ab1H3Hlv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Aug 2011 03:41:51 -0400
In-Reply-To: <1314541826-7448-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

On Sun, 28 Aug 2011, Jan Engelhardt wrote:
 
> While refreshing iptables's header files with new ones from the
> kernel, libxt_SET fails to compile because some definitions were
> locked away in __KERNEL__ sections when they should not have been.

In the second patch please move the type id and the ip_set_dim enum 
together outside of the __KERNEL__ section. Thus a single #ifdef section
suffices. Thanks!

Best regards,
Jozsef 
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
