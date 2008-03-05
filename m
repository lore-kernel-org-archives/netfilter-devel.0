From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: netlink socket filtering
Date: Wed, 05 Mar 2008 14:20:04 +0100
Message-ID: <47CE9E04.90308@netfilter.org>
References: <47CAAD4E.3020508@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53017 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759123AbYCENPI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Mar 2008 08:15:08 -0500
In-Reply-To: <47CAAD4E.3020508@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Out of interest how feasible it would be to do ctnetlink
> message filtering using socket filters I've hacked together
> these two patches for the kernel and libnl to filter on
> the TCP_CONNTRACK_ESTABLISHED state.
> 
> The filtering works well, but it brought up a question that
> I think also affects the patches you've posted earlier.
> You mentioned that for synchronization you want to filter
> on ESTABLISHED states. Since BPF only gets the final message
> it can't filter on the previous conntrack state when
> transitioning, but only on the current state. This means
> that a filter on TCP_CONNTRACK_ESTABLISHED won't let
> a message for a transition from TCP_CONNTRACK_ESTABLISHED
> to TCP_CONNTRACK_CLOSED pass.
> 
> Your patches add a new table, at which point the conntrack
> will also already have performed the transistion and filtering
> using state matches will also only see the new state. So I'm
> wondering, what are the exact filtering needs for replication
> and would something like this work?

I mainly need conntrack event filtering capabilities by:

* protocol states, so that one can replicate TCP Established and 
whatever state in the connection closure (or even the destroy event), I 
don't need state transitions.
* source address and destination, so that the administrator can 
replicate traffic for certain parts of the networks, eg. 192.168.0.0/24

I link this BSF-based solution, however, would they be flexible enough 
for my needs? Another question that comes to my mind, isn't this 
filtering coming to late? I mean, we have to invest time to build the 
netlink message and then decide if we want to replicate it or not.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
