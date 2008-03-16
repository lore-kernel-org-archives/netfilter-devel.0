From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: netlink socket filtering
Date: Sun, 16 Mar 2008 12:58:25 +0100
Message-ID: <47DD0B61.3070300@netfilter.org>
References: <47CAAD4E.3020508@trash.net> <47CE9E04.90308@netfilter.org> <47D568DA.8060006@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36864 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751450AbYCPL6e (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Mar 2008 07:58:34 -0400
In-Reply-To: <47D568DA.8060006@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> I link this BSF-based solution, however, would they be flexible enough
>> for my needs? Another question that comes to my mind, isn't this
>> filtering coming to late? I mean, we have to invest time to build the
>> netlink message and then decide if we want to replicate it or not.
> 
> Its quite flexible, but you're right that it only takes place
> after the message has already been constructed. The advantage
> over selective unicast delivery is that if messages are consumed
> by multiple receivers we only need to construct them once.

On most system the number of listener would be usually 2: ulogd and
conntrack-daemon. I remember that someone told during the workshop that
building netlink messages is resource consuming.

> The downside is that messages that will get filtered on all
> sockets are constructed completely unnecessary.

More concerns, if we go BSF, I'll have to implement some kind of
"compiler" to translate user options from conntrackd.conf to BSF code.
Using iptables for this seems to be more user-friendly?

I have a patch here that I'll send you as I have some spare time. It
introduces a nfevent field in the skbuff by using a 2 bytes free hole in
it. Thus, I only have to insert one hook for the 'events' table.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
