From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH COLO-Frame v5 00/29] COarse-grain LOck-stepping(COLO)
 Virtual Machines for Non-stop Service
Date: Tue, 2 Jun 2015 09:02:51 +0100
Message-ID: <20150602080250.GA2139@work-vm>
References: <1432196001-10352-1-git-send-email-zhang.zhanghailiang@huawei.com>
 <20150528162402.GE2127@work-vm>
 <556D283E.3010107@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: zhanghailiang <zhang.zhanghailiang@huawei.com>,
	qemu-devel@nongnu.org, quintela@redhat.com, amit.shah@redhat.com,
	eblake@redhat.com, berrange@redhat.com, peter.huangpeng@huawei.com,
	eddie.dong@intel.com, yunhong.jiang@intel.com,
	lizhijian@cn.fujitsu.com, arei.gonglei@huawei.com,
	david@gibson.dropbear.id.au, netfilter-devel@vger.kernel.org
To: Wen Congyang <wency@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbbFBIC6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2015 04:02:58 -0400
Content-Disposition: inline
In-Reply-To: <556D283E.3010107@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* Wen Congyang (wency@cn.fujitsu.com) wrote:
> On 05/29/2015 12:24 AM, Dr. David Alan Gilbert wrote:
> > * zhanghailiang (zhang.zhanghailiang@huawei.com) wrote:
> >> This is the 5th version of COLO, here is only COLO frame part, include: VM checkpoint,
> >> failover, proxy API, block replication API, not include block replication.
> >> The block part has been sent by wencongyang:
> >> "[Qemu-devel] [PATCH COLO-Block v5 00/15] Block replication for continuous checkpoints"
> >>
> >> we have finished some new features and optimization on COLO (As a development branch in github),
> >> but for easy of review, it is better to keep it simple now, so we will not add too much new 
> >> codes into this frame patch set before it been totally reviewed. 
> >>
> >> You can get the latest integrated qemu colo patches from github (Include Block part):
> >> https://github.com/coloft/qemu/commits/colo-v1.2-basic
> >> https://github.com/coloft/qemu/commits/colo-v1.2-developing (more features)
> >>
> >> Please NOTE the difference between these two branch.
> >> colo-v1.2-basic is exactly same with this patch series, which has basic features of COLO.
> >> Compared with colo-v1.2-basic, colo-v1.2-developing has some optimization in the 
> >> process of checkpoint, including: 
> >>    1) separate ram and device save/load process to reduce size of extra memory
> >>       used during checkpoint
> >>    2) live migrate part of dirty pages to slave during sleep time.
> >> Besides, we add some statistic info in colo-v1.2-developing, which you can get these stat
> >> info by using command 'info migrate'.
> > 
> > 
> > Hi,
> >   I have that running now.
> > 
> > Some notes:
> >   1) The colo-proxy is working OK until qemu quits, and then it gets an RCU problem; see below
> >   2) I've attached some minor tweaks that were needed to build with the 4.1rc kernel I'm using;
> >      they're very minor changes and I don't think related to (1).
> >   3) I've also included some minor fixups I needed to get the -developing world
> >      to build;  my compiler is fussy about unused variables etc - but I think the code
> >      in ram_save_complete in your -developing patch is wrong because there are two
> >      'pages' variables and the one in the inner loop is the only one changed.
> >   4) I've started trying simple benchmarks and tests now:
> >     a) With a simple web server most requests have very little overhead, the comparison
> >        matches most of the time;  I do get quite large spikes (0.04s->1.05s) which I guess
> >        corresponds to when a checkpoint happens, but I'm not sure why the spike is so big,
> >        since the downtime isn't that big.
> 
> I reproduce it, and we are investigating it now.
> 
> >     b) I tried something with more dynamic pages - the front page of a simple bugzilla
> 
> What does 'dynamic pages' mean?

dynamic is the oppposite of static; so pages that are created at runtime.
Bugzilla generates most pages using cgi-bin from templates, even for simple things,
although most of the output from the cgi-bin script is the same each time.

> >        install;  it failed the comparison every time; it took me a while to figure out
> >        why, but it generates a unique token in it's javascript each time (for a password reset
> >        link), and I guess the randomness used by that doesn't match on the two hosts.
> 
> Yes.
> 

Dave

> Thanks
> Wen Congyang
> 
> >        It surprised me, because I didn't expect this page to have much randomness
> >        in.
> > 
> >   4a is really nice - it shows the benefit of COLO over the simple checkpointing;
> > checkpoints happen very rarely.
> > 
> > The colo-proxy rcu problem I hit shows as rcu-stalls in both primary and secondary
> > after the qemu quits; the backtrace of the qemu stack is:
> > 
> > [<ffffffff810d8c0c>] wait_rcu_gp+0x5c/0x80
> > [<ffffffff810ddb05>] synchronize_rcu+0x45/0xd0
> > [<ffffffffa0a251e5>] colo_node_release+0x35/0x50 [nfnetlink_colo]
> > [<ffffffffa0a25795>] colonl_close_event+0xe5/0x160 [nfnetlink_colo]
> > [<ffffffff81090c96>] notifier_call_chain+0x66/0x90
> > [<ffffffff8109154c>] atomic_notifier_call_chain+0x6c/0x110
> > [<ffffffff815eee07>] netlink_release+0x5b7/0x7f0
> > [<ffffffff815878bf>] sock_release+0x1f/0x90
> > [<ffffffff81587942>] sock_close+0x12/0x20
> > [<ffffffff812193c3>] __fput+0xd3/0x210
> > [<ffffffff8121954e>] ____fput+0xe/0x10
> > [<ffffffff8108d9f7>] task_work_run+0xb7/0xf0
> > [<ffffffff81002d4d>] do_notify_resume+0x8d/0xa0
> > [<ffffffff81722b66>] int_signal+0x12/0x17
> > [<ffffffffffffffff>] 0xffffffffffffffff
> > 
> > that's with both the 423a8e268acbe3e644a16c15bc79603cfe9eb084 from yesterday and 
> > older e58e5152b74945871b00a88164901c0d46e6365e tags on colo-proxy.
> > I'm not sure of the right fix; perhaps it might be possible to replace the 
> > synchronize_rcu in colo_node_release by a call_rcu that does the kfree later?
> > 
> > Thanks,
> > 
> > Dave
> > 
> >>
> >> You can test any branch of the above, 
> >> about how to test COLO, Please reference to the follow link.
> >> http://wiki.qemu.org/Features/COLO.
> >>
> >> COLO is still in early stage, 
> >> your comments and feedback are warmly welcomed.
> >>
> >> Cc: netfilter-devel@vger.kernel.org
> >>
> >> TODO:
> >> 1. Strengthen failover
> >> 2. COLO function switch on/off
> >> 2. Optimize proxy part, include proxy script.
> >>   1) Remove the limitation of forward network link.
> >>   2) Reuse the nfqueue_entry and NF_STOLEN to enqueue skb
> >> 3. The capability of continuous FT
> >>
> >> v5:
> >> - Replace the previous communication way between proxy and qemu with nfnetlink
> >> - Remove the 'forward device'parameter of xt_PMYCOLO, and now we use iptables command
> >> to set the 'forward device'
> >> - Turn DPRINTF into trace_ calls as Dave's suggestion
> >>
> >> v4:
> >> - New block replication scheme (use image-fleecing for sencondary side)
> >> - Adress some comments from Eric Blake and Dave
> >> - Add commmand colo-set-checkpoint-period to set the time of periodic checkpoint
> >> - Add a delay (100ms) between continuous checkpoint requests to ensure VM
> >>   run 100ms at least since last pause.
> >> v3:
> >> - use proxy instead of colo agent to compare network packets
> >> - add block replication
> >> - Optimize failover disposal
> >> - handle shutdown
> >>
> >> v2:
> >> - use QEMUSizedBuffer/QEMUFile as COLO buffer
> >> - colo support is enabled by default
> >> - add nic replication support
> >> - addressed comments from Eric Blake and Dr. David Alan Gilbert
> >>
> >> v1:
> >> - implement the frame of colo
> >>
> >> Wen Congyang (1):
> >>   COLO: Add block replication into colo process
> >>
> >> zhanghailiang (28):
> >>   configure: Add parameter for configure to enable/disable COLO support
> >>   migration: Introduce capability 'colo' to migration
> >>   COLO: migrate colo related info to slave
> >>   migration: Integrate COLO checkpoint process into migration
> >>   migration: Integrate COLO checkpoint process into loadvm
> >>   COLO: Implement colo checkpoint protocol
> >>   COLO: Add a new RunState RUN_STATE_COLO
> >>   QEMUSizedBuffer: Introduce two help functions for qsb
> >>   COLO: Save VM state to slave when do checkpoint
> >>   COLO RAM: Load PVM's dirty page into SVM's RAM cache temporarily
> >>   COLO VMstate: Load VM state into qsb before restore it
> >>   arch_init: Start to trace dirty pages of SVM
> >>   COLO RAM: Flush cached RAM into SVM's memory
> >>   COLO failover: Introduce a new command to trigger a failover
> >>   COLO failover: Implement COLO master/slave failover work
> >>   COLO failover: Don't do failover during loading VM's state
> >>   COLO: Add new command parameter 'colo_nicname' 'colo_script' for net
> >>   COLO NIC: Init/remove colo nic devices when add/cleanup tap devices
> >>   COLO NIC: Implement colo nic device interface configure()
> >>   COLO NIC : Implement colo nic init/destroy function
> >>   COLO NIC: Some init work related with proxy module
> >>   COLO: Handle nfnetlink message from proxy module
> >>   COLO: Do checkpoint according to the result of packets comparation
> >>   COLO: Improve checkpoint efficiency by do additional periodic
> >>     checkpoint
> >>   COLO: Add colo-set-checkpoint-period command
> >>   COLO NIC: Implement NIC checkpoint and failover
> >>   COLO: Disable qdev hotplug when VM is in COLO mode
> >>   COLO: Implement shutdown checkpoint
> >>
> >>  arch_init.c                            | 243 +++++++++-
> >>  configure                              |  36 +-
> >>  hmp-commands.hx                        |  30 ++
> >>  hmp.c                                  |  14 +
> >>  hmp.h                                  |   2 +
> >>  include/exec/cpu-all.h                 |   1 +
> >>  include/migration/migration-colo.h     |  57 +++
> >>  include/migration/migration-failover.h |  22 +
> >>  include/migration/migration.h          |   3 +
> >>  include/migration/qemu-file.h          |   3 +-
> >>  include/net/colo-nic.h                 |  27 ++
> >>  include/net/net.h                      |   3 +
> >>  include/sysemu/sysemu.h                |   3 +
> >>  migration/Makefile.objs                |   2 +
> >>  migration/colo-comm.c                  |  68 +++
> >>  migration/colo-failover.c              |  48 ++
> >>  migration/colo.c                       | 836 +++++++++++++++++++++++++++++++++
> >>  migration/migration.c                  |  60 ++-
> >>  migration/qemu-file-buf.c              |  58 +++
> >>  net/Makefile.objs                      |   1 +
> >>  net/colo-nic.c                         | 420 +++++++++++++++++
> >>  net/tap.c                              |  45 +-
> >>  qapi-schema.json                       |  42 +-
> >>  qemu-options.hx                        |  10 +-
> >>  qmp-commands.hx                        |  41 ++
> >>  savevm.c                               |   2 +-
> >>  scripts/colo-proxy-script.sh           |  88 ++++
> >>  stubs/Makefile.objs                    |   1 +
> >>  stubs/migration-colo.c                 |  58 +++
> >>  trace-events                           |  11 +
> >>  vl.c                                   |  39 +-
> >>  31 files changed, 2235 insertions(+), 39 deletions(-)
> >>  create mode 100644 include/migration/migration-colo.h
> >>  create mode 100644 include/migration/migration-failover.h
> >>  create mode 100644 include/net/colo-nic.h
> >>  create mode 100644 migration/colo-comm.c
> >>  create mode 100644 migration/colo-failover.c
> >>  create mode 100644 migration/colo.c
> >>  create mode 100644 net/colo-nic.c
> >>  create mode 100755 scripts/colo-proxy-script.sh
> >>  create mode 100644 stubs/migration-colo.c
> >>
> >> -- 
> >> 1.7.12.4
> >>
> >>
> > --
> > Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> > 
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
