From: Jean-Philippe Menil <jean-philippe.menil@univ-nantes.fr>
Subject: Re: kernel BUG at net/netfilter/ipset/ip_set_core.c:314
Date: Tue, 30 Aug 2011 11:07:46 +0200
Message-ID: <4E5CA862.2070004@univ-nantes.fr>
References: <4E5CA623.9000402@univ-nantes.fr>
Reply-To: jean-philippe.menil@univ-nantes.fr
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060001030209010108000607"
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-tls2.univ-nantes.fr ([193.52.101.146]:43747 "EHLO
	smtp-tls.univ-nantes.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066Ab1H3JHs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Aug 2011 05:07:48 -0400
In-Reply-To: <4E5CA623.9000402@univ-nantes.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060001030209010108000607
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Le 30/08/2011 10:58, Jean-Philippe Menil a écrit :
> Hi,
>
> With the set bitmap ipmac, if i had one, two hundred ip,mac in a set; 
> and do an ipset list,
> i get an:
> ipset v6.8: Kernel error received: No buffer space available
> followed by a kernel panic (trace attached).
>
> Maybe, in ip_set_core.c, can we modify the line 435 to this one:
> if (ip_set_list[index] != NULL && ip_set_list[index]->ref !=0)
>
> This way, we avoid the kernel panic?
>
> Regards.
>
Sorry,

forgot to attached the kernel trace ...

-- 
Jean-Philippe Menil - Pôle réseau Service IRTS
DSI Université de Nantes
jean-philippe.menil@univ-nantes.fr
Tel : 02.53.48.49.27 - Fax : 02.53.48.49.09


--------------060001030209010108000607
Content-Type: text/plain;
 name="kernel-panic.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="kernel-panic.txt"

Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.492008] ------------[ cut here ]------------
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.492505] kernel BUG at net/netfilter/ipset/ip_set_core.c:314!
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.492962] invalid opcode: 0000 [#1] SMP 
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.493472] CPU 0 
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.493590] Modules linked in: netconsole configfs ip6table_filter fuse ipt_LOG xt_TPROXY nf_tproxy_core xt_socket ip6_tables nf_defrag_ipv6 xt_set ip_set_bitmap_ipmac ip_set nfnetlink ipt_REDIRECT xt_mark xt_tcpudp xt_limit xt_state iptable_mangle iptable_filter nf_nat_ftp iptable_nat nf_nat nf_conntrack_irc nf_conntrack_ftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables ipv6 ext2 mbcache snd_pcm snd_timer snd soundcore snd_page_alloc tpm_tis tpm pcspkr tpm_bios psmouse virtio_balloon serio_raw evdev i2c_piix4 i2c_core processor button thermal_sys xfs exportfs dm_mod virtio_blk ata_generic ata_piix libata virtio_net scsi_mod ide_pci_generic floppy virtio_pci virtio_ring virtio uhci_hcd ehci_hcd piix ide_core [last unloa
 ded: scsi_wait_scan]
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336] 
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336] Pid: 2053, comm: ipset Not tainted 3.0.3-dsiun-110829-debug+ #16 Bochs Bochs
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336] RIP: 0010:[<ffffffffa03aec6a>]  [<ffffffffa03aec6a>] ip_set_put_byindex+0x4a/0x50 [ip_set]
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336] RSP: 0018:ffff88007a617a68  EFLAGS: 00010246
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336] RAX: ffff88007a6b7960 RBX: 0000000000000000 RCX: ffff88007a61a028
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336] RDX: 0000000000000000 RSI: ffff88007a617a34 RDI: ffffffffa03b24d4
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336] RBP: ffff88007adc1a00 R08: 0000000005000000 R09: 0000000000000004
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336] R10: ffff88007a61a1dc R11: 0000000000000000 R12: ffff88007a6b7960
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336] R13: ffff88007a61a000 R14: 0000000000000000 R15: ffff88007a6b7980
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336] FS:  00007f0995be4700(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336] CR2: 00007f09954e7750 CR3: 000000003789e000 CR4: 00000000000006f0
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336] Process ipset (pid: 2053, threadinfo ffff88007a616000, task ffff880079240940)
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336] Stack:
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336]  ffff88007aec1780 ffffffffa03afa6a ffffffffa03aec70 ffff880000000000
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336]  0000000000000e80 00000000000000d0 00000000ffffffff 0000000000000000
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336]  0000000000000e80 ffffffff812f278f 00000000819f1540 ffff88007f802900
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336] Call Trace:
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336]  [<ffffffffa03afa6a>] ? ip_set_dump_start+0x29a/0x450 [ip_set]
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336]  [<ffffffffa03aec70>] ? ip_set_put_byindex+0x50/0x50 [ip_set]
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336]  [<ffffffff812f278f>] ? __alloc_skb+0x7f/0x180
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336]  [<ffffffff81323655>] ? netlink_dump+0x65/0x200
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336]  [<ffffffff81127a9c>] ? kfree+0x2c/0x110
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336]  [<ffffffff81126c12>] ? kmem_cache_free+0x12/0xe0
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336]  [<ffffffff81323d30>] ? netlink_recvmsg+0x320/0x480
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336]  [<ffffffff812e88a7>] ? sock_recvmsg+0x127/0x140
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336]  [<ffffffff812e8b50>] ? sock_sendmsg+0x110/0x130
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336]  [<ffffffff812e8308>] ? move_addr_to_user+0x88/0xa0
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336]  [<ffffffff812e8780>] ? sock_recvmsg_nosec+0x140/0x140
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336]  [<ffffffff812e8444>] ? __sys_recvmsg+0x124/0x2b0
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336]  [<ffffffff81101422>] ? handle_mm_fault+0x52/0x3f0
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336]  [<ffffffff812e92cc>] ? sys_sendto+0x13c/0x1a0
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336]  [<ffffffff812e8308>] ? move_addr_to_user+0x88/0xa0
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336]  [<ffffffff812e9d67>] ? sys_getsockname+0xe7/0x100
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336]  [<ffffffff812e9f7b>] ? sock_alloc_file+0xab/0x130
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336]  [<ffffffff812e8fa4>] ? sys_recvmsg+0x44/0x80
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336]  [<ffffffff813a4cd2>] ? system_call_fastpath+0x16/0x1b
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336] Code: 8b 05 83 3b 00 00 48 8b 04 d8 8b 50 24 85 d2 74 1a 83 ea 01 48 c7 c7 d4 24 3b a0 89 50 24 5b e9 bd 56 ff e0 0f 1f 44 00 00 5b c3 <0f> 0b eb fe 66 90 48 83 ec 08 48 83 7f 38 00 74 09 0f b7 7f 30 
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336] RIP  [<ffffffffa03aec6a>] ip_set_put_byindex+0x4a/0x50 [ip_set]
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.495336]  RSP <ffff88007a617a68>
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.529211] ---[ end trace c8ce909497081d18 ]---
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.529693] Kernel panic - not syncing: Fatal exception in interrupt
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.530187] Pid: 2053, comm: ipset Tainted: G      D     3.0.3-dsiun-110829-debug+ #16
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.530909] Call Trace:
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.531253]  [<ffffffff813a176d>] ? panic+0x92/0x19d
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.531690]  [<ffffffff810504c2>] ? kmsg_dump+0x42/0xf0
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.532171]  [<ffffffff81005e07>] ? oops_end+0xe7/0xf0
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.532607]  [<ffffffff810038c4>] ? do_invalid_op+0x84/0xa0
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.533042]  [<ffffffffa03aec6a>] ? ip_set_put_byindex+0x4a/0x50 [ip_set]
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.533520]  [<ffffffff813a4389>] ? _raw_write_lock_bh+0x9/0x20
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.533965]  [<ffffffffa03afa6a>] ? ip_set_dump_start+0x29a/0x450 [ip_set]
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.534458]  [<ffffffff8121026e>] ? __nla_reserve+0x4e/0x70
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.534906]  [<ffffffff813a5c5b>] ? invalid_op+0x1b/0x20
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.535368]  [<ffffffffa03aec6a>] ? ip_set_put_byindex+0x4a/0x50 [ip_set]
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.535847]  [<ffffffffa03aec3e>] ? ip_set_put_byindex+0x1e/0x50 [ip_set]
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.536373]  [<ffffffffa03afa6a>] ? ip_set_dump_start+0x29a/0x450 [ip_set]
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.536866]  [<ffffffffa03aec70>] ? ip_set_put_byindex+0x50/0x50 [ip_set]
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.537344]  [<ffffffff812f278f>] ? __alloc_skb+0x7f/0x180
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.537783]  [<ffffffff81323655>] ? netlink_dump+0x65/0x200
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.538222]  [<ffffffff81127a9c>] ? kfree+0x2c/0x110
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.538648]  [<ffffffff81126c12>] ? kmem_cache_free+0x12/0xe0
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.539088]  [<ffffffff81323d30>] ? netlink_recvmsg+0x320/0x480
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.539533]  [<ffffffff812e88a7>] ? sock_recvmsg+0x127/0x140
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.539973]  [<ffffffff812e8b50>] ? sock_sendmsg+0x110/0x130
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.540464]  [<ffffffff812e8308>] ? move_addr_to_user+0x88/0xa0
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.540953]  [<ffffffff812e8780>] ? sock_recvmsg_nosec+0x140/0x140
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.541410]  [<ffffffff812e8444>] ? __sys_recvmsg+0x124/0x2b0
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.541855]  [<ffffffff81101422>] ? handle_mm_fault+0x52/0x3f0
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.542299]  [<ffffffff812e92cc>] ? sys_sendto+0x13c/0x1a0
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.542736]  [<ffffffff812e8308>] ? move_addr_to_user+0x88/0xa0
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.543187]  [<ffffffff812e9d67>] ? sys_getsockname+0xe7/0x100
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.543635]  [<ffffffff812e9f7b>] ? sock_alloc_file+0xab/0x130
Aug 30 11:09:28 test.wifi.univ-nantes.fr kernel: [  149.544116]  [<ffffffff812e8fa4>] ? sys_recvmsg+0x44/0x80

--------------060001030209010108000607--
