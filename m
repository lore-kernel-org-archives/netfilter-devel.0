From: ilninno <ilninno@gmail.com>
Subject: Please i need help with this error
Date: Sat, 31 Jan 2009 19:41:40 +0100
Message-ID: <92770c820901311041o57a3a33t96f5d32430f8b7bc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gx0-f21.google.com ([209.85.217.21]:47165 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbZAaSln (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 31 Jan 2009 13:41:43 -0500
Received: by gxk14 with SMTP id 14so766900gxk.13
        for <netfilter-devel@vger.kernel.org>; Sat, 31 Jan 2009 10:41:41 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello, i need help please,


Sometimes all is working fine, and other times i got a kernel panic.

int i= nfq_set_verdict_mark(myQueue, id, NF_REPEAT, htonl(1) ,0, NULL);
cout << "ver: " <<  i << endl;
return i;

The problem is exacly in nfq_set_verdict_mark(myQueue, id, NF_REPEAT,
htonl(1) ,0, NULL);


I don't know what is the problem. Please i need help.



BUG: unable to handle kernel NULL pointer dereference
IP: [<f89848a9>] :nfnetlink_queue:nfqnl_enqueue_packet+0x18f/0x507
*pde = 2264c067 *pte = 00000000
Oops: 0000 [#1] SMP
Modules linked in: nfnetlink_queue nfnetlink vfat fat fuse sco bridge
stp bnep l2cap bluetooth sunrpc ts_bm xt_string xt_comment xt_NFQUEUE
ipt_LOG xt_mark iptable_nat nf_nat ip6t_REJECT nf_conntrack_ipv6
ip6table_filter ip6_tables ipv6 cpufreq_ondemand acpi_cpufreq
dm_multipath uinput ata_generic pata_acpi snd_hda_intel ppdev
snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
snd_pcm_oss snd_mixer_oss snd_pcm floppy snd_timer i2c_i801 pcspkr
firewire_ohci firewire_core snd_page_alloc i2c_core snd_hwdep
parport_pc parport usb_storage iTCO_wdt pata_jmicron snd
iTCO_vendor_support crc_itu_t sky2 soundcore [last unloaded:
microcode]

Pid: 3258, comm: listener Not tainted (2.6.27.9-159.fc10.i686 #1)
EIP: 0060:[<f89848a9>] EFLAGS: 00010282 CPU: 1
EIP is at nfqnl_enqueue_packet+0x18f/0x507 [nfnetlink_queue]
EAX: 00000000 EBX: 000000b0 ECX: 00000009 EDX: 00000001
ESI: f25a9b40 EDI: e25c1a00 EBP: e749ebfc ESP: e749ebb0
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process listener (pid: 3258, ti=e749e000 task=e89a59b0 task.ti=e749e000)
Stack: e75353c0 f5d73800 f8cfb0b4 e74c6cb8 e2872a00 0000003c e2872a00 e25c1a30
       00040438 00000438 e2642c80 e749ebfc 00000286 00b10f03 00000300 00000040
       e75353c0 00000002 f8984cdc e749ec24 c0648717 c06d7cec f5d73800 c080f50c
Call Trace:
 [<c0648717>] ? __nf_queue+0x108/0x18b
 [<c06488ab>] ? nf_reinject+0x111/0x134
 [<c0654a3c>] ? dst_output+0x0/0xb
 [<f8984707>] ? nfqnl_recv_verdict+0x1db/0x1ee [nfnetlink_queue]
 [<f8c0b1aa>] ? nfnetlink_rcv_msg+0x10e/0x125 [nfnetlink]
 [<c04f5143>] ? security_netlink_recv+0xf/0x11
 [<f8c0b0b5>] ? nfnetlink_rcv_msg+0x19/0x125 [nfnetlink]
 [<f8c0b09c>] ? nfnetlink_rcv_msg+0x0/0x125 [nfnetlink]
 [<c0646c7c>] ? netlink_rcv_skb+0x30/0x78
 [<f8c0b01c>] ? nfnetlink_rcv+0x1c/0x29 [nfnetlink]
 [<c064688d>] ? netlink_unicast+0xee/0x144
 [<c0646b12>] ? netlink_sendmsg+0x22f/0x23c
 [<c0626f19>] ? __sock_sendmsg+0x45/0x4e
 [<c06276e2>] ? sock_sendmsg+0xb8/0xce
 [<c043dc16>] ? autoremove_wake_function+0x0/0x33
 [<c0575507>] ? n_tty_receive_buf+0xeae/0xf1f
 [<c041e6f6>] ? need_resched+0x18/0x22
 [<c051efd8>] ? copy_from_user+0x39/0x121
 [<c062d935>] ? verify_iovec+0x40/0x6f
 [<c0627837>] ? sys_sendmsg+0x13f/0x192
 [<c0429f07>] ? finish_task_switch+0x2f/0xb0
 [<c06a79cf>] ? schedule+0x6ee/0x70d
 [<c0628389>] ? sys_recvfrom+0xaf/0xba
 [<c0576c9d>] ? pty_write+0x31/0x40
 [<c043ddff>] ? remove_wait_queue+0x22/0x27
 [<c06a8fe3>] ? _spin_unlock_irqrestore+0x22/0x38
 [<c0420e83>] ? __wake_up+0x31/0x3b
 [<c06287d2>] ? sys_socketcall+0x168/0x19e
 [<c040a068>] ? syscall_trace_enter+0xb5/0xc9
 [<c0403c76>] ? syscall_call+0x7/0xb
