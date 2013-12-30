From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 1/1] netfilter: xtables: add quota support to nfacct
Date: Tue, 31 Dec 2013 00:31:22 +0100
Message-ID: <20131230233122.GA28854@breakpoint.cc>
References: <CANLsYkxMzdFCpJ3456PPd8KsEPi-U70kJDqGv8c3BhCsKY8RiQ@mail.gmail.com>
 <20131219194339.GA4561@localhost>
 <CANLsYkzoa0E6T8ZGYmKHSPdFyGkLeQw8_dsB_NAJx9YA2qD8uw@mail.gmail.com>
 <20131221085509.GA4230@localhost>
 <CANLsYkx32_sUzZvy697Vhyu7cBUaoYtB__FNTvdhwWDguLmT2Q@mail.gmail.com>
 <20131230173655.GA21288@localhost>
 <CANLsYkx34A97NwJyFb05MT=zneT8ET=Nyz7HTGEDWHhGAZP_-Q@mail.gmail.com>
 <20131230214653.GP29632@breakpoint.cc>
 <CANLsYkxr2eRyz0aWDD8OMJDf2YWpwg3SOBpEhoopfy6N+kzfWg@mail.gmail.com>
 <CANLsYkzRPDQsKFDsHTZKDOLmX=_yhBa3FBCbuY1-Uy2TG3jYQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	John Stultz <john.stultz@linaro.org>,
	JP Abgrall <jpa@google.com>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34907 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932355Ab3L3XbY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Dec 2013 18:31:24 -0500
Content-Disposition: inline
In-Reply-To: <CANLsYkzRPDQsKFDsHTZKDOLmX=_yhBa3FBCbuY1-Uy2TG3jYQg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Mathieu Poirier <mathieu.poirier@linaro.org> wrote:
> >>> will log the quota reached event but won't prevent further http
> >>> traffic from going out.  One could instinctively add another rule
> >>> right after the above one, something like:
> >>>
> >>> iptables -I OUTPUT -p http \
> >>>          -m nfacct --nfacct-name http-limit --quota 10000 \
> >>>          -j REJECT
> >>>
> >>> but that won't work either because the packet/byte could will be
> >>> incremented twice.
> >>
> >> The usual workaround is to create custom chains to deal with this,
> >> i.e.
> >> iptables -N LOG_DROP_HTTP
> >> iptables -A LOG_DROP_HTTP -j NFLOG --nflog-prefix "http: " --nflog-group 34
> >> iptables -A LOG_DROP_HTTP -j REJECT
> >> iptables -I OUTPUT -p http -m nfacct ... -j LOG_DROP_HTTP
> 
> I may have spoken too quickly.  With this solution a log message is
> sent every time a packet over quota is received, something we
> definitely want to avoid.  I was able to cover that case when sending
> a notification from the match function.

I see.  I have no nice solution for this problem.  What could be done
is adding a --check-only option to nfacct to only query but not
increment the quota counter, then you could use the 'two-rules' approach
you described earlier.  (one rule to increment quotas per-packet but only match
exactly once when the current packet brings us over the quota, another
rule to 'passively' check against the limit).

Another option would be to using connmarks or connlabels to flag when
a connection is overlimit or has already been logged.  I understand
that this would be cumbersome though (also adds the conntrack dependency).
