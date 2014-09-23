From: Rob Jones <rob.jones@codethink.co.uk>
Subject: Re: [PATCH] net/netfilter/x_tables.c: use __seq_open_private()
Date: Tue, 23 Sep 2014 16:32:39 +0100
Message-ID: <54219297.2060906@codethink.co.uk>
References: <1411122471-20087-1-git-send-email-rob.jones@codethink.co.uk> <20140923140237.GA27307@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, linux-kernel@codethink.co.uk
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:41701 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbaIWPcp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:32:45 -0400
In-Reply-To: <20140923140237.GA27307@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Would you like that change made and re-submitted? It's the work of
moments to do it.

I was only concentrating on not changing the logic so I didn't check on
whether and existing initialisation was made redundant.

On 23/09/14 15:02, Pablo Neira Ayuso wrote:
> On Fri, Sep 19, 2014 at 11:27:51AM +0100, Rob Jones wrote:
>> Reduce boilerplate code by using __seq_open_private() instead of seq_open()
>> in xt_match_open() and xt_target_open().
>>
>> Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
>> ---
>>
>> This patch uses an existing variant of seq_open() to reduce the kernel code
>> size.
>
> Less code to maintain, good.
>
>> The only significant variation from the pre-existing code is the fact that
>> __seq_open_private() calls kzalloc() rather than kmalloc(), which could
>> conceivably have an impact on timing.
>
> I think you can skip
>
>          trav->class = MTTG_TRAV_INIT;
>
> too, now that trav is set to zero.
>
>
>

-- 
Rob Jones
Codethink Ltd
mailto:rob.jones@codethink.co.uk
tel:+44 161 236 5575
