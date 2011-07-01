From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC] nfnetlink_queue not scalable
Date: Fri, 1 Jul 2011 09:49:36 +0200
Message-ID: <20110701074936.GR16021@Chamillionaire.breakpoint.cc>
References: <1309416426.2532.119.camel@edumazet-laptop>
 <4E0C278B.7010403@yandex.ru>
 <1309433652.1994.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <4E0C651A.1000300@trash.net>
 <1309446900.1994.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <4E0C8902.8070303@earthlink.net>
 <4E0C8D7F.3000902@trash.net>
 <1309453730.5846.31.camel@tiger.regit.org>
 <1309455919.2515.3.camel@edumazet-laptop>
 <1309503610.2515.18.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>, Patrick McHardy <kaber@trash.net>,
	sclark46@earthlink.net, Kuzin Andrey <kuzinandrey@yandex.ru>,
	Anders Nilsson Plymoth <lanilsson@gmail.com>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:41212 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754834Ab1GAHtl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Jul 2011 03:49:41 -0400
Content-Disposition: inline
In-Reply-To: <1309503610.2515.18.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Number one offender is the nfnl_lock mutex hold each time we give a
> verdict.

Yes, the nfnl mutex is fairly annoying for nfqueue.

Unfortunately it is not possible to just remove it
completely since it also protects against module removal.

But I guess even having to grab a refcount would be
a huge win as opposed to holding on to the nfnl mutex...

We'd also need to audit all ->call implementations; most
of them assume the nfnl_mutex is being hold.

> Time to add RCU ;)

Thanks for volunteering ;-)
