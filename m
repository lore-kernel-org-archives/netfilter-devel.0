From: Patrick McHardy <kaber@trash.net>
Subject: Re: netlink socket filtering
Date: Mon, 10 Mar 2008 17:59:06 +0100
Message-ID: <47D568DA.8060006@trash.net>
References: <47CAAD4E.3020508@trash.net> <47CE9E04.90308@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep32-int.chello.at ([62.179.121.50]:38248 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbYCJQ7U (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Mar 2008 12:59:20 -0400
In-Reply-To: <47CE9E04.90308@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Your patches add a new table, at which point the conntrack
>> will also already have performed the transistion and filtering
>> using state matches will also only see the new state. So I'm
>> wondering, what are the exact filtering needs for replication
>> and would something like this work?
> 
> I mainly need conntrack event filtering capabilities by:
> 
> * protocol states, so that one can replicate TCP Established and 
> whatever state in the connection closure (or even the destroy event), I 
> don't need state transitions.

OK, so that should work.

> * source address and destination, so that the administrator can 
> replicate traffic for certain parts of the networks, eg. 192.168.0.0/24

That also works using BPF.

> I link this BSF-based solution, however, would they be flexible enough 
> for my needs? Another question that comes to my mind, isn't this 
> filtering coming to late? I mean, we have to invest time to build the 
> netlink message and then decide if we want to replicate it or not.

Its quite flexible, but you're right that it only takes place
after the message has already been constructed. The advantage
over selective unicast delivery is that if messages are consumed
by multiple receivers we only need to construct them once.
The downside is that messages that will get filtered on all
sockets are constructed completely unnecessary.
