From: Wen Congyang <wency@cn.fujitsu.com>
Subject: Re: [PATCH COLO-Frame v5 00/29] COarse-grain LOck-stepping(COLO)
 Virtual Machines for Non-stop Service
Date: Fri, 29 May 2015 20:34:18 +0800
Message-ID: <55685CCA.2010604@cn.fujitsu.com>
References: <1432196001-10352-1-git-send-email-zhang.zhanghailiang@huawei.com> <20150528162402.GE2127@work-vm> <5567C104.3070805@cn.fujitsu.com> <55681DF5.50206@huawei.com> <20150529084249.GC2127@work-vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <peter.huangpeng@huawei.com>, <qemu-devel@nongnu.org>,
	<quintela@redhat.com>, <amit.shah@redhat.com>, <eblake@redhat.com>,
	<berrange@redhat.com>, <eddie.dong@intel.com>,
	<yunhong.jiang@intel.com>, <lizhijian@cn.fujitsu.com>,
	<arei.gonglei@huawei.com>, <david@gibson.dropbear.id.au>,
	<netfilter-devel@vger.kernel.org>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
	zhanghailiang <zhang.zhanghailiang@huawei.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7566 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752097AbbE2MaD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 May 2015 08:30:03 -0400
In-Reply-To: <20150529084249.GC2127@work-vm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05/29/2015 04:42 PM, Dr. David Alan Gilbert wrote:
> * zhanghailiang (zhang.zhanghailiang@huawei.com) wrote:
>> On 2015/5/29 9:29, Wen Congyang wrote:
>>> On 05/29/2015 12:24 AM, Dr. David Alan Gilbert wrote:
>>>> * zhanghailiang (zhang.zhanghailiang@huawei.com) wrote:
>>>>> This is the 5th version of COLO, here is only COLO frame part, include: VM checkpoint,
>>>>> failover, proxy API, block replication API, not include block replication.
>>>>> The block part has been sent by wencongyang:
>>>>> "[Qemu-devel] [PATCH COLO-Block v5 00/15] Block replication for continuous checkpoints"
>>>>>
>>>>> we have finished some new features and optimization on COLO (As a development branch in github),
>>>>> but for easy of review, it is better to keep it simple now, so we will not add too much new
>>>>> codes into this frame patch set before it been totally reviewed.
>>>>>
>>>>> You can get the latest integrated qemu colo patches from github (Include Block part):
>>>>> https://github.com/coloft/qemu/commits/colo-v1.2-basic
>>>>> https://github.com/coloft/qemu/commits/colo-v1.2-developing (more features)
>>>>>
>>>>> Please NOTE the difference between these two branch.
>>>>> colo-v1.2-basic is exactly same with this patch series, which has basic features of COLO.
>>>>> Compared with colo-v1.2-basic, colo-v1.2-developing has some optimization in the
>>>>> process of checkpoint, including:
>>>>>    1) separate ram and device save/load process to reduce size of extra memory
>>>>>       used during checkpoint
>>>>>    2) live migrate part of dirty pages to slave during sleep time.
>>>>> Besides, we add some statistic info in colo-v1.2-developing, which you can get these stat
>>>>> info by using command 'info migrate'.
>>>>
>>>>
>>>> Hi,
>>>>   I have that running now.
>>>>
>>>> Some notes:
>>>>   1) The colo-proxy is working OK until qemu quits, and then it gets an RCU problem; see below
>>>>   2) I've attached some minor tweaks that were needed to build with the 4.1rc kernel I'm using;
>>>>      they're very minor changes and I don't think related to (1).
>>>>   3) I've also included some minor fixups I needed to get the -developing world
>>>>      to build;  my compiler is fussy about unused variables etc - but I think the code
>>>>      in ram_save_complete in your -developing patch is wrong because there are two
>>>>      'pages' variables and the one in the inner loop is the only one changed.
>>
>> Oops, i will fix them. thank you for pointing out this low grade mistake. :)
> 
> No problem; we all make them.
> 
>>>>   4) I've started trying simple benchmarks and tests now:
>>>>     a) With a simple web server most requests have very little overhead, the comparison
>>>>        matches most of the time;  I do get quite large spikes (0.04s->1.05s) which I guess
>>>>        corresponds to when a checkpoint happens, but I'm not sure why the spike is so big,
>>>>        since the downtime isn't that big.
>>
>> Have you disabled DEBUG for colo proxy? I turned it on in default, is this related?
> 
> Yes, I've turned that off, I still get the big spikes; not looked why yet.
> 
>>>>     b) I tried something with more dynamic pages - the front page of a simple bugzilla
>>>>        install;  it failed the comparison every time; it took me a while to figure out
>>
>> Failed comprison ? Do you mean the net packets in these two sides are always inconsistent?
> 
> Yes.
> 
>>>>        why, but it generates a unique token in it's javascript each time (for a password reset
>>>>        link), and I guess the randomness used by that doesn't match on the two hosts.
>>>>        It surprised me, because I didn't expect this page to have much randomness
>>>>        in.
>>>>
>>>>   4a is really nice - it shows the benefit of COLO over the simple checkpointing;
>>>> checkpoints happen very rarely.
>>>>
>>>> The colo-proxy rcu problem I hit shows as rcu-stalls in both primary and secondary
>>>> after the qemu quits; the backtrace of the qemu stack is:
>>>
>>> How to reproduce it? Use monitor command quit to quit qemu? Or kill the qemu?
>>>
>>>>
>>>> [<ffffffff810d8c0c>] wait_rcu_gp+0x5c/0x80
>>>> [<ffffffff810ddb05>] synchronize_rcu+0x45/0xd0
>>>> [<ffffffffa0a251e5>] colo_node_release+0x35/0x50 [nfnetlink_colo]
>>>> [<ffffffffa0a25795>] colonl_close_event+0xe5/0x160 [nfnetlink_colo]
>>>> [<ffffffff81090c96>] notifier_call_chain+0x66/0x90
>>>> [<ffffffff8109154c>] atomic_notifier_call_chain+0x6c/0x110
>>>> [<ffffffff815eee07>] netlink_release+0x5b7/0x7f0
>>>> [<ffffffff815878bf>] sock_release+0x1f/0x90
>>>> [<ffffffff81587942>] sock_close+0x12/0x20
>>>> [<ffffffff812193c3>] __fput+0xd3/0x210
>>>> [<ffffffff8121954e>] ____fput+0xe/0x10
>>>> [<ffffffff8108d9f7>] task_work_run+0xb7/0xf0
>>>> [<ffffffff81002d4d>] do_notify_resume+0x8d/0xa0
>>>> [<ffffffff81722b66>] int_signal+0x12/0x17
>>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>>
>>> Thanks for your test. The backtrace is very useful, and we will fix it soon.
>>>
>>
>> Yes, it is a bug, the callback function colonl_close_event() is called when holding
>> rcu lock:
>> netlink_release
>>     ->atomic_notifier_call_chain
>>          ->rcu_read_lock();
>>          ->notifier_call_chain
>>             ->ret = nb->notifier_call(nb, val, v);
>> And here it is wrong to call synchronize_rcu which will lead to sleep.
>> Besides, there is another function might lead to sleep, kthread_stop which is called
>> in destroy_notify_cb.
>>
>>>>
>>>> that's with both the 423a8e268acbe3e644a16c15bc79603cfe9eb084 from yesterday and
>>>> older e58e5152b74945871b00a88164901c0d46e6365e tags on colo-proxy.
>>>> I'm not sure of the right fix; perhaps it might be possible to replace the
>>>> synchronize_rcu in colo_node_release by a call_rcu that does the kfree later?
>>>
>>> I agree with it.
>>
>> That is a good solution, i will fix both of the above problems.
> 
> Thanks,

We have fix this problem, and test it. The patch is pushed to github, please try it.

Thanks
Wen Congyang

> 
> Dave
> 
>>
>> Thanks,
>> zhanghailiang
>>
>>>
>>>>
>>>> Thanks,
>>>>
>>>> Dave
>>>>
>>>>>
>>>
>>>
>>> .
>>>
>>
>>
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 

