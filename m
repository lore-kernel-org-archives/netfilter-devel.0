Return-Path: <SRS0=uN83=25=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04FABC00523
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jan 2020 09:26:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAB832070E
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jan 2020 09:26:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tanaza-com.20150623.gappssmtp.com header.i=@tanaza-com.20150623.gappssmtp.com header.b="VczCDC+n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbgAHJ0b (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jan 2020 04:26:31 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34839 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727205AbgAHJ0b (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jan 2020 04:26:31 -0500
Received: by mail-wr1-f66.google.com with SMTP id g17so2584505wro.2
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Jan 2020 01:26:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tanaza-com.20150623.gappssmtp.com; s=20150623;
        h=user-agent:from:to:subject:date:message-id:mime-version;
        bh=fpZLj0FgCoNphUsBgVK4ekQ3yuUAJG0XvAUKmcuxHq8=;
        b=VczCDC+nFb+I/zgNr8us7z233u2kLhkpc0ogyD3V3jMBx3wSI8eoHnKqdzoKvOfrNV
         Zg6cE0EPNBg71cqyalFZUDZReI9u/UuCUJqYqK1vaA7bRp+YykU7JXJtqGUtstdXCNVV
         mEI/tTs2/JDOj0bbzsdJHesRF4qMKKnNMMxP6jvq195/erZpFG9+7F80i9jQa+paRVvp
         0gattfImj+Lz8dQo1j8kCpwFnsFvdh8XrwDsTKK0AcAjB2UKbf8v9OYZ58VFtZUsS819
         L7Eh5YiW2CTCXWz/47TTHvRbzgHKACR5nUEBwBjriSBu12dlTeVOmPr6qkVElMjOL8Al
         vNBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:user-agent:from:to:subject:date:message-id
         :mime-version;
        bh=fpZLj0FgCoNphUsBgVK4ekQ3yuUAJG0XvAUKmcuxHq8=;
        b=sEBx8y3ArtR52KdQPLgPDhHJ0MEUhjGlR1tsrA0cEYkS9OC/z85Pt1o9IvfdmBoxJV
         ysKPbKaouuCPkYWki+JRomOLH2cEF8I8IBaJp3ko9Co9D7TRWhLKvHok86ycTlv4g7LG
         8aDhL2IUvzXEMMw+3Tb0LyTKq2NiSWWu0XOMi8Na6SEcy0M1RO/UMTy7icah/P5B4Ak+
         HJ72zGt2bpRlJjTzkf+A6KlGBRQalRrPwAp9fBoGA7+2ZFeRU2Lkw9VGKpqpOiE9zZER
         dkByv12GMwcSSSpEHLuROAgkJc5tOTSjybHITWKUUQvYERTID0k1msl9Ds38ZD2XcU09
         Ez1g==
X-Gm-Message-State: APjAAAUwn7aEweP8dRXlN0L9ns9kWeupyrYHXzJu672p1aEU2y+Pf7Bb
        szqNdcXuDNKWg/n0Bg9+J7Ezun3aWB8=
X-Google-Smtp-Source: APXvYqwHE7p0Z7/6QMVAcmUov/NfJzuMkgZb4OF+GtbuNdR70Wj7/pFEyqhqnbSA/fsCNcWnVDc6Sg==
X-Received: by 2002:a5d:4f8e:: with SMTP id d14mr3510082wru.112.1578475589158;
        Wed, 08 Jan 2020 01:26:29 -0800 (PST)
Received: from sancho (net-2-32-63-83.cust.vodafonedsl.it. [2.32.63.83])
        by smtp.gmail.com with ESMTPSA id s15sm3525283wrp.4.2020.01.08.01.26.28
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 01:26:28 -0800 (PST)
User-agent: mu4e 1.2.0; emacs 26.3
From:   Marco Oliverio <marco.oliverio@tanaza.com>
To:     netfilter-devel@vger.kernel.org
Subject: WARN on nft_set_destroy (probably use-after-free)
Date:   Wed, 08 Jan 2020 10:26:27 +0100
Message-ID: <87h816s3i4.fsf@tanaza.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi, if nft_counter module is not loaded and I add a ruleset like
this:

table ip t {
	set set1 {
		type ether_addr
	}

	set set2 {
		type ether_addr
		size 65535
		flags dynamic
	}

	chain c {
		ether daddr @set1 add @set2 { ether daddr counter }
	}
}

the kernel WARNS about a set destroyed with set->use > 0 (trace below):

AFAIU:

the culprit rule is composed, beside others, by a lookup expression
and a dynset expression with a nested counter expression.

In nf_tables_newrule():

Lookup expression is initalized (by nf_tables_newerxpr()) and
nft_lookup_init() increments set1->use.

When dynset expression is initalized, the transaction is aborted
(because the counter nested expression requests an unloaded module and
the transaction is aborted to release the lock (in
nft_request_module()).

In aborting the transaction the set is destroyed, but the lookup
expression is not yet destroyed. It is eventually destroyed in the
nf_tables_newrule():err2 label, but it still holds a reference to the
destroyed set in priv->set and we have a use-after-free.

Regards,
Marco


 ------------[ cut here ]------------
 WARNING: CPU: 3 PID: 3456 at net/netfilter/nf_tables_api.c:3740 nft_set_destroy+0x45/0x50 [nf_tables]
 Modules linked in: nf_tables_set nf_tables nfnetlink fuse ccm intel_rapl_msr intel_rapl_common x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel iwldvm mac80211 uvcvideo nls_iso8859_1 kvm libarc4 nls>
  crc32c_intel ghash_clmulni_intel serio_raw atkbd libps2 sdhci_pci cqhci sdhci ata_piix aesni_intel libata crypto_simd mmc_core cryptd glue_helper scsi_mod xhci_pci ehci_pci xhci_hcd ehci_hcd i8042 serio i9>
 CPU: 3 PID: 3456 Comm: nft Not tainted 5.4.6-arch3-1 #1
 RIP: 0010:nft_set_destroy+0x45/0x50 [nf_tables]
 Code: e8 30 eb 83 c6 48 8b 85 80 00 00 00 48 8b b8 90 00 00 00 e8 dd 6b d7 c5 48 8b 7d 30 e8 24 dd eb c5 48 89 ef 5d e9 6b c6 e5 c5 <0f> 0b c3 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 8b 7f 10 e9 52
 RSP: 0018:ffffac4f43e53700 EFLAGS: 00010202
 RAX: 0000000000000001 RBX: ffff99d63a154d80 RCX: 0000000001f88e03
 RDX: 0000000001f88c03 RSI: ffff99d6560ef0c0 RDI: ffff99d63a101200
 RBP: ffff99d617721de0 R08: 0000000000000000 R09: 0000000000000318
 R10: 00000000f0000000 R11: 0000000000000001 R12: ffffffff880fabf0
 R13: dead000000000122 R14: dead000000000100 R15: ffff99d63a154d80
 FS:  00007ff3dbd5b740(0000) GS:ffff99d6560c0000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00001cb5de6a9000 CR3: 000000016eb6a004 CR4: 00000000001606e0
 Call Trace:
  __nf_tables_abort+0x3e3/0x6d0 [nf_tables]
  nft_request_module+0x6f/0x110 [nf_tables]
  nft_expr_type_request_module+0x28/0x50 [nf_tables]
  nf_tables_expr_parse+0x198/0x1f0 [nf_tables]
  nft_expr_init+0x3b/0xf0 [nf_tables]
  nft_dynset_init+0x1e2/0x410 [nf_tables]
  nf_tables_newrule+0x30a/0x930 [nf_tables]
  nfnetlink_rcv_batch+0x2a0/0x640 [nfnetlink]
  nfnetlink_rcv+0x125/0x171 [nfnetlink]
  netlink_unicast+0x179/0x210
  netlink_sendmsg+0x208/0x3d0
  sock_sendmsg+0x5e/0x60
  ____sys_sendmsg+0x21b/0x290
  ___sys_sendmsg+0xa3/0xf0
  __sys_sendmsg+0x81/0xd0
  do_syscall_64+0x4e/0x140
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
 RIP: 0033:0x7ff3dbfa97b7
 Code: 64 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
 RSP: 002b:00007ffeb7675098 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
 RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007ff3dbfa97b7
 RDX: 0000000000000000 RSI: 00007ffeb7676120 RDI: 0000000000000003
 RBP: 00007ffeb7676220 R08: 00007ffeb7675074 R09: 0000000000000001
 R10: 00007ff3dc165bac R11: 0000000000000246 R12: 0000000000000988
 R13: 00007ffeb76750a0 R14: 00007ffeb7676270 R15: 00007ffeb76750b0
 ---[ end trace 9f9b4db1487263a1 ]---
