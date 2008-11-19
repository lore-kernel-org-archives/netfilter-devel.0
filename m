From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: crash in death_by_timeout()
Date: Wed, 19 Nov 2008 13:37:08 +0100
Message-ID: <49240874.1090208@netfilter.org>
References: <20081117221855.GD3271@zebra.home> <4922A1E8.7080405@trash.net> <20081118123830.GD3201@zebra.home> <4922C0F7.3050604@trash.net> <4922C2D0.9060207@trash.net> <492340EE.1020607@netfilter.org> <492400B3.6070706@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: BORBELY Zoltan <bozo@andrews.hu>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46943 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752344AbYKSMhS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Nov 2008 07:37:18 -0500
In-Reply-To: <492400B3.6070706@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Patrick McHardy wrote:
>>> Pablo, do you recall the reason why the lock isn't held in
>>> ctnetlink_create_conntrack()?
>>
>> The creation is done under the nfnl_mutex so that requests to create
>> identical entries cannot race. Of course, this is not enough to avoid
>> the race with the timer if we set a very small timer for a conntrack :(.
> 
> Its also not enough to avoid the race against packet processing,
> which takes nf_conntrack_lock.
> 
>> AFAICS, we don't need to enclose the whole conntrack creation path.
>> Would you prefer the patch attached? This patch should apply fine to
>> 2.6.28-rc.
> 
> That fixes the timer race, but the race between lookup and creation
> remains. We really need to either hold the lock the entire time or
> redo the lookup before inserting the entry into the hash tables.

I see, I forgot about that case. Your patch should be fine then.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
