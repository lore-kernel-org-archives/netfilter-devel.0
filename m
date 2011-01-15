From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC,PATCH] netfilter: SNMP conntrack module
Date: Sat, 15 Jan 2011 17:15:00 +0100
Message-ID: <4D31C804.5090304@trash.net>
References: <20110114201805.GC4546@jolsa.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Tim Waugh <twaugh@redhat.com>, netfilter-devel@vger.kernel.org
To: Jiri Olsa <jolsa@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60265 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab1AOQPB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Jan 2011 11:15:01 -0500
In-Reply-To: <20110114201805.GC4546@jolsa.brq.redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 14.01.2011 21:18, schrieb Jiri Olsa:
> hi,
> 
> attached patch adds SNMP conntrack module to the netfilter.
> 
> I refer to the following conversation:
> http://marc.info/?l=netfilter-devel&m=125992205006600&w=2
> 
> Patrick McHardy wrote:
>> The best solution would be to add generic broadcast tracking, the
>> use of expectations for this is a bit of abuse.
> 
>> The second best choice I guess would be to move the help() function
>> to a shared module and generalize it so it can be used for both.
> 
> The patch tries to implement the "second best choice".
> 
> In case the 'second best choice' is not good enough anyway,
> could you please outline the first one in more detail..?

Adding full broadcast tracking is non-trivial, so this is good
enough for now.

> Also the patch is not adding the "help" function to the
> shared module, since I'm not sure where to put it. If the
> idea of the patch would be acceptable, could you please
> suggest the shared module for the 'help' function?

How about adding a nf_conntrack_broadcast.c or something
like that and keep the common code there? The help function
and the expect policy (probably not really worth it) could
be moved to that file.

> --- /dev/null
> +++ b/net/netfilter/nf_conntrack_snmp.c

Besides Jan comments, the patch looks fine to me.

