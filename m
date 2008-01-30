From: Thomas Woerner <twoerner@redhat.com>
Subject: Re: kernel crash in nf_nat_move_storage
Date: Wed, 30 Jan 2008 16:50:32 +0100
Message-ID: <47A09CC8.8060608@redhat.com>
References: <47A062BF.1010008@redhat.com> <47A07BE3.7000600@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050301020107000304050700"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbYA3Puh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 10:50:37 -0500
In-Reply-To: <47A07BE3.7000600@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050301020107000304050700
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hello Patrick,

after sucessfully testing 2.6.23.14-107.fc8 on my i386 test system, I 
installed 2.6.23.14-107.fc8 on the x86_64 system. At first I was not 
able to reproduce the problem, but after starting the ftp server 
(vsftpd) and using 'echo "quit" | telnet test-x86_64 80' several times, 
I got a backtrace again. Please have a look at the attachment.

Thanks,
Thomas

Patrick McHardy wrote:
> Thomas Woerner wrote:
>> Hello,
>>
>> Using port forwarding from port 80 to 21 with nf_conntrack_ftp loaded 
>> results in a kernel crash, when connecting to port 80 from a remote
>> host. This seems to be a problem for kernels > 2.6.18 including 2.6.24.
>>
>> Steps to Reproduce:
>>
>> host1> iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT 
>> --to :21
>> host1> iptables -t filter -A INPUT -i eth0 -m state --state NEW -m tcp 
>> -p tcp --dport 21 -j ACCEPT
>> host1> modprobe ip_conntrack_ftp
>> host2> telnet host1 80
>>
>> Attached is the kernel crash log for kernel 2.6.23.9-85.fc8PAE. I was 
>> told that this kernel crash dump is incomplete, but it took several 
>> attempts to get a log with more that 5 lines over serial console. The 
>> kernel seems to die too fast.
> 
> 
> This is already fixed in 2.6.23.10.
> -
> To unsubscribe from this list: send the line "unsubscribe 
> netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Thomas Woerner
Software Engineer            Phone: +49-711-96437-310
Red Hat GmbH                 Fax  : +49-711-96437-111
Hauptstaetterstr. 58         Email: Thomas Woerner <twoerner@redhat.com>
D-70178 Stuttgart            Web  : http://www.redhat.de/

--------------050301020107000304050700
Content-Type: text/plain;
 name="oups3"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="oups3"

stack segment: 0000 [1] SMP 
CPU 3 
Modules linked in: nf_conntrack_ftp ipt_REJECT ipt_LOG xt_state iptable_filter xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nfnetlink ip_tables x_tables cpufreq_ondemand dm_mirror dm_multipath dm_mod snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss cfi_cmdset_0002 cfi_util snd_mixer_oss shpchp jedec_probe firewire_ohci firewire_core cfi_probe gen_probe snd_pcm parport_pc ck804xrom k8temp hwmon parport floppy sr_mod mtd chipreg map_funcs cdrom snd_timer forcedeth snd pcspkr soundcore sg i2c_nforce2 crc_itu_t serio_raw button snd_page_alloc i2c_core pata_amd ata_generic sata_nv libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd
Pid: 0, comm: swapper Not tainted 2.6.23.14-107.fc8 #1
RIP: 0010:[<ffffffff8827e069>]  [<ffffffff8827e069>] :nf_nat:nf_nat_move_storage+0x2f/0x8a
RSP: 0018:ffff810001f7f9d0  EFLAGS: 00010206
RAX: 0000000000000008 RBX: ffff81007d306d08 RCX: ffff81007d306d00
RDX: ffff81007d306d00 RSI: ffff81007d306d20 RDI: ffff81007c1f8130
RBP: 73616c636632785c R08: ffff81007c1f8130 R09: 0000000000000000
R10: 000000004646dc9c R11: ffffffff8826a304 R12: ffff81007d306d20
R13: 0000000000000038 R14: 0000000000000001 R15: 0000000000000000
FS:  00002aaaad752260(0000) GS:ffff81007fead380(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00002aaaaace9958 CR3: 000000007c3df000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff810040f12000, task ffff810001f76820)
Stack:  0000000000000070 ffff81007c1f8130 ffff81007fefb600 ffffffff8826bb32
 0106d7be00000000 0000000000000000 ffffffff882a2640 ffff81007c1f8130
 ffff81007c1f8130 0000000000000000 0000000000000001 ffffffff88269b3f
Call Trace:
 <IRQ>  [<ffffffff8826bb32>] :nf_conntrack:__nf_ct_ext_add+0x136/0x1bc
 [<ffffffff88269b3f>] :nf_conntrack:nf_ct_helper_ext_add+0xd/0x1c
 [<ffffffff88267f1b>] :nf_conntrack:nf_conntrack_alter_reply+0x89/0xb4
 [<ffffffff8827ea95>] :nf_nat:nf_nat_setup_info+0x3f1/0x548
 [<ffffffff88286232>] :iptable_nat:ipt_dnat_target+0x141/0x14c
 [<ffffffff8125d30f>] _write_lock_bh+0x9/0x1c
 [<ffffffff88267a98>] :nf_conntrack:__nf_ct_refresh_acct+0x137/0x178
 [<ffffffff8825ca80>] :ip_tables:ipt_do_table+0x4d6/0x592
 [<ffffffff8827e102>] :nf_nat:nf_nat_protocol_register+0xd/0x4a
 [<ffffffff88286254>] :iptable_nat:nf_nat_rule_find+0x17/0x57
 [<ffffffff8828643c>] :iptable_nat:nf_nat_fn+0x190/0x1bc
 [<ffffffff882864c7>] :iptable_nat:nf_nat_in+0x23/0x9f
 [<ffffffff81209f3d>] nf_iterate+0x41/0x7d
 [<ffffffff8120f610>] ip_rcv_finish+0x0/0x30b
 [<ffffffff8120a0ea>] nf_hook_slow+0x5d/0xc0
 [<ffffffff8120f610>] ip_rcv_finish+0x0/0x30b
 [<ffffffff8120fe6c>] ip_rcv+0x25c/0x58d
 [<ffffffff811efc79>] netif_receive_skb+0x192/0x3ae
 [<ffffffff8102f1ed>] __update_rq_clock+0x1a/0xed
 [<ffffffff880fefe7>] :forcedeth:nv_napi_poll+0x544/0x6cd
 [<ffffffff811f214f>] net_rx_action+0xa8/0x1a3
 [<ffffffff8103c9ed>] __do_softirq+0x55/0xc3
 [<ffffffff8101d667>] ack_apic_level+0x10/0xd9
 [<ffffffff8100cd5c>] call_softirq+0x1c/0x28
 [<ffffffff8100de8d>] do_softirq+0x2c/0x85
 [<ffffffff8103c953>] irq_exit+0x3f/0x84
 [<ffffffff8100e149>] do_IRQ+0x13e/0x161
 [<ffffffff8100adba>] default_idle+0x0/0x3d
 [<ffffffff8100c0e1>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8101bdf7>] lapic_next_event+0x0/0xa
 [<ffffffff8100ade3>] default_idle+0x29/0x3d
 [<ffffffff8100ae8b>] cpu_idle+0x94/0xbc


Code: 48 f7 45 78 80 01 00 00 74 4c 48 c7 c7 e0 18 28 88 e8 87 f2 
RIP  [<ffffffff8827e069>] :nf_nat:nf_nat_move_storage+0x2f/0x8a
 RSP <ffff810001f7f9d0>
Kernel panic - not syncing: Aiee, killing interrupt handler!


--------------050301020107000304050700--
