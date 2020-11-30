Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B39C63777
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Nov 2020 19:39:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23FA020709
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Nov 2020 19:39:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NamcBjUm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729951AbgK3Tj1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Nov 2020 14:39:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729949AbgK3Tj1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Nov 2020 14:39:27 -0500
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB09C0613CF
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Nov 2020 11:38:47 -0800 (PST)
Received: by mail-qv1-xf2c.google.com with SMTP id q7so6170736qvt.12
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Nov 2020 11:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :to;
        bh=z6AnD2hu/34vYkl2OtaAr6e3Salsbzh5qLmnRaMGwqU=;
        b=NamcBjUmgRPbmhWoz1uT6sYRp3JVOf8xHo1FEPryDQ8D5bzhZZWhy4Em3nDLbRS707
         aXlWDDJChPQl6ixk8AEruH1GtSd+bph8IxXByGg/tSrkZMwmOqIrSZek+NUE+hwunJ4B
         u0se+4mc/Br+gI9NU+fywFWqrA0DXeU3BmqWz4n5oBmHTnyavt07XTVw+SeR0ETbHx/R
         pxZlVcFUtSsiRjkrI/GOJKdGy7zW3fFh5WeKwZ1mTc/RRhUuFdDvzBT/KKtq5pHZC3Q2
         VQfY04KqXegjiMLfBpHSoVvut0wlb05QuXAc4w3flytQqHAtVBNbBvx9RxmkXwzroiLR
         vgJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:to;
        bh=z6AnD2hu/34vYkl2OtaAr6e3Salsbzh5qLmnRaMGwqU=;
        b=HVqHwdJzgFB5SZzVnJp1GnZOpPytoNY5ZJqCtVJdD9GGMoOyV1Zv68Ld7fUz7GiwwZ
         51g8uUT4zZ8mbOeMeiXpTTZcGLsc9Cv/laf2555pxf9vi3j2GzZ+7oMYyLwrmaVA93PM
         FUuJRoHs63JnpjX7w3GM+TqukqPaIdKExTBeEO3Rs5YnBj//spRRw6+nG18E0DzSTLOa
         K4brKRrpFneTqWaApxNVQZS5b9kzZ1Anx/vgooWR7SxFVPcIv969ostStkw0UmQZwxj3
         PedNOQ8s2X3/d1HVqviWCu62niews/ZMuQgbqqHWfDhjil5St3/tki75MmHJ0ILHazAw
         xI5A==
X-Gm-Message-State: AOAM530JIQ/dsqhhJFQJ8fPRzLpH+sG+/vJGxjjxu+3Eq35/iOJUX93B
        6gARzPbASOxkGBsV0imBhJmYFkJiixQ=
X-Google-Smtp-Source: ABdhPJxvg5cJD0L3Ng+DhcPbWyc4dPPRZI1dZLd+BxhvEkiSIshUVThy7t72d8QGMiqt5d0bCVzQCw==
X-Received: by 2002:a0c:b3d6:: with SMTP id b22mr23897464qvf.10.1606765125903;
        Mon, 30 Nov 2020 11:38:45 -0800 (PST)
Received: from [10.254.248.143] ([159.89.225.236])
        by smtp.gmail.com with ESMTPSA id w192sm17176751qka.68.2020.11.30.11.38.44
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Nov 2020 11:38:45 -0800 (PST)
From:   Yuri Lipnesh <yuri.lipnesh@gmail.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.20.0.2.21\))
Subject: System crash on Ubuntu 18, in netlink code when using iptables /
 netfilter
Message-Id: <B37EABB8-355F-4A05-9BF3-1119D1E0470D@gmail.com>
Date:   Mon, 30 Nov 2020 14:38:42 -0500
To:     netfilter-devel@vger.kernel.org
X-Mailer: Apple Mail (2.3654.20.0.2.21)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Linux system crashed

[    0.000000] Linux version 5.4.0-54-generic (buildd@lcy01-amd64-008) =
(gcc version 7.5.0 (Ubuntu 7.5.0-3ubuntu1~18.04)) #60~18.04.1-Ubuntu SMP =
Fri Nov 6 17:25:16 UTC 2020 (Ubuntu 5.4.0-54.60~18.04.1-generic 5.4.65)
[    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-5.4.0-54-generic =
root=3DUUID=3D11885fd3-b840-4c9b-a500-532c73ac952a ro =
find_preseed=3D/preseed.cfg auto noprompt priority=3Dcritical =
locale=3Den_US quiet crashkernel=3D512M-:192M

=E2=80=A6
[  156.321147] TCP: eth0: Driver has suspect GRO implementation, TCP =
performance may be compromised.
[  177.519159] general protection fault: 0000 [#1] SMP PTI
[  177.519737] CPU: 5 PID: 18484 Comm: worker-1 Kdump: loaded Not =
tainted 5.4.0-54-generic #60~18.04.1-Ubuntu
[  177.519742] Hardware name: VMware, Inc. VMware Virtual Platform/440BX =
Desktop Reference Platform, BIOS 6.00 02/27/2020
[  177.519814] RIP: 0010:dev_hard_start_xmit+0x38/0x200
[  177.519827] Code: 55 41 54 53 48 83 ec 20 48 85 ff 48 89 55 c8 48 89 =
4d b8 0f 84 c1 01 00 00 48 8d 86 90 00 00 00 48 89 fb 49 89 f4 48 89 45 =
c0 <4c> 8b 2b 48 c7 c0 d0 f2 04 8f 48 c7 03 00 00 00 00 48 8b 00 4d 85
[  177.519829] RSP: 0018:ffffbc6d0609b5e8 EFLAGS: 00010286
[  177.519833] RAX: 0000000000000000 RBX: dead000000000100 RCX: =
ffff95cf4bcfe800
[  177.519835] RDX: 0000000000000000 RSI: ffff95cf4bcfe800 RDI: =
0000000000000286
[  177.519837] RBP: ffffbc6d0609b630 R08: ffff95cf6a190ec8 R09: =
ffff95cf4a2f7438
[  177.519839] R10: ffffbc6d0609b6d0 R11: ffff95cf49d4d180 R12: =
ffff95cf51a5f000
[  177.519841] R13: dead000000000100 R14: 000000000000009c R15: =
ffff95d02996b400
[  177.519844] FS:  00007ff394cdfb20(0000) GS:ffff95d035d40000(0000) =
knlGS:0000000000000000
[  177.519846] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  177.519848] CR2: 00007fb4a9c2d000 CR3: 00000001049fa004 CR4: =
00000000003606e0
[  177.519908] Call Trace:
[  177.519917]  __dev_queue_xmit+0x719/0x920
[  177.519930]  ? ctnetlink_conntrack_event+0x8c/0x5e0 =
[nf_conntrack_netlink]
[  177.519934]  dev_queue_xmit+0x10/0x20
[  177.519937]  ? dev_queue_xmit+0x10/0x20
[  177.519940]  ip_finish_output2+0x304/0x5a0
[  177.519944]  ? conntrack_mt_v3+0x20/0x30 [xt_conntrack]
[  177.519947]  __ip_finish_output+0xfa/0x1c0
[  177.519949]  ? __ip_finish_output+0xfa/0x1c0
[  177.519952]  ip_finish_output+0x2c/0xa0
[  177.519954]  ip_output+0x6d/0xe0
[  177.519957]  ? __ip_finish_output+0x1c0/0x1c0
[  177.519960]  ip_forward_finish+0x57/0x90
[  177.519963]  ip_forward+0x38c/0x480
[  177.519967]  ? ip4_key_hashfn+0xc0/0xc0
[  177.519970]  ip_rcv_finish+0x84/0xa0
[  177.519973]  nf_reinject+0x18e/0x1e0
[  177.519980]  nfqnl_reinject+0x50/0x60 [nfnetlink_queue]
[  177.519984]  nfqnl_recv_verdict+0x310/0x4c0 [nfnetlink_queue]
[  177.519990]  nfnetlink_rcv_msg+0x165/0x290 [nfnetlink]
[  177.520000]  ? __switch_to_asm+0x34/0x70
[  177.520002]  ? __switch_to_asm+0x40/0x70
[  177.520005]  ? __switch_to_asm+0x34/0x70
[  177.520008]  ? apic_timer_interrupt+0xa/0x20
[  177.520013]  ? nfnetlink_net_exit_batch+0x70/0x70 [nfnetlink]
[  177.520016]  netlink_rcv_skb+0x51/0x120
[  177.520021]  nfnetlink_rcv+0x88/0x145 [nfnetlink]
[  177.520024]  netlink_unicast+0x1a4/0x250
[  177.520027]  netlink_sendmsg+0x2eb/0x3f0
[  177.520032]  sock_sendmsg+0x63/0x70
[  177.520036]  ____sys_sendmsg+0x200/0x280
[  177.520041]  ___sys_sendmsg+0x88/0xd0
[  177.520047]  ? __wake_up+0x13/0x20
[  177.520052]  ? fput+0x13/0x20
[  177.520055]  ? __sys_recvfrom+0x14b/0x160
[  177.520058]  ? sock_poll+0x79/0xb0
[  177.520061]  __sys_sendmsg+0x63/0xa0
[  177.520063]  ? __sys_sendmsg+0x63/0xa0
[  177.520067]  __x64_sys_sendmsg+0x1f/0x30
[  177.520072]  do_syscall_64+0x57/0x190
[  177.520075]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  177.520079] RIP: 0033:0x7ff39660c879
[  177.520083] Code: c3 8b 07 85 c0 75 24 49 89 fb 48 89 f0 48 89 d7 48 =
89 ce 4c 89 c2 4d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 89 5c 24 08 0f =
05 <c3> e9 4d d3 ff ff 41 54 b8 02 00 00 00 49 89 f4 be 00 08 08 00 55
[  177.520085] RSP: 002b:00007ff394cddaa8 EFLAGS: 00000246 ORIG_RAX: =
000000000000002e
[  177.520089] RAX: ffffffffffffffda RBX: 00007ff394cdfb20 RCX: =
00007ff39660c879
[  177.520091] RDX: 0000000000000000 RSI: 00007ff394cddb08 RDI: =
0000000000000022
[  177.520092] RBP: 0000000000000022 R08: 0000000000000000 R09: =
0000000000000000
[  177.520094] R10: 0000000000000000 R11: 0000000000000246 R12: =
000000000000002e
[  177.520095] R13: 0000000000000022 R14: 00007ff394cddb08 R15: =
00000000fa000000
[  177.520098] Modules linked in: nfnetlink_queue xt_NFQUEUE =
ipt_rpfilter xt_multiport xt_set iptable_raw ip_set_hash_ip =
ip_set_hash_net ipip tunnel4 ip_tunnel vxlan ip6_udp_tunnel udp_tunnel =
ipt_REJECT nf_reject_ipv4 ip_set ip_vs_sh ip_vs_wrr ip_vs_rr ip_vs =
iptable_mangle xt_comment xt_mark rfcomm veth xt_nat xt_tcpudp =
xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xfrm_user =
xfrm_algo xt_addrtype iptable_filter iptable_nat nf_nat nf_conntrack =
nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c bpfilter br_netfilter bridge stp =
llc intel_rapl_msr intel_rapl_common crct10dif_pclmul crc32_pclmul =
ghash_clmulni_intel aesni_intel crypto_simd cryptd glue_helper rapl bnep =
vmw_balloon aufs snd_ens1371 snd_ac97_codec gameport ac97_bus input_leds =
snd_pcm joydev serio_raw snd_seq_midi snd_seq_midi_event snd_rawmidi =
btusb btrtl btbcm snd_seq btintel bluetooth snd_seq_device snd_timer =
ecdh_generic ecc snd soundcore overlay mac_hid vmw_vsock_vmci_transport =
vsock vmw_vmci sch_fq_codel vmwgfx ttm
[  177.520148]  drm_kms_helper drm fb_sys_fops syscopyarea sysfillrect =
sysimgblt parport_pc ppdev lp parport ip_tables x_tables autofs4 =
hid_generic usbhid hid mptspi mptscsih mptbase ahci psmouse e1000 =
libahci scsi_transport_spi i2c_piix4 pata_acpi


Two products Calico and Aqua security use iptables /netfilter on that =
system

Regards,
Yuri Lipnesh


