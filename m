From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: flow start_time
Date: Wed, 06 May 2009 13:26:07 +0200
Message-ID: <4A0173CF.6080505@netfilter.org>
References: <49F08A19.6010909@msgid.tls.msk.ru> <4A0045E8.1000508@trash.net> <4A016F74.6050601@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51933 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655AbZEFL0p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 May 2009 07:26:45 -0400
In-Reply-To: <4A016F74.6050601@msgid.tls.msk.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Michael Tokarev wrote:
> Patrick McHardy wrote:
>> How are you going to log the data of a connection thats removed
>> from the conntrack tables without using netlink? If you're using
>> netlink, you can generate a time stamp when you receive a NEW
>> event.
> 
> In case either "new" or "remove" event is missing now, that connection
> can't be logged properly, because we don't see some part of the
> info in either of the two cases.
> 
> For nowadays tools, in case we've seen "new" but not "remove" event,
> that connection will be in our hash table sorta forever (ok, till
> restart).  Which is, I think, worse than not logging it at all (it
> will not be logged anyway).
> 
> Basically, I don't see such a case (lost "remove" event) as valid.

I have a couple of patches here that I'm still working on it here to
avoid "remove" event loss. It should be ready for review once the
nf-next-2.6 tree is open.

To know when a flow starts and avoid the problem of "new" event loss. I
think that we can still add a conntrack extension to store the start
time. I think that's enough, right?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
