From: Deti Fliegl <deti@fliegl.de>
Subject: Re: problem with conntrack utility and kernel 2.6.14
Date: Sun, 04 Dec 2005 19:44:28 +0100
Message-ID: <4393390C.4080301@fliegl.de>
References: <43627A8F.9060307@eurodev.net>
	<436281BB.2010100@fliegl.de>	<4392510A.3030400@eurodev.net>
	<200512041710.jB4HA40F021665@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040206010500010105020403"
Cc: netfilter-devel@lists.netfilter.org, pablo@eurodev.net, kaber@trash.net,
	romary@nikoon.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200512041710.jB4HA40F021665@toshiba.co.jp>
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

This is a multi-part message in MIME format.
--------------040206010500010105020403
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Yasuyuki KOZAKAI wrote:
> Deti, Romary, could you try CONFIG_DEBUG_PREEMPT and CONFIG_DEBUG_SPINLOCK ?
Done. First I had to enable preemption in general (was switched off).

> 
> And did you apply Pablo's patch (attached in this mail) which fixes refcount
> leak ? linux 2.6.14.3 doesn't include this fix. If no, please try it.
Latest test was done with linux-2.6.15-rc5 which already contains this 
patch.

And here comes your oops...

Sorry it's reproducible.

Deti

--------------040206010500010105020403
Content-Type: text/plain;
 name="panic.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="panic.txt"

----------- [cut here ] --------- [please bite here ] ---------
Kernel BUG at kernel/sched.c:2930
invalid operand: 0000 [1] PREEMPT SMP 
CPU 3 
Modules linked in: ip_conntrack_netlink ipt_CLASSIFY sch_htb ipt_mark ipt_CONNMARK af_packet ipt_SAME ipt_state i8xx_tco ipt_pkttype ipt_NOTRACK iptable_raw ipt_LOG ipt_limit ipt_hashlimit ip_nat_ftp evdev ip_conntrack_ftp edd iptable_nat ip_nat ip_conntrack ipt_MARK nfnetlink iptable_mangle iptable_filter ip_tables sg sr_mod i2c_i801 i2c_core hw_random capability commoncap ext3 jbd ide_cd cdrom ide_disk e1000 piix ide_core megaraid_mbox megaraid_mm sd_mod scsi_mod
Pid: 12629, comm: conntrack Not tainted 2.6.15-rc5-smp #1
RIP: 0010:[<ffffffff80129a3c>] <ffffffff80129a3c>{sub_preempt_count+22}
RSP: 0018:ffff81011513bb38  EFLAGS: 00010206
RAX: ffff81011513bfd8 RBX: ffff810117b3be08 RCX: 0000000000000000
RDX: 00000000ffffffff RSI: 0000000000000dc8 RDI: 00000000000000ff
RBP: ffff81011513bb38 R08: 0000000000000000 R09: ffff810115608e80
R10: 0000000000000000 R11: 0000000000000000 R12: ffff810115b867f0
R13: ffff81011a1fed80 R14: ffff81011513bc48 R15: ffff81011654def0
FS:  00002aaaab0f6b00(0000) GS:ffffffff8049a980(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000054d008 CR3: 000000011569f000 CR4: 00000000000006e0
Process conntrack (pid: 12629, threadinfo ffff81011513a000, task ffff810115076840)
Stack: ffff810115b867c0 ffffffff80135ee0 0000000000000296 ffffffff88184a87 
       ffff81011654dc00 ffff81011513be08 ffff81011a1fed80 ffff81011654dc00 
       ffff810115b867c0 ffffffff80292544 
Call Trace:<ffffffff80135ee0>{local_bh_enable+69} <ffffffff88184a87>{:ip_conntrack_netlink:ctnetlink_dump_table+254}
       <ffffffff80292544>{netlink_dump+148} <ffffffff802927c7>{netlink_recvmsg+305}
       <ffffffff80275302>{sock_recvmsg+273} <ffffffff802f010b>{_spin_unlock_irq+20}
       <ffffffff802eee5f>{thread_return+206} <ffffffff8012975a>{resched_task+78}
       <ffffffff8012b772>{try_to_wake_up+1291} <ffffffff8014540a>{autoremove_wake_function+0}
       <ffffffff80174806>{fget+153} <ffffffff80276938>{sys_recvmsg+357}
       <ffffffff8018041b>{pipe_writev+1293} <ffffffff802eee5f>{thread_return+206}
       <ffffffff8017402e>{vfs_write+326} <ffffffff80174122>{sys_write+69}
       <ffffffff8010da72>{system_call+126} 

Code: 0f 0b 68 51 da 30 80 c2 72 0b 81 ff fe 00 00 00 3e 77 1d 65 
RIP <ffffffff80129a3c>{sub_preempt_count+22} RSP <ffff81011513bb38>
 <3>BUG: soft lockup detected on CPU#1!
CPU 1:
Modules linked in: ip_conntrack_netlink ipt_CLASSIFY sch_htb ipt_mark ipt_CONNMARK af_packet ipt_SAME ipt_state i8xx_tco ipt_pkttype ipt_NOTRACK iptable_raw ipt_LOG ipt_limit ipt_hashlimit ip_nat_ftp evdev ip_conntrack_ftp edd iptable_nat ip_nat ip_conntrack ipt_MARK nfnetlink iptable_mangle iptable_filter ip_tables sg sr_mod i2c_i801 i2c_core hw_random capability commoncap ext3 jbd ide_cd cdrom ide_disk e1000 piix ide_core megaraid_mbox megaraid_mm sd_mod scsi_mod
Pid: 12754, comm: wget Not tainted 2.6.15-rc5-smp #1
RIP: 0010:[<ffffffff802f0208>] <ffffffff802f0208>{_write_lock_irqsave+117}
RSP: 0018:ffff81011525f978  EFLAGS: 00000202
RAX: 0000000001000001 RBX: ffffffff881336d0 RCX: ffff8101170a3a68
RDX: 0000000000000000 RSI: 0000000000000014 RDI: 0000000000000001
RBP: ffff81011525fac8 R08: 0000000000008460 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000001 R12: ffff81011cc2e078
R13: ffff81011525fbc8 R14: ffff8101173fcd10 R15: ffff81011525fab4
FS:  00002aaaab4726e0(0000) GS:ffffffff8049a880(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000536100 CR3: 0000000115470000 CR4: 00000000000006e0

Call Trace:<ffffffff802f01c7>{_write_lock_irqsave+52} <ffffffff802f0233>{_write_lock_bh+6}
       <ffffffff881278a2>{:ip_conntrack:tcp_packet+152} <ffffffff801598bd>{__alloc_pages+79}
       <ffffffff802bfb17>{inet_fill_ifaddr+558} <ffffffff802f032e>{_read_lock_irqsave+32}
       <ffffffff88125142>{:ip_conntrack:__ip_conntrack_find+17}
       <ffffffff88126cb6>{:ip_conntrack:ip_conntrack_in+1083}
       <ffffffff80295a37>{nf_iterate+87} <ffffffff8029e731>{dst_output+0}
       <ffffffff80295c30>{nf_hook_slow+135} <ffffffff8029e731>{dst_output+0}
       <ffffffff802a0d64>{ip_queue_xmit+1227} <ffffffff80135f14>{local_bh_enable+121}
       <ffffffff802d4da6>{unix_stream_sendmsg+669} <ffffffff80135f14>{local_bh_enable+121}
       <ffffffff80299139>{__ip_route_output_key+1656} <ffffffff80135092>{current_fs_time+82}
       <ffffffff802f032e>{_read_lock_irqsave+32} <ffffffff8018c2ac>{update_atime+69}
       <ffffffff802b389a>{tcp_v4_send_check+153} <ffffffff802afd38>{tcp_transmit_skb+1673}
       <ffffffff802b045e>{tcp_connect+756} <ffffffff802b74c6>{tcp_v4_connect+2328}
       <ffffffff80277db6>{lock_sock+200} <ffffffff802c2550>{inet_stream_connect+186}
       <ffffffff802f0171>{_spin_unlock+19} <ffffffff8015c48e>{cache_alloc_refill+420}
       <ffffffff80174806>{fget+153} <ffffffff80276f9a>{sys_connect+114}
       <ffffffff802f0171>{_spin_unlock+19} <ffffffff80276659>{sock_map_fd+299}
       <ffffffff8010da72>{system_call+126} 
BUG: soft lockup detected on CPU#1!
CPU 1:
Modules linked in: ip_conntrack_netlink ipt_CLASSIFY sch_htb ipt_mark ipt_CONNMARK af_packet ipt_SAME ipt_state i8xx_tco ipt_pkttype ipt_NOTRACK iptable_raw ipt_LOG ipt_limit ipt_hashlimit ip_nat_ftp evdev ip_conntrack_ftp edd iptable_nat ip_nat ip_conntrack ipt_MARK nfnetlink iptable_mangle iptable_filter ip_tables sg sr_mod i2c_i801 i2c_core hw_random capability commoncap ext3 jbd ide_cd cdrom ide_disk e1000 piix ide_core megaraid_mbox megaraid_mm sd_mod scsi_mod
Pid: 12754, comm: wget Not tainted 2.6.15-rc5-smp #1
RIP: 0010:[<ffffffff802f0210>] <ffffffff802f0210>{_write_lock_irqsave+125}
RSP: 0018:ffff81011525f978  EFLAGS: 00000202
RAX: 0000000001000001 RBX: ffffffff881336d0 RCX: ffff8101170a3a68
RDX: 0000000000000000 RSI: 0000000000000014 RDI: 0000000000000001
RBP: ffff81011525fac8 R08: 0000000000008460 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000001 R12: ffff81011cc2e078
R13: ffff81011525fbc8 R14: ffff8101173fcd10 R15: ffff81011525fab4
FS:  00002aaaab4726e0(0000) GS:ffffffff8049a880(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000536100 CR3: 0000000115470000 CR4: 00000000000006e0

Call Trace:<ffffffff802f01c7>{_write_lock_irqsave+52} <ffffffff802f0233>{_write_lock_bh+6}
       <ffffffff881278a2>{:ip_conntrack:tcp_packet+152} <ffffffff801598bd>{__alloc_pages+79}
       <ffffffff802bfb17>{inet_fill_ifaddr+558} <ffffffff802f032e>{_read_lock_irqsave+32}
       <ffffffff88125142>{:ip_conntrack:__ip_conntrack_find+17}
       <ffffffff88126cb6>{:ip_conntrack:ip_conntrack_in+1083}
       <ffffffff80295a37>{nf_iterate+87} <ffffffff8029e731>{dst_output+0}
       <ffffffff80295c30>{nf_hook_slow+135} <ffffffff8029e731>{dst_output+0}
       <ffffffff802a0d64>{ip_queue_xmit+1227} <ffffffff80135f14>{local_bh_enable+121}
       <ffffffff802d4da6>{unix_stream_sendmsg+669} <ffffffff80135f14>{local_bh_enable+121}
       <ffffffff80299139>{__ip_route_output_key+1656} <ffffffff80135092>{current_fs_time+82}
       <ffffffff802f032e>{_read_lock_irqsave+32} <ffffffff8018c2ac>{update_atime+69}
       <ffffffff802b389a>{tcp_v4_send_check+153} <ffffffff802afd38>{tcp_transmit_skb+1673}
       <ffffffff802b045e>{tcp_connect+756} <ffffffff802b74c6>{tcp_v4_connect+2328}
       <ffffffff80277db6>{lock_sock+200} <ffffffff802c2550>{inet_stream_connect+186}
       <ffffffff802f0171>{_spin_unlock+19} <ffffffff8015c48e>{cache_alloc_refill+420}
       <ffffffff80174806>{fget+153} <ffffffff80276f9a>{sys_connect+114}
       <ffffffff802f0171>{_spin_unlock+19} <ffffffff80276659>{sock_map_fd+299}
       <ffffffff8010da72>{system_call+126} 
BUG: soft lockup detected on CPU#1!
CPU 1:
Modules linked in: ip_conntrack_netlink ipt_CLASSIFY sch_htb ipt_mark ipt_CONNMARK af_packet ipt_SAME ipt_state i8xx_tco ipt_pkttype ipt_NOTRACK iptable_raw ipt_LOG ipt_limit ipt_hashlimit ip_nat_ftp evdev ip_conntrack_ftp edd iptable_nat ip_nat ip_conntrack ipt_MARK nfnetlink iptable_mangle iptable_filter ip_tables sg sr_mod i2c_i801 i2c_core hw_random capability commoncap ext3 jbd ide_cd cdrom ide_disk e1000 piix ide_core megaraid_mbox megaraid_mm sd_mod scsi_mod
Pid: 12754, comm: wget Not tainted 2.6.15-rc5-smp #1
RIP: 0010:[<ffffffff802f0208>] <ffffffff802f0208>{_write_lock_irqsave+117}
RSP: 0018:ffff81011525f978  EFLAGS: 00000202
RAX: 0000000001000001 RBX: ffffffff881336d0 RCX: ffff8101170a3a68
RDX: 0000000000000000 RSI: 0000000000000014 RDI: 0000000000000001
RBP: ffff81011525fac8 R08: 0000000000008460 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000001 R12: ffff81011cc2e078
R13: ffff81011525fbc8 R14: ffff8101173fcd10 R15: ffff81011525fab4
FS:  00002aaaab4726e0(0000) GS:ffffffff8049a880(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000536100 CR3: 0000000115470000 CR4: 00000000000006e0

Call Trace:<ffffffff802f01c7>{_write_lock_irqsave+52} <ffffffff802f0233>{_write_lock_bh+6}
       <ffffffff881278a2>{:ip_conntrack:tcp_packet+152} <ffffffff801598bd>{__alloc_pages+79}
       <ffffffff802bfb17>{inet_fill_ifaddr+558} <ffffffff802f032e>{_read_lock_irqsave+32}
       <ffffffff88125142>{:ip_conntrack:__ip_conntrack_find+17}
       <ffffffff88126cb6>{:ip_conntrack:ip_conntrack_in+1083}
       <ffffffff80295a37>{nf_iterate+87} <ffffffff8029e731>{dst_output+0}
       <ffffffff80295c30>{nf_hook_slow+135} <ffffffff8029e731>{dst_output+0}
       <ffffffff802a0d64>{ip_queue_xmit+1227} <ffffffff80135f14>{local_bh_enable+121}
       <ffffffff802d4da6>{unix_stream_sendmsg+669} <ffffffff80135f14>{local_bh_enable+121}
       <ffffffff80299139>{__ip_route_output_key+1656} <ffffffff80135092>{current_fs_time+82}
       <ffffffff802f032e>{_read_lock_irqsave+32} <ffffffff8018c2ac>{update_atime+69}
       <ffffffff802b389a>{tcp_v4_send_check+153} <ffffffff802afd38>{tcp_transmit_skb+1673}
       <ffffffff802b045e>{tcp_connect+756} <ffffffff802b74c6>{tcp_v4_connect+2328}
       <ffffffff80277db6>{lock_sock+200} <ffffffff802c2550>{inet_stream_connect+186}
       <ffffffff802f0171>{_spin_unlock+19} <ffffffff8015c48e>{cache_alloc_refill+420}
       <ffffffff80174806>{fget+153} <ffffffff80276f9a>{sys_connect+114}
       <ffffffff802f0171>{_spin_unlock+19} <ffffffff80276659>{sock_map_fd+299}
       <ffffffff8010da72>{system_call+126} 
--------------040206010500010105020403--
