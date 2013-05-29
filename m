From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 0/4] ipset: add "inner" flag support
Date: Wed, 29 May 2013 18:38:14 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1305291833190.20804@blackhole.kfki.hu>
References: <51A54814.5040405@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:54654 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209Ab3E2QiQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 May 2013 12:38:16 -0400
In-Reply-To: <51A54814.5040405@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 29 May 2013, Dash Four wrote:

> This series of 4 patches implements "inner" flag option in the set
> iptables match, allowing matching based on the properties
> (source/destination IP address, protocol, port and so on) of the
> original (inner) connection in the event of the following
> ICMP[v4,v6] messages:
> 
> ICMPv4 destination-unreachable (code 3);
> ICMPv4 source-quench (code 4);
> ICMPv4 time-exceeded (code 11);
> ICMPv6 destination-unreachable (code 1);
> ICMPv6 packet-too-big (code 2);
> ICMPv6 time-exceeded (code 3);
> 
> 
> Dash Four (4):
>   ipset: minor variable-naming corrections
>   ipset: add "inner" flag implementation
>   iptables: add set match "inner" flag support
>   iptables (userspace): add set match "inner" flag support

I can review your patches in a few days, a quick look is not enough.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
