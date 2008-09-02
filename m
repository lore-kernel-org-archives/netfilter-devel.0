From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: high number of rule changes per second (was Re: Netfilter development
 project)
Date: Tue, 02 Sep 2008 10:46:57 +0200
Message-ID: <48BCFD81.3070005@netfilter.org>
References: <000501c8fd68$da840390$8f8c0ab0$@com> <48A32467.80703@netfilter.org> <002101c90c64$f40dae50$dc290af0$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Andy Loukes <andy@loukes.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47197 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751033AbYIBIrF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2008 04:47:05 -0400
In-Reply-To: <002101c90c64$f40dae50$dc290af0$@com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Andy Loukes wrote:
> I should clarify the problem we have a little more. I realised we shouldn't
> be to be too hasty in throwing away our current system, which is currently
> perl (not ideal but it does work and isn't a bottleneck) handling the
> network connection which then just calls iptables to add and remove rules.
> 
> The problem we have is two-fold. First the application that is controlling
> the firewall is load balanced, so often the daemon gets two concurrent
> requests and it appears that only one iptables command can be executed at
> once so one fails. We can fix that with locking but it would be interesting
> to understand what is happening. Is this a kernel thing?

Fails with EINTR? Anyway, it is sane to perform some kind of
serialization of the request from your application.

> Secondly it can take up to 0.5s to execute an iptables (1.3.8) add and this
> is causing a bottleneck and making the first problem more significant.

Use iptables-restore instead with -n. You can pipe iptables commands to
it. And upgrade to iptables >= 1.4, there was a major rewrite to resolve
scalability problems in iptables-restore.

> I can't reproduce this in test, I get more like 0.02s. I don't know if this is
> due to the throughput of the firewall in production (I only tried flood
> pinging when testing to generate packets). Is the slow execution likely to
> caused by throughput? It also appears to take longer with more rules already
> in the chain, which I would expect. 
> 
> I am considering IPSet for these rules, is that likely to suffer from the
> same problem?
> 
> If we were to develop a C app that directly manipulates the rules using
> libnetfilter would that help?

Unfortunately, there is no supported library for this but there will be
one in the near future. The safest interface by now is iptables-restore.

> Another option we've talked about is batching the changes and using
> iptables-restore to insert the rules as often as possible.

Indeed, that should be the way to go.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
