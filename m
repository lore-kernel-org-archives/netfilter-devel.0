From: 00bormoj@gmail.com
Subject: Re: Bug#631945: HFSC warning issue
Date: Mon, 11 Jul 2011 08:07:44 -0700
Message-ID: <CAAJ8s-RGocriAycZv4cjkKGd2mwGF1UH_-uyi+fbwdeUhvMk7g@mail.gmail.com>
References: <1310376412.8036.134.camel@luna.madrid.commsmundi.com>
	<4E1AE4F1.6030905@ziu.info>
	<4E1AE88F.803@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: fdelawarde@wirelessmundi.com, netfilter-devel@vger.kernel.org,
	kaber@trash.net
To: Michal Soltys <soltys@ziu.info>, 631945@bugs.debian.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42717 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757291Ab1GKPHo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jul 2011 11:07:44 -0400
Received: by iyb12 with SMTP id 12so3746812iyb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2011 08:07:44 -0700 (PDT)
In-Reply-To: <4E1AE88F.803@ziu.info>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Oops - my logs are again filled with the WARN_ON from
net/sched/sch_hfsc.c:1427. Sorry for the confusion, it looks like
"initialize parent's cl_cfmin properly in init_vf()" is not to blame.

This is an amd64 system. Vanilla kernel.org kernel except with fglrx
(the amd/ati radeon proprietary driver - yes it is a router and an
HTPC...) loaded. I should probably start bisecting then, but it's a
little tough when it can take more than two days to trigger :(

[1115475.034494] WARNING: at net/sched/sch_hfsc.c:1427
hfsc_dequeue+0x155/0x28c [sch_hfsc]()
[1115475.034497] Hardware name: TA780G M2+
[1115475.034498] Modules linked in: ifb act_police sch_ingress cls_u32
sch_sfq sch_hfsc joydev hid_apple hidp binfmt_misc rfcomm bnep
ipt_ULOG cryptd aes_x86_64 aes_generic lirc_serial(C) ipt_MASQUERADE
xt_NOTRACK xt_state xt_dscp xt_length xt_mark nf_conntrack_ipv6
nf_defrag_ipv6 xt_connmark xt_tcpudp ip6t_REJECT ipt_REJECT ip6t_LOG
ipt_LOG xt_limit nf_conntrack_ftp kvm_amd kvm ip6table_raw iptable_raw
iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4
ip6table_mangle sit tunnel4 iptable_mangle ip6table_filter nfsd
ip6_tables ipv6 nfs iptable_filter lockd ip_tables x_tables
auth_rpcgss nfs_acl sunrpc arc4 ecb saa7134_alsa snd_hda_codec_hdmi
snd_hda_codec_realtek fglrx(P) snd_hda_intel snd_hda_codec snd_hwdep
ir_lirc_codec lirc_dev snd_pcm_oss snd_mixer_oss snd_pcm
ir_sony_decoder tda827x snd_seq_dummy snd_seq_oss snd_seq_midi
ir_jvc_decoder rt61pci crc_itu_t snd_rawmidi tda8290 ir_rc6_decoder
snd_seq_midi_event tuner ir_rc5_decoder snd_seq saa7134 rt2x00pci
ir_nec_decoder snd_timer snd_seq_device rt2x00lib rc_core mac80211
videobuf_dma_sg videobuf_core xfs v4l2_common btusb snd bluetooth
videodev v4l2_compat_ioctl32 cfg80211 i2c_piix4 uinput soundcore
cpufreq_ondemand powernow_k8 freq_table edac_core mperf tveeprom evdev
i2c_core pl2303 k8temp edac_mce_amd ppdev usbserial eeprom_93cx6
snd_page_alloc rfkill usblp wmi parport_pc parport processor button
loop ext4 mbcache jbd2 crc16 usb_storage uas usbhid hid dm_mod sg
raid10 sd_mod crc_t10dif raid456 async_pq async_xor pata_acpi xor
async_memcpy async_raid6_recov raid6_pq async_tx raid1 raid0 multipath
linear md_mod btrfs lzo_compress ahci pata_atiixp zlib_deflate libahci
libata thermal thermal_sys hwmon scsi_mod r8169 crc32c mii ehci_hcd
ohci_hcd libcrc32c [last unloaded: ifb]
[1115475.034594] Pid: 3, comm: ksoftirqd/0 Tainted: P        WC  2.6.39.1 #1
[1115475.034596] Call Trace:
[1115475.034600]  [<ffffffff8103b785>] ? warn_slowpath_common+0x78/0x8c
[1115475.034604]  [<ffffffffa0371e1c>] ? hfsc_dequeue+0x155/0x28c [sch_hfsc]
[1115475.034607]  [<ffffffff81244dfa>] ? __qdisc_run+0x93/0x11a
[1115475.034610]  [<ffffffff8122c9bc>] ? net_tx_action+0x134/0x19d
[1115475.034613]  [<ffffffff81041403>] ? __do_softirq+0xff/0x1e0
[1115475.034617]  [<ffffffff81041588>] ? run_ksoftirqd+0xa4/0x18c
[1115475.034620]  [<ffffffff810414e4>] ? __do_softirq+0x1e0/0x1e0
[1115475.034623]  [<ffffffff810414e4>] ? __do_softirq+0x1e0/0x1e0
[1115475.034626]  [<ffffffff81055b04>] ? kthread+0x7a/0x82
[1115475.034630]  [<ffffffff812b4ad4>] ? kernel_thread_helper+0x4/0x10
[1115475.034633]  [<ffffffff81055a8a>] ? kthread_worker_fn+0x14d/0x14d
[1115475.034637]  [<ffffffff812b4ad0>] ? gs_change+0xb/0xb
