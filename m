From: Patrick McHardy <kaber@trash.net>
Subject: Re: crash in death_by_timeout()
Date: Tue, 18 Nov 2008 14:19:51 +0100
Message-ID: <4922C0F7.3050604@trash.net>
References: <20081117221855.GD3271@zebra.home> <4922A1E8.7080405@trash.net> <20081118123830.GD3201@zebra.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: BORBELY Zoltan <bozo@andrews.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36841 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbYKRNT6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Nov 2008 08:19:58 -0500
In-Reply-To: <20081118123830.GD3201@zebra.home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

BORBELY Zoltan wrote:
> Hi,
> 
> On Tue, Nov 18, 2008 at 12:07:20PM +0100, Patrick McHardy wrote:
>>> --- /tmp/nf_conntrack_netlink.c-orig	2008-09-29 23:28:55.000000000 +0200
>>> +++ /tmp/nf_conntrack_netlink.c	2008-09-29 23:29:11.000000000 +0200
>>> @@ -1177,8 +1177,8 @@
>>>  		ct->master = master_ct;
>>>  	}
>>>  -	add_timer(&ct->timeout);
>>>  	nf_conntrack_hash_insert(ct);
>>> +	add_timer(&ct->timeout);
>>>  	rcu_read_unlock();
>> That code looks very fishy. We should be holding the conntrack lock,
>> otherwise the addition is not only racy against the timer, but also
>> against addition of identical conntracks. Let me look into what
>> happened here.
> 
> We have experienced a lot of kernel crashes, _every time_ in the
> death_by_timeout() function while we were trying to add a new conntrack
> entry from userspace via netlink (attached the disassembled version
> of the function, ===> points to the EIP upon the crash). There was a
> possibility, that we tried to add conntrack entries with zero timeout
> value, maybe it's necessary to trigger this crash. The previous patch
> has definitly solved the problem for us.
> 
> I've got photos from various crashes, but it takes a little time to
> find them. Please let me know if you want to see them.

Thats not necessary, the problem is pretty obvious, I was mainly
wondering at what point we broke it.

I'll send you a patch soon.
