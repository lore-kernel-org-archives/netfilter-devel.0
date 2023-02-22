Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F4BDC64EC4
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Feb 2023 06:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjBVGsv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Feb 2023 01:48:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjBVGsv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Feb 2023 01:48:51 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A862595F
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Feb 2023 22:48:49 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id o12so26748217edb.9
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Feb 2023 22:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=siS3ixfQE77apNVBJV/0UEQRRUKOsd6g91dr47nIp8U=;
        b=WzTLhpI0ZzQmEPUBu8LDAPZzevjIkYoHs3Gm9c78u6phm8aFTjCFYtG8Mb6cQKuKIl
         TltacrUPM69sfOXOX3vfbuI07KHfP01zi9/3BrKBf5JjHHLC69pVUNG4ybQ7Y0m/LfJm
         7w5MWqbA67sIKFEOIniuP19o7iaTlXvntAjQxsGPesj9qHoxe3cg2pi67m2ICjwW+TYT
         VnawOuvu+sKY4BmAPpvp7H/jQ3W2wTgBPsiXunLhgOYVxMpzZJkRNHtYAUtwZd4CGUCg
         smDyeJD1vGL8J2fs6A6wT9gauLH4Fjsxaruxd/hpnqTxpaMx5bmEqRsDN1DOPUMB7dxK
         qZag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=siS3ixfQE77apNVBJV/0UEQRRUKOsd6g91dr47nIp8U=;
        b=GUekccvod58kg2RTcXNf7rP7f5/aKTgalpx57x69W+9HabVNTCvFskheMW5hMfTEpj
         7+VfW+z3FLd/Xcf8yQ/ilS5XQJR92VKzSTD2TaW95VuDE7rXpmJu5jY7zmrvoz0qtNgv
         skSqdge92Dv0TsxD5u3JtRRhCr0Al3NOLrOCW7vr7+hlHWiNTtqOn9Uz/boLo/vNxo+/
         ocnK/wdSnpOxAQWB0LR8zZkSg6uFo9MgOC5i9kS+V8pzIshAdZh3XyyvY02DE0cRkdaP
         FIU3NbSs6qlQ76PbcJH8n1c1Rw6y9R2uAxNhvdqaEbGBokvYxzGASwj2WHvPjK/R4hLj
         3nug==
X-Gm-Message-State: AO0yUKWXBV58pKVUcjF33/JK9kgyTOdh2qGFBPIzFAPSwSNxoFEStzHr
        c8lx3eEEG/jDwi59iRumBYAOCsLOiN8ivoZCGgjrbHe50pUJqw==
X-Google-Smtp-Source: AK7set/xGKhnHLH4HmL2wu7aBElxw5L+1TawkZFACsdWTFZNn5S9w2ZDqxdKSwAh0+8dtVObuq/NpwbdGFjn4i2433U=
X-Received: by 2002:a17:907:98ce:b0:877:7480:c76b with SMTP id
 kd14-20020a17090798ce00b008777480c76bmr7253584ejc.14.1677048528098; Tue, 21
 Feb 2023 22:48:48 -0800 (PST)
MIME-Version: 1.0
From:   "Thomas S." <thomashen@gmail.com>
Date:   Tue, 21 Feb 2023 22:48:36 -0800
Message-ID: <CANEnfE+imqyiLi+5ALLjNd3xe-Vs9U680CduPCrGk7VwarV3tA@mail.gmail.com>
Subject: Kernel panic in nf_send_reset6() path
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

I=E2=80=99ve met a crash on kernel v5.4 when a v4 packet goes through a
464-clatd interface, thus converted to v6, and hits a netfilter rule
that triggers a TCP reset to be sent back.

Here is an example rule that can trigger it:

ip6tables -t filter -I zone_wan_dest_ACCEPT 1 -p tcp -j REJECT
--reject-with tcp-reset

CONFIG_BRIDGE_NETFILTER is enabled.

The crash is in skb_panic, when the code tries to add the eth header
(dev_hard_header) but finds no room available. There seems to be a
disconnect in the skb_alloc() and skb_reserve() values used in
nf_send_reset6(), plus the eth header added. Anyone able to confirm?

Thanks in advance,

Thomas


Traceback:



[   49.029989] -(2)[18620:modprobe] skb_panic+0x48/0x4c

[   49.030619] -(2)[18620:modprobe] skb_push+0x38/0x40

[   49.031238] -(2)[18620:modprobe] eth_header+0x30/0xb8

[   49.031880] -(2)[18620:modprobe] nf_send_reset6+0x234/0xc4c [nf_reject_i=
pv6]

[   49.032771] -(2)[18620:modprobe] 0xffffffc008df6084

[   49.033389] -(2)[18620:modprobe] ip6t_do_table+0x398/0x820 [ip6_tables]

[   49.034223] -(2)[18620:modprobe] 0xffffffc008e0a054

[   49.034841] -(2)[18620:modprobe] nf_hook_slow+0x40/0xbc

[   49.035502] -(2)[18620:modprobe] nf_hook.constprop.0+0x64/0x90

[   49.036238] -(2)[18620:modprobe] ip6_forward+0x710/0x7b4

[   49.036909] -(2)[18620:modprobe] ip6_rcv_finish+0x34/0x48
