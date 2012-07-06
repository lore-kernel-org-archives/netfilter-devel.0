From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 0/3] ipset: change 'iface' part in hash:net,iface set
Date: Fri, 6 Jul 2012 10:35:05 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207060947530.14535@blackhole.kfki.hu>
References: <cover.1341525006.git.mr.dash.four@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:34415 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab2GFJM3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jul 2012 05:12:29 -0400
In-Reply-To: <cover.1341525006.git.mr.dash.four@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 5 Jul 2012, Mr Dash Four wrote:

> The following series of 3 patches included in this set allow 'in' or 
> 'out' values to be specified for the 'iface' part of hash:net,iface set, 
> corresponding to the incoming and outgoing interface accordingly, thus 
> eliminating the discrepancy which, up until now, existed with the 'old' 
> format and also reinforcing much-needed consistency with the rest of the 
> netfilter/iptables terminology.
> 
> For backwards compatibility, the 'old' format, comprising of 'src' 
> (incoming) and 'dst' (outgoing) direction parameter for the 'iface' part 
> of hash:net,iface is also supported.

You have to introduce a new set type version whenever a new feature is 
added: in your patches there is no protection against mixed cases, when 
only the kernel or just the userspace is upgraded. Or one side is 
downgraded for whatever reason.

You must handle the case of the list:set type: how should then the new 
"in", "out" be interpreted? Or should those be rejected? But then it'd 
mean that if someone used a hash:net,iface type as a member of list:set, 
then he is forced to use "src", "dst" only.

It'd be much simpler to introduce the keywords as aliases, all over:
"in" as "dst" and "out" as "src", and print them with hash:net,iface only.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
