From: zhanghailiang <zhang.zhanghailiang@huawei.com>
Subject: Re: [PATCH COLO-Frame v6 00/31] COarse-grain
 LOck-stepping(COLO) Virtual Machines for Non-stop Service
Date: Wed, 1 Jul 2015 14:36:11 +0800
Message-ID: <55938A5B.3090700@huawei.com>
References: <1434617935-6924-1-git-send-email-zhang.zhanghailiang@huawei.com>
	<20150630163804.GD2142@work-vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: lizhijian@cn.fujitsu.com, quintela@redhat.com, yunhong.jiang@intel.com,
	eddie.dong@intel.com, peter.huangpeng@huawei.com,
	qemu-devel@nongnu.org, arei.gonglei@huawei.com,
	netfilter-devel@vger.kernel.org, amit.shah@redhat.com, laijs@cn.fujitsu.com
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <20150630163804.GD2142@work-vm>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
List-Id: netfilter-devel.vger.kernel.org

On 2015/7/1 0:38, Dr. David Alan Gilbert wrote:
>
> Hi,
>    An observation I've got, and this is from the previous version; if there
> is a problem with the network that carries the comparison traffic, the failure is
> difficult to dtect - you start COLO both VMs seem to be running and COLO
> starts up fine, but it's only later that you realise that you are getting
> no comparison failures.
>

Yes, that is a problem, it is usually caused by passing wrong net parameter when
startup qemu or the network topology in host is incorrect for COLO, and it is really
difficult to detect these cases, we will look into them ...

Thanks,
zhanghailiang

>    It would be good to find a way to detect this failure reliably.
>
> * zhanghailiang (zhang.zhanghailiang@huawei.com) wrote:
>> This is the 6th version of COLO, here is only COLO frame part, include: VM checkpoint,
>> failover, proxy API, block replication API, not include block replication.
>> The block part is sent as a separate series.
>>
>> As usuall, we provide two branch which one is 'colo-v1.3-basic',
>> and the other is 'colo-v1.3-developing', The 'basic' branch is exactly the same
>> with this patch series, which has basic features of COLO.
>> We will keep this series simple as possible, just for easy review.
>>
>> You can get the newest integrated qemu colo patches from github (Include Block part):
>> https://github.com/coloft/qemu/commits/colo-v1.3-basic
>> https://github.com/coloft/qemu/commits/colo-v1.3-developing (more features)
>> Please NOTE the difference between these two branch.
>> Colo-v1.3-developing has some optimization in the process of checkpoint, including:
>>     1) separate ram and device save/load process to reduce size of extra memory
>>        used during checkpoint
>>     2) live migrate part of dirty pages to slave during sleep time.
>> Besides, we add some statistic info in 'developing' branch, which you can get these stat
>> info by using command 'info migrate'.
>>
>> About how to test COLO, Please reference to the follow link.
>> http://wiki.qemu.org/Features/COLO.
>>
>> For the kernel part (colo proxy) of COLO, we have sent a RFC patch to kernel community:
>> https://lkml.org/lkml/2015/6/18/32
>>
>> COLO is a totally new feature which is still in early stage,
>> your comments and feedback are warmly welcomed.
>>
>> Cc: netfilter-devel@vger.kernel.org
>>
>> TODO:
>> 1. COLO function switch on/off
>> 2. Optimize proxy part, include proxy script.
>>    1) Remove the limitation of forward network link.
>>    2) Reuse the nfqueue_entry and NF_STOLEN to enqueue skb
>> 3. The capability of continuous FT
>>
>> v6:
>> - Add a new qmp event 'COLO_EXIT' for COLO error, which is useful
>>    for users to get involved in failover verdict.
>> - Support '-net nic' configure
>> - Fix segmentfault bug that triggered by running 'colo_lost_heartbeat' directly
>>    when VM is not in COLO state.
>> - Fix qemu abort bug that triggered by Startup another migration when in COLO state.
>> - Optimize some codes, especailly colo net part.
>>
>> zhanghailiang (31):
>>    configure: Add parameter for configure to enable/disable COLO support
>>    migration: Introduce capability 'colo' to migration
>>    COLO: migrate colo related info to slave
>>    migration: Integrate COLO checkpoint process into migration
>>    migration: Integrate COLO checkpoint process into loadvm
>>    COLO: Implement colo checkpoint protocol
>>    COLO: Add a new RunState RUN_STATE_COLO
>>    QEMUSizedBuffer: Introduce two help functions for qsb
>>    COLO: Save VM state to slave when do checkpoint
>>    COLO RAM: Load PVM's dirty page into SVM's RAM cache temporarily
>>    COLO VMstate: Load VM state into qsb before restore it
>>    arch_init: Start to trace dirty pages of SVM
>>    COLO RAM: Flush cached RAM into SVM's memory
>>    COLO failover: Introduce a new command to trigger a failover
>>    COLO failover: Implement COLO primary/secondary vm failover work
>>    qmp event: Add event notification for COLO error
>>    COLO failover: Don't do failover during loading VM's state
>>    COLO: Add new command parameter 'colo_nicname' 'colo_script' for net
>>    COLO NIC: Init/remove colo nic devices when add/cleanup tap devices
>>    tap: Make launch_script() public
>>    COLO NIC: Implement colo nic device interface configure()
>>    COLO NIC : Implement colo nic init/destroy function
>>    COLO NIC: Some init work related with proxy module
>>    COLO: Handle nfnetlink message from proxy module
>>    COLO: Do checkpoint according to the result of packets comparation
>>    COLO: Improve checkpoint efficiency by do additional periodic
>>      checkpoint
>>    COLO: Add colo-set-checkpoint-period command
>>    COLO NIC: Implement NIC checkpoint and failover
>>    COLO: Disable qdev hotplug when VM is in COLO mode
>>    COLO: Implement shutdown checkpoint
>>    COLO: Add block replication into colo process
>>
>>   configure                              |  36 +-
>>   docs/qmp/qmp-events.txt                |  16 +
>>   hmp-commands.hx                        |  30 ++
>>   hmp.c                                  |  15 +
>>   hmp.h                                  |   2 +
>>   include/exec/cpu-all.h                 |   1 +
>>   include/migration/migration-colo.h     |  50 ++
>>   include/migration/migration-failover.h |  22 +
>>   include/migration/migration.h          |   3 +
>>   include/migration/qemu-file.h          |   3 +-
>>   include/net/colo-nic.h                 |  34 ++
>>   include/net/net.h                      |   2 +
>>   include/net/tap.h                      |  19 +
>>   include/sysemu/sysemu.h                |   3 +
>>   migration/Makefile.objs                |   2 +
>>   migration/colo-comm.c                  |  68 +++
>>   migration/colo-failover.c              |  53 ++
>>   migration/colo.c                       | 854 +++++++++++++++++++++++++++++++++
>>   migration/migration.c                  |  68 ++-
>>   migration/qemu-file-buf.c              |  58 +++
>>   migration/ram.c                        | 249 +++++++++-
>>   migration/savevm.c                     |   2 +-
>>   net/Makefile.objs                      |   1 +
>>   net/colo-nic.c                         | 402 ++++++++++++++++
>>   net/net.c                              |   2 +
>>   net/tap.c                              |  87 ++--
>>   qapi-schema.json                       |  58 ++-
>>   qapi/event.json                        |  15 +
>>   qemu-options.hx                        |   7 +
>>   qmp-commands.hx                        |  41 ++
>>   scripts/colo-proxy-script.sh           |  90 ++++
>>   stubs/Makefile.objs                    |   1 +
>>   stubs/migration-colo.c                 |  58 +++
>>   trace-events                           |  11 +
>>   vl.c                                   |  39 +-
>>   35 files changed, 2333 insertions(+), 69 deletions(-)
>>   create mode 100644 include/migration/migration-colo.h
>>   create mode 100644 include/migration/migration-failover.h
>>   create mode 100644 include/net/colo-nic.h
>>   create mode 100644 migration/colo-comm.c
>>   create mode 100644 migration/colo-failover.c
>>   create mode 100644 migration/colo.c
>>   create mode 100644 net/colo-nic.c
>>   create mode 100755 scripts/colo-proxy-script.sh
>>   create mode 100644 stubs/migration-colo.c
>>
>> --
>> 1.7.12.4
>>
>>
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
>
> .
>
