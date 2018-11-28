From: Sami Farin <hvtaifwkbgefbaei@gmail.com>
Subject: Re: 4.19.4 nf_conntrack_count kernel panic
Date: Wed, 28 Nov 2018 18:24:32 +0100
Message-ID: <20181128172432.dlpevb2ixvi4qypq@m.mifar.in>
References: <20181126194638.tpwagr7gqzvi3ogf@m.mifar.in>
 <2088ac5f7c2aaba6776db0f1f8528edf@nuclearcat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
To: Linux Networking Mailing List <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, netdev-owner@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2088ac5f7c2aaba6776db0f1f8528edf@nuclearcat.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Nov 26, 2018 at 22:14:48 +0200, Denys Fedoryshchenko wrote:
> On 2018-11-26 21:46, Sami Farin wrote:
> > 4.18.20 works OK, but unfortunately 4.18 series is EOL.
...
> Check this patches:
> https://patchwork.ozlabs.org/project/netfilter-devel/list/?series=73972&state=*
> 
> Relevant discussion:
> https://marc.info/?l=linux-netdev&m=154211826106430&w=2

I applied those three patches and 4.19.5 does not crash now the same
way.  BUT I got this when I ran iptables-restore (could not reproduce):

RIP: 0010:rb_erase+0xce/0x380
Code: 01 48 83 e0 fc 0f 84 cf 01 00 00 48 3b 78 10 0f 84 1d 02 00 00 48 89 48 08 c3 48 8b 17 48 89 d0 48 83 e0 fc 0f 84 d1 01 00 00 <48> 3b 78 10 0f 84 aa 01 00 00 4c 89 40 08 4d 85 c0 0f 85 c6 01 00
RSP: 0018:ffffbfc10c643cf8 EFLAGS: 00010282
RAX: b488144c79e96970 RBX: ffffa1bf63320e10 RCX: 0000000000000000
RDX: b488144c79e96970 RSI: ffffa1c224983010 RDI: ffffa1bf63320e10
RBP: ffffa1ba766fa210 R08: 0000000000000000 R09: ffffa1bea0368bd0
R10: 0000000000000000 R11: ffffa1c140038000 R12: ffffa1c224983010
R13: ffffa1c224983808 R14: ffffa1c224983000 R15: ffffa1bf63320e60
FS:  00007ff302a1b900(0000) GS:ffffa1c23e880000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000562e3b407000 CR3: 000000027666e000 CR4: 00000000003406e0
Call Trace:
nf_conncount_destroy+0x58/0xc0 [nf_conncount]
cleanup_match+0x45/0x70 [ip_tables]
cleanup_entry+0x3e/0xc0 [ip_tables]
do_ipt_set_ctl+0x450/0x4ed [ip_tables]
nf_setsockopt+0x44/0x70
__sys_setsockopt+0x82/0xe0
__x64_sys_setsockopt+0x20/0x30
do_syscall_64+0x6f/0x353
? trace_hardirqs_off_thunk+0x1a/0x1c
entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7ff301a1740a
Code: ff ff ff c3 48 8b 15 95 da 2b 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b1 0f 1f 80 00 00 00 00 49 89 ca b8 36 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 66 da 2b 00 f7 d8 64 89 01 48
RSP: 002b:00007ffd76e9e9a8 EFLAGS: 00000206 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000562e3b3bece8 RCX: 00007ff301a1740a
RDX: 0000000000000040 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 0000562e3b3f4850 R08: 0000000000013830 R09: 0000000000000000
R10: 0000562e3b3f4850 R11: 0000000000000206 R12: 0000562e3b3f48b0
R13: 0000562e3b3bece8 R14: 00000000000137d0 R15: 0000562e3b3bece0
Modules linked in: act_skbedit cls_u32 algif_hash sch_cake arptable_filter arp_tables cls_fw sch_fq nfnetlink_acct ip6table_mangle nf_log_ipv6 xt_hl ip6t_REJECT nf_reject_ipv6 ip6t_rt ip6table_filter ip6_tables ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat iptable_raw xt_mark xt_connmark iptable_mangle nf_log_ipv4 nf_log_common xt_LOG xt_length xt_limit ipt_REJECT nf_reject_ipv4 xt_connlimit nf_conncount xt_multiport xt_hashlimit xt_owner xt_set xt_conntrack iptable_filter nf_conntrack_netlink ip_set_bitmap_port ip_set_hash_mac ip_set_hash_net ip_set nfnetlink bnep hwmon_vid iwlmvm mac80211 snd_usb_audio kvm_amd snd_usbmidi_lib snd_hwdep snd_rawmidi kvm btusb btrtl iwlwifi btbcm btintel bluetooth irqbypass ecdh_generic cfg80211 wmi_bmof sp5100_tco k10temp i2c_piix4 snd_hda_codec_realtek
snd_hda_codec_generic rfkill snd_hda_codec_hdmi snd_hda_intel snd_hda_codec snd_hda_core rtc_cmos acpi_cpufreq binfmt_misc snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device snd_pcm tcp_cubic tcp_westwood br_netfilter bridge stp llc ip_tables scsi_transport_iscsi algif_skcipher af_alg uas usb_storage usbhid mxm_wmi ccp igb xhci_pci xhci_hcd usbcore usb_common wmi button 8021q mrp sunrpc snd_timer snd soundcore fuse tun xt_tcpudp x_tables tcp_bbr nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 sch_fq_codel sch_htb sch_pie analog gameport joydev i2c_dev ecryptfs autofs4 amdkfd amd_iommu_v2 [last unloaded: pcspkr]
---[ end trace 166aeb108d0289e0 ]---
RIP: 0010:rb_erase+0xce/0x380
Code: 01 48 83 e0 fc 0f 84 cf 01 00 00 48 3b 78 10 0f 84 1d 02 00 00 48 89 48 08 c3 48 8b 17 48 89 d0 48 83 e0 fc 0f 84 d1 01 00 00 <48> 3b 78 10 0f 84 aa 01 00 00 4c 89 40 08 4d 85 c0 0f 85 c6 01 00
RSP: 0018:ffffbfc10c643cf8 EFLAGS: 00010282
RAX: b488144c79e96970 RBX: ffffa1bf63320e10 RCX: 0000000000000000
RDX: b488144c79e96970 RSI: ffffa1c224983010 RDI: ffffa1bf63320e10
RBP: ffffa1ba766fa210 R08: 0000000000000000 R09: ffffa1bea0368bd0
R10: 0000000000000000 R11: ffffa1c140038000 R12: ffffa1c224983010
R13: ffffa1c224983808 R14: ffffa1c224983000 R15: ffffa1bf63320e60
FS:  00007ff302a1b900(0000) GS:ffffa1c23e880000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000562e3b407000 CR3: 000000027666e000 CR4: 00000000003406e0

-- 
Do what you love because life is too short for anything else.
https://samifar.in/
