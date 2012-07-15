From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v2 3/3] ipset: change 'iface' part in hash:net,iface
 set
Date: Sun, 15 Jul 2012 21:39:36 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207152136090.4382@blackhole.kfki.hu>
References: <cover.1341871199.git.mr.dash.four@googlemail.com> <1341872622-5015-2-git-send-email-mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207101721510.24998@blackhole.kfki.hu> <4FFCBDB8.9080101@googlemail.com> <alpine.DEB.2.00.1207112154070.26540@blackhole.kfki.hu>
 <4FFF6EF2.6010108@googlemail.com> <alpine.DEB.2.00.1207130857480.31126@blackhole.kfki.hu> <5000293F.4030901@googlemail.com> <alpine.DEB.2.00.1207131608230.32475@blackhole.kfki.hu> <50002F3F.5020408@googlemail.com> <alpine.DEB.2.00.1207141009340.1031@blackhole.kfki.hu>
 <5001678C.6000505@googlemail.com> <alpine.DEB.2.00.1207141816580.1593@blackhole.kfki.hu> <5002AF68.9070204@googlemail.com> <alpine.DEB.2.00.1207151552140.3610@blackhole.kfki.hu> <5002F0AF.4000502@googlemail.com>
 <alpine.DEB.2.00.1207152041270.4159@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:40982 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab2GOTjj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Jul 2012 15:39:39 -0400
In-Reply-To: <alpine.DEB.2.00.1207152041270.4159@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 15 Jul 2012, Jozsef Kadlecsik wrote:

> Because this or that way, someone would scratch his/her head. For example 
> if the rule contains "in/out" and the list:set is a mixed one, contains 
> both hash:net,iface and other types of sets. They'll ask: "What the heck 
> is "in/out" for say hash:ip type of set?" Let me cite again our own words:

A letter is missing, which may easily lead to misunderstanding, in spite 
of the prefix before the next citation. So the corrected sentence is:

> ....... Let me cite again your own words:
 
> You:> Simpler for whom? It can't be for the end user, because referring 
> You:> to, say, destination IP address as "out" IP address is even more 
> You:> ridiculous than using 'src' and 'dst' designators for network 
> You:> interfaces. Quite astonishing that!
> 
> So we circled again. Shortcut the next round:
> 
> Send your patches according to solution a, that is the "in/out" keywords 
> are allowed only with hash:net,iface type of sets alone and rejected with 
> a proper error message when attempted to use with any other set type.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
