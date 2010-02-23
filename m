From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] xt_recent: Fix buffer overflow
Date: Tue, 23 Feb 2010 14:56:25 +0100
Message-ID: <4B83DE89.6080309@trash.net>
References: <20100219174804.43CD8F8C3F@sepang.rtg.net> <alpine.LSU.2.01.1002192136160.4415@obet.zrqbmnf.qr> <4B7F04F0.8020607@tpi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>, coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: timg@tpi.com
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4B7F04F0.8020607@tpi.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Tim Gardner wrote:
> Jan Engelhardt wrote:
>> On Friday 2010-02-19 18:48, Tim Gardner wrote:
>>> Consider the case when ip_pkt_list_tot==1; the first packet received is stored
>>> in e->stamps[0] and e->index is initialized to 1. The next received packet
>>> timestamp is then stored at e->stamps[1] in recent_entry_update(),
>>> a buffer overflow because the maximum e->stamps[] index is 0.
>>> @@ -173,10 +173,10 @@ recent_entry_init(struct recent_table *t, const union nf_inet_addr *addr,
>>>
>>> static void recent_entry_update(struct recent_table *t, struct recent_entry *e)
>>> {
>>> +	e->index %= ip_pkt_list_tot;
>>> 	e->stamps[e->index++] = jiffies;
>>> 	if (e->index > e->nstamps)
>>> 		e->nstamps = e->index;
>>> -	e->index %= ip_pkt_list_tot;
>>> 	list_move_tail(&e->lru_list, &t->lru_list);
>>> }
>> Let's analyze in 3-step manner:
>>
>> Claim: writes always happen to e->stamps[0]
>> Prereqs: ip_pkt_list_tot==1
>> Proof:
>>  Start with assumption that e->index's possible values at the
>>  start of the function are {0}.
> 
> This assumption is the root of the bug. e->index is initialized to 1 in
> recent_entry_init() which means that its already out of bounds when next
> recent_entry_update() is called.

This patch looks correct to me. Applied, thanks Tim.
