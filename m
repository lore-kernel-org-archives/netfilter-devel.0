From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 0/3] ipset: change 'iface' part in hash:net,iface set
Date: Fri, 6 Jul 2012 21:11:39 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207062110260.6477@frira.zrqbmnf.qr>
References: <cover.1341525006.git.mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207060947530.14535@blackhole.kfki.hu> <4FF736FE.8030109@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:44552 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757823Ab2GFTLk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jul 2012 15:11:40 -0400
In-Reply-To: <4FF736FE.8030109@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2012-07-06 21:05, Mr Dash Four wrote:

>
>> You have to introduce a new set type version whenever a new feature is added:
>> in your patches there is no protection against mixed cases, when only the
>> kernel or just the userspace is upgraded. Or one side is downgraded for
>> whatever reason.
>>  
> You mean object version (similar to the one you had a debate about on this ML
> with Mr Engelhardt a while ago)?

The SO version is purely a userspace issue. Here, Joszef means the 
user-kernel interaction; a too-old userspace ipset binary would not know 
how to interpret a too-new kernel response which has IFACE set; and a 
too-old kernel would not know how to read a too-new ipset request with 
IFACE set.
