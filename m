From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: xtables: add quota support to nfacct
Date: Mon, 30 Dec 2013 18:36:55 +0100
Message-ID: <20131230173655.GA21288@localhost>
References: <1386780798-24374-1-git-send-email-mathieu.poirier@linaro.org>
 <1386780798-24374-2-git-send-email-mathieu.poirier@linaro.org>
 <20131218095322.GA4740@localhost>
 <CANLsYkxMzdFCpJ3456PPd8KsEPi-U70kJDqGv8c3BhCsKY8RiQ@mail.gmail.com>
 <20131219194339.GA4561@localhost>
 <CANLsYkzoa0E6T8ZGYmKHSPdFyGkLeQw8_dsB_NAJx9YA2qD8uw@mail.gmail.com>
 <20131221085509.GA4230@localhost>
 <CANLsYkx32_sUzZvy697Vhyu7cBUaoYtB__FNTvdhwWDguLmT2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	John Stultz <john.stultz@linaro.org>,
	JP Abgrall <jpa@google.com>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38556 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756078Ab3L3RhE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Dec 2013 12:37:04 -0500
Content-Disposition: inline
In-Reply-To: <CANLsYkx32_sUzZvy697Vhyu7cBUaoYtB__FNTvdhwWDguLmT2Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 29, 2013 at 02:53:15PM -0700, Mathieu Poirier wrote:
> On 21 December 2013 01:55, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Fri, Dec 20, 2013 at 01:34:00PM -0700, Mathieu Poirier wrote:
> >> On 19 December 2013 12:43, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > [...]
> >> > Thinking again on the event delivery, I think it's better if the
> >> > nfacct match using the new --quota does not deliver the event itself.
> >> > You can use libnetfilter_queue instead, eg.
> >> >
> >> >         iptables -I INPUT -p icmp \
> >> >                  -m nfacct icmp --quota 12345 --mode bytes --match-once \
> >> >                  -j NFLOG --nflog-prefix "icmp: " --nflog-group 34
> >> >
> 
> Thinking further on this...
> 
> Unless I'm missing something the above only specifies when to log
> quota transgression, hence introducing the need to write yet another
> rule do explicitly deal with the packet.  My previous solution logged
> quota excess _and_ dealt with the packet.

What kind of "deal with the packet" you need to make in case you
reach the quota? Please, elaborate your use case with hypothetical
(iptables) examples so I can help better.

> Using ' nfulnl_log_packet()' (if even possible) would seem hackish to me.

That don't like that choice either.
