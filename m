From: Lev Stipakov <lstipakov@gmail.com>
Subject: Re: iptables audit target causes kernel panic with
 iptables-persistent (kernel 3.2.78)
Date: Tue, 26 Apr 2016 15:17:58 +0300
Message-ID: <571F5C76.3010700@gmail.com>
References: <CAGyAFMVTf6nRtKtdQAJ0EqP3tpz7k=UBY+6daXmt+h3h3GKqfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:34225 "EHLO
	mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbcDZMSC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Apr 2016 08:18:02 -0400
Received: by mail-lf0-f43.google.com with SMTP id j11so15520850lfb.1
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Apr 2016 05:18:01 -0700 (PDT)
Received: from [10.64.1.70] (fsgw.f-secure.com. [193.110.108.33])
        by smtp.gmail.com with ESMTPSA id sa9sm5238588lbb.38.2016.04.26.05.17.59
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Apr 2016 05:17:59 -0700 (PDT)
In-Reply-To: <CAGyAFMVTf6nRtKtdQAJ0EqP3tpz7k=UBY+6daXmt+h3h3GKqfw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Kernel crash dump:

[  217.819774] piix4_smbus 0000:00:07.0: SMBus base address 
uninitialized - upgrade BIOS or use force_addr=0xaddr
[  218.173782] Error: Driver 'pcspkr' is already registered, aborting...
[  229.433697] BUG: unable to handle kernel paging request at 
ffff88021a2fc80b
[  229.524189] IP: [<ffffffffa03e3330>] audit_tg+0xb9/0x15b [xt_AUDIT]
[  229.713702] PGD 1606063 PUD 0
[  229.714117] Oops: 0000 [#1] SMP
[  229.714479] CPU 0
[  229.714652] Modules linked in: xt_AUDIT parport_pc ppdev lp parport 
bnep bluetooth rfkill ip6table_filter ip6_tables iptable_filter 
ip_tables x_tables uinput nfsd nfs nfs_acl auth_rpcgss fscache lockd 
sunrpc loop crc32c_intel aesni_intel battery ac power_supply pcspkr 
processor video aes_x86_64 thermal_sys psmouse joydev evdev serio_raw 
button aes_generic cryptd snd_intel8x0 snd_ac97_codec snd_pcm 
snd_page_alloc snd_timer snd soundcore vboxguest(O) i2c_piix4 i2c_core 
ac97_bus ext4 crc16 jbd2 mbcache usbhid hid sg sr_mod sd_mod crc_t10dif 
cdrom ata_generic ata_piix ohci_hcd ehci_hcd ahci libahci libata usbcore 
usb_common e1000 scsi_mod [last unloaded: scsi_wait_scan]
[  230.154897]
[  230.223490] Pid: 0, comm: swapper/0 Tainted: G           O 
3.2.0-4-amd64 #1 Debian 3.2.78-1 innotek GmbH VirtualBox/VirtualBox
[  230.594007] RIP: 0010:[<ffffffffa03e3330>]  [<ffffffffa03e3330>] 
audit_tg+0xb9/0x15b [xt_AUDIT]
[  230.963683] RSP: 0018:ffff88011fc03be0  EFLAGS: 00010286
[  231.053744] RAX: 0000000000000000 RBX: ffff880119f8aac0 RCX: 
ffff88021a2fc7ff
[  231.433840] RDX: 000000000000005c RSI: ffffffffa03e412f RDI: 
ffff88011a8beac0
[  231.603982] RBP: ffff88011fc03ce0 R08: ffff880119e15000 R09: 
00000000fffffff8
[  231.724164] R10: 0000000000000078 R11: 0000000000000000 R12: 
ffff88011a8beac0
[  231.725226] R13: ffff8801181cb658 R14: ffff880119f8aac0 R15: 
ffff8801181cb638
[  231.744298] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) 
knlGS:0000000000000000
[  231.745494] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  231.754042] CR2: ffff88021a2fc80b CR3: 0000000119e58000 CR4: 
00000000000406f0
[  231.755131] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  231.763888] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[  231.764930] Process swapper/0 (pid: 0, threadinfo ffffffff81600000, 
task ffffffff8160d020)
[  231.766108] Stack:
[  231.772178]  ffff880117e3e000 0000000000000000 0000009d00000001 
ffff8801181cb5c8
[  231.794053]  ffff880119e1a540 ffff88011fc1a88c ffff88011a2fc810 
ffffffffa035b0f4
[  231.804858]  0000000000000046 ffff880117e3e000 ffff880118f17e80 
ffffffff8160d020
[  231.805980] Call Trace:
[  231.814086]  <IRQ>
[  231.814508]  [<ffffffffa035b0f4>] ? ipt_do_table+0x4d7/0x556 [ip_tables]
[  231.815478]  [<ffffffff812f4470>] ? xfrm_lookup+0x3a1/0x43a
[  231.816293]  [<ffffffff810ec003>] ? virt_to_cache+0x7/0x23
[  231.854059]  [<ffffffff812b3a49>] ? nf_iterate+0x41/0x77
[  231.864550]  [<ffffffff812bc14a>] ? __skb_dequeue+0x31/0x31
[  231.865372]  [<ffffffff812b3ae7>] ? nf_hook_slow+0x68/0x101
[  231.866184]  [<ffffffff812bc14a>] ? __skb_dequeue+0x31/0x31
[  231.880501]  [<ffffffff812bd7cb>] ? nf_hook_thresh.constprop.31+0x39/0x3e
[  231.881538]  [<ffffffff812bd7ef>] ? __ip_local_out+0x1f/0x3d
[  231.882373]  [<ffffffff812bd816>] ? ip_local_out+0x9/0x19
[  231.883171]  [<ffffffff812e2aa5>] ? igmp_ifc_timer_expire+0x1b2/0x1df
[  231.884114]  [<ffffffff810526cc>] ? run_timer_softirq+0x19a/0x261
[  231.885010]  [<ffffffff812e28f3>] ? add_grec+0x364/0x364
[  231.885799]  [<ffffffff8102b2d2>] ? kvm_clock_read+0x17/0x1a
[  231.894392]  [<ffffffff8104c4c0>] ? __do_softirq+0xd7/0x1af
[  231.895271]  [<ffffffff8106b417>] ? clockevents_program_event+0xaa/0xce
[  231.896236]  [<ffffffff813594ec>] ? call_softirq+0x1c/0x30
[  231.897055]  [<ffffffff8100faad>] ? do_softirq+0x3c/0x7b
[  231.897857]  [<ffffffff8104c742>] ? irq_exit+0x3c/0x99
[  231.904278]  [<ffffffff81024670>] ? smp_apic_timer_interrupt+0x74/0x82
[  231.905270]  [<ffffffff81357d5e>] ? apic_timer_interrupt+0x6e/0x80
[  231.906178]  <EOI>
[  231.906543]  [<ffffffff810149e7>] ? mwait_idle+0x7f/0xac
[  232.125169]  [<ffffffff810149da>] ? mwait_idle+0x72/0xac
[  232.284049]  [<ffffffff8100d24c>] ? cpu_idle+0xaf/0xf2
[  232.284927]  [<ffffffff816aab3b>] ? start_kernel+0x3bd/0x3c8
[  232.285814]  [<ffffffff816aa140>] ? early_idt_handlers+0x140/0x140
[  232.286728]  [<ffffffff816aa3c4>] ? x86_64_start_kernel+0x104/0x111
[  232.287645] Code: 8b 43 20 48 85 c0 74 78 66 83 b8 c4 01 00 00 01 75 
6e 8b 8b c8 00 00 00 31 c0 48 c7 c6 2f 41 3e a0 48 03 8b d8 00 00 00 4c 
89 e7 <66> 44 8b 41 0c 48 8d 51 06 66 41 c1 c0 08 45 0f b7 c0 e8 cd 5e
[  232.505392] RIP  [<ffffffffa03e3330>] audit_tg+0xb9/0x15b [xt_AUDIT]
[  232.506338]  RSP <ffff88011fc03be0>
[  232.524441] CR2: ffff88021a2fc80b
[  232.534296] ---[ end trace 3c9efffc5c9e0cae ]---
[  232.535051] Kernel panic - not syncing: Fatal exception in interrupt
[  232.535973] Pid: 0, comm: swapper/0 Tainted: G      D    O 
3.2.0-4-amd64 #1 Debian 3.2.78-1
[  232.537158] Call Trace:
[  232.537543]  <IRQ>  [<ffffffff8134b6b7>] ? panic+0x95/0x1a2
[  232.538388]  [<ffffffff81352247>] ? _raw_spin_unlock_irqrestore+0xe/0xf
[  232.539358]  [<ffffffff8135310c>] ? oops_end+0xa9/0xb6
[  232.540123]  [<ffffffff8134afd6>] ? no_context+0x1ff/0x20e
[  232.540968]  [<ffffffff8134a8ed>] ? pud_offset+0x16/0x35
[  232.564725]  [<ffffffff81355109>] ? do_page_fault+0x1b6/0x345
[ 2232.604314]  [<ffffffff81089205>] ? audit_log_vformat+0xcb/0xda
[  232.914225]  [<ffffffff811b4025>] ? vsnprintf+0x3ee/0x427
[  233.014428]  [<ffffffff81089257>] ? audit_log_format+0x43/0x48
[  233.164204]  [<ffffffff81352815>] ? page_fault+0x25/0x30
[  233.374338]  [<ffffffffa03e3330>] ? audit_tg+0xb9/0x15b [xt_AUDIT]
[  233.405031]  [<ffffffffa035b0f4>] ? ipt_do_table+0x4d7/0x556 [ip_tablss]
[  233.924368]  [<ffffffff812f4470>] ? xfrm_lookup+0x3a1/0x43a
[  234.214539]  [<ffffffff810ec003>] ? virt_to_cache+0x7/0x23
[ 2234.274907]  [<ffffffff812b3a49>] ? nf_iterate+0x41/0x77
[  234.342667]  [<ffffffff812bc14a>] ? __skb_dequeue+0x31/0x31
[  234.495100]  [<ffffffff812b3ae7>] ? nf_hook_slow+0x68/0x101
[  234.535275]  [<ffffffff812bc14a>] ? __skb_dequeue+0x31/0x31
[  234.614601]  [<ffffffff812bd7cb>] ? nf_hook_thresh.constprop.31+0x39/0x3e
[  234.714592]  [<ffffffff812bd7ef>] ? __ip_local_out+0x1f/0x3

[ 2234.836013]  [<ffffffff812bd816>] ? ip_local_out+0x9/0x19
[ 2234.925049]  [<ffffffff812e2aa5>] ? igmp_ifc_timer_expire+0x1b2/0x1df
[  235.014937]  [<ffffffff810526cc>] ? run_timer_softirq+0x19a/0x261
[  235.083763]  [<ffffffff812e28f3>] ? add_grec+0x364/0x364
[  235.314747]  [<ffffffff8102b2d2>] ? kvm_clock_read+0x17/0x1a
[  235.380032]  [<ffffffff8104c4c0>] ? __do_softirq+0xd7/0x1af
[  235.495023]  [<ffffffff8106b417>] ? clockevents_program_event+0xaa/0xce
[ 2235.575418]  [<ffffffff813594ec>] ? call_softirq+0x1c/0x30
[  255.725267]  [<ffffffff8100faad>] ? do_softirq+0x3c/0x7b
[  235.914972]  [<ffffffff8104c742>] ? irq_exit+0x3c/0x99
[  235.995091]  [<ffffffff81024670>] ? smp_apic_timer_interrupt+0x74/0x82
[  236.035736]  [<ffffffff81357d5e>] ? apic_timer_interrupt+0x6e/0x80
[  236.104947]  <EOI>  [<ffffffff810149e7>] ? mwait_idle+0x7f/0xac
[  236.254760]  [<ffffffff810149da>] ? mwait_idle+0x72/0xac
[  236.358975]  [<ffffffff8100d24c>] ? cpu_idle+0xaf/0x22
[  236.463513]  [<ffffffff816aab3b>] ? start_kernel+0x3bd/0x3c8
[  236.515132]  [<ffffffff816aa140>] ? early_idt_handlers+0x140/0x140
[ 2236.536116]  [<ffffffff816aa3c4>] ? x86_64_start_kernel+0x104/0x111



On 26.04.2016 12:25, Lev Stipakov wrote:
> Hello,
>
> I see kernel panic with iptables-persistent package installed and one
> iptables rule with AUDIT target.
>
>    root@debian7:~# uname -a
>    Linux debian7 3.2.0-4-amd64 #1 SMP Debian 3.2.78-1 x86_64 GNU/Linux
>
>    root@debian7:~# dpkg -l | grep iptables
>    ii  iptables            1.4.14-3.1
>    ii  iptables-persistent    0.5.7+deb7u1
>
> Steps to reproduce:
>
> 1) Install Debian 7 and iptables-persistent (see versions above)
> 2) Add iptables rule (must be OUTPUT chain):
>
>    root@debian7:~# iptables -I OUTPUT -j AUDIT --type ACCEPT
>
> 3) Save rule:
>
>    root@debian7:~# iptables-save > /etc/iptables/rules.v4
>
> 4) Reboot
>
> 5) Kernel panic (screenshot):
> https://www.dropbox.com/s/db40e5kc10e4ddg/kernel_panic2.png?dl=0
>
> I cannot reproduce it on (one of) previous kernel version:
>
>    lev@debi7:~$ uname -a
>    Linux debi7 3.2.0-4-amd64 #1 SMP Debian 3.2.73-2+deb7u2 x86_64 GNU/Linux
>
>    lev@debi7:~$ dpkg -l | grep iptables
>    ii  iptables                           1.4.14-3.1
>    ii  iptables-persistent                0.5.7+deb7u1
>
> -Lev
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

