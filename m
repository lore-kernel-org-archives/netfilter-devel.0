Return-Path: <SRS0=ZKiM=DX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63485C433DF
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Oct 2020 07:11:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F36AA20720
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Oct 2020 07:11:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SwFHJcr6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404369AbgJPHLg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Oct 2020 03:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394503AbgJPHLf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Oct 2020 03:11:35 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F92C061755;
        Fri, 16 Oct 2020 00:11:34 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id e18so1465161wrw.9;
        Fri, 16 Oct 2020 00:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=/MMxUJ2bI7oUA9Bs+z3A1FPipfme7cLDpY+R3EOq+9k=;
        b=SwFHJcr6Fmr+ydT1t1msx8gRZ3AdNO2vCL+MgrZG3t4RIPV2ujOUe8T89dNhgJEkFf
         Fb3e2J/XxAQGzd7TXBMegF/zDU12YQaT0ro0yJRpKmZjS1HPA7aO+CDyNcww67AzCQhl
         QOwm2j/75mtGumII1s6k5pq/FQ/HjFG7x5Hg4c0a4eXGlS4Ij9AJkV3ipXLzW1FbbndJ
         P/mPZld5PeebzSEy0tMxNJTNLInK423ux8aJzkgrbZGMuaYVkeR5MK12/V+QkQBd9JdF
         D4fv+LlG9C+I8acKgckrASNtVzfp+Z26Y3KddbgY+0u+0iOb7emBdUurbVNHfoECPJ+x
         9o6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=/MMxUJ2bI7oUA9Bs+z3A1FPipfme7cLDpY+R3EOq+9k=;
        b=LE/syYV2TTd0wy4aFLVsgfk1IadPkS8l63QWdwLZVKRBuMlJmelkbfvIIJVXcFRpO8
         +R2QaOwmM1QpM6jQ5tl+B67UdDlbPWboeeeZwtfuyc9BO/v17URMIsThJneZmxkZ1e7Z
         ePTHrJeRw8z0IMhDUV8zitpTnijiJdxSFByjDHobCj/WsfUGSr8jAxXsd2Gix6HnXZ40
         9QWumcd6ZFgeYgNNz3zwFcS9c0G9zcHXpGDxrWmxY13eyvLaaKx9L6V/lDbWt8kOzD7X
         nrRqGs2+4pcH/3edeLjEP+ogQoI/ZAibKdiJ8q2CJ0tk5HT2+PNslt2uNry8ASLeVy9/
         IWfQ==
X-Gm-Message-State: AOAM530MxCeZI8XJ7Tu7/CWnO9Ox9Y+bd0PVJkvjW8Lsgtr0b3w0gKxB
        6KApOicR/fP4P77NV3DrF51WTE6vSCdjc4Wn3V6y+Ont9wkwwsZy
X-Google-Smtp-Source: ABdhPJwH86ZJHEBGsKC2H+9yR2rEPDkFLCEftCvtupC9+xvq4TglL4Lg8T8/kifobuBUYzQOVSORDGEuiKGpa8Y51hk=
X-Received: by 2002:a5d:504a:: with SMTP id h10mr2094750wrt.85.1602832292727;
 Fri, 16 Oct 2020 00:11:32 -0700 (PDT)
MIME-Version: 1.0
From:   Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date:   Fri, 16 Oct 2020 12:11:21 +0500
Message-ID: <CABXGCsPd7Mz559CmUG0nLPGfKYZA-wp5vR8WJTd+xOOeeXEjuQ@mail.gmail.com>
Subject: [bugreport] [5.10] warning at net/netfilter/nf_tables_api.c:622
To:     Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi folks,
today I joined to testing Kernel 5.10 and see that every boot happens
this warning:

[   22.180180] ------------[ cut here ]------------
[   22.180193] WARNING: CPU: 28 PID: 1205 at
net/netfilter/nf_tables_api.c:622 nft_chain_parse_hook+0x224/0x330
[nf_tables]
[   22.180194] Modules linked in: nf_tables nfnetlink ip6table_filter
ip6_tables iptable_filter cmac bnep sunrpc vfat fat
snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio
snd_hda_codec_hdmi mt76x2u mt76x2_common mt76x02_usb iwlmvm mt76_usb
uvcvideo snd_hda_intel mt76x02_lib gspca_zc3xx snd_intel_dspcfg btusb
gspca_main videobuf2_vmalloc btrtl mt76 edac_mce_amd snd_hda_codec
btbcm videobuf2_memops btintel kvm_amd snd_usb_audio videobuf2_v4l2
snd_hda_core mac80211 kvm bluetooth snd_usbmidi_lib joydev
videobuf2_common iwlwifi snd_seq xpad snd_hwdep ff_memless videodev
snd_rawmidi snd_seq_device libarc4 eeepc_wmi snd_pcm ecdh_generic
irqbypass asus_wmi mc rapl sparse_keymap ecc snd_timer sp5100_tco
video cfg80211 wmi_bmof pcspkr snd k10temp i2c_piix4 soundcore rfkill
acpi_cpufreq binfmt_misc zram ip_tables hid_logitech_hidpp
hid_logitech_dj amdgpu iommu_v2 gpu_sched ttm drm_kms_helper
crct10dif_pclmul crc32_pclmul crc32c_intel cec drm ccp
ghash_clmulni_intel igb nvme dca nvme_core
[   22.180273]  i2c_algo_bit wmi pinctrl_amd fuse
[   22.180279] CPU: 28 PID: 1205 Comm: ebtables Not tainted
5.10.0-0.rc0.20201014gitb5fc7a89e58b.41.fc34.x86_64 #1
[   22.180281] Hardware name: System manufacturer System Product
Name/ROG STRIX X570-I GAMING, BIOS 2606 08/13/2020
[   22.180289] RIP: 0010:nft_chain_parse_hook+0x224/0x330 [nf_tables]
[   22.180292] Code: a0 14 00 00 be ff ff ff ff e8 68 82 e1 e4 85 c0
0f 85 21 fe ff ff 0f 0b bf 0a 00 00 00 e8 14 60 97 ff 84 c0 0f 84 1f
fe ff ff <0f> 0b e9 18 fe ff ff 48 85 f6 74 61 4c 89 ef e8 78 d0 ff ff
48 89
[   22.180294] RSP: 0018:ffffa9850214f780 EFLAGS: 00010202
[   22.180296] RAX: 0000000000000001 RBX: ffffa9850214f810 RCX: 0000000000000000
[   22.180297] RDX: ffffa9850214f810 RSI: 00000000ffffffff RDI: ffffffffc0851c20
[   22.180299] RBP: 0000000000000007 R08: 0000000000000001 R09: ffffa9850214f847
[   22.180300] R10: 0000000000000000 R11: 0000000000000007 R12: ffffa9850214fa88
[   22.180301] R13: ffffffffa6fdfcc0 R14: ffffa9850214fa88 R15: ffff993c5c12c800
[   22.180304] FS:  00007ff92ed99540(0000) GS:ffff993c8a200000(0000)
knlGS:0000000000000000
[   22.180305] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   22.180307] CR2: 00007ff92ed1e000 CR3: 00000007d3714000 CR4: 0000000000350ee0
[   22.180308] Call Trace:
[   22.180319]  ? __rhashtable_lookup+0x11d/0x210 [nf_tables]
[   22.180329]  nf_tables_addchain.constprop.0+0xab/0x5e0 [nf_tables]
[   22.180337]  ? nft_chain_lookup.part.0+0x12c/0x1e0 [nf_tables]
[   22.180344]  ? get_order+0x20/0x20 [nf_tables]
[   22.180350]  ? nft_chain_hash+0x30/0x30 [nf_tables]
[   22.180356]  ? nft_dump_register+0x40/0x40 [nf_tables]
[   22.180368]  nf_tables_newchain+0x54d/0x730 [nf_tables]
[   22.180376]  nfnetlink_rcv_batch+0x2a4/0x950 [nfnetlink]
[   22.180385]  ? lock_acquire+0x175/0x400
[   22.180387]  ? lock_release+0x1e7/0x400
[   22.180391]  ? cred_has_capability.isra.0+0x68/0x100
[   22.180395]  ? __nla_validate_parse+0x4f/0x8d0
[   22.180401]  nfnetlink_rcv+0x115/0x130 [nfnetlink]
[   22.180407]  netlink_unicast+0x16d/0x230
[   22.180426]  netlink_sendmsg+0x23f/0x460
[   22.180431]  sock_sendmsg+0x5e/0x60
[   22.180434]  ____sys_sendmsg+0x231/0x270
[   22.180438]  ? import_iovec+0x17/0x20
[   22.180440]  ? sendmsg_copy_msghdr+0x5c/0x80
[   22.180444]  ___sys_sendmsg+0x75/0xb0
[   22.180450]  ? cred_has_capability.isra.0+0x68/0x100
[   22.180452]  ? lock_acquire+0x175/0x400
[   22.180454]  ? lock_acquire+0x93/0x400
[   22.180457]  ? lock_release+0x1e7/0x400
[   22.180459]  ? lock_release+0x1e7/0x400
[   22.180462]  ? trace_hardirqs_on+0x1b/0xe0
[   22.180465]  ? sock_setsockopt+0xdf/0x1010
[   22.180467]  ? __local_bh_enable_ip+0x82/0xd0
[   22.180470]  ? sock_setsockopt+0xdf/0x1010
[   22.180473]  __sys_sendmsg+0x49/0x80
[   22.180480]  do_syscall_64+0x33/0x40
[   22.180483]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   22.180486] RIP: 0033:0x7ff92efdb087
[   22.180488] Code: 0c 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7
0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74
24 10
[   22.180490] RSP: 002b:00007fff54436b38 EFLAGS: 00000246 ORIG_RAX:
000000000000002e
[   22.180492] RAX: ffffffffffffffda RBX: 00007fff54436b40 RCX: 00007ff92efdb087
[   22.180494] RDX: 0000000000000000 RSI: 00007fff54437be0 RDI: 0000000000000003
[   22.180495] RBP: 00007fff544381e0 R08: 0000000000000004 R09: 000055b281bcf1d0
[   22.180496] R10: 00007fff54437bcc R11: 0000000000000246 R12: 0000000000007000
[   22.180497] R13: 0000000000000001 R14: 00007fff54436b50 R15: 00007fff54438200
[   22.180503] irq event stamp: 0
[   22.180505] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[   22.180507] hardirqs last disabled at (0): [<ffffffffa50d7683>]
copy_process+0x723/0x1c80
[   22.180509] softirqs last  enabled at (0): [<ffffffffa50d7683>]
copy_process+0x723/0x1c80
[   22.180511] softirqs last disabled at (0): [<0000000000000000>] 0x0
[   22.180512] ---[ end trace 6a0904ace1916b5d ]---

reproductivity 100% reliable on my system

$ /usr/src/kernels/`uname -r`/scripts/faddr2line
/lib/debug/lib/modules/`uname
-r`/kernel/net/netfilter/nf_tables.ko.debug nft_chain_parse_hook+0x224
nft_chain_parse_hook+0x224/0x330:
lockdep_nfnl_nft_mutex_not_held at
/usr/src/debug/kernel-20201014gitb5fc7a89e58b/linux-5.10.0-0.rc0.20201014gitb5fc7a89e58b.41.fc34.x86_64/net/netfilter/nf_tables_api.c:622
(inlined by) lockdep_nfnl_nft_mutex_not_held at
/usr/src/debug/kernel-20201014gitb5fc7a89e58b/linux-5.10.0-0.rc0.20201014gitb5fc7a89e58b.41.fc34.x86_64/net/netfilter/nf_tables_api.c:619
(inlined by) nft_chain_parse_hook at
/usr/src/debug/kernel-20201014gitb5fc7a89e58b/linux-5.10.0-0.rc0.20201014gitb5fc7a89e58b.41.fc34.x86_64/net/netfilter/nf_tables_api.c:1816

$ git blame -L 617,627 net/netfilter/nf_tables_api.c
452238e8d5ffd (Florian Westphal  2018-07-11 13:45:10 +0200 617) #endif
452238e8d5ffd (Florian Westphal  2018-07-11 13:45:10 +0200 618)
f102d66b335a4 (Florian Westphal  2018-07-11 13:45:14 +0200 619) static
void lockdep_nfnl_nft_mutex_not_held(void)
f102d66b335a4 (Florian Westphal  2018-07-11 13:45:14 +0200 620) {
f102d66b335a4 (Florian Westphal  2018-07-11 13:45:14 +0200 621) #ifdef
CONFIG_PROVE_LOCKING
f102d66b335a4 (Florian Westphal  2018-07-11 13:45:14 +0200 622)
 WARN_ON_ONCE(lockdep_nfnl_is_held(NFNL_SUBSYS_NFTABLES));
f102d66b335a4 (Florian Westphal  2018-07-11 13:45:14 +0200 623) #endif
f102d66b335a4 (Florian Westphal  2018-07-11 13:45:14 +0200 624) }
f102d66b335a4 (Florian Westphal  2018-07-11 13:45:14 +0200 625)
32537e91847a5 (Pablo Neira Ayuso 2018-03-27 11:53:05 +0200 626) static
const struct nft_chain_type *
452238e8d5ffd (Florian Westphal  2018-07-11 13:45:10 +0200 627)
nf_tables_chain_type_lookup(struct net *net, const struct nlattr *nla,

$ git show f102d66b335a4
commit f102d66b335a417d4848da9441f585695a838934
Author: Florian Westphal <fw@strlen.de>
Date:   Wed Jul 11 13:45:14 2018 +0200

    netfilter: nf_tables: use dedicated mutex to guard transactions

    Continue to use nftnl subsys mutex to protect (un)registration of
hook types,
    expressions and so on, but force batch operations to do their own
    locking.

    This allows distinct net namespaces to perform transactions in parallel.

    Signed-off-by: Florian Westphal <fw@strlen.de>
    Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
index 94767ea3a490..286fd960896f 100644
--- a/include/net/netns/nftables.h
+++ b/include/net/netns/nftables.h
@@ -7,6 +7,7 @@
 struct netns_nftables {
        struct list_head        tables;
        struct list_head        commit_list;
+       struct mutex            commit_mutex;
        unsigned int            base_seq;
        u8                      gencursor;
        u8                      validate_state;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 68436edd9cdf..c0fb2bcd30fe 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -480,12 +480,19 @@ static void nft_request_module(struct net *net,
const char *fmt, ...)
        if (WARN(ret >= MODULE_NAME_LEN, "truncated: '%s' (len %d)",
module_name, ret))
                return;

-       nfnl_unlock(NFNL_SUBSYS_NFTABLES);
+       mutex_unlock(&net->nft.commit_mutex);
        request_module("%s", module_name);
-       nfnl_lock(NFNL_SUBSYS_NFTABLES);
+       mutex_lock(&net->nft.commit_mutex);
 }
 #endif

+static void lockdep_nfnl_nft_mutex_not_held(void)
+{
+#ifdef CONFIG_PROVE_LOCKING
+       WARN_ON_ONCE(lockdep_nfnl_is_held(NFNL_SUBSYS_NFTABLES));
+#endif
+}
+
 static const struct nft_chain_type *
 nf_tables_chain_type_lookup(struct net *net, const struct nlattr *nla,

The last changes were made by Florian. That is why I invited you here,
can you clarify the situation.

Full dmesg output: https://pastebin.com/tZY3npHG

--
Best Regards,
Mike Gavrilov.
