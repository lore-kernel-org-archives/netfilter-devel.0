Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5ECCC433DB
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Mar 2021 11:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9573B64FF0
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Mar 2021 11:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhCELGE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Mar 2021 06:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbhCELFn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Mar 2021 06:05:43 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6E9C061574
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Mar 2021 03:05:42 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id i9so1073682wml.0
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Mar 2021 03:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=s/duYJUbBpU5ieyPyPNgwOT5uRME8Dl60H0RiIFWJ+Q=;
        b=hZbMuwngbpDXiXG1B+AzgVA9ZzS5aulJGJJznA4x5PmGhpYHA5H+jAxDd9VLm9JcA7
         f0ymqywtzUR5TtLFJgj3mR3ZXI1cyDtQN8h2CikxeMF1h1PivkNh/ebhxrH/+GmQKp3m
         PATneEjl2IBUmHVKSC0IzrlTR0AwP7TvYByrp2gsWAeFEXmRUmhp3I//ZWzmTxLS+a7R
         1DwVpY0urHEDY5dm/dZIjaGldxt71iDLo6uzIvzrG1q/y9XZg+GpRa/OFYxPBm9TRBze
         T11UX3B8/Gfx/Mdcb553s1Be2JVAZ+X6mrTvoVl/BYN/3/OKD9RcumdKj32cOjNKq0iZ
         U3JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=s/duYJUbBpU5ieyPyPNgwOT5uRME8Dl60H0RiIFWJ+Q=;
        b=eNdK2+mbldtjipjqgVfb+AM4KR44mswsoD/dgmIHRjCVRDOVR14cmhY2aOqG2pohVm
         bbzBKkDQws/M1pRQvWwD588QtXDW4xKPtsT9qHphbo2CbTl3GyXFllC/TX3MC5tBwOR0
         uCl5gFsNMO72Xp0bdy3Cv6/dCZl6g5Tbc9c7w/MyLRt7g9jMfQPsRX7dbvacPd726cpG
         XHlMuL89Bf0Ci9LnPJRZRPFxX2Lpa/zG1MMQA1Ep7p5UNQSkFJdVmyvT98ndhmRULASf
         qIpLiMUZP6z+mhmWJoEE6ehO3ORgdanAzZriLpp4Y/2hYr5DpztpmJTacXaEGifQeEma
         kiAQ==
X-Gm-Message-State: AOAM533wPor2BeZaO1OJ95y0GysdGzTPPutHMxzT4JOSGU2lMgRWS4Ht
        QGk76973ED8TrBNuxzdiuklHS8l4JiuwoVEMLVFrES4m2J6900QC
X-Google-Smtp-Source: ABdhPJzKlr7LtmPyg5r/cFRDkM9KhCrmsfAhwQGuS9QXDkA/GsLtF4iG2dQ8QzGDlLMMBRpKWZhotMQkz4ye5UUQ4XQ=
X-Received: by 2002:a1c:c20a:: with SMTP id s10mr8259325wmf.144.1614942340306;
 Fri, 05 Mar 2021 03:05:40 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?B?0JzQsNC60YHQuNC8?= <maxbur89@gmail.com>
Date:   Fri, 5 Mar 2021 18:05:29 +0700
Message-ID: <CA+GUAtOnjr-bG41Ryf6YJsH66oBRBeBnTp9+8_1Zn--0OOiQ9g@mail.gmail.com>
Subject: Kernel Error FLOW OFFLOAD on nftables
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Good day.

Had an issue with FLOW OFFLOAD on nftables based NAT server. NAT
crashes after a few hours of running with the error:

[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021] rcu: INFO: rcu_sched sel=
f-detected stall on CPU
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021] rcu: 10-....: (5251 tick=
s this GP)
idle=3D73e/1/0x4000000000000002 softirq=3D4099632/4099633 fqs=3D2625
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021] rcu: (t=3D5251 jiffies g=
=3D14930289 q=3D91701)
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021] NMI backtrace for cpu 10
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021] CPU: 10 PID: 64 Comm: ks=
oftirqd/10 Tainted:
G           OE     4.19.0-14-amd64 #1 Debian 4.19.171-2

What could be the problem? What can you check?

Kernel: Linux nat8 4.19.0-14-amd64 #1 SMP Debian 4.19.171-2
(2021-01-30) x86_64 GNU/Linux
Version nftables:
nft -v nftables v0.9.0 (Fearless Fosdick)
Server: CPU Xeon(R) CPU E5-2680 v3 @ 2.50GHz, Memory 64Gb
Network card: Intel 82599ES (520 chipset), driver ixgbe 5.10.2

Configuration nftables (nft list ruleset):
table ip nat {
chain postrouting {
type nat hook postrouting priority 100; policy accept;
counter packets 0 bytes 0
oif "ens1f1" ip saddr 10.0.0.0/8 snat to 31.43.223.160-31.43.223.176 persis=
tent
oif "ens1f1" ip saddr 192.168.0.0/16 snat to
31.43.223.160-31.43.223.176 persistent
oif "ens1f1" ip saddr 172.16.0.0/12 snat to
31.43.223.160-31.43.223.176 persistent
counter packets 0 bytes 0
}
}
table inet filter {
flowtable fastnat {
hook ingress priority 0
devices =3D { ens1f0, ens1f1 }
}

chain forward {
type filter hook forward priority 0; policy accept;
ip protocol { tcp, udp } flow offload @fastnat counter packets 3 bytes 323
counter packets 3 bytes 323
}
}
table ip raw {
ct helper pptp-gre {
type "pptp" protocol tcp
l3proto ip
}

chain prerouting {
type filter hook prerouting priority -300; policy accept;
tcp dport 1723 ct helper set "pptp-gre"
counter packets 84 bytes 5147
}
}

More detailed error log:

[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021] rcu: INFO: rcu_sched sel=
f-detected stall on CPU
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021] rcu: 10-....: (5251 tick=
s this GP)
idle=3D73e/1/0x4000000000000002 softirq=3D4099632/4099633 fqs=3D2625
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021] rcu: (t=3D5251 jiffies g=
=3D14930289 q=3D91701)
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021] NMI backtrace for cpu 10
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021] CPU: 10 PID: 64 Comm: ks=
oftirqd/10 Tainted:
G           OE     4.19.0-14-amd64 #1 Debian 4.19.171-2
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021] Hardware name: HP ProLia=
nt DL360
Gen9/ProLiant DL360 Gen9, BIOS P89 10/21/2019
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021] Call Trace:
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  <IRQ>
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  dump_stack+0x66/0x81
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  nmi_cpu_backtrace.cold.=
4+0x13/0x50
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  ? lapic_can_unplug_cpu+=
0x80/0x80
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  nmi_trigger_cpumask_bac=
ktrace+0xf9/0x100
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  rcu_dump_cpu_stacks+0x9=
b/0xcb
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  rcu_check_callbacks.col=
d.81+0x1db/0x335
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  ? tick_sched_do_timer+0=
x60/0x60
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  update_process_times+0x=
28/0x60
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  tick_sched_handle+0x22/=
0x60
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  tick_sched_timer+0x37/0=
x70
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  __hrtimer_run_queues+0x=
100/0x280
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  hrtimer_interrupt+0x100=
/0x220
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  ? handle_irq_event+0x47=
/0x60
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  smp_apic_timer_interrup=
t+0x6a/0x140
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  apic_timer_interrupt+0x=
f/0x20
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  </IRQ>
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021] RIP:
0010:nf_conntrack_tuple_taken+0xad/0x240 [nf_conntrack]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021] Code: 48 8d 04 f5 00 00 =
00 00 48 89 f1 48 29
f0 48 c1 e0 03 48 29 c7 48 01 df 4c 39 ef 74 1b 48 8b 05 a9 16 bb d5
8b b7 88 00 00 00 <29> c6 85 f6 7e 2f 8b 43 10 41 39 06 74 36 48 8b 1b
48 89 d8 f6 c3
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021] RSP: 0018:ffffbd004652f6=
80 EFLAGS: 00000202
ORIG_RAX: ffffffffffffff13
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021] RAX: 000000010164f9f0 RB=
X: ffff9422a30af410
RCX: 0000000000000000
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021] RDX: 000000000000b89a RS=
I: 00000000029915c5
RDI: ffff9422a30af400
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021] RBP: ffffffff962deb80 R0=
8: ffffbd004652f6d8
R09: 000000008029bca6
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021] R10: ffff942252148dc0 R1=
1: 0000000000000001
R12: ffffffffc0670a84
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021] R13: ffff942251345cc0 R1=
4: ffffbd004652f6c0
R15: fffffffffffffff0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  nf_nat_used_tuple+0x33/=
0x50 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  nf_nat_l4proto_unique_t=
uple+0xba/0x1d0 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  get_unique_tuple+0x1ee/=
0x550 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  nf_nat_setup_info+0x8c/=
0x290 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  nft_nat_eval+0xcd/0x120=
 [nft_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  nft_do_chain+0xea/0x420=
 [nf_tables]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  ? nft_counter_obj_dump+=
0x20/0x20 [nft_counter]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  ? nft_do_chain+0xea/0x4=
20 [nf_tables]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  ? nf_conntrack_tuple_ta=
ken+0x5e/0x240 [nf_conntrack]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  ? get_unique_tuple+0x26=
5/0x550 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  ? nf_ct_ext_add+0x90/0x=
160 [nf_conntrack]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  nft_nat_do_chain+0x66/0=
x80 [nft_chain_nat_ipv4]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  nf_nat_inet_fn+0xea/0x2=
30 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  nf_nat_ipv4_out+0x14/0x=
a0 [nf_nat_ipv4]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  nf_hook_slow+0x44/0xc0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  ip_output+0xd2/0xe0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  ? ip_fragment.constprop=
.50+0x80/0x80
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  ip_forward+0x3bf/0x480
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  ? ip4_key_hashfn+0xb0/0=
xb0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  ip_rcv+0xbc/0xd0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  ? ip_rcv_finish_core.is=
ra.18+0x360/0x360
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  __netif_receive_skb_one=
_core+0x5a/0x80
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  netif_receive_skb_inter=
nal+0x2f/0xa0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  napi_gro_receive+0xba/0=
xe0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  ixgbe_poll+0x530/0x1170=
 [ixgbe]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  net_rx_action+0x149/0x3=
b0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  __do_softirq+0xde/0x2d8
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  ? sort_range+0x20/0x20
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  run_ksoftirqd+0x26/0x40
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  smpboot_thread_fn+0xc5/=
0x160
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  kthread+0x112/0x130
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  ? kthread_bind+0x30/0x3=
0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:30:12 2021]  ret_from_fork+0x35/0x40
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021] rcu: INFO: rcu_sched sel=
f-detected stall on CPU
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021] rcu: 10-....: (1 GPs beh=
ind)
idle=3D6ba/1/0x4000000000000002 softirq=3D4101971/4101972 fqs=3D2624
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021] rcu: (t=3D5251 jiffies g=
=3D14930473 q=3D89249)
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021] NMI backtrace for cpu 10
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021] CPU: 10 PID: 64 Comm: ks=
oftirqd/10 Tainted:
G           OE     4.19.0-14-amd64 #1 Debian 4.19.171-2
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021] Hardware name: HP ProLia=
nt DL360
Gen9/ProLiant DL360 Gen9, BIOS P89 10/21/2019
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021] Call Trace:
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  <IRQ>
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  dump_stack+0x66/0x81
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  nmi_cpu_backtrace.cold.=
4+0x13/0x50
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  ? lapic_can_unplug_cpu+=
0x80/0x80
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  nmi_trigger_cpumask_bac=
ktrace+0xf9/0x100
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  rcu_dump_cpu_stacks+0x9=
b/0xcb
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  rcu_check_callbacks.col=
d.81+0x1db/0x335
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  ? tick_sched_do_timer+0=
x60/0x60
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  update_process_times+0x=
28/0x60
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  tick_sched_handle+0x22/=
0x60
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  tick_sched_timer+0x37/0=
x70
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  __hrtimer_run_queues+0x=
100/0x280
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  hrtimer_interrupt+0x100=
/0x220
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  ? handle_irq_event+0x47=
/0x60
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  smp_apic_timer_interrup=
t+0x6a/0x140
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  apic_timer_interrupt+0x=
f/0x20
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  </IRQ>
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021] RIP:
0010:nf_conntrack_tuple_taken+0x80/0x240 [nf_conntrack]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021] Code: 89 0c 24 e8 f2 f3 =
ff ff 89 da 89 c3 48
0f af d3 48 c1 ea 20 48 8b 0c 24 48 8d 04 d1 48 8b 00 48 89 c3 a8 01
75 4a 0f b6 73 37 <4c> 89 ff 48 8d 04 f5 00 00 00 00 48 89 f1 48 29 f0
48 c1 e0 03 48
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021] RSP: 0018:ffffbd004652f6=
80 EFLAGS: 00000246
ORIG_RAX: ffffffffffffff13
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021] RAX: ffff94227d8b03d0 RB=
X: ffff94227d8b03d0
RCX: 0000000000000001
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021] RDX: 0000000000001916 RS=
I: 0000000000000000
RDI: ffff94227ae76780
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021] RBP: ffffffff962deb80 R0=
8: ffffbd004652f6d8
R09: 000000002531dd40
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021] R10: ffff94224f1a17c0 R1=
1: 0000000000000001
R12: ffffffffc0670a84
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021] R13: ffff942a748d0140 R1=
4: ffffbd004652f6c0
R15: fffffffffffffff0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  nf_nat_used_tuple+0x33/=
0x50 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  nf_nat_l4proto_unique_t=
uple+0xba/0x1d0 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  get_unique_tuple+0x1ee/=
0x550 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  nf_nat_setup_info+0x8c/=
0x290 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  nft_nat_eval+0xcd/0x120=
 [nft_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  nft_do_chain+0xea/0x420=
 [nf_tables]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  ? nft_counter_obj_dump+=
0x20/0x20 [nft_counter]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  ? nft_do_chain+0xea/0x4=
20 [nf_tables]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  ? nf_conntrack_tuple_ta=
ken+0x5e/0x240 [nf_conntrack]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  ? get_unique_tuple+0x26=
5/0x550 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  ? nf_nat_ipv4_csum_reca=
lc+0xb0/0xb0 [nf_nat_ipv4]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  nft_nat_do_chain+0x66/0=
x80 [nft_chain_nat_ipv4]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  nf_nat_inet_fn+0xea/0x2=
30 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  nf_nat_ipv4_out+0x14/0x=
a0 [nf_nat_ipv4]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  nf_hook_slow+0x44/0xc0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  ip_output+0xd2/0xe0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  ? ip_fragment.constprop=
.50+0x80/0x80
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  ip_forward+0x3bf/0x480
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  ? ip4_key_hashfn+0xb0/0=
xb0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  ip_rcv+0xbc/0xd0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  ? ip_rcv_finish_core.is=
ra.18+0x360/0x360
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  __netif_receive_skb_one=
_core+0x5a/0x80
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  netif_receive_skb_inter=
nal+0x2f/0xa0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  napi_gro_receive+0xba/0=
xe0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  ixgbe_poll+0x530/0x1170=
 [ixgbe]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  net_rx_action+0x149/0x3=
b0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  __do_softirq+0xde/0x2d8
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  ? sort_range+0x20/0x20
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  run_ksoftirqd+0x26/0x40
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  smpboot_thread_fn+0xc5/=
0x160
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  kthread+0x112/0x130
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  ? kthread_bind+0x30/0x3=
0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:18 2021]  ret_from_fork+0x35/0x40
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021] rcu: INFO: rcu_sched sel=
f-detected stall on CPU
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021] rcu: 10-....: (5250 tick=
s this GP)
idle=3D6c2/1/0x4000000000000002 softirq=3D4101976/4101977 fqs=3D2301
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021] rcu: (t=3D5251 jiffies g=
=3D14930485 q=3D55206)
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021] NMI backtrace for cpu 10
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021] CPU: 10 PID: 64 Comm: ks=
oftirqd/10 Tainted:
G           OE     4.19.0-14-amd64 #1 Debian 4.19.171-2
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021] Hardware name: HP ProLia=
nt DL360
Gen9/ProLiant DL360 Gen9, BIOS P89 10/21/2019
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021] Call Trace:
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  <IRQ>
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  dump_stack+0x66/0x81
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  nmi_cpu_backtrace.cold.=
4+0x13/0x50
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  ? lapic_can_unplug_cpu+=
0x80/0x80
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  nmi_trigger_cpumask_bac=
ktrace+0xf9/0x100
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  rcu_dump_cpu_stacks+0x9=
b/0xcb
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  rcu_check_callbacks.col=
d.81+0x1db/0x335
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  ? tick_sched_do_timer+0=
x60/0x60
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  update_process_times+0x=
28/0x60
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  tick_sched_handle+0x22/=
0x60
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  tick_sched_timer+0x37/0=
x70
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  __hrtimer_run_queues+0x=
100/0x280
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  hrtimer_interrupt+0x100=
/0x220
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  ? handle_irq_event+0x47=
/0x60
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  smp_apic_timer_interrup=
t+0x6a/0x140
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  apic_timer_interrupt+0x=
f/0x20
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  </IRQ>
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021] RIP:
0010:nf_conntrack_tuple_taken+0xad/0x240 [nf_conntrack]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021] Code: 48 8d 04 f5 00 00 =
00 00 48 89 f1 48 29
f0 48 c1 e0 03 48 29 c7 48 01 df 4c 39 ef 74 1b 48 8b 05 a9 16 bb d5
8b b7 88 00 00 00 <29> c6 85 f6 7e 2f 8b 43 10 41 39 06 74 36 48 8b 1b
48 89 d8 f6 c3
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021] RSP: 0018:ffffbd004652f6=
80 EFLAGS: 00000206
ORIG_RAX: ffffffffffffff13
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021] RAX: 000000010165cae1 RB=
X: ffff942a8887be10
RCX: 0000000000000000
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021] RDX: 0000000000003061 RS=
I: 0000000002aecad6
RDI: ffff942a8887be00
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021] RBP: ffffffff962deb80 R0=
8: ffffbd004652f6d8
R09: 0000000061909bca
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021] R10: ffff942a7548eb40 R1=
1: 0000000000000001
R12: ffffffffc0670a84
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021] R13: ffff942a74eb5400 R1=
4: ffffbd004652f6c0
R15: fffffffffffffff0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  nf_nat_used_tuple+0x33/=
0x50 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  nf_nat_l4proto_unique_t=
uple+0xba/0x1d0 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  get_unique_tuple+0x1ee/=
0x550 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  nf_nat_setup_info+0x8c/=
0x290 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  nft_nat_eval+0xcd/0x120=
 [nft_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  nft_do_chain+0xea/0x420=
 [nf_tables]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  ? nft_counter_obj_dump+=
0x20/0x20 [nft_counter]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  ? nft_do_chain+0xea/0x4=
20 [nf_tables]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  ? nf_conntrack_tuple_ta=
ken+0x5e/0x240 [nf_conntrack]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  ? get_unique_tuple+0x26=
5/0x550 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  nft_nat_do_chain+0x66/0=
x80 [nft_chain_nat_ipv4]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  nf_nat_inet_fn+0xea/0x2=
30 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  nf_nat_ipv4_out+0x14/0x=
a0 [nf_nat_ipv4]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  nf_hook_slow+0x44/0xc0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  ip_output+0xd2/0xe0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  ? ip_fragment.constprop=
.50+0x80/0x80
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  ip_forward+0x3bf/0x480
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  ? ip4_key_hashfn+0xb0/0=
xb0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  ip_rcv+0xbc/0xd0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  ? ip_rcv_finish_core.is=
ra.18+0x360/0x360
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  __netif_receive_skb_one=
_core+0x5a/0x80
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  netif_receive_skb_inter=
nal+0x2f/0xa0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  napi_gro_receive+0xba/0=
xe0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  ixgbe_poll+0x530/0x1170=
 [ixgbe]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  net_rx_action+0x149/0x3=
b0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  __do_softirq+0xde/0x2d8
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  ? sort_range+0x20/0x20
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  run_ksoftirqd+0x26/0x40
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  smpboot_thread_fn+0xc5/=
0x160
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  kthread+0x112/0x130
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  ? kthread_bind+0x30/0x3=
0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:33:46 2021]  ret_from_fork+0x35/0x40
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021] watchdog: BUG: soft lock=
up - CPU#6 stuck for
22s! [swapper/6:0]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021] Modules linked in: nft_o=
bjref nft_ct
nf_conntrack_pptp nf_conntrack_proto_gre ipmi_ssif intel_rapl
nft_flow_offload nf_flow_table_inet nf_flow_table sb_edac
nf_tables_set x86_pkg_temp_thermal intel_powerclamp coretemp mgag200
crct10dif_pclmul crc32_pclmul ttm ghash_clmulni_intel intel_cstate
drm_kms_helper intel_uncore pcc_cpufreq intel_rapl_perf nft_nat
serio_raw pcspkr drm evdev joydev sg i2c_algo_bit iTCO_wdt hpilo hpwdt
iTCO_vendor_support ioatdma wmi ipmi_si nft_counter ipmi_devintf
ipmi_msghandler acpi_tad acpi_power_meter button nft_chain_nat_ipv4
nf_nat_ipv4 nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
nf_tables nfnetlink ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2
fscrypto ecb raid10 raid456 async_raid6_recov async_memcpy async_pq
async_xor async_tx xor hid_generic
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  usbhid hid raid6_pq lib=
crc32c
crc32c_generic raid0 multipath linear raid1 md_mod sd_mod crc32c_intel
ahci libahci libata aesni_intel xhci_pci aes_x86_64 uhci_hcd
crypto_simd ehci_pci xhci_hcd psmouse cryptd ehci_hcd glue_helper
scsi_mod ixgbe(OE) tg3 usbcore lpc_ich i2c_i801 mfd_core libphy dca
usb_common
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021] CPU: 6 PID: 0 Comm: swap=
per/6 Tainted: G
      OE     4.19.0-14-amd64 #1 Debian 4.19.171-2
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021] Hardware name: HP ProLia=
nt DL360
Gen9/ProLiant DL360 Gen9, BIOS P89 10/21/2019
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021] RIP:
0010:nf_conntrack_tuple_taken+0x80/0x240 [nf_conntrack]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021] Code: 89 0c 24 e8 f2 f3 =
ff ff 89 da 89 c3 48
0f af d3 48 c1 ea 20 48 8b 0c 24 48 8d 04 d1 48 8b 00 48 89 c3 a8 01
75 4a 0f b6 73 37 <4c> 89 ff 48 8d 04 f5 00 00 00 00 48 89 f1 48 29 f0
48 c1 e0 03 48
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021] RSP: 0018:ffff942b1f8037=
60 EFLAGS: 00000246
ORIG_RAX: ffffffffffffff13
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021] RAX: ffff94226f4f57d0 RB=
X: ffff94226f4f57d0
RCX: 0000000000000001
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021] RDX: 0000000000001f5f RS=
I: 0000000000000000
RDI: ffff942a891b0f00
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021] RBP: ffffffff962deb80 R0=
8: ffff942b1f8037b8
R09: 00000000ca74ee0f
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021] R10: ffff94224e4e8780 R1=
1: 0000000000000001
R12: ffffffffc0670a84
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021] R13: ffff942a74346a00 R1=
4: ffff942b1f8037a0
R15: fffffffffffffff0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021] FS:  0000000000000000(00=
00)
GS:ffff942b1f800000(0000) knlGS:0000000000000000
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021] CS:  0010 DS: 0000 ES: 0=
000 CR0: 0000000080050033
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021] CR2: 00007fff73454038 CR=
3: 0000000b7c80a003
CR4: 00000000001606e0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021] Call Trace:
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  <IRQ>
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  nf_nat_used_tuple+0x33/=
0x50 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  nf_nat_l4proto_unique_t=
uple+0xba/0x1d0 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  get_unique_tuple+0x1ee/=
0x550 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  nf_nat_setup_info+0x8c/=
0x290 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  nft_nat_eval+0xcd/0x120=
 [nft_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  nft_do_chain+0xea/0x420=
 [nf_tables]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  ? nft_counter_obj_dump+=
0x20/0x20 [nft_counter]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  ? nft_do_chain+0xea/0x4=
20 [nf_tables]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  ? nf_conntrack_tuple_ta=
ken+0x5e/0x240 [nf_conntrack]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  ? get_unique_tuple+0x26=
5/0x550 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  nft_nat_do_chain+0x66/0=
x80 [nft_chain_nat_ipv4]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  nf_nat_inet_fn+0xea/0x2=
30 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  nf_nat_ipv4_out+0x14/0x=
a0 [nf_nat_ipv4]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  nf_hook_slow+0x44/0xc0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  ip_output+0xd2/0xe0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  ? ip_fragment.constprop=
.50+0x80/0x80
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  ip_forward+0x3bf/0x480
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  ? ip4_key_hashfn+0xb0/0=
xb0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  ip_rcv+0xbc/0xd0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  ? ip_rcv_finish_core.is=
ra.18+0x360/0x360
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  __netif_receive_skb_one=
_core+0x5a/0x80
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  netif_receive_skb_inter=
nal+0x2f/0xa0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  napi_gro_receive+0xba/0=
xe0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  ixgbe_poll+0x530/0x1170=
 [ixgbe]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  net_rx_action+0x149/0x3=
b0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  __do_softirq+0xde/0x2d8
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  irq_exit+0xba/0xc0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  do_IRQ+0x7f/0xe0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  common_interrupt+0xf/0x=
f
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  </IRQ>
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021] RIP: 0010:cpuidle_enter_=
state+0xb9/0x320
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021] Code: e8 7c 85 b2 ff 80 =
7c 24 0b 00 74 17 9c
58 0f 1f 44 00 00 f6 c4 02 0f 85 3b 02 00 00 31 ff e8 1e 0d b8 ff fb
66 0f 1f 44 00 00 <48> b8 ff ff ff ff f3 01 00 00 48 2b 1c 24 ba ff ff
ff 7f 48 39 c3
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021] RSP: 0018:ffffbd0046317e=
90 EFLAGS: 00000246
ORIG_RAX: ffffffffffffffdc
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021] RAX: ffff942b1f822140 RB=
X: 000055a73f206ba4
RCX: 000000000000001f
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021] RDX: 000055a73f206ba4 RS=
I: 000000003342629e
RDI: 0000000000000000
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021] RBP: ffff942b1f82a748 R0=
8: 0000000000000002
R09: 0000000000021a00
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021] R10: 0000d8c97090db52 R1=
1: ffff942b1f821128
R12: 0000000000000004
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021] R13: ffffffff962b71d8 R1=
4: 0000000000000004
R15: 0000000000000000
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  do_idle+0x228/0x270
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  cpu_startup_entry+0x6f/=
0x80
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  start_secondary+0x1a4/0=
x200
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:35:29 2021]  secondary_startup_64+0x=
a4/0xb0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021] watchdog: BUG: soft lock=
up - CPU#6 stuck for
21s! [ksoftirqd/6:43]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021] Modules linked in: nft_o=
bjref nft_ct
nf_conntrack_pptp nf_conntrack_proto_gre ipmi_ssif intel_rapl
nft_flow_offload nf_flow_table_inet nf_flow_table sb_edac
nf_tables_set x86_pkg_temp_thermal intel_powerclamp coretemp mgag200
crct10dif_pclmul crc32_pclmul ttm ghash_clmulni_intel intel_cstate
drm_kms_helper intel_uncore pcc_cpufreq intel_rapl_perf nft_nat
serio_raw pcspkr drm evdev joydev sg i2c_algo_bit iTCO_wdt hpilo hpwdt
iTCO_vendor_support ioatdma wmi ipmi_si nft_counter ipmi_devintf
ipmi_msghandler acpi_tad acpi_power_meter button nft_chain_nat_ipv4
nf_nat_ipv4 nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
nf_tables nfnetlink ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2
fscrypto ecb raid10 raid456 async_raid6_recov async_memcpy async_pq
async_xor async_tx xor hid_generic
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  usbhid hid raid6_pq lib=
crc32c
crc32c_generic raid0 multipath linear raid1 md_mod sd_mod crc32c_intel
ahci libahci libata aesni_intel xhci_pci aes_x86_64 uhci_hcd
crypto_simd ehci_pci xhci_hcd psmouse cryptd ehci_hcd glue_helper
scsi_mod ixgbe(OE) tg3 usbcore lpc_ich i2c_i801 mfd_core libphy dca
usb_common
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021] CPU: 6 PID: 43 Comm: kso=
ftirqd/6 Tainted: G
         OEL    4.19.0-14-amd64 #1 Debian 4.19.171-2
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021] Hardware name: HP ProLia=
nt DL360
Gen9/ProLiant DL360 Gen9, BIOS P89 10/21/2019
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021] RIP:
0010:nf_conntrack_tuple_taken+0xad/0x240 [nf_conntrack]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021] Code: 48 8d 04 f5 00 00 =
00 00 48 89 f1 48 29
f0 48 c1 e0 03 48 29 c7 48 01 df 4c 39 ef 74 1b 48 8b 05 a9 16 bb d5
8b b7 88 00 00 00 <29> c6 85 f6 7e 2f 8b 43 10 41 39 06 74 36 48 8b 1b
48 89 d8 f6 c3
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021] RSP: 0018:ffffbd00464876=
80 EFLAGS: 00000283
ORIG_RAX: ffffffffffffff13
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021] RAX: 0000000101664eb1 RB=
X: ffff9422964bfb90
RCX: 0000000000000000
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021] RDX: 000000000000840f RS=
I: 00000000029a6128
RDI: ffff9422964bfb80
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021] RBP: ffffffff962deb80 R0=
8: ffffbd00464876d8
R09: 00000000ffebaa15
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021] R10: ffff942a74641900 R1=
1: 0000000000000001
R12: ffffffffc0670a84
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021] R13: ffff942a75d90b40 R1=
4: ffffbd00464876c0
R15: fffffffffffffff0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021] FS:  0000000000000000(00=
00)
GS:ffff942b1f800000(0000) knlGS:0000000000000000
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021] CS:  0010 DS: 0000 ES: 0=
000 CR0: 0000000080050033
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021] CR2: 00007fff73454038 CR=
3: 0000000b7c80a003
CR4: 00000000001606e0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021] Call Trace:
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  nf_nat_used_tuple+0x33/=
0x50 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  nf_nat_l4proto_unique_t=
uple+0xba/0x1d0 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  get_unique_tuple+0x1ee/=
0x550 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  nf_nat_setup_info+0x8c/=
0x290 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  ? ip_route_output_flow+=
0x19/0x50
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  nft_nat_eval+0xcd/0x120=
 [nft_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  nft_do_chain+0xea/0x420=
 [nf_tables]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  ? nft_counter_obj_dump+=
0x20/0x20 [nft_counter]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  ? nft_do_chain+0xea/0x4=
20 [nf_tables]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  ? eth_header+0x26/0xc0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  ? nf_conntrack_tuple_ta=
ken+0x5e/0x240 [nf_conntrack]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  ? get_unique_tuple+0x26=
5/0x550 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  ? nf_nat_ipv4_csum_reca=
lc+0xb0/0xb0 [nf_nat_ipv4]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  nft_nat_do_chain+0x66/0=
x80 [nft_chain_nat_ipv4]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  nf_nat_inet_fn+0xea/0x2=
30 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  nf_nat_ipv4_out+0x14/0x=
a0 [nf_nat_ipv4]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  nf_hook_slow+0x44/0xc0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  ip_output+0xd2/0xe0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  ? ip_fragment.constprop=
.50+0x80/0x80
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  ip_forward+0x3bf/0x480
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  ? ip4_key_hashfn+0xb0/0=
xb0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  ip_rcv+0xbc/0xd0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  ? ip_rcv_finish_core.is=
ra.18+0x360/0x360
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  __netif_receive_skb_one=
_core+0x5a/0x80
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  netif_receive_skb_inter=
nal+0x2f/0xa0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  napi_gro_receive+0xba/0=
xe0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  ixgbe_poll+0x530/0x1170=
 [ixgbe]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  net_rx_action+0x149/0x3=
b0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  __do_softirq+0xde/0x2d8
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  ? sort_range+0x20/0x20
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  run_ksoftirqd+0x26/0x40
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  smpboot_thread_fn+0xc5/=
0x160
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  kthread+0x112/0x130
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  ? kthread_bind+0x30/0x3=
0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:01 2021]  ret_from_fork+0x35/0x40
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021] rcu: INFO: rcu_sched sel=
f-detected stall on CPU
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021] rcu: 4-....: (1 GPs behi=
nd) idle=3D32a/0/0x3
softirq=3D3874694/3874694 fqs=3D2602
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021] rcu: (t=3D5251 jiffies g=
=3D14930609 q=3D81134)
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021] NMI backtrace for cpu 4
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021] CPU: 4 PID: 0 Comm: swap=
per/4 Tainted: G
      OEL    4.19.0-14-amd64 #1 Debian 4.19.171-2
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021] Hardware name: HP ProLia=
nt DL360
Gen9/ProLiant DL360 Gen9, BIOS P89 10/21/2019
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021] Call Trace:
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  <IRQ>
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  dump_stack+0x66/0x81
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  nmi_cpu_backtrace.cold.=
4+0x13/0x50
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  ? lapic_can_unplug_cpu+=
0x80/0x80
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  nmi_trigger_cpumask_bac=
ktrace+0xf9/0x100
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  rcu_dump_cpu_stacks+0x9=
b/0xcb
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  rcu_check_callbacks.col=
d.81+0x1db/0x335
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  ? tick_sched_do_timer+0=
x60/0x60
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  update_process_times+0x=
28/0x60
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  tick_sched_handle+0x22/=
0x60
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  tick_sched_timer+0x37/0=
x70
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  __hrtimer_run_queues+0x=
100/0x280
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  hrtimer_interrupt+0x100=
/0x220
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  smp_apic_timer_interrup=
t+0x6a/0x140
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  apic_timer_interrupt+0x=
f/0x20
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021] RIP:
0010:nf_conntrack_tuple_taken+0x80/0x240 [nf_conntrack]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021] Code: 89 0c 24 e8 f2 f3 =
ff ff 89 da 89 c3 48
0f af d3 48 c1 ea 20 48 8b 0c 24 48 8d 04 d1 48 8b 00 48 89 c3 a8 01
75 4a 0f b6 73 37 <4c> 89 ff 48 8d 04 f5 00 00 00 00 48 89 f1 48 29 f0
48 c1 e0 03 48
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021] RSP: 0018:ffff94231f9037=
60 EFLAGS: 00000246
ORIG_RAX: ffffffffffffff13
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021] RAX: ffff942aa5f50f10 RB=
X: ffff942aa5f50f10
RCX: 0000000000000001
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021] RDX: 0000000000000436 RS=
I: 0000000000000000
RDI: ffff94229ee78000
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021] RBP: ffffffff962deb80 R0=
8: ffff94231f9037b8
R09: 00000000db6085b2
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021] R10: ffff94224da82780 R1=
1: 0000000000000001
R12: ffffffffc0670a84
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021] R13: ffff94224cb28140 R1=
4: ffff94231f9037a0
R15: fffffffffffffff0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  ? apic_timer_interrupt+=
0xa/0x20
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  nf_nat_used_tuple+0x33/=
0x50 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  nf_nat_l4proto_unique_t=
uple+0xba/0x1d0 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  get_unique_tuple+0x1ee/=
0x550 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  nf_nat_setup_info+0x8c/=
0x290 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  nft_nat_eval+0xcd/0x120=
 [nft_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  nft_do_chain+0xea/0x420=
 [nf_tables]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  ? ixgbe_xmit_frame_ring=
+0x611/0xf10 [ixgbe]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  ? nft_counter_obj_dump+=
0x20/0x20 [nft_counter]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  ? nft_do_chain+0xea/0x4=
20 [nf_tables]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  ? nf_conntrack_tuple_ta=
ken+0x5e/0x240 [nf_conntrack]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  ? get_unique_tuple+0x26=
5/0x550 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  nft_nat_do_chain+0x66/0=
x80 [nft_chain_nat_ipv4]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  nf_nat_inet_fn+0xea/0x2=
30 [nf_nat]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  nf_nat_ipv4_out+0x14/0x=
a0 [nf_nat_ipv4]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  nf_hook_slow+0x44/0xc0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  ip_output+0xd2/0xe0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  ? ip_fragment.constprop=
.50+0x80/0x80
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  ip_forward+0x3bf/0x480
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  ? ip4_key_hashfn+0xb0/0=
xb0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  ip_rcv+0xbc/0xd0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  ? ip_rcv_finish_core.is=
ra.18+0x360/0x360
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  __netif_receive_skb_one=
_core+0x5a/0x80
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  netif_receive_skb_inter=
nal+0x2f/0xa0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  napi_gro_receive+0xba/0=
xe0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  ixgbe_poll+0x530/0x1170=
 [ixgbe]
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  ? tick_sched_do_timer+0=
x60/0x60
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  net_rx_action+0x149/0x3=
b0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  __do_softirq+0xde/0x2d8
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  irq_exit+0xba/0xc0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  do_IRQ+0x7f/0xe0
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  common_interrupt+0xf/0x=
f
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  </IRQ>
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021] RIP: 0010:cpuidle_enter_=
state+0xb9/0x320
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021] Code: e8 7c 85 b2 ff 80 =
7c 24 0b 00 74 17 9c
58 0f 1f 44 00 00 f6 c4 02 0f 85 3b 02 00 00 31 ff e8 1e 0d b8 ff fb
66 0f 1f 44 00 00 <48> b8 ff ff ff ff f3 01 00 00 48 2b 1c 24 ba ff ff
ff 7f 48 39 c3
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021] RSP: 0018:ffffbd0046307e=
90 EFLAGS: 00000246
ORIG_RAX: ffffffffffffffd9
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021] RAX: ffff94231f922140 RB=
X: 000055b8713511c3
RCX: 000000000000001f
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021] RDX: 000055b8713511c3 RS=
I: 000000003342629e
RDI: 0000000000000000
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021] RBP: ffff94231f92a748 R0=
8: 0000000000000002
R09: 0000000000021a00
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021] R10: 0000d8f461084355 R1=
1: ffff94231f921128
R12: 0000000000000001
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021] R13: ffffffff962b70b8 R1=
4: 0000000000000001
R15: 0000000000000000
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  do_idle+0x228/0x270
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  cpu_startup_entry+0x6f/=
0x80
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  start_secondary+0x1a4/0=
x200
[=D0=9F=D1=82 =D0=BC=D0=B0=D1=80  5 11:36:44 2021]  secondary_startup_64+0x=
a4/0xb0
