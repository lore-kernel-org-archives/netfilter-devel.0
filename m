From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Wed, 18 Feb 2009 12:14:04 +0100
Message-ID: <499BED7C.7070809@trash.net>
References: <20090214192936.11718.44732.stgit@Decadence> <49994643.8010001@trash.net> <499971CC.6040903@netfilter.org> <49997247.3010105@trash.net> <4999787C.7050203@netfilter.org> <499982CB.7020503@netfilter.org> <499981FA.3040106@trash.net> <499A9597.4070608@netfilter.org> <499A9689.7090208@trash.net> <499AC0B3.5040902@netfilter.org> <499BDF5D.2010809@trash.net> <499BEBBF.7080705@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49541 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbZBRLOI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2009 06:14:08 -0500
In-Reply-To: <499BEBBF.7080705@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[Please trim unrelated content, these mails are getting hard to read]

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> BTW, I recently looked into TIPC, its incredibly easy to use since
>> it deals with dead-node dectection etc internally and all you need
>> to do is exchange a few messages. Might be quite easy to write a
>> smarter failover daemon.
> 
> I see, I don't have more convincing arguments that "I would also need
> time for that but in the meanwhile, please allow this". Well, failover
> daemons are delicate pieces of software, they have to be stable,
> well-tested, bug-free, give timely responses. Still TIPC is experimental
> and I guess that the dead-node detection is only layer 3/4 based on
> heartbeats. Dead-node detection is a tricky issue, the more you can
> perform different layer checkings, the more increase chances to make
> wrong decisions that may lead to inconsistent situations and tons of
> problems. VRRP is the current standard and this one of his limitations,
> and so on.
> 
> Well, if you are not going to accept the /proc interface, not matter
> what I can argument, I give up on this ;)

I'm afraid I can't be convinced of this. If you want to specify
multiple node ids, have the iptables command accept them, but
there's no reason to use proc for this.

> Anyway, probably, this is a premature optimization (but worth?). Some
> numbers, in my testbed, I get ~1800 TCP connections per second less with
> eight cluster rules (no /proc interface).
> 
> 24347 TCP connections per second with one rule.
> 22580 TCP connections per second with eight rules.
> 
> OK, I'll send you another patch without the /proc interface.

Thanks. As I said, I don't have anything against handling multiple
nodes in one rule, as long as its not done using proc.

