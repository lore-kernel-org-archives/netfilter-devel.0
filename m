From: Deti Fliegl <deti@fliegl.de>
Subject: again oops: conntrack & 2.6.14-git14
Date: Sat, 12 Nov 2005 16:34:47 +0100
Message-ID: <43760B97.9010603@fliegl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

This time it seems that I cought the oops in the right place. It's still 
happening somewhere in the conntrack code:

<1>Unable to handle kernel paging request at ffffffff82800000 RIP:
<ffffffff8010f35c>{show_trace+489}
PGD 103027 PUD 105027 PMD 0
Oops: 0000 [1] SMP
CPU 1
Modules linked in: ip_conntrack_netlink ipt_CLASSIFY sch_htb ipt_ipp2p 
ipt_mark ipt_CONNMARK af_packet i8xx_tco ipt_SAME ipt_state ipt_pkttype 
ipt_NOTRACK iptable_raw ipt_LOG ipt_limit ipt_hashlimit ip_nat_ftp 
ip_conntrack_ftp iptable_nat ip_nat ip_conntrack nfnetl
ink iptable_mangle ipt_MARK iptable_filter ip_tables edd evdev sg sr_mod 
i2c_i801 i2c_core hw_random capability commoncap ext3 jbd ide_cd cdrom 
ide_disk e1000 piix ide_core megaraid_mbox megaraid_mm sd_mod scsi_mod
Pid: 4522, comm: wget Not tainted 2.6.14-git14-smp #1
RIP: 0010:[<ffffffff8010f35c>] <ffffffff8010f35c>{show_trace+489}
RSP: 0018:ffff810009bdf840  EFLAGS: 00010006
RAX: 0000000000000000 RBX: 0000000001bc67ff RCX: ffffffff803acd78
RDX: 0000000000000000 RSI: 0000000000000086 RDI: ffffffff803acdc0
RBP: ffffffff827fffff R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000007 R14: 0000000000000000 R15: ffffffff804b8100
FS:  00002aaaab4726e0(0000) GS:ffffffff80483880(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffff82800000 CR3: 000000005e8c7000 CR4: 00000000000006e0
Process wget (pid: 4522, threadinfo ffff81005ef68000, task ffff81010a3850e0)
Stack: 0000000000000080 ffff810009bdfa00 0000000009bdf968 0000000000000001
        ffff810009bdf968 0000000000000000 ffff810009bdf968 0000000000000000
        ffff810009bdf968 ffffffff8015096e
Call Trace: <IRQ> <ffffffff8015096e>{softlockup_tick+132} 
<ffffffff80111b6c>{timer_interrupt+501}
        <ffffffff801509d7>{handle_IRQ_event+41} 
<ffffffff80150aa5>{__do_IRQ+155}
        <ffffffff80110172>{do_IRQ+47} <ffffffff8010df12>{ret_from_intr+0}
        <ffffffff8020da5d>{__write_lock_failed+9} 
<ffffffff802e368c>{.text.lock.spinlock+111}
        <ffffffff8812e78c>{:ip_conntrack:tcp_packet+152} 
<ffffffff8013ba1f>{notifier_call_chain+31}
        <ffffffff8812c142>{:ip_conntrack:__ip_conntrack_find+17}
        <ffffffff8812dd7a>{:ip_conntrack:ip_conntrack_in+1084}
        <ffffffff802c1f77>{nf_iterate+87} <ffffffff80292921>{dst_output+0}
        <ffffffff802c2166>{nf_hook_slow+125} 
<ffffffff80292921>{dst_output+0}
        <ffffffff802953a4>{ip_build_and_send_pkt+563} 
<ffffffff802a48cc>{tcp_make_synack+475}
        <ffffffff802a7b89>{tcp_v4_send_synack+203} 
<ffffffff802aa414>{tcp_v4_conn_request+986}
        <ffffffff802a1d23>{tcp_rcv_state_process+120} 
<ffffffff802a92d8>{tcp_v4_do_rcv+650}
        <ffffffff802a9950>{tcp_v4_rcv+1553} 
<ffffffff80290422>{ip_local_deliver+409}
        <ffffffff8028fff4>{ip_rcv+1247} 
<ffffffff8027640a>{netif_receive_skb+948}
        <ffffffff802764ea>{process_backlog+156} 
<ffffffff80274ea1>{net_rx_action+177}
        <ffffffff801342da>{__do_softirq+102} 
<ffffffff8010ee87>{call_softirq+31}
         <EOI> <1>Unable to handle kernel paging request at 
ffffffff82800000 RIP:
