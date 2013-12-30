From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 1/1] netfilter: xtables: add quota support to nfacct
Date: Mon, 30 Dec 2013 22:46:53 +0100
Message-ID: <20131230214653.GP29632@breakpoint.cc>
References: <1386780798-24374-1-git-send-email-mathieu.poirier@linaro.org>
 <1386780798-24374-2-git-send-email-mathieu.poirier@linaro.org>
 <20131218095322.GA4740@localhost>
 <CANLsYkxMzdFCpJ3456PPd8KsEPi-U70kJDqGv8c3BhCsKY8RiQ@mail.gmail.com>
 <20131219194339.GA4561@localhost>
 <CANLsYkzoa0E6T8ZGYmKHSPdFyGkLeQw8_dsB_NAJx9YA2qD8uw@mail.gmail.com>
 <20131221085509.GA4230@localhost>
 <CANLsYkx32_sUzZvy697Vhyu7cBUaoYtB__FNTvdhwWDguLmT2Q@mail.gmail.com>
 <20131230173655.GA21288@localhost>
 <CANLsYkx34A97NwJyFb05MT=zneT8ET=Nyz7HTGEDWHhGAZP_-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	John Stultz <john.stultz@linaro.org>,
	JP Abgrall <jpa@google.com>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34774 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932246Ab3L3Vqz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Dec 2013 16:46:55 -0500
Content-Disposition: inline
In-Reply-To: <CANLsYkx34A97NwJyFb05MT=zneT8ET=Nyz7HTGEDWHhGAZP_-Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Mathieu Poirier <mathieu.poirier@linaro.org> wrote:
> Upon reaching the limit of 10000 byte of http traffic, any outgoing
> http packets will be dropped and a single broadcast message will be
> sent to user space.  That is because the match explicitly takes care
> of sending the notification.
> 
> With your proposal:
> 
> iptables -I OUTPUT -p http \
>          -m nfacct --nfacct-name http-limit --quota 10000 --match-once \
>          -j NFLOG --nflog-prefix "http: " --nflog-group 34
> 
> will log the quota reached event but won't prevent further http
> traffic from going out.  One could instinctively add another rule
> right after the above one, something like:
> 
> iptables -I OUTPUT -p http \
>          -m nfacct --nfacct-name http-limit --quota 10000 \
>          -j REJECT
> 
> but that won't work either because the packet/byte could will be
> incremented twice.

The usual workaround is to create custom chains to deal with this,
i.e.
iptables -N LOG_DROP_HTTP
iptables -A LOG_DROP_HTTP -j NFLOG --nflog-prefix "http: " --nflog-group 34
iptables -A LOG_DROP_HTTP -j REJECT
iptables -I OUTPUT -p http -m nfacct ... -j LOG_DROP_HTTP
