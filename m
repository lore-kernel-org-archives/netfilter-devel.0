From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: [OOPS PATCH 0/1] netfilter/sip: fix OOPS in flush_expectations()
Date: Fri, 11 Oct 2013 16:02:04 +0200
Message-ID: <20131011140204.916097373@eitzenberger.org>
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:60717 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757496Ab3JKOEn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Oct 2013 10:04:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

I have two reports about oopses happened when using the Netfilter SIP
helper.  Both systems make heavy use of it.

The reports occured both with kernel 3.3.y and kernel 3.8.y.

This is the initial report I got:

  [ 2886.953175] BUG: unable to handle kernel paging request at 00100100
  [ 2886.956435] IP: [<f88a4ab8>] flush_expectations+0x68/0x85 [nf_conntrack_sip]
  [ 2886.956435] *pde = 00000000
  [ 2886.956435] Oops: 0000 [001] SMP
  [ 2886.956435] Modules linked in: cryptd aes_i586 aes_generic cbc sha1_generic
  hmac authenc xt_dscp xt_nat ip_set_hash_net sr_mod cdrom xt_limit xt_length2(O)
  xt_hashlimit xt_CLASSIFY xt_helper xt_TPROXY nf_tproxy_core xt_socket xt_NFQUEUE
  ipt_REDIRECT ipt_MASQUERADE xt_policy xt_mark xt_psd(O) xt_addrtype xt_connmark
  xt_tcpudp xt_multiport xt_set nf_nat_sip nf_conntrack_sip ip_set_hash_ip
  nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_ftp nf_conntrack_pptp
  nf_conntrack_proto_gre nf_conntrack_irc nf_conntrack_ftp nfnetlink_queue
  sch_prio sch_hfsc sch_sfq sch_red sch_tbf act_mirred cls_u32 sch_ingress ifb tun
  af_packet ebt_arp ebtable_filter ebtables bridge stp llc ip6table_ips
  ip6table_mangle ip6table_nat nf_nat_ipv6 iptable_ips iptable_mangle iptable_nat
  nf_nat_ipv4 nf_nat xt_NFLOG xt_condition(O) xt_logmark xt_confirmed xt_owner
  xt_conntrack ip6t_REJECT ipt_REJECT ip_set nfnetlink_log mperf microcode
  nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6table_raw nf_conntrack_ipv4
  nf_defrag_ipv4 xt_state iptable_filter xt_NOTRACK iptable_raw
  nf_conntrack_netlink nfnetlink nf_conntrack ip6_tables ip_tables x_tables ipv6
  red loop ppdev parport_pc parport e1000 i2c_i801 evdev e100 mii sg rng_core
  pcspkr rtc_cmos button uhci_hcd sd_mod ehci_hcd fan thermal processor
  thermal_sys hwmon pata_acpi ata_generic ata_piix libata scsi_mod edd
  [ 2886.956435]
  [ 2886.956435] Pid: 5606, comm: red_server.plc Tainted: G O
  3.3.8-79.g20f5c30-smp 001 Astaro AG ASG/i845GV-W83627HF
  [ 2886.956435] EIP: 0060:[<f88a4ab8>] EFLAGS: 00210246 CPU: 0
  [ 2886.956435] EIP is at flush_expectations+0x68/0x85 [nf_conntrack_sip]
  [ 2886.956435] EAX: 00000000 EBX: 00100100 ECX: 00000000 EDX: effdc0a0
  [ 2886.956435] ESI: 00100100 EDI: 00000001 EBP: 00000001 ESP: f5c0bd54
  [ 2886.956435] DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
  [ 2886.956435] Process red_server.plc (pid: 5606, ti=f5c0a000 task=f5da2a20
  task.ti=efc62000)
  [ 2886.956435] Stack:
  [ 2886.956435] f490b948 00000001 00000197 f45f4f00 f88a5918 f5c0bde0 f5c0bddc
  0000001c
  [ 2886.956435] 00000014 f88a72a8 0000015d f5c0bddc 00000001 f88a472e f5c0bddc
  f5c0bde0
  [ 2886.956435] 00000001 00000197 00000014 f490b948 f45f4f00 f88a72a8 00000197
  00000001
  [ 2886.956435] Call Trace:
  [ 2886.956435] [<f88a5918>] ? process_invite_response+0x91/0x9e
  [nf_conntrack_sip]
  [ 2886.956435] [<f88a472e>] ? process_sip_msg+0x1dc/0x23f [nf_conntrack_sip]
  [ 2886.956435] [<f88a4a3d>] ? sip_help_udp+0x90/0xa3 [nf_conntrack_sip]
  [ 2886.956435] [<f84738a1>] ? ipv4_confirm+0x87/0x177 [nf_conntrack_ipv4]
  [ 2886.956435] [<f86ee268>] ? nf_nat_ipv4_out+0x42/0xd1 [iptable_nat]
  [ 2886.956435] [<c11f93c8>] ? nf_iterate+0x38/0x5f
  [ 2886.956435] [<c120365a>] ? ip_finish_output2+0x202/0x202
  [ 2886.956435] [<c11f9685>] ? nf_hook_slow+0x1fa/0x290
  [ 2886.956435] [<c120365a>] ? ip_finish_output2+0x202/0x202
  [ 2886.956435] [<c11ffe38>] ? ip_check_defrag+0x110/0x110
  [ 2886.956435] [<c120365a>] ? ip_finish_output2+0x202/0x202
  [ 2886.956435] [<c12029ab>] ? NF_HOOK_COND+0x46/0x56
  [ 2886.956435] [<c120365a>] ? ip_finish_output2+0x202/0x202
  ...

The other system is 64 bit.

The disassembly shows that the actual bug happens in the helpers
flush_expectations() while traversing the helper->expectations linked
list.  From the disassembly I also see that the actual loop cursor
('pos' in hlist_for_each_entry_safe()) contains the value LIST_POISON1
(0x00100100 in %ebx) in the trace.

And when checking hlist_for_each_entry_safe() I see that the loop
cursor ('pos' in the macro) checks for NULL-ness instead.

But in nf_ct_unlink_expect_report() I see that hlist_del() is used on
exp->lnode, which explicitely sets exp->lnode.next to LIST_POISON1
after removing it from the list.

Not sure though why this occurs so rarely, as the expectations are
removed e. g. by timeout quite often.

My proposed fix is therefore to change nf_ct_unlink_expect_report()
so that it uses __hlist_del() instead, so that the loop cursor in
hlist_for_each_entry_safe() terminates correctly at the end of the
list.

Patch is reported to have fixed the issue at the customers site.

Please check.

 /Holger

