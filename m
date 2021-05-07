Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A92BFC433B4
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 May 2021 09:26:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 666556144F
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 May 2021 09:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbhEGJ1y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 May 2021 05:27:54 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:34708 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236023AbhEGJ1y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 May 2021 05:27:54 -0400
Received: by mail-wr1-f42.google.com with SMTP id t18so8468723wry.1
        for <netfilter-devel@vger.kernel.org>; Fri, 07 May 2021 02:26:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language;
        bh=7CVTkWwx/9/NznxAVpD229X02vyLGmc3hYATglYHe8c=;
        b=G73eiLfHHOWv3uw++QKoqNMQ/R4elJg0KmySbagVxzhvc08R5c8gKptEUkhNH1zUsr
         87gzBchVg074as79Xd3D6vc7kQM5M7UpQ27+0yH8mUMqBfTRIx5wrh2sfqCs7x9atSKk
         AJ1IWfPh/x7XRI1OJu4/AxpjGBEGgxdDUAWsTIw6RBAGjwKKkbEyxfnx6BoHFSj0v4np
         sEUvR0738Uzsh9KMdNq/NHFXYeFEllwf9/ybNPG69F9egdgdWo+MxRmxbr4bBDsdZ+BJ
         QrsrwZNIkb0Ws29v19MiNAtjdf99Uo653Vgom+ltHGlXfatJ6x9/hR1NRhOu39fbJBEM
         Fy8Q==
X-Gm-Message-State: AOAM530FwYr2S/yBdpXjnkve3L1MyPCO3p8BFcxtPmlxJnzuWP6ZsyGQ
        mfziTzr4SyJQzUb+tagieXrzqkIB1BPf3g==
X-Google-Smtp-Source: ABdhPJyKOm5evNC9nuWG6sgXGz9UgahlJ85CxPXq4CRJ6084VQMLICOgX45rBhuWlBUJuprUOhKBgA==
X-Received: by 2002:a5d:6386:: with SMTP id p6mr10948808wru.36.1620379612788;
        Fri, 07 May 2021 02:26:52 -0700 (PDT)
Received: from [10.239.43.214] (79.red-80-24-233.staticip.rima-tde.net. [80.24.233.79])
        by smtp.gmail.com with ESMTPSA id p10sm8286727wre.84.2021.05.07.02.26.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 02:26:52 -0700 (PDT)
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Cc:     Stefano Brivio <sbrivio@redhat.com>
Subject: nft_pipapo_avx2_lookup backtrace in linux 5.10
Message-ID: <8ff71ad7-7171-c8c7-f31b-d4bd7577cc18@netfilter.org>
Date:   Fri, 7 May 2021 11:26:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------9040B69D02B4E6D6504F4998"
Content-Language: en-US
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a multi-part message in MIME format.
--------------9040B69D02B4E6D6504F4998
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi there,

I got this backtrace in one of my servers. I wonder if it is known or fixed 
already in a later version.

My versions:
* kernel 5.10.24
* nft 0.9.6

Also, find attached the ruleset that triggered this.

[Thu May  6 16:20:21 2021] ------------[ cut here ]------------
[Thu May  6 16:20:21 2021] WARNING: CPU: 3 PID: 456 at 
arch/x86/kernel/fpu/core.c:129 kernel_fpu_begin_mask+0xc9/0xe0
[Thu May  6 16:20:21 2021] Modules linked in: binfmt_misc nft_nat nft_chain_nat 
nf_nat nft_counter nft_ct nf_tables nf_conntrack_netlink nfnetlink 8021q garp 
stp mrp llc vrf intel_rapl_msr intel_rapl_common skx_edac nfit libnvdimm 
ipmi_ssif x86_pkg_temp_thermal intel_powerclamp coretemp crc32_pclmul mgag200 
ghash_clmulni_intel drm_kms_helper cec aesni_intel drm libaes crypto_simd cryptd 
glue_helper mei_me dell_smbios iTCO_wdt evdev intel_pmc_bxt iTCO_vendor_support 
dcdbas pcspkr rapl dell_wmi_descriptor wmi_bmof sg i2c_algo_bit watchdog mei 
acpi_ipmi ipmi_si button nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ipmi_devintf 
ipmi_msghandler ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 dm_mod raid10 
raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor sd_mod 
t10_pi crc_t10dif crct10dif_generic raid6_pq libcrc32c crc32c_generic raid1 
raid0 multipath linear md_mod ahci libahci tg3 libata xhci_pci libphy xhci_hcd 
ptp usbcore crct10dif_pclmul crct10dif_common bnxt_en crc32c_intel scsi_mod
[Thu May  6 16:20:21 2021]  pps_core i2c_i801 lpc_ich i2c_smbus wmi usb_common
[Thu May  6 16:20:21 2021] CPU: 3 PID: 456 Comm: jbd2/dm-0-8 Tainted: G        W 
         5.10.0-0.bpo.5-amd64 #1 Debian 5.10.24-1~bpo10+1
[Thu May  6 16:20:21 2021] Hardware name: Dell Inc. PowerEdge R440/04JN2K, BIOS 
2.9.3 09/23/2020
[Thu May  6 16:20:21 2021] RIP: 0010:kernel_fpu_begin_mask+0xc9/0xe0
[Thu May  6 16:20:21 2021] Code: c4 10 5b c3 65 8a 05 5e 21 5e 76 84 c0 74 92 0f 
0b eb 8e f0 80 4f 01 40 48 81 c7 00 14 00 00 e8 dd fb ff ff eb a5 db e3 eb c4 
<0f> 0b e9 7b ff ff ff e8 2b 8a 84 00 66 66 2e 0f 1f 84 00 00 00 00
[Thu May  6 16:20:21 2021] RSP: 0018:ffffbb9700304740 EFLAGS: 00010202
[Thu May  6 16:20:21 2021] RAX: 0000000000000001 RBX: 0000000000000003 RCX: 
0000000000000001
[Thu May  6 16:20:21 2021] RDX: ffffbb9700304970 RSI: ffff922fe1952e00 RDI: 
0000000000000003
[Thu May  6 16:20:21 2021] RBP: ffffbb9700304970 R08: ffff922fc868a600 R09: 
ffff922fc711e462
[Thu May  6 16:20:21 2021] R10: 000000000000005f R11: ffff922ff0b27180 R12: 
ffffbb9700304960
[Thu May  6 16:20:21 2021] R13: ffffbb9700304b08 R14: ffff922fc664b6c8 R15: 
ffff922fc664b660
[Thu May  6 16:20:21 2021] FS:  0000000000000000(0000) GS:ffff92371fec0000(0000) 
knlGS:0000000000000000
[Thu May  6 16:20:21 2021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Thu May  6 16:20:21 2021] CR2: 0000557a6655bdd0 CR3: 000000026020a001 CR4: 
00000000007706e0
[Thu May  6 16:20:21 2021] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[Thu May  6 16:20:21 2021] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[Thu May  6 16:20:21 2021] PKRU: 55555554
[Thu May  6 16:20:21 2021] Call Trace:
[Thu May  6 16:20:21 2021]  <IRQ>
[Thu May  6 16:20:21 2021]  nft_pipapo_avx2_lookup+0x4c/0x1cba [nf_tables]
[Thu May  6 16:20:21 2021]  ? sched_clock+0x5/0x10
[Thu May  6 16:20:21 2021]  ? sched_clock_cpu+0xc/0xb0
[Thu May  6 16:20:21 2021]  ? record_times+0x16/0x80
[Thu May  6 16:20:21 2021]  ? plist_add+0xc1/0x100
[Thu May  6 16:20:21 2021]  ? psi_group_change+0x47/0x230
[Thu May  6 16:20:21 2021]  ? skb_clone+0x4d/0xb0
[Thu May  6 16:20:21 2021]  ? enqueue_task_rt+0x22b/0x310
[Thu May  6 16:20:21 2021]  ? bnxt_start_xmit+0x1e8/0xaf0 [bnxt_en]
[Thu May  6 16:20:21 2021]  ? packet_rcv+0x40/0x4a0
[Thu May  6 16:20:21 2021]  nft_lookup_eval+0x59/0x160 [nf_tables]
[Thu May  6 16:20:21 2021]  nft_do_chain+0x350/0x500 [nf_tables]
[Thu May  6 16:20:21 2021]  ? nft_lookup_eval+0x59/0x160 [nf_tables]
[Thu May  6 16:20:21 2021]  ? nft_do_chain+0x364/0x500 [nf_tables]
[Thu May  6 16:20:21 2021]  ? fib4_rule_action+0x6d/0x80
[Thu May  6 16:20:21 2021]  ? fib_rules_lookup+0x107/0x250
[Thu May  6 16:20:21 2021]  nft_nat_do_chain+0x8a/0xf2 [nft_chain_nat]
[Thu May  6 16:20:21 2021]  nf_nat_inet_fn+0xea/0x210 [nf_nat]
[Thu May  6 16:20:21 2021]  nf_nat_ipv4_out+0x14/0xa0 [nf_nat]
[Thu May  6 16:20:21 2021]  nf_hook_slow+0x44/0xc0
[Thu May  6 16:20:21 2021]  ip_output+0xd2/0x100
[Thu May  6 16:20:21 2021]  ? __ip_finish_output+0x210/0x210
[Thu May  6 16:20:21 2021]  ip_forward+0x37d/0x4a0
[Thu May  6 16:20:21 2021]  ? ip4_key_hashfn+0xb0/0xb0
[Thu May  6 16:20:21 2021]  ip_sublist_rcv_finish+0x4f/0x60
[Thu May  6 16:20:21 2021]  ip_sublist_rcv+0x196/0x220
[Thu May  6 16:20:21 2021]  ? ip_rcv_finish_core.isra.22+0x400/0x400
[Thu May  6 16:20:21 2021]  ip_list_rcv+0x137/0x160
[Thu May  6 16:20:21 2021]  __netif_receive_skb_list_core+0x29b/0x2c0
[Thu May  6 16:20:21 2021]  netif_receive_skb_list_internal+0x1a6/0x2d0
[Thu May  6 16:20:21 2021]  gro_normal_list.part.156+0x19/0x40
[Thu May  6 16:20:21 2021]  napi_complete_done+0x67/0x170
[Thu May  6 16:20:21 2021]  bnxt_poll+0x105/0x190 [bnxt_en]
[Thu May  6 16:20:21 2021]  ? irqentry_exit+0x29/0x30
[Thu May  6 16:20:21 2021]  ? asm_common_interrupt+0x1e/0x40
[Thu May  6 16:20:21 2021]  net_rx_action+0x144/0x3c0
[Thu May  6 16:20:21 2021]  __do_softirq+0xd5/0x29c
[Thu May  6 16:20:21 2021]  asm_call_irq_on_stack+0xf/0x20
[Thu May  6 16:20:21 2021]  </IRQ>
[Thu May  6 16:20:21 2021]  do_softirq_own_stack+0x37/0x40
[Thu May  6 16:20:21 2021]  irq_exit_rcu+0x9d/0xa0
[Thu May  6 16:20:21 2021]  common_interrupt+0x78/0x130
[Thu May  6 16:20:21 2021]  asm_common_interrupt+0x1e/0x40
[Thu May  6 16:20:21 2021] RIP: 0010:crc_41+0x0/0x1e [crc32c_intel]
[Thu May  6 16:20:21 2021] Code: ff ff f2 4d 0f 38 f1 93 a8 fe ff ff f2 4c 0f 38 
f1 81 b0 fe ff ff f2 4c 0f 38 f1 8a b0 fe ff ff f2 4d 0f 38 f1 93 b0 fe ff ff 
<f2> 4c 0f 38 f1 81 b8 fe ff ff f2 4c 0f 38 f1 8a b8 fe ff ff f2 4d
[Thu May  6 16:20:21 2021] RSP: 0018:ffffbb97008dfcd0 EFLAGS: 00000246
[Thu May  6 16:20:21 2021] RAX: 000000000000002a RBX: 0000000000000400 RCX: 
ffff922fc591dd50
[Thu May  6 16:20:21 2021] RDX: ffff922fc591dea0 RSI: 0000000000000a14 RDI: 
ffffffffc00dddc0
[Thu May  6 16:20:21 2021] RBP: 0000000000001000 R08: 000000000342d8c3 R09: 
0000000000000000
[Thu May  6 16:20:21 2021] R10: 0000000000000000 R11: ffff922fc591dff0 R12: 
ffffbb97008dfe58
[Thu May  6 16:20:21 2021] R13: 000000000000000a R14: ffff922fd2b91e80 R15: 
ffff922fef83fe38
[Thu May  6 16:20:21 2021]  ? crc_43+0x1e/0x1e [crc32c_intel]
[Thu May  6 16:20:21 2021]  ? crc32c_pcl_intel_update+0x97/0xb0 [crc32c_intel]
[Thu May  6 16:20:21 2021]  ? jbd2_journal_commit_transaction+0xaec/0x1a30 [jbd2]
[Thu May  6 16:20:21 2021]  ? irq_exit_rcu+0x3e/0xa0
[Thu May  6 16:20:21 2021]  ? kjournald2+0xbd/0x270 [jbd2]
[Thu May  6 16:20:21 2021]  ? finish_wait+0x80/0x80
[Thu May  6 16:20:21 2021]  ? commit_timeout+0x10/0x10 [jbd2]
[Thu May  6 16:20:21 2021]  ? kthread+0x116/0x130
[Thu May  6 16:20:21 2021]  ? kthread_park+0x80/0x80
[Thu May  6 16:20:21 2021]  ? ret_from_fork+0x1f/0x30
[Thu May  6 16:20:21 2021] ---[ end trace 081a19978e5f09f6 ]---
[Thu May  6 16:20:21 2021] ------------[ cut here ]------------

--------------9040B69D02B4E6D6504F4998
Content-Type: text/plain; charset=UTF-8;
 name="ruleset.nft"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="ruleset.nft"

ZGVmaW5lIHJvdXRpbmdfc291cmNlX2lwICAgPSAxODUuMTUuNTYuMQpkZWZpbmUgdmlydHVh
bF9zdWJuZXRfY2lkciA9IDE3Mi4xNi4wLjAvMjEKZGVmaW5lIG5pY19ob3N0ID0gImVuczJm
MG5wMCIKZGVmaW5lIG5pY192aXJ0ID0gImVuczJmMW5wMS4xMTA3IgpkZWZpbmUgbmljX3dh
biA9ICJlbnMyZjFucDEuMTEyMCIKCnRhYmxlIGluZXQgY2xvdWRndyB7CiAgICBzZXQgZG16
X2NpZHJfc2V0IHsKICAgICAgICB0eXBlIGlwdjRfYWRkciAuIGlwdjRfYWRkcgogICAgICAg
IGZsYWdzIGludGVydmFsCiAgICAgICAgY291bnRlcgogICAgICAgIGVsZW1lbnRzID0gewog
ICAgICAgICAgICAgICAgICAgIDE3Mi4xNi4wLjAvMjEgLiAyMDguODAuMTU0LjIyNCAsCiAg
ICAgICAgICAgICAgICAgICAgMTcyLjE2LjAuMC8yMSAuIDIwOC44MC4xNTQuMjQwICwKICAg
ICAgICAgICAgICAgICAgICAxNzIuMTYuMC4wLzIxIC4gMjA4LjgwLjE1My4yMjQgLAogICAg
ICAgICAgICAgICAgICAgIDE3Mi4xNi4wLjAvMjEgLiAyMDguODAuMTUzLjI0MCAsCiAgICAg
ICAgICAgICAgICAgICAgMTcyLjE2LjAuMC8yMSAuIDE5OC4zNS4yNi45NiAsCiAgICAgICAg
ICAgICAgICAgICAgMTcyLjE2LjAuMC8yMSAuIDE5OC4zNS4yNi4xMTIgLAogICAgICAgICAg
ICAgICAgICAgIDE3Mi4xNi4wLjAvMjEgLiAxMDMuMTAyLjE2Ni4yMjQgLAogICAgICAgICAg
ICAgICAgICAgIDE3Mi4xNi4wLjAvMjEgLiAxMDMuMTAyLjE2Ni4yNDAgLAogICAgICAgICAg
ICAgICAgICAgIDE3Mi4xNi4wLjAvMjEgLiA5MS4xOTguMTc0LjE5MiAsCiAgICAgICAgICAg
ICAgICAgICAgMTcyLjE2LjAuMC8yMSAuIDkxLjE5OC4xNzQuMjA4ICwKICAgICAgICAgICAg
ICAgICAgICAxNzIuMTYuMC4wLzIxIC4gMjA4LjgwLjE1NC4yNCAsCiAgICAgICAgICAgICAg
ICAgICAgMTcyLjE2LjAuMC8yMSAuIDIwOC44MC4xNTQuMTQzICwKICAgICAgICAgICAgICAg
ICAgICAxNzIuMTYuMC4wLzIxIC4gMjA4LjgwLjE1My4xMTggLAogICAgICAgICAgICAgICAg
ICAgIDE3Mi4xNi4wLjAvMjEgLiAyMDguODAuMTUzLjc4ICwKICAgICAgICAgICAgICAgICAg
ICAxNzIuMTYuMC4wLzIxIC4gMjA4LjgwLjE1My4xMDcgLAogICAgICAgICAgICAgICAgICAg
IDE3Mi4xNi4wLjAvMjEgLiAyMDguODAuMTU0LjEzNyAsCiAgICAgICAgICAgICAgICAgICAg
MTcyLjE2LjAuMC8yMSAuIDIwOC44MC4xNTQuMzAgLAogICAgICAgICAgICAgICAgICAgIDE3
Mi4xNi4wLjAvMjEgLiAyMDguODAuMTUzLjQyICwKICAgICAgICAgICAgICAgICAgICAxNzIu
MTYuMC4wLzIxIC4gMjA4LjgwLjE1NC4xNSAsCiAgICAgICAgICAgICAgICAgICAgMTcyLjE2
LjAuMC8yMSAuIDIwOC44MC4xNTQuMjMgLAogICAgICAgICAgICAgICAgICAgIDE3Mi4xNi4w
LjAvMjEgLiAyMDguODAuMTU0LjEzMiAsCiAgICAgICAgICAgICAgICAgICAgMTcyLjE2LjAu
MC8yMSAuIDIwOC44MC4xNTQuODUgLAogICAgICAgICAgICAgICAgICAgIDE3Mi4xNi4wLjAv
MjEgLiAyMDguODAuMTUzLjU5ICwKICAgICAgICAgICAgICAgICAgICAxNzIuMTYuMC4wLzIx
IC4gMjA4LjgwLjE1My43NSAsCiAgICAgICAgICAgICAgICAgICAgMTcyLjE2LjAuMC8yMSAu
IDIwOC44MC4xNTMuMTE2ICwKICAgICAgICAgICAgICAgICAgICAxNzIuMTYuMC4wLzIxIC4g
MjA4LjgwLjE1My4xNSAsCiAgICAgICAgICAgICAgICAgICAgMTcyLjE2LjAuMC8yMSAuIDIw
OC44MC4xNTQuMjUyICwKICAgICAgICAgICAgICAgICAgICAxNzIuMTYuMC4wLzIxIC4gMjA4
LjgwLjE1My4yNTIgLAogICAgICAgICAgICAgICAgICAgIDE3Mi4xNi4wLjAvMjEgLiAyMDgu
ODAuMTU1LjExOSAsCiAgICAgICAgICAgICAgICAgICAgMTcyLjE2LjAuMC8yMSAuIDIwOC44
MC4xNTUuMTI2ICwKICAgICAgICAgICAgICAgICAgICAxNzIuMTYuMC4wLzIxIC4gMjA4Ljgw
LjE1NS4xMjUgLAogICAgICAgICAgICAgICAgICAgIDE3Mi4xNi4wLjAvMjEgLiAxMC42NC4z
Ny4xOC8zMiAsCiAgICAgICAgICAgICAgICAgICAgMTcyLjE2LjAuMC8yMSAuIDEwLjY0LjM3
LjI4LzMyICwKICAgICAgICAgICAgICAgICAgICAxNzIuMTYuMC4wLzIxIC4gMTAuNjQuMzcu
MjcvMzIgLAogICAgICAgICAgICAgICAgICAgIDE3Mi4xNi4wLjAvMjEgLiAxMC42NC4zNy4x
My8zMiAsCiAgICAgICAgICAgICAgICAgICAgMTcyLjE2LjAuMC8yMSAuIDEwLjY0LjQuMTUv
MzIgLAogICAgICAgICAgICAgICAgfQogICAgfQoKICAgIGNoYWluIHByZXJvdXRpbmcgewog
ICAgICAgIHR5cGUgbmF0IGhvb2sgcHJlcm91dGluZyBwcmlvcml0eSBkc3RuYXQ7IHBvbGlj
eSBhY2NlcHQ7CiAgICB9CgogICAgY2hhaW4gcG9zdHJvdXRpbmcgewogICAgICAgIHR5cGUg
bmF0IGhvb2sgcG9zdHJvdXRpbmcgcHJpb3JpdHkgc3JjbmF0OyBwb2xpY3kgYWNjZXB0OwoK
ICAgICAgICBpcCBzYWRkciAuIGlwIGRhZGRyIEBkbXpfY2lkcl9zZXQgY291bnRlciBhY2Nl
cHQgY29tbWVudCAiZG16X2NpZHIiCiAgICAgICAgaXAgc2FkZHIgJHZpcnR1YWxfc3VibmV0
X2NpZHIgY291bnRlciBzbmF0IGlwIHRvICRyb3V0aW5nX3NvdXJjZV9pcCBjb21tZW50ICJy
b3V0aW5nX3NvdXJjZV9pcCIKICAgIH0KCiAgICBjaGFpbiBmb3J3YXJkIHsKICAgICAgICB0
eXBlIGZpbHRlciBob29rIGZvcndhcmQgcHJpb3JpdHkgZmlsdGVyOyBwb2xpY3kgZHJvcDsK
ICAgICAgICAjIG9ubHkgZm9yd2FyZCBwYWNrZXRzIGluIHRoZSBWUkYKICAgICAgICBpaWZu
YW1lICJ2cmYtY2xvdWRndyIgb2lmbmFtZSB7ICRuaWNfdmlydCwgJG5pY193YW4gfSBjb3Vu
dGVyIGFjY2VwdAogICAgICAgIGNvdW50ZXIgY29tbWVudCAiY291bnRlciBkcm9wcGVkIHBh
Y2tldHMiCiAgICB9Cn0K
--------------9040B69D02B4E6D6504F4998--
