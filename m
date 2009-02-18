From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Wed, 18 Feb 2009 11:13:49 +0100
Message-ID: <499BDF5D.2010809@trash.net>
References: <20090214192936.11718.44732.stgit@Decadence> <49994643.8010001@trash.net> <499971CC.6040903@netfilter.org> <49997247.3010105@trash.net> <4999787C.7050203@netfilter.org> <499982CB.7020503@netfilter.org> <499981FA.3040106@trash.net> <499A9597.4070608@netfilter.org> <499A9689.7090208@trash.net> <499AC0B3.5040902@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48050 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbZBRKNw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2009 05:13:52 -0500
In-Reply-To: <499AC0B3.5040902@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>>> A possible solution (that thinking it well, I don't like too much yet)
>>> would be to convert this to a HASHMARK target that will store the result
>>> of the hash in the skbuff mark, but the problem is that it would require
>>> a reserved space for hashmarks since they may clash with other
>>> user-defined marks.
>> That sounds a bit like a premature optimization. What I don't get
>> is why you don't simply set cluster-total-nodes to one when two
>> are down or remove the rule entirely.
> 
> Indeed, but in practise existing failover daemons (at least those
> free/opensource that I know) doesn't show that "intelligent" behaviour
> since they initially (according to the configuration file) assign the
> resources to each node, and if one node fails, it assigns the
> corresponding resources to another sane node (ie. the daemon runs a
> script with the corresponding iptables rules).
> 
> Re-adjusting cluster-total-nodes and cluster-local-nodes options (eg. if
> one cluster node goes down and there are only two nodes alive, change
> the rule-set to have only two nodes) seems indeed the natural way to go
> since the alive cluster nodes would share the workload that the failing
> node has left. However, as said, existing failover daemons only select
> one new master to recover what a failing node was doing, thus, only one
> runs the script to inject the states into the kernel.
> 
> Therefore AFAICS, without the /proc interface, I would need one iptables
> rule per cluster-local-node handled, and so it's still the possible
> sub-optimal situation when one or several node fails.

OK, that explains why you want to handle it this way. I don't want
to merge the proc file part though, so until the daemons get smarter,
people will have to use multiple rules.

BTW, I recently looked into TIPC, its incredibly easy to use since
it deals with dead-node dectection etc internally and all you need
to do is exchange a few messages. Might be quite easy to write a
smarter failover daemon.
