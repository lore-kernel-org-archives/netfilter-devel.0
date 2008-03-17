From: Patrick McHardy <kaber@trash.net>
Subject: Re: netlink socket filtering
Date: Mon, 17 Mar 2008 15:51:17 +0100
Message-ID: <47DE8565.2080605@trash.net>
References: <47CAAD4E.3020508@trash.net> <47CE9E04.90308@netfilter.org> <47D568DA.8060006@trash.net> <47DD0B61.3070300@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep11-int.chello.at ([62.179.121.31]:57233 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbYCQO7z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Mar 2008 10:59:55 -0400
In-Reply-To: <47DD0B61.3070300@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Pablo Neira Ayuso wrote:
>>> I link this BSF-based solution, however, would they be flexible enough
>>> for my needs? Another question that comes to my mind, isn't this
>>> filtering coming to late? I mean, we have to invest time to build the
>>> netlink message and then decide if we want to replicate it or not.
>> Its quite flexible, but you're right that it only takes place
>> after the message has already been constructed. The advantage
>> over selective unicast delivery is that if messages are consumed
>> by multiple receivers we only need to construct them once.
> 
> On most system the number of listener would be usually 2: ulogd and
> conntrack-daemon. I remember that someone told during the workshop that
> building netlink messages is resource consuming.

Yes, the question is how many messages will be filtered.
Since with unicasting and two listeners we potentially
have to construct messages twice, with anything > 50%
delivery rate the socket filtering should be more efficient
(not counting filtering overhead itself).

>> The downside is that messages that will get filtered on all
>> sockets are constructed completely unnecessary.
> 
> More concerns, if we go BSF, I'll have to implement some kind of
> "compiler" to translate user options from conntrackd.conf to BSF code.
> Using iptables for this seems to be more user-friendly?

That should be fairly simple since you're usually only
looking at addresses, ports and protocol states. For
a start this could be hardcoded in a few templates.

> I have a patch here that I'll send you as I have some spare time. It
> introduces a nfevent field in the skbuff by using a 2 bytes free hole in
> it. Thus, I only have to insert one hook for the 'events' table.

I wasn't aware that we still have holes in the skb. Anyway,
adding new skb members is a hard sale for something that
really only a very small subset of users need.

