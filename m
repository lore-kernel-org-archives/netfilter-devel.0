From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2] deliver events for conntracks created via ctnetlink
Date: Tue, 24 Jun 2008 18:51:01 +0200
Message-ID: <486125F5.3090806@netfilter.org>
References: <4857A939.6050701@netfilter.org> <486118A9.5030808@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51378 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754087AbYFXQvG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2008 12:51:06 -0400
In-Reply-To: <486118A9.5030808@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> As for now, the creation and update of conntracks via ctnetlink do not
>> propagate an event to userspace. This can result in inconsistent
>> situations if several userspace processes modify the connection tracking
>> table by means of ctnetlink at the same time. Specifically, using the
>> conntrack command line tool and conntrackd at the same time can trigger
>> unconsistencies.
>>
>> This patch fixes this inconsistent situation. Note that the deletion
>> does not suffer from this problem.
>>
>> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Unfortunately all the change functions are deadlock prone,
> they are called while holding the conntrack lock and
> event delivery might trigger destruction of the conntrack
> entry already in the cache, which takes the lock again.

Indeed. I didn't notice the nf_ct_event_cache_init path.

> Perhaps we can do all this much easier. Conntrack updates
> over netlink are a lot more rare than events triggered
> by packet processing. What do you think about just sending
> the full entry on successful changes over ctnetlink?

Yes, that is simple.

> A few minor nits:
> 
>> +            atomic_inc(&ct->ct_general.use);
> 
> Should be using nf_conntrack_get().

OK

> Also the patch adds newlines excessively, to a file already
> containing about 20% empty lines.

OK, I'll fix those.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
