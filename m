Return-Path: <SRS0=Xgm7=SK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C9B2C10F14
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Apr 2019 13:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3FBD21473
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Apr 2019 13:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfDHNd7 convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 09:33:59 -0400
Received: from mxin.vub.ac.be ([134.184.129.114]:28088 "EHLO mxin.vub.ac.be"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbfDHNd7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 09:33:59 -0400
X-Greylist: delayed 654 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Apr 2019 09:33:56 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2G4AgDlSqtc/wEauIZlHAEBAQQBAQc?=
 =?us-ascii?q?EAQGBZYFigWggEieEDoh7pw0BO4pKOBIBAQMBAQkBAQEBAgICaSiFdYELAiY?=
 =?us-ascii?q?CXwEShRitX4EviDAhgVOBCyWLXoFAP4Rhg30Gg0uCVwORX5QnCZQdi0aJFi2?=
 =?us-ascii?q?LJpVVNyKBVjMaCBgYgyeCFhcUjg09AQExgQImE48yAQE?=
X-IPAS-Result: =?us-ascii?q?A2G4AgDlSqtc/wEauIZlHAEBAQQBAQcEAQGBZYFigWggE?=
 =?us-ascii?q?ieEDoh7pw0BO4pKOBIBAQMBAQkBAQEBAgICaSiFdYELAiYCXwEShRitX4Evi?=
 =?us-ascii?q?DAhgVOBCyWLXoFAP4Rhg30Gg0uCVwORX5QnCZQdi0aJFi2LJpVVNyKBVjMaC?=
 =?us-ascii?q?BgYgyeCFhcUjg09AQExgQImE48yAQE?=
Received: from ai01.vub.ac.be (HELO ai.vub.ac.be) ([134.184.26.1])
  by smtp.vub.ac.be with ESMTP; 08 Apr 2019 15:22:50 +0200
Received: from localhost (localhost [127.0.0.1])
        by ai.vub.ac.be (Postfix) with ESMTP id 3FEC9100DAD;
        Mon,  8 Apr 2019 15:22:50 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at ai.vub.ac.be
Received: from ai.vub.ac.be ([127.0.0.1])
        by localhost (ai.vub.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with LMTP id IEdIN4b8JkvW; Mon,  8 Apr 2019 15:22:49 +0200 (CEST)
Received: from elitebook (ai86.vub.ac.be [134.184.26.86])
        by ai.vub.ac.be (Postfix) with ESMTPSA id D620C100DA0;
        Mon,  8 Apr 2019 15:22:49 +0200 (CEST)
Message-ID: <306bc8c0e81422a73ccfcd0ac3ea2d79fc1df0b0.camel@ai.vub.ac.be>
Subject: 5.0.7: WARNING: CPU: 1 PID: 169 at net/netfilter/nft_compat.c:82
 and genreal protection fault
From:   Frederik Himpe <fhimpe@ai.vub.ac.be>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Date:   Mon, 08 Apr 2019 15:22:49 +0200
Organization: Vrije Universiteit Brussel
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I'm experiencing this reproducible bug every time shorewall6 is
restarted:


[   28.932323] WARNING: CPU: 1 PID: 169 at net/netfilter/nft_compat.c:82 nft_xt_put.part.9+0x21/0x30 [nft_compat]
[   28.932325] Modules linked in: ip6t_REJECT(E) nf_reject_ipv6(E) nft_chain_nat_ipv6(E) nf_nat_ipv6(E) nft_chain_route_ipv6(E) xt_multiport(E) nf_log_ipv6(E) xt_recent(E) xt_comment(E) xt_hashlimit(E) xt_addrtype(E) xt_mark(E) xt_CT(E) nfnetlink_log(E) xt_NFLOG(E) nf_log_ipv4(E) nf_log_common(E) xt_LOG(E) nf_nat_tftp(E) nf_nat_snmp_basic(E) nf_conntrack_snmp(E) nf_nat_sip(E) nf_nat_pptp(E) nf_nat_irc(E) nf_nat_h323(E) nf_nat_ftp(E) nf_nat_amanda(E) ts_kmp(E) nf_conntrack_amanda(E) nf_conntrack_sane(E) nf_conntrack_tftp(E) nf_conntrack_sip(E) nf_conntrack_pptp(E) nf_conntrack_proto_gre(E) nf_conntrack_netlink(E) nf_conntrack_netbios_ns(E) nf_conntrack_broadcast(E) nf_conntrack_irc(E) nf_conntrack_h323(E) nf_conntrack_ftp(E) nft_chain_route_ipv4(E) xt_CHECKSUM(E) nft_chain_nat_ipv4(E) ipt_MASQUERADE(E) nf_nat_ipv4(E) nf_nat(E) xt_conntrack(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) ipt_REJECT(E) nf_reject_ipv4(E) nft_counter(E) xt_tcpudp(E) nft_compat(E) tun(E) bridge(E) s
 tp(E)
[   28.932357]  llc(E) devlink(E) nf_tables(E) nfnetlink(E) msr(E) cmac(E) cpufreq_userspace(E) cpufreq_powersave(E) cpufreq_conservative(E) bnep(E) binfmt_misc(E) nls_ascii(E) nls_cp437(E) vfat(E) fat(E) ext4(E) mbcache(E) jbd2(E) fscrypto(E) intel_rapl(E) x86_pkg_temp_thermal(E) intel_powerclamp(E) kvm_intel(E) kvm(E) irqbypass(E) crct10dif_pclmul(E) crc32_pclmul(E) efi_pstore(E) ghash_clmulni_intel(E) btusb(E) mei_wdt(E) btrtl(E) btbcm(E) btintel(E) bluetooth(E) arc4(E) aesni_intel(E) snd_hda_codec_hdmi(E) drbg(E) iwldvm(E) aes_x86_64(E) ansi_cprng(E) crypto_simd(E) ecdh_generic(E) cryptd(E) glue_helper(E) crc16(E) snd_hda_codec_idt(E) mac80211(E) hp_wmi(E) snd_hda_codec_generic(E) sparse_keymap(E) joydev(E) ledtrig_audio(E) snd_hda_intel(E) iwlwifi(E) snd_hda_codec(E) intel_cstate(E) wmi_bmof(E) uvcvideo(E) intel_uncore(E) sg(E) serio_raw(E) intel_rapl_perf(E) snd_hda_core(E) videobuf2_vmalloc(E) tpm_infineon(E) videobuf2_memops(E) videobuf2_v4l2(E) videobuf2_common(E) snd_hwdep(
 E)
[   28.932408]  videodev(E) media(E) snd_pcm(E) efivars(E) snd_timer(E) iTCO_wdt(E) cfg80211(E) iTCO_vendor_support(E) rfkill(E) snd(E) tpm_tis(E) tpm_tis_core(E) soundcore(E) tpm(E) mei_me(E) mei(E) rng_core(E) evdev(E) hp_accel(E) lis3lv02d(E) input_polldev(E) pcc_cpufreq(E) hp_wireless(E) battery(E) ac(E) coretemp(E) loop(E) parport_pc(E) ppdev(E) lp(E) parport(E) bfq(E) efivarfs(E) ip_tables(E) x_tables(E) autofs4(E) btrfs(E) xor(E) zstd_decompress(E) zstd_compress(E) raid6_pq(E) libcrc32c(E) crc32c_generic(E) dm_mod(E) sr_mod(E) cdrom(E) sd_mod(E) hid_generic(E) usbhid(E) hid(E) sdhci_pci(E) cqhci(E) i915(E) ahci(E) i2c_algo_bit(E) libahci(E) sdhci(E) drm_kms_helper(E) crc32c_intel(E) mmc_core(E) xhci_pci(E) libata(E) ehci_pci(E) xhci_hcd(E) ehci_hcd(E) scsi_mod(E) psmouse(E) lpc_ich(E) firewire_ohci(E) firewire_core(E) crc_itu_t(E) e1000e(E) drm(E) usbcore(E) thermal(E) wmi(E) video(E) button(E)
[   28.932469] CPU: 1 PID: 169 Comm: kworker/1:2 Tainted: G            E     5.0.7 #1
[   28.932471] Hardware name: Hewlett-Packard HP EliteBook 8470p/179B, BIOS 68ICF Ver. F.31 09/24/2012
[   28.932481] Workqueue: events nf_tables_trans_destroy_work [nf_tables]
[   28.932486] RIP: 0010:nft_xt_put.part.9+0x21/0x30 [nft_compat]
[   28.932489] Code: ff ff ff f3 c3 0f 1f 40 00 0f 1f 44 00 00 48 8b 07 48 39 c7 75 14 48 83 ef 80 be 80 00 00 00 e8 f5 54 14 f6 b8 01 00 00 00 c3 <0f> 0b eb e8 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 53
[   28.932491] RSP: 0018:ffffb119411a3db8 EFLAGS: 00010206
[   28.932493] RAX: ffff9a33fe12b300 RBX: ffff9a33fe12b600 RCX: 0000000000000000
[   28.932495] RDX: 0000000000000000 RSI: ffff9a33fe12b678 RDI: ffff9a33fe12b600
[   28.932497] RBP: ffffffffc10e3400 R08: ffffffffc10e3180 R09: ffffffffc1288800
[   28.932498] R10: 0000000000000001 R11: 0000000000000001 R12: ffff9a34081d9e40
[   28.932500] R13: dead000000000200 R14: dead000000000100 R15: ffffffffc12a5088
[   28.932503] FS:  0000000000000000(0000) GS:ffff9a3436840000(0000) knlGS:0000000000000000
[   28.932505] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   28.932506] CR2: 0000557e2fdb5000 CR3: 00000001f6e5e002 CR4: 00000000001606e0
[   28.932508] Call Trace:
[   28.932516]  __nft_match_destroy.isra.10+0x69/0xa0 [nft_compat]
[   28.932526]  nf_tables_expr_destroy+0x1a/0x40 [nf_tables]
[   28.932533]  nf_tables_rule_destroy+0x4f/0x80 [nf_tables]
[   28.932541]  nf_tables_trans_destroy_work+0x1dd/0x200 [nf_tables]
[   28.932548]  process_one_work+0x191/0x380
[   28.932553]  worker_thread+0x204/0x3b0
[   28.932557]  ? rescuer_thread+0x340/0x340
[   28.932560]  kthread+0xf8/0x130
[   28.932563]  ? kthread_create_worker_on_cpu+0x70/0x70
[   28.932569]  ret_from_fork+0x35/0x40
[   28.932573] ---[ end trace fc35add4fa3b2bde ]---
[   29.015565] general protection fault: 0000 [#1] SMP PTI
[   29.015574] CPU: 3 PID: 2069 Comm: ip6tables-resto Tainted: G        W   E     5.0.7 #1
[   29.015577] Hardware name: Hewlett-Packard HP EliteBook 8470p/179B, BIOS 68ICF Ver. F.31 09/24/2012
[   29.015586] RIP: 0010:strcmp+0x4/0x20
[   29.015590] Code: 74 1a 49 39 d0 48 89 d0 75 e9 48 85 d2 74 05 c6 44 17 ff 00 48 c7 c0 f9 ff ff ff c3 f3 c3 f3 c3 66 0f 1f 44 00 00 48 83 c7 01 <0f> b6 47 ff 48 83 c6 01 3a 46 ff 75 07 84 c0 75 eb 31 c0 c3 19 c0
[   29.015593] RSP: 0018:ffffb119428e78e0 EFLAGS: 00010282
[   29.015597] RAX: 00000000ffffffff RBX: ffffb11941401264 RCX: 000000000000000b
[   29.015600] RDX: ffff9a33fe12b600 RSI: ffffb11941401264 RDI: 894810247c8d4849
[   29.015602] RBP: ffff9a340486c510 R08: 0000000000000003 R09: ffff9a33f6d58128
[   29.015605] R10: ffffb119428e7930 R11: 0000000000000002 R12: 0000000000000000
[   29.015607] R13: ffffffffc1294e70 R14: ffff9a340486c500 R15: 894810247c8d4838
[   29.015611] FS:  00007f26d10ba740(0000) GS:ffff9a34368c0000(0000) knlGS:0000000000000000
[   29.015614] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   29.015617] CR2: 00007f26d118a6d0 CR3: 00000001fd760003 CR4: 00000000001606e0
[   29.015619] Call Trace:
[   29.015631]  nft_match_select_ops+0x92/0x210 [nft_compat]
[   29.015646]  nf_tables_expr_parse+0x13e/0x1e0 [nf_tables]
[   29.015653]  ? kvmalloc_node+0x43/0x70
[   29.015663]  nf_tables_newrule+0x247/0x8b0 [nf_tables]
[   29.015671]  nfnetlink_rcv_batch+0x499/0x720 [nfnetlink]
[   29.015679]  ? skb_queue_tail+0x1b/0x50
[   29.015685]  ? _cond_resched+0x16/0x40
[   29.015691]  ? kmem_cache_alloc_node_trace+0x1c1/0x1f0
[   29.015695]  ? __insert_vmap_area+0x99/0x100
[   29.015702]  ? refcount_inc_checked+0x5/0x30
[   29.015707]  ? apparmor_capable+0x70/0xb0
[   29.015713]  ? __nla_parse+0x34/0x150
[   29.015719]  nfnetlink_rcv+0x113/0x136 [nfnetlink]
[   29.015725]  netlink_unicast+0x1b9/0x240
[   29.015731]  netlink_sendmsg+0x2d0/0x3c0
[   29.015735]  sock_sendmsg+0x36/0x40
[   29.015739]  ___sys_sendmsg+0x2e9/0x300
[   29.015744]  ? page_add_file_rmap+0x13/0x1f0
[   29.015750]  ? filemap_map_pages+0x183/0x380
[   29.015756]  ? __handle_mm_fault+0xb89/0x1200
[   29.015760]  ? refcount_inc_checked+0x5/0x30
[   29.015764]  ? apparmor_capable+0x70/0xb0
[   29.015768]  ? security_capable+0x35/0x50
[   29.015772]  ? release_sock+0x19/0x90
[   29.015776]  ? __sys_sendmsg+0x63/0xa0
[   29.015780]  __sys_sendmsg+0x63/0xa0
[   29.015787]  do_syscall_64+0x55/0xf0
[   29.015792]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   29.015797] RIP: 0033:0x7f26d11bcc74
[   29.015800] Code: 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b5 0f 1f 80 00 00 00 00 48 8d 05 89 5a 0c 00 8b 00 85 c0 75 13 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 54 c3 0f 1f 00 41 54 41 89 d4 55 48 89 f5 53
[   29.015803] RSP: 002b:00007ffd02e15868 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[   29.015807] RAX: ffffffffffffffda RBX: 00007ffd02e15880 RCX: 00007f26d11bcc74
[   29.015809] RDX: 0000000000000000 RSI: 00007ffd02e16900 RDI: 0000000000000003
[   29.015812] RBP: 00007ffd02e16f80 R08: 0000000000000004 R09: 0000000000000000
[   29.015814] R10: 00007ffd02e168ec R11: 0000000000000246 R12: 0000564c33d862a0
[   29.015816] R13: 00007ffd02e19850 R14: 00007ffd02e15870 R15: 00007ffd02e19888
[   29.015820] Modules linked in: ip6t_REJECT(E) nf_reject_ipv6(E) nft_chain_nat_ipv6(E) nf_nat_ipv6(E) nft_chain_route_ipv6(E) xt_multiport(E) nf_log_ipv6(E) xt_recent(E) xt_comment(E) xt_hashlimit(E) xt_addrtype(E) xt_mark(E) xt_CT(E) nfnetlink_log(E) xt_NFLOG(E) nf_log_ipv4(E) nf_log_common(E) xt_LOG(E) nf_nat_tftp(E) nf_nat_snmp_basic(E) nf_conntrack_snmp(E) nf_nat_sip(E) nf_nat_pptp(E) nf_nat_irc(E) nf_nat_h323(E) nf_nat_ftp(E) nf_nat_amanda(E) ts_kmp(E) nf_conntrack_amanda(E) nf_conntrack_sane(E) nf_conntrack_tftp(E) nf_conntrack_sip(E) nf_conntrack_pptp(E) nf_conntrack_proto_gre(E) nf_conntrack_netlink(E) nf_conntrack_netbios_ns(E) nf_conntrack_broadcast(E) nf_conntrack_irc(E) nf_conntrack_h323(E) nf_conntrack_ftp(E) nft_chain_route_ipv4(E) xt_CHECKSUM(E) nft_chain_nat_ipv4(E) ipt_MASQUERADE(E) nf_nat_ipv4(E) nf_nat(E) xt_conntrack(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) ipt_REJECT(E) nf_reject_ipv4(E) nft_counter(E) xt_tcpudp(E) nft_compat(E) tun(E) bridge(E) s
 tp(E)
[   29.015861]  llc(E) devlink(E) nf_tables(E) nfnetlink(E) msr(E) cmac(E) cpufreq_userspace(E) cpufreq_powersave(E) cpufreq_conservative(E) bnep(E) binfmt_misc(E) nls_ascii(E) nls_cp437(E) vfat(E) fat(E) ext4(E) mbcache(E) jbd2(E) fscrypto(E) intel_rapl(E) x86_pkg_temp_thermal(E) intel_powerclamp(E) kvm_intel(E) kvm(E) irqbypass(E) crct10dif_pclmul(E) crc32_pclmul(E) efi_pstore(E) ghash_clmulni_intel(E) btusb(E) mei_wdt(E) btrtl(E) btbcm(E) btintel(E) bluetooth(E) arc4(E) aesni_intel(E) snd_hda_codec_hdmi(E) drbg(E) iwldvm(E) aes_x86_64(E) ansi_cprng(E) crypto_simd(E) ecdh_generic(E) cryptd(E) glue_helper(E) crc16(E) snd_hda_codec_idt(E) mac80211(E) hp_wmi(E) snd_hda_codec_generic(E) sparse_keymap(E) joydev(E) ledtrig_audio(E) snd_hda_intel(E) iwlwifi(E) snd_hda_codec(E) intel_cstate(E) wmi_bmof(E) uvcvideo(E) intel_uncore(E) sg(E) serio_raw(E) intel_rapl_perf(E) snd_hda_core(E) videobuf2_vmalloc(E) tpm_infineon(E) videobuf2_memops(E) videobuf2_v4l2(E) videobuf2_common(E) snd_hwdep(
 E)
[   29.015913]  videodev(E) media(E) snd_pcm(E) efivars(E) snd_timer(E) iTCO_wdt(E) cfg80211(E) iTCO_vendor_support(E) rfkill(E) snd(E) tpm_tis(E) tpm_tis_core(E) soundcore(E) tpm(E) mei_me(E) mei(E) rng_core(E) evdev(E) hp_accel(E) lis3lv02d(E) input_polldev(E) pcc_cpufreq(E) hp_wireless(E) battery(E) ac(E) coretemp(E) loop(E) parport_pc(E) ppdev(E) lp(E) parport(E) bfq(E) efivarfs(E) ip_tables(E) x_tables(E) autofs4(E) btrfs(E) xor(E) zstd_decompress(E) zstd_compress(E) raid6_pq(E) libcrc32c(E) crc32c_generic(E) dm_mod(E) sr_mod(E) cdrom(E) sd_mod(E) hid_generic(E) usbhid(E) hid(E) sdhci_pci(E) cqhci(E) i915(E) ahci(E) i2c_algo_bit(E) libahci(E) sdhci(E) drm_kms_helper(E) crc32c_intel(E) mmc_core(E) xhci_pci(E) libata(E) ehci_pci(E) xhci_hcd(E) ehci_hcd(E) scsi_mod(E) psmouse(E) lpc_ich(E) firewire_ohci(E) firewire_core(E) crc_itu_t(E) e1000e(E) drm(E) usbcore(E) thermal(E) wmi(E) video(E) button(E)
[   29.015977] ---[ end trace fc35add4fa3b2bdf ]---
[   29.613482] RIP: 0010:strcmp+0x4/0x20
[   29.613486] Code: 74 1a 49 39 d0 48 89 d0 75 e9 48 85 d2 74 05 c6 44 17 ff 00 48 c7 c0 f9 ff ff ff c3 f3 c3 f3 c3 66 0f 1f 44 00 00 48 83 c7 01 <0f> b6 47 ff 48 83 c6 01 3a 46 ff 75 07 84 c0 75 eb 31 c0 c3 19 c0
[   29.613488] RSP: 0018:ffffb119428e78e0 EFLAGS: 00010282
[   29.613490] RAX: 00000000ffffffff RBX: ffffb11941401264 RCX: 000000000000000b
[   29.613492] RDX: ffff9a33fe12b600 RSI: ffffb11941401264 RDI: 894810247c8d4849
[   29.613493] RBP: ffff9a340486c510 R08: 0000000000000003 R09: ffff9a33f6d58128
[   29.613494] R10: ffffb119428e7930 R11: 0000000000000002 R12: 0000000000000000
[   29.613495] R13: ffffffffc1294e70 R14: ffff9a340486c500 R15: 894810247c8d4838
[   29.613497] FS:  00007f26d10ba740(0000) GS:ffff9a34368c0000(0000) knlGS:0000000000000000
[   29.613499] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   29.613500] CR2: 00007f26d118a6d0 CR3: 00000001fd760003 CR4: 00000000001606e0

The shorewall6 process hangs, and the system fails to shut down completely afterwards.

-- 
Frederik Himpe <fhimpe@ai.vub.ac.be>

