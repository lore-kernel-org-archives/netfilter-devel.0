From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 0/3] ipset: change 'iface' part in hash:net,iface set
Date: Fri, 06 Jul 2012 21:41:00 +0100
Message-ID: <4FF74D5C.6060909@googlemail.com>
References: <cover.1341525006.git.mr.dash.four@googlemail.com>	<alpine.DEB.2.00.1207060947530.14535@blackhole.kfki.hu>	<4FF736FE.8030109@googlemail.com>	<alpine.DEB.2.00.1207062138140.16055@blackhole.kfki.hu>	<4FF74868.3070303@googlemail.com> <CAHo-OowHXH9f526QQc4Ln5_P_Osdm1Q_RrBkw83hSGj=oES5ww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Netfilter Core Team <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49352 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab2GFUlI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jul 2012 16:41:08 -0400
Received: by wgbdr13 with SMTP id dr13so9643753wgb.1
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Jul 2012 13:41:07 -0700 (PDT)
In-Reply-To: <CAHo-OowHXH9f526QQc4Ln5_P_Osdm1Q_RrBkw83hSGj=oES5ww@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> > You can't expect to issue two different iptables statements (as in 
> your example above) and get the same number of matches! Not going to 
> happen, is it? By the same token, if I execute the following two 
> statements:
>
> I would certainly expect the two above statements to be identical.
>
They are not! How many times would you like me to repeat that: 'in' = 
use and match on incoming interfaces *only*, 'out' = use and match on 
outgoing interfaces *only*. It is appropriately named as well. I 
considered 'in' to be 'incoming_network_interface' at one point, but 
opted for the short version instead. ;-)

> As an uninterested third party only slightly following along this 
> discussion.  I would expect this to be a purely userspace change.  Ie. 
> just change src->in and dst->out on display, and make src==in and 
> dst==out on input.  I see no reason for any kernel space changes or 
> kernel version bumps.
>
And why is that exactly? What is stopping me, or everybody else for that 
matter, to make "kernel version bumps", as you put it? Changes to 
various netfilter components often require kernel submissions as well as 
userspace changes, simply because of the scope of those changes. Nothing 
is precluding me, or anybody else, from applying these changes.

> > The above will also produce "different results for the same member 
> sets with the same elements against the same packets". So why is this 
> not "unacceptable" then?
>
> Because src != dst ?
>
Exactly my point! src != dst, but src != in as well (see above). 'src' = 
'in' (and use the the term "equal" loosely here) *only* in the scope of 
the 'iface' part of hash:net,iface set describing network interface matches.

