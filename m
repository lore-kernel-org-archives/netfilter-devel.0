From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: netfilter: ipset: add missing break statemtns in
 ip_set_get_ip_port()
Date: Wed, 2 Feb 2011 20:49:19 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1102022046210.29563@blackhole.kfki.hu>
References: <4D49173C.6080703@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:49981 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab1BBTtU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Feb 2011 14:49:20 -0500
In-Reply-To: <4D49173C.6080703@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2 Feb 2011, Patrick McHardy wrote:

> Add missing break statements.

Thanks! It's a clear bugfix, I applied your patch.
 
> I assume the second switch statement which handles only TCP and UDP
> is intended to indicate whether a real port number instead of ICMP
> port and code were parsed? Otherwise we should add IPPROTO_ICMP and
> IPPROTO_ICMPV6 there too.

Yes, excatly. The function is called from the bitmap:port type which 
can handle TCP/UDP ports only.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
