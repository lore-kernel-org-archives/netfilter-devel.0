From: Andrew McNamara <andrewm@object-craft.com.au>
Subject: Re: Pre-emptable lock debug
Date: Fri, 29 Apr 2005 14:39:51 +1000
Message-ID: <20050429043951.DE0717940A8@longblack.object-craft.com.au>
References: <20050429013756.2B12E7940A8@longblack.object-craft.com.au>
	<20050428205432.05e0721a.akpm@osdl.org>
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Andrew Morton <akpm@osdl.org>
In-reply-to: <20050428205432.05e0721a.akpm@osdl.org> 
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

>> BUG: using smp_processor_id() in preemptible [00000001] code: ifconfig/1606
>> caller is get_next_corpse+0x14/0x280
>>  [<c021a348>] smp_processor_id+0xa8/0xc0
>>  [<c03fcfb4>] get_next_corpse+0x14/0x280
>>  [<c03fcfb4>] get_next_corpse+0x14/0x280
>>  [<c0429aff>] _spin_unlock_irqrestore+0xf/0x30
>>  [<c03a78bd>] skb_dequeue+0x4d/0x60
>>  [<c03fd254>] ip_ct_iterate_cleanup+0x34/0xd0
>>  [<c040d3c0>] device_cmp+0x0/0x110
>>  [<c040d388>] masq_inet_event+0x38/0x70
>>  [<c040d3c0>] device_cmp+0x0/0x110
>>  [<c012db0d>] notifier_call_chain+0x2d/0x50
>>  [<c03eb8ec>] inet_del_ifa+0x8c/0x150
>>  [<c03ec5b9>] devinet_ioctl+0x4d9/0x5b0
>>  [<c03ee876>] inet_ioctl+0x66/0xb0
>>  [<c03a2219>] sock_ioctl+0xc9/0x250
>>  [<c01717ae>] do_ioctl+0x8e/0xa0
>>  [<c01719c5>] vfs_ioctl+0x65/0x1f0
>>  [<c0171bb7>] sys_ioctl+0x67/0x90
>>  [<c010328f>] syscall_call+0x7/0xb
>
>That's a bug in MUST_BE_WRITE_LOCKED(), doing smp_processor_id() outside
>preempt_disable().
>
>Like this, I think:
>
>Avoid smp_processor_id() in premptible code in the netfilter lock debugging
>code.

Thanks - your patch fixed it for me.

-- 
Andrew McNamara, Senior Developer, Object Craft
http://www.object-craft.com.au/
