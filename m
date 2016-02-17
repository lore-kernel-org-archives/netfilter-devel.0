From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 0/6] Namespacify various ip sysctl knobs
Date: Tue, 16 Feb 2016 23:14:34 -0600
Message-ID: <874md76hqd.fsf@x220.int.ebiederm.org>
References: <1455530583-23053-1-git-send-email-kernel@kyup.com>
	<20160216.204328.1217913168570304116.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Cc: kernel@kyup.com, netfilter-devel@vger.kernel.org,
	pabeni@redhat.com, jmorris@namei.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out01.mta.xmission.com ([166.70.13.231]:34184 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbcBQFYf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Feb 2016 00:24:35 -0500
In-Reply-To: <20160216.204328.1217913168570304116.davem@davemloft.net> (David
	Miller's message of "Tue, 16 Feb 2016 20:43:28 -0500 (EST)")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David Miller <davem@davemloft.net> writes:

> From: Nikolay Borisov <kernel@kyup.com>
> Date: Mon, 15 Feb 2016 12:02:57 +0200
>
>> This series continues namespacifying more net related knobs.
>> The focus here is on ip options. Patches 1,3,4,5 namespacify
>> the respective sysctl knobs. Patch 2 moves some igmp code to the 
>> correct file (and function) and also adds some #ifdef guards to 
>> silence compilation warnings. 
>> 
>> Finally, patch 5 exposes the ip fragmentation related sysctls 
>> since all of the knobs are namespaced.
>
> Series applied, but I found Arnd's fix for the unused local variable
> problems much nicer.  I wish you had fixed it that way.

*scratches head*

Did Arnd send that fix publicly?  I have not seen it, and I was copied
on the thread, and I don't see such a fix on netdev or netfilter either.

Eric
