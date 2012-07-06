From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 0/3] ipset: change 'iface' part in hash:net,iface set
Date: Fri, 6 Jul 2012 22:49:52 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207062243080.16055@blackhole.kfki.hu>
References: <cover.1341525006.git.mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207060947530.14535@blackhole.kfki.hu> <4FF736FE.8030109@googlemail.com> <alpine.DEB.2.00.1207062138140.16055@blackhole.kfki.hu> <4FF74868.3070303@googlemail.com>
 <CAHo-OowHXH9f526QQc4Ln5_P_Osdm1Q_RrBkw83hSGj=oES5ww@mail.gmail.com> <4FF74D5C.6060909@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:41169 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684Ab2GFUtx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jul 2012 16:49:53 -0400
In-Reply-To: <4FF74D5C.6060909@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 6 Jul 2012, Mr Dash Four wrote:

> > Because src != dst ?
> > 
> Exactly my point! src != dst, but src != in as well (see above). 'src' = 
> 'in' (and use the the term "equal" loosely here) *only* in the scope of 
> the 'iface' part of hash:net,iface set describing network interface 
> matches.

Do you deliberately close your eyes? In the two rules

iptables -A INPUT -m set --match-set list1 src,src -j ACCEPT
iptables -A INPUT -m set --match-set list1 src,in -j ACCEPT

the underlying set types "decide" how to act to "src/in", when actually 
"src" == "in". I hear you shouting: FOR HASH:NET,IFACE ONLY. Right. But 
"list1" is a list type of set, not hash:net,iface. Still, the result is 
different.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
