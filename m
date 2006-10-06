From: Deti Fliegl <deti@fliegl.de>
Subject: kernel oops in 2.6.17.7 (smp)
Date: Fri, 06 Oct 2006 10:10:02 +0200
Message-ID: <45260F5A.60700@fliegl.de>
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

Hi there,

a kernel oops happens since ages with this setup with all recent kernels 
(since 2.6.12) - and most probably even with the latest versions. Here 
it takes about 60 days to reproduce:

----------------------------------------------------------------
Unable to handle kernel paging request at ffffc2000031d103 RIP:
<ffffffff88103e83>{:ip_tables:ipt_do_table+194}
PGD 11fc42067 PUD 11fc43067 PMD 11f72b067 PTE 0
Oops: 0000 [1] SMP
CPU 2
Modules linked in: ipt_ipp2p ipt_REDIRECT af_packet i8xx_tco xt_CLASSIFY 
sch_htb xt_mark xt_CONNMARK ipt_SAME xt_state xt_pkttype xt_NOTRACK 
iptable_raw edd ipt_LOG xt_limit ipt_hashlimit xt_tcpudp
  ip_conntrack_netlink ip_nat_ftp ip_conntrack_ftp thermal processor fan 
button iptable_nat battery ip_nat ac xt_MARK ip_conntrack nfnetlink 
iptable_filter iptable_mangle ip_tables x_tables ipmi_si ipmi_devintf 
ipmi_msghandler ext3 jbd ide_cd cdrom e1000 piix sg megaraid_mbox 
megaraid_mm sd_mod scsi_mod ide_disk ide_core
Pid: 4709, comm: syslog-ng Not tainted 2.6.17.7-smp #1
RIP: 0010:[<ffffffff88103e83>] 
<ffffffff88103e83>{:ip_tables:ipt_do_table+194}
RSP: 0018:ffff81011cff9a88  EFLAGS: 00010206
RAX: ffffc2000031d0b0 RBX: 0000000000000000 RCX: ffff81011eff2000
RDX: 0000000000000003 RSI: 0000000000000003 RDI: ffffffff8810dc58
RBP: ffffc2000031d0b0 R08: ffffffff8810dc58 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffffc2000031b000 R14: ffff81003f366010 R15: 0000000000000000
FS:  00002b41a73416e0(0000) GS:ffff81011fc6ed40(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffc2000031d103 CR3: 000000011cfd9000 CR4: 00000000000006e0
Process syslog-ng (pid: 4709, threadinfo ffff81011cff8000, task 
ffff81011c4f5760)
Stack: 0000000000000000 ffff81011eff2000 0000000000000000 0000000388136493
        ffff81011cff9be0 ffffffff8810dc58 0000000000000000 ffffffff88108688
        ffff81011eff2000 ffffc2000031d0b0
Call Trace: <ffffffff8037a7f7>{nf_iterate+63} 
<ffffffff80382178>{dst_output+0}
        <ffffffff8037a88d>{nf_hook_slow+90} <ffffffff80382178>{dst_output+0}
        <ffffffff80382246>{ip_generic_getfrag+40} 
<ffffffff80383fb8>{ip_push_pending_frames+877}
        <ffffffff8039cc99>{udp_push_pending_frames+559} 
<ffffffff8039d577>{udp_sendmsg+1172}
        <ffffffff8027d603>{dput+32} 
<ffffffff80276a14>{__link_path_walk+3399}
        <ffffffff8035d083>{do_sock_write+193} 
<ffffffff8035d6c9>{sock_aio_write+81}
        <ffffffff802685b9>{do_sync_write+199} 
<ffffffff802fcaa0>{_atomic_dec_and_lock+52}
        <ffffffff80239e4c>{autoremove_wake_function+0} 
<ffffffff80268b29>{vfs_write+225}
        <ffffffff80269400>{sys_write+69} <ffffffff80209736>{system_call+126}

Code: 40 8a 7d 53 40 0f b6 f7 8b 45 08 41 23 46 0c 3b 45 00 0f 95
RIP <ffffffff88103e83>{:ip_tables:ipt_do_table+194} RSP <ffff81011cff9a88>
CR2: ffffc2000031d103
  <0>Kernel panic - not syncing: Aiee, killing interrupt handler!
----------------------------------------------------------------

For me it looks like a race condition or memory corruption within 
iptables even though it happend in the process context of syslog-ng. Any 
clues?

Deti
