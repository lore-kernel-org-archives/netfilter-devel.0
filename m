From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v2 3/3] ipset: change 'iface' part in hash:net,iface
 set
Date: Sat, 14 Jul 2012 10:45:51 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207141009340.1031@blackhole.kfki.hu>
References: <cover.1341871199.git.mr.dash.four@googlemail.com> <1341872622-5015-2-git-send-email-mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207101721510.24998@blackhole.kfki.hu> <4FFCBDB8.9080101@googlemail.com> <alpine.DEB.2.00.1207112154070.26540@blackhole.kfki.hu>
 <4FFF6EF2.6010108@googlemail.com> <alpine.DEB.2.00.1207130857480.31126@blackhole.kfki.hu> <5000293F.4030901@googlemail.com> <alpine.DEB.2.00.1207131608230.32475@blackhole.kfki.hu> <50002F3F.5020408@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:59311 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757878Ab2GNIp4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Jul 2012 04:45:56 -0400
In-Reply-To: <50002F3F.5020408@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 13 Jul 2012, Mr Dash Four wrote:

> Let me ask you a question then - if I send you the patches where in/out is
> allowed in list:set and produces "consistent" (by your own high-standards)
> result would that be OK with you (if not, why not)?

I can see two possible solutions with "in/out" notation and list:set type:

a. The keywords are not permitted at all.
b. "in/out" is permitted but "converted" to "src/dst" wherever needed for
   the member sets, that is all types but hash:net,iface.

Solution a. is completely acceptable for me. It can nicely be documented, 
there's no chance for misunderstanding.

Solution b. is also acceptable but it's more controversial: if "in/out" is 
accepted with list:set type, then it's very hard to explain why it's *not* 
allowed with every type, when actually "in/out" is allowed then for every 
type of member sets of list:set type of sets. So solution b. implies that 
"in/out" is then a general synonym of "src/dst" and should be allowed 
everywhere. Therefore I'm not really happy with solution b. but I can 
stomach it.

Do you see other possibilities, which produce result independent of the 
allowed syntax?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
