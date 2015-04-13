From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/5] netfilter: nf_tables: dynamic stateful expression
 instantiation
Date: Mon, 13 Apr 2015 20:54:09 +0200
Message-ID: <20150413185409.GA3269@salvia>
References: <1428745602-31799-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35420 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441AbbDMStw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Apr 2015 14:49:52 -0400
Content-Disposition: inline
In-Reply-To: <1428745602-31799-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Apr 11, 2015 at 10:46:37AM +0100, Patrick McHardy wrote:
> The following patches are the grand finale of my nf_tables set work,
> using all the building blocks put in place by the previous patches
> to support something like iptables hashlimit, but a lot more powerful.
> 
> Sets are extended to allow attaching expressions to set elements.
> The dynset expression dynamically instantiates these expressions
> based on a template when creating new set elements and evaluates
> them for all new or updated set members.
> 
> In combination with concatenations this effectively creates state
> tables for arbitrary combinations of keys, using the existing
> expression types to maintain that state. Regular set GC takes care
> of purging expired states.
> 
> We currently support two different stateful expressions, counter
> and limit. Using limit as a template we can express the functionality
> of hashlimit, but completely unrestricted in the combination of keys.
> Using counter we can perform accounting for arbitrary flows.
> 
> The following examples from patch 5/5 show some possibilities.
> Userspace syntax is still WIP, especially the listing of state
> tables will most likely be seperated from normal set listings
> and use a more structured format:
> 
> 1. Limit the rate of new SSH connections per host, similar to iptables
>    hashlimit:
> 
> # nft filter input tcp dport ssh ct state new \
> 	flow ip saddr timeout 60s \
> 	limit 10/second \
> 	accept
> 
> 2. Account network traffic between each set of /24 networks:
> 
> # nft filter forward \
> 	flow ip saddr & 255.255.255.0 . ip daddr & 255.255.255.0 \
> 	counter
> 
> 3. Account traffic to each host per user:
> 
> # nft filter output \
> 	flow skuid . ip daddr \
> 	counter
> 
> 4. Account traffic for each combination of source address and TCP flags:
> 
> # nft filter input \
> 	flow ip saddr . tcp flags \
> 	counter
> 
> The resulting set content after a Xmas-scan look like this:
> 
> {
> 	192.168.122.1 . fin | psh | urg : counter packets 1001 bytes 40040,
> 	192.168.122.1 . ack : counter packets 74 bytes 3848,
> 	192.168.122.1 . psh | ack : counter packets 35 bytes 3144
> }
> 
> In the future the "expressions attached to elements" will be extended
> to also support user created non-stateful expressions to allow to
> efficiently select beween a set of parameter sets, f.i. a set of log
> statements with different prefixes based on the interface, which currently
> require one rule each. This will most likely have to wait until the next
> kernel version though.

Seried applied, thanks Patrick!
