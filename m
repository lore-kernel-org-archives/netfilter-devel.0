From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 0/3] ipset: change 'iface' part in hash:net,iface set
Date: Fri, 06 Jul 2012 20:44:18 +0100
Message-ID: <4FF74012.6060106@googlemail.com>
References: <cover.1341525006.git.mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207060947530.14535@blackhole.kfki.hu> <4FF736FE.8030109@googlemail.com> <alpine.LNX.2.01.1207062110260.6477@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45112 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757763Ab2GFTo1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jul 2012 15:44:27 -0400
Received: by wgbdr13 with SMTP id dr13so9610176wgb.1
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Jul 2012 12:44:26 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1207062110260.6477@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Oh, and also...
> and a too-old kernel would not know how to read a too-new ipset request with 
> IFACE set.
>   
A response I gave on this very issue from the post you quoted:

"...With the second case, again, even if iptables accept 'in' and 'out' 
as values, because the patches I submitted yesterday allow for backwards 
compatibility, the kernel would be able to process these matches without 
any issues.

If you look at the code, the iptables code is raising both DIM_TWO_SRC 
as well as the new DIM_IFACE bits in the 'flags' variable. The set 
matching functions of the "old" kernel will "know" of and take into 
account just the DIM_TWO_SRC bit to produce a match, which is quite fine 
and it is how is supposed to work in the first place, so again, a match 
will be produced and I don't see any issues here either."

If you know any different I am all eyes/ears etc!
