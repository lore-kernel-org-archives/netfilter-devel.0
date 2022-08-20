Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C31FC25B08
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Aug 2022 14:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345691AbiHTOEh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 20 Aug 2022 10:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344493AbiHTOEh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Aug 2022 10:04:37 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E6A25C4F
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Aug 2022 07:04:35 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id pm17so7027616pjb.3
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Aug 2022 07:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=gv8nVRUX0uussLjMEWqQWlZ7tog2GUkCRyX/I+MUqJE=;
        b=P9ssHn4OPE9nPiau4tnmgDhaVsLU1HQAknf9X6MP7UUZEb7KEcbb7eAwIxOLpkKvng
         6WtPpvzszypVm1T8opxBCmjyBJNjb9eklbtaZfmlliSXI2Ev+1Q2QY5ihylQlauM39BC
         mm7PXfsEjyxy738XP/6TtRnsne46TD8hS8qMqdn3pIFVaqXvvFvqAkKmKY/Jtl7RwWWS
         +X4rfvqMyvXsBQYJ5j6nDa2rAqM9x9b6ocNca1xLB4Lv/jylJGdPxwg+7JL78lCBiTqf
         gEsOKSHxmugYhvCFU+aEzTugmO/m7znlqk/D4Yiqi+6kkOEf6/8kZgaOWmkKvgy/AJqM
         SVnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=gv8nVRUX0uussLjMEWqQWlZ7tog2GUkCRyX/I+MUqJE=;
        b=ZhixYessDgrqp9Aa6nVKAtSZsscVmwnqbefKX8n+MjflWO+sAB3S4nDoYf8EvtrFKp
         0Py6R8xfZzpmyQjHvlrYZM89Y2Pty32qIKc2kk5eoXgRriF0UDkYlL1+ujJ1B75DYfet
         kf9iKTQHWZSBlhEaxEDG8ue7i7ehyNOrneNISwjZb3BnM+RI4pOEVBWbIdK/nKHo9M2z
         3BQeVJ2/MhSjqrSALID2sJm32CtoXcqxyXyTDDZUb5lXk8OyvaEXhGKIqRPTyRFTeL5J
         wz/ogcP6p7ujKp6pf2yfPB1IcVwt1Q3LkyriOEGsZ5uWoEBm7XBtIREGEsKbbsL0mb/V
         jVcQ==
X-Gm-Message-State: ACgBeo2AwmhUFccJ97dVPAQM7u6BElC5M//+of6br+nwO5MQtLSuxjn1
        ri9H24VJcMZGwjmjCJUHXfRZ1lZewQ8QcxzAND3i3pKkfan1W05cqdY=
X-Google-Smtp-Source: AA6agR6U0caM2gyCvoEj2zXGUo+LXv+U+NALCZY6AxKQqj/OUGWV14Lyby6qpkyKBApII3lIQLSjLNRucDE7SaCee1o=
X-Received: by 2002:a17:902:da92:b0:16e:f4a4:9f93 with SMTP id
 j18-20020a170902da9200b0016ef4a49f93mr12017946plx.27.1661004274542; Sat, 20
 Aug 2022 07:04:34 -0700 (PDT)
MIME-Version: 1.0
From:   Shell Chen <xierch@gmail.com>
Date:   Sat, 20 Aug 2022 22:04:22 +0800
Message-ID: <CAAqMkDxLzFZ9YT-DiRh5cVQRha=JzZ+8RYcmkcn8iinrucA+GA@mail.gmail.com>
Subject: [BUG] nft_tproxy: Null pointer dereference on local-send UDP
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

It occurs when tproxy is set for any UDP packets that are sent from local.
Both IPv4 and IPv6 have the same issue. I reproduced it on at least 5.4.8,
5.19.1, and 6.0.0-rc1.

To reproduce:

1. Load nft rules:

  table inet filter {
    chain output {
      type filter hook output priority 0;
      udp dport 1234 tproxy ip to 127.0.0.1
    }
  }

2. Send UDP packet from local:

  $ dig . -p 1234

Log:

[   35.428124] BUG: kernel NULL pointer dereference, address: 00000000000000d8
[   35.428147] #PF: supervisor read access in kernel mode
[   35.428157] #PF: error_code(0x0000) - not-present page
[   35.428164] PGD 0 P4D 0
[   35.428171] Oops: 0000 [#1] PREEMPT SMP NOPTI
[   35.428179] CPU: 1 PID: 864 Comm: isc-net-0000 Not tainted
6.0.0-rc1 #1 e15cb1b777bcaea4bb9ecf9297c3d0508f7a779f
[   35.428193] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.15.0-1 04/01/2014
[   35.428204] RIP: 0010:nf_tproxy_get_sock_v4+0x175/0x300 [nf_tproxy_ipv4]
[   35.430220] Code: c1 08 44 89 e2 45 89 f8 4c 89 df 50 45 0f b7 c9
48 c7 c6 40 67 18 83 e8 39 66 4c c1 5a 59 48 89 c5 e9 e4 fe ff ff 41
0f b7 d1 <45> 8b 88 d8 00 00 00 44 89 f9 45 0f b7 c5 44 89 e6 e8 b5 b9
4f c1
[   35.430257] RSP: 0018:ffffa2ad80d0f470 EFLAGS: 00010246
[   35.430295] RAX: 0000000000000000 RBX: 0000000000000011 RCX: 000000000f02000a
[   35.430305] RDX: 000000000000ce8e RSI: ffff96abc8c01000 RDI: ffffffff83183e40
[   35.430314] RBP: ffffa2ad80d0f570 R08: 0000000000000000 R09: 000000000000ce8e
[   35.430323] R10: ffff96abca114824 R11: ffffffff83183e40 R12: 000000000f02000a
[   35.430331] R13: 000000000000d204 R14: 000000000000ce8e R15: 00000000fe00a8c0
[   35.430348] FS:  00007fe1933ff6c0(0000) GS:ffff96acf7a40000(0000)
knlGS:0000000000000000
[   35.430359] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   35.430368] CR2: 00000000000000d8 CR3: 00000001038d6000 CR4: 0000000000350ee0
[   35.430384] Call Trace:
[   35.430392]  <TASK>
[   35.430400]  nft_tproxy_eval+0x127/0x525 [nft_tproxy
8d7725141545ae8b9fb380ea47ee66df8e48f101]
[   35.430414]  ? nft_do_chain+0x19c/0x5d0 [nf_tables
a934f55f630af424ff3c14d01532077582f9f85d]
[   35.430430]  ? nft_tproxy_destroy+0x40/0x40 [nft_tproxy
8d7725141545ae8b9fb380ea47ee66df8e48f101]
[   35.430443]  nft_do_chain+0x19c/0x5d0 [nf_tables
a934f55f630af424ff3c14d01532077582f9f85d]
[   35.430465]  nft_nat_do_chain+0xa8/0x10d [nft_chain_nat
a850356582360f7dc2d2dcaf1fb11475e05f226f]
[   35.430478]  nf_nat_inet_fn+0x165/0x320 [nf_nat
0be50e0b8e30f7db00eef996b18522498e81b155]
[   35.430491]  nf_nat_ipv4_local_fn+0x4f/0x120 [nf_nat
0be50e0b8e30f7db00eef996b18522498e81b155]
[   35.430505]  nf_hook_slow+0x45/0xc0
[   35.430531]  __ip_local_out+0xe1/0x160
[   35.430540]  ? ip_output+0x130/0x130
[   35.430548]  ip_send_skb+0x22/0x90
[   35.430555]  udp_send_skb+0x154/0x350
[   35.430564]  udp_sendmsg+0xb08/0xe90
[   35.430572]  ? ip_mc_finish_output+0x1a0/0x1a0
[   35.430584]  ? sock_sendmsg+0x5c/0x70
[   35.430592]  sock_sendmsg+0x5c/0x70
[   35.430600]  ____sys_sendmsg+0x17f/0x2b0
[   35.430608]  ? copy_msghdr_from_user+0x7d/0xc0
[   35.430617]  ___sys_sendmsg+0x9a/0xe0
[   35.430627]  __sys_sendmmsg+0xe3/0x210
[   35.430638]  __x64_sys_sendmmsg+0x21/0x30
[   35.430646]  do_syscall_64+0x5f/0x90
[   35.430655]  ? do_syscall_64+0x6b/0x90
[   35.430663]  ? syscall_exit_to_user_mode+0x1b/0x40
[   35.430673]  ? do_syscall_64+0x6b/0x90
[   35.430681]  ? handle_mm_fault+0xb2/0x290
[   35.431249]  ? do_user_addr_fault+0x1e0/0x6a0
[   35.432019]  ? exc_page_fault+0x74/0x170
[   35.433697]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   35.434025] RIP: 0033:0x7fe196d0056d
[   35.434313] Code: 5d c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e
fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24
08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 03 78 0d 00 f7 d8 64 89
01 48
[   35.434901] RSP: 002b:00007fe1933fa468 EFLAGS: 00000246 ORIG_RAX:
0000000000000133
[   35.435215] RAX: ffffffffffffffda RBX: 00007fe192613018 RCX: 00007fe196d0056d
[   35.435498] RDX: 0000000000000001 RSI: 00007fe1933fa470 RDI: 0000000000000009
[   35.435776] RBP: 0000000000000001 R08: 00007fe196bff0b4 R09: 0000000000000000
[   35.436038] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fe1926130d0
[   35.436299] R13: 00007fe1933fa470 R14: 0000000000000001 R15: 00007fe19266c720
[   35.436546]  </TASK>
[   35.436806] Modules linked in: nft_tproxy nf_tproxy_ipv6
nf_tproxy_ipv4 nft_reject_inet nf_reject_ipv4 nf_reject_ipv6
nft_reject nft_limit nft_ct nft_chain_nat nf_nat nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 nf_tables nfnetlink intel_rapl_msr
intel_rapl_common kvm_amd ccp rng_core kvm irqbypass joydev
crct10dif_pclmul bochs ppdev crc32_pclmul cfg80211 ghash_clmulni_intel
mousedev drm_vram_helper aesni_intel drm_ttm_helper parport_pc e1000
psmouse intel_agp i2c_piix4 crypto_simd ttm rfkill pcspkr parport
cryptd intel_gtt mac_hid fuse qemu_fw_cfg ip_tables x_tables btrfs
blake2b_generic libcrc32c crc32c_generic xor raid6_pq serio_raw sr_mod
atkbd cdrom libps2 vivaldi_fmap ata_generic i8042 pata_acpi
crc32c_intel floppy serio ata_piix
[   35.436909] Unloaded tainted modules: edac_mce_amd():1
edac_mce_amd():1 edac_mce_amd():1 edac_mce_amd():1 edac_mce_amd():1
edac_mce_amd():1 edac_mce_amd():1 edac_mce_amd():1 pcc_cpufreq():1
edac_mce_amd():1 edac_mce_amd():1 pcc_cpufreq():1 acpi_cpufreq():1
edac_mce_amd():1 acpi_cpufreq():1 pcc_cpufreq():1 edac_mce_amd():1
pcc_cpufreq():1 edac_mce_amd():1 acpi_cpufreq():1 pcc_cpufreq():1
edac_mce_amd():1 acpi_cpufreq():1 acpi_cpufreq():1 pcc_cpufreq():1
edac_mce_amd():1 edac_mce_amd():1 acpi_cpufreq():1 pcc_cpufreq():1
acpi_cpufreq():1 pcc_cpufreq():1 pcc_cpufreq():1 acpi_cpufreq():1
acpi_cpufreq():1 pcc_cpufreq():1 pcc_cpufreq():1 acpi_cpufreq():1
pcc_cpufreq():1 acpi_cpufreq():1 pcc_cpufreq():1 acpi_cpufreq():1
pcc_cpufreq():1 acpi_cpufreq():1 acpi_cpufreq():1 pcc_cpufreq():1
acpi_cpufreq():1 pcc_cpufreq():1 acpi_cpufreq():1 bpf_preload():1
[   35.440118] CR2: 00000000000000d8
[   35.440377] ---[ end trace 0000000000000000 ]---
[   35.440627] RIP: 0010:nf_tproxy_get_sock_v4+0x175/0x300 [nf_tproxy_ipv4]
[   35.444920] Code: c1 08 44 89 e2 45 89 f8 4c 89 df 50 45 0f b7 c9
48 c7 c6 40 67 18 83 e8 39 66 4c c1 5a 59 48 89 c5 e9 e4 fe ff ff 41
0f b7 d1 <45> 8b 88 d8 00 00 00 44 89 f9 45 0f b7 c5 44 89 e6 e8 b5 b9
4f c1
[   35.445565] RSP: 0018:ffffa2ad80d0f470 EFLAGS: 00010246
[   35.445843] RAX: 0000000000000000 RBX: 0000000000000011 RCX: 000000000f02000a
[   35.446120] RDX: 000000000000ce8e RSI: ffff96abc8c01000 RDI: ffffffff83183e40
[   35.446407] RBP: ffffa2ad80d0f570 R08: 0000000000000000 R09: 000000000000ce8e
[   35.446687] R10: ffff96abca114824 R11: ffffffff83183e40 R12: 000000000f02000a
[   35.446969] R13: 000000000000d204 R14: 000000000000ce8e R15: 00000000fe00a8c0
[   35.447272] FS:  00007fe1933ff6c0(0000) GS:ffff96acf7a40000(0000)
knlGS:0000000000000000
[   35.447564] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   35.448378] CR2: 00000000000000d8 CR3: 00000001038d6000 CR4: 0000000000350ee0
