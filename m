From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH COLO-Frame v5 00/29] COarse-grain LOck-stepping(COLO)
 Virtual Machines for Non-stop Service
Date: Fri, 29 May 2015 16:12:56 +0100
Message-ID: <20150529151256.GA20215@work-vm>
References: <1432196001-10352-1-git-send-email-zhang.zhanghailiang@huawei.com>
 <20150528162402.GE2127@work-vm>
 <5567C104.3070805@cn.fujitsu.com>
 <55681DF5.50206@huawei.com>
 <20150529084249.GC2127@work-vm>
 <55685CCA.2010604@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: zhanghailiang <zhang.zhanghailiang@huawei.com>,
	peter.huangpeng@huawei.com, qemu-devel@nongnu.org,
	quintela@redhat.com, amit.shah@redhat.com, eblake@redhat.com,
	berrange@redhat.com, eddie.dong@intel.com, yunhong.jiang@intel.com,
	lizhijian@cn.fujitsu.com, arei.gonglei@huawei.com,
	david@gibson.dropbear.id.au, netfilter-devel@vger.kernel.org
To: Wen Congyang <wency@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756571AbbE2PND (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 May 2015 11:13:03 -0400
Content-Disposition: inline
In-Reply-To: <55685CCA.2010604@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* Wen Congyang (wency@cn.fujitsu.com) wrote:
> On 05/29/2015 04:42 PM, Dr. David Alan Gilbert wrote:
> > * zhanghailiang (zhang.zhanghailiang@huawei.com) wrote:
> >> On 2015/5/29 9:29, Wen Congyang wrote:
> >>> On 05/29/2015 12:24 AM, Dr. David Alan Gilbert wrote:
> >>>> * zhanghailiang (zhang.zhanghailiang@huawei.com) wrote:

<snip>

> >>>> The colo-proxy rcu problem I hit shows as rcu-stalls in both primary and secondary
> >>>> after the qemu quits; the backtrace of the qemu stack is:
> >>>
> >>> How to reproduce it? Use monitor command quit to quit qemu? Or kill the qemu?
> >>>
> >>>>
> >>>> [<ffffffff810d8c0c>] wait_rcu_gp+0x5c/0x80
> >>>> [<ffffffff810ddb05>] synchronize_rcu+0x45/0xd0
> >>>> [<ffffffffa0a251e5>] colo_node_release+0x35/0x50 [nfnetlink_colo]
> >>>> [<ffffffffa0a25795>] colonl_close_event+0xe5/0x160 [nfnetlink_colo]
> >>>> [<ffffffff81090c96>] notifier_call_chain+0x66/0x90
> >>>> [<ffffffff8109154c>] atomic_notifier_call_chain+0x6c/0x110
> >>>> [<ffffffff815eee07>] netlink_release+0x5b7/0x7f0
> >>>> [<ffffffff815878bf>] sock_release+0x1f/0x90
> >>>> [<ffffffff81587942>] sock_close+0x12/0x20
> >>>> [<ffffffff812193c3>] __fput+0xd3/0x210
> >>>> [<ffffffff8121954e>] ____fput+0xe/0x10
> >>>> [<ffffffff8108d9f7>] task_work_run+0xb7/0xf0
> >>>> [<ffffffff81002d4d>] do_notify_resume+0x8d/0xa0
> >>>> [<ffffffff81722b66>] int_signal+0x12/0x17
> >>>> [<ffffffffffffffff>] 0xffffffffffffffff
> >>>
> >>> Thanks for your test. The backtrace is very useful, and we will fix it soon.
> >>>
> >>
> >> Yes, it is a bug, the callback function colonl_close_event() is called when holding
> >> rcu lock:
> >> netlink_release
> >>     ->atomic_notifier_call_chain
> >>          ->rcu_read_lock();
> >>          ->notifier_call_chain
> >>             ->ret = nb->notifier_call(nb, val, v);
> >> And here it is wrong to call synchronize_rcu which will lead to sleep.
> >> Besides, there is another function might lead to sleep, kthread_stop which is called
> >> in destroy_notify_cb.
> >>
> >>>>
> >>>> that's with both the 423a8e268acbe3e644a16c15bc79603cfe9eb084 from yesterday and
> >>>> older e58e5152b74945871b00a88164901c0d46e6365e tags on colo-proxy.
> >>>> I'm not sure of the right fix; perhaps it might be possible to replace the
> >>>> synchronize_rcu in colo_node_release by a call_rcu that does the kfree later?
> >>>
> >>> I agree with it.
> >>
> >> That is a good solution, i will fix both of the above problems.
> > 
> > Thanks,
> 
> We have fix this problem, and test it. The patch is pushed to github, please try it.

Yes, that works.  Thank you very much for the quick fix.

Dave

> 
> Thanks
> Wen Congyang
> 
> > 
> > Dave
> > 
> >>
> >> Thanks,
> >> zhanghailiang
> >>
> >>>
> >>>>
> >>>> Thanks,
> >>>>
> >>>> Dave
> >>>>
> >>>>>
> >>>
> >>>
> >>> .
> >>>
> >>
> >>
> > --
> > Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> > --
> > To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > .
> > 
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
