Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BDD2C4708D
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Jan 2023 15:24:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjAFPYE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Jan 2023 10:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233812AbjAFPXu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Jan 2023 10:23:50 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B4F45649;
        Fri,  6 Jan 2023 07:23:48 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id bi26-20020a05600c3d9a00b003d3404a89faso3862438wmb.1;
        Fri, 06 Jan 2023 07:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:in-reply-to:to:references:date:subject:mime-version
         :content-transfer-encoding:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VbT9pMUaSCmN3XabeekxLiKw6la9cHdMDU5rqXhfx3w=;
        b=Qc9vMHprdRN1AB/k+9J7m8vxDC/YjIJnZ+3okfTBRSWz8dLDkTSjUpf62+Cj6YdWcz
         Vw3dnqhJUu7MkxhTgMAzBqySzK57ysUpLBGd433EDZp3jFLV5jgdHHS/cj5Mwp9vYU6d
         ARsFrhzvjSwZDkW5oBjutHXQj5GXwYdpEXUNa7QPz9a7ojbPAmh4uMMYy+sIgYpSxybI
         uPBPEmY6ECB4hso0oyC6QK1fgzJCCy+Zakgr6BYfCBzYM85JlrtHdBJ5ptczmy1mEwzU
         Iv0NTcga1+yy5zwKxnIx3p6Dsa9cy1JMo7yw0iPZvvoyLw+JL7RFu7XOEVN5oNB0Yc23
         r8Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:in-reply-to:to:references:date:subject:mime-version
         :content-transfer-encoding:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VbT9pMUaSCmN3XabeekxLiKw6la9cHdMDU5rqXhfx3w=;
        b=3Lwn+6aitoSOHlvKagi0+2kYuZC4m/LYMadShCya/Uu2d6bVFF08DqgERA3ItVPkXT
         yP/WecQ5gl/EJ4SXX3cGnjdUeyKQ9zqzT/cgMzSEvGXqegOfDnpQgeSwpP5KSBVJU8zj
         nlIjpDrU5Ya16GMoZcmQ1JtyWY+VFv+BLTxykiBxx5c6tAv+OwRf9ZILkueWmpbb1vqw
         hj4USGtzluQuq4xboTbgp20YAVv0NukyOBA5N9ShVyXW2WOBI7ZtLH/DlF+nM1uKGs/e
         yOk8uccij92m/bJeI8hSQW2fCjTKY3vi/cIG7K3T0snh2k4Uo3dNSZhygaLbmALOjPZV
         s2Vw==
X-Gm-Message-State: AFqh2kp2mdkRTrIrDJkWvxU5wsTfNnBYfuQaWLunwLq4jxjLAiVSd+BN
        9Rpd1PyYkvLdmbw6DjNIrGYNE4E/v9A=
X-Google-Smtp-Source: AMrXdXtLnbuCROyVf6TS2d7qv6UOVXR90zyjBlW7VYyijEBDaultsppbWfKJN3Lf45zv0Fu5qlv8qw==
X-Received: by 2002:a05:600c:4854:b0:3d3:5a4a:90ff with SMTP id j20-20020a05600c485400b003d35a4a90ffmr41959659wmo.23.1673018627299;
        Fri, 06 Jan 2023 07:23:47 -0800 (PST)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id m5-20020a056000024500b00267bcb1bbe5sm1501125wrz.56.2023.01.06.07.23.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Jan 2023 07:23:46 -0800 (PST)
From:   Martin Zaharinov <micron10@gmail.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [nft] src: allow for updating devices on existing netdev chain -
 Test result
Date:   Fri, 6 Jan 2023 17:23:45 +0200
References: <DD658C3B-2FB9-451E-893C-EE37ABDC678A@gmail.com>
To:     pablo@netfilter.org, netfilter <netfilter@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
In-Reply-To: <DD658C3B-2FB9-451E-893C-EE37ABDC678A@gmail.com>
Message-Id: <72087908-1387-4D9F-A4D1-7DC5C276155E@gmail.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

And one more this is BUG in delete :=20

When run delete :=20
for i in `seq 2 9999`; do nft delete  chain netdev x int$i '{ devices =3D =
{ ppp0 }; }'; done



Jan  6 16:19:20 78.142.32.70 [ 2982.211837][T21662] BUG: kernel NULL =
pointer dereference, address: 0000000000000000
Jan  6 16:19:20 78.142.32.70 [ 2982.212414][T21662] #PF: supervisor =
write access in kernel mode
Jan  6 16:19:20 78.142.32.70 [ 2982.212858][T21662] #PF: =
error_code(0x0002) - not-present page
Jan  6 16:19:20 78.142.32.70 [ 2982.213285][T21662] PGD 132f8d067 P4D =
132f8d067 PUD 101afe067 PMD 0
Jan  6 16:19:20 78.142.32.70 [ 2982.213751][T21662] Oops: 0002 [#1] SMP
Jan  6 16:19:20 78.142.32.70 [ 2982.214048][T21662] CPU: 5 PID: 21662 =
Comm: nft Tainted: G           O       6.1.3 #1
Jan  6 16:19:20 78.142.32.70 [ 2982.214609][T21662] Hardware name: QEMU =
Standard PC (Q35 + ICH9, 2009), BIOS =
rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
Jan  6 16:19:20 78.142.32.70 [ 2982.215479][T21662] RIP: =
0010:nf_tables_fill_chain_info+0x57a/0x590 [nf_tables]
Jan  6 16:19:20 78.142.32.70 [ 2982.216026][T21662] Code: 48 89 df e8 58 =
19 e9 f6 85 c0 0f 84 48 fe ff ff e9 d0 fd ff ff 8b 83 b4 00 00 00 48 8b =
7c 24 18 48 03 83 c0 00 00 00 48 29 f8 <66> 89 07 e9 26 fe ff ff 0f 0b =
e9 bc fd ff ff 0f 1f 80 00 00 00 00
Jan  6 16:19:20 78.142.32.70 [ 2982.217400][T21662] RSP: =
0018:ffffb1c247b3fb48 EFLAGS: 00010286
Jan  6 16:19:20 78.142.32.70 [ 2982.217836][T21662] RAX: =
ffff90e372777ec0 RBX: ffff90e37c725300 RCX: 0000000000000000
Jan  6 16:19:20 78.142.32.70 [ 2982.218399][T21662] RDX: =
0000000000000000 RSI: 0000000000000004 RDI: 0000000000000000
Jan  6 16:19:20 78.142.32.70 [ 2982.218970][T21662] RBP: =
ffff90e372777e78 R08: 0000000000000009 R09: ffff90e372777ec0
Jan  6 16:19:20 78.142.32.70 [ 2982.219180][T21662] R10: =
0000000000008000 R11: 0000000000000008 R12: ffff90e341bbb350
Jan  6 16:19:20 78.142.32.70 [ 2982.219180][T21662] R13: =
0000000000000000 R14: ffff90e372777ec0 R15: ffff90e341bbb328
Jan  6 16:19:20 78.142.32.70 [ 2982.220416][T21662] FS:  =
00007f43e82f2740(0000) GS:ffff90e3bbd40000(0000) knlGS:0000000000000000
Jan  6 16:19:20 78.142.32.70 [ 2982.220416][T21662] CS:  0010 DS: 0000 =
ES: 0000 CR0: 0000000080050033
Jan  6 16:19:20 78.142.32.70 [ 2982.220416][T21662] CR2: =
0000000000000000 CR3: 000000010020e000 CR4: 00000000003506e0
Jan  6 16:19:20 78.142.32.70 [ 2982.220416][T21662] Call Trace:
Jan  6 16:19:20 78.142.32.70 [ 2982.223811][T21662]  <TASK>
Jan  6 16:19:20 78.142.32.70 [ 2982.223811][T21662]  =
nf_tables_dump_chains+0x103/0x1b0 [nf_tables]
Jan  6 16:19:20 78.142.32.70 [ 2982.223811][T21662]  =
netlink_dump+0x181/0x470
Jan  6 16:19:20 78.142.32.70 [ 2982.223811][T21662]  =
netlink_recvmsg+0x21d/0x320
Jan  6 16:19:20 78.142.32.70 [ 2982.223811][T21662]  =
____sys_recvmsg+0x6d/0x150
Jan  6 16:19:20 78.142.32.70 [ 2982.223811][T21662]  ? =
__mod_lruvec_state+0x56/0xa0
Jan  6 16:19:20 78.142.32.70 [ 2982.223811][T21662]  ? =
_copy_from_user+0x3f/0x60
Jan  6 16:19:20 78.142.32.70 [ 2982.227253][T21662]  ? =
iovec_from_user.part.0+0x48/0x170
Jan  6 16:19:20 78.142.32.70 [ 2982.227253][T21662]  ? =
page_add_new_anon_rmap+0x94/0x100
Jan  6 16:19:20 78.142.32.70 [ 2982.227253][T21662]  =
__x64_sys_recvmsg+0x17d/0x1f0
Jan  6 16:19:20 78.142.32.70 [ 2982.227253][T21662]  ? =
__handle_mm_fault+0x7bc/0x810
Jan  6 16:19:20 78.142.32.70 [ 2982.227253][T21662]  ? =
handle_mm_fault+0x233/0x380
Jan  6 16:19:20 78.142.32.70 [ 2982.227253][T21662]  ? =
do_user_addr_fault+0x16a/0x540
Jan  6 16:19:20 78.142.32.70 [ 2982.227253][T21662]  =
do_syscall_64+0x2b/0x50
Jan  6 16:19:20 78.142.32.70 [ 2982.227253][T21662]  =
entry_SYSCALL_64_after_hwframe+0x46/0xb0
Jan  6 16:19:20 78.142.32.70 [ 2982.227253][T21662] RIP: =
0033:0x7f43e83f8a15
Jan  6 16:19:20 78.142.32.70 [ 2982.230533][T21662] Code: 21 54 0c 00 f7 =
d8 64 89 02 48 c7 c0 ff ff ff ff eb b5 0f 1f 00 53 48 83 ec 10 80 3d 0c =
da 0c 00 00 74 22 b8 2f 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 5b 48 63 =
d8 48 83 c4 10 48 89 d8 5b c3 0f 1f
Jan  6 16:19:20 78.142.32.70 [ 2982.230533][T21662] RSP: =
002b:00007ffea3775ab0 EFLAGS: 00000202 ORIG_RAX: 000000000000002f
Jan  6 16:19:20 78.142.32.70 [ 2982.230533][T21662] RAX: =
ffffffffffffffda RBX: 00007ffea3787c60 RCX: 00007f43e83f8a15
Jan  6 16:19:20 78.142.32.70 [ 2982.230533][T21662] RDX: =
0000000000000000 RSI: 00007ffea3775af0 RDI: 0000000000000003
Jan  6 16:19:20 78.142.32.70 [ 2982.230533][T21662] RBP: =
00007ffea3786b90 R08: 0000000000000007 R09: 0000000000000020
Jan  6 16:19:20 78.142.32.70 [ 2982.230533][T21662] R10: =
00007f43e86cbb80 R11: 0000000000000202 R12: 00007ffea3775b40
Jan  6 16:19:20 78.142.32.70 [ 2982.230533][T21662] R13: =
0000000000010fff R14: 0000000000000001 R15: 0000000000000000
Jan  6 16:19:20 78.142.32.70 [ 2982.247266][T21662]  </TASK>
Jan  6 16:19:20 78.142.32.70 [ 2982.260937][T21662] Modules linked in: =
nft_limit  pppoe pppox ppp_generic slhc nft_flow_offload =
nf_flow_table_inet nf_flow_table nft_objref nft_nat nft_ct nft_chain_nat =
nf_tables netconsole igb i2c_algo_bit e1000e virtio_net net_failover =
failover virtio_pci virtio_pci_legacy_dev virtio_pci_modern_dev virtio =
virtio_ring vmxnet3 i40e ixgbe mdio_devres libphy mdio nf_nat_sip =
nf_conntrack_sip nf_nat_pptp nf_conntrack_pptp nf_nat_tftp =
nf_conntrack_tftp nf_nat_ftp nf_conntrack_ftp nf_nat nf_conntrack =
nf_defrag_ipv6 nf_defrag_ipv4ipmi_devintf ipmi_msghandler rtc_cmos
Jan  6 16:19:20 78.142.32.70 [ 2982.341896][T21662] CR2: =
0000000000000000
Jan  6 16:19:20 78.142.32.70 [ 2982.357264][T21662] ---[ end trace =
0000000000000000 ]---
Jan  6 16:19:20 78.142.32.70 [ 2982.372595][T21662] RIP: =
0010:nf_tables_fill_chain_info+0x57a/0x590 [nf_tables]
Jan  6 16:19:20 78.142.32.70 [ 2982.387271][T21662] Code: 48 89 df e8 58 =
19 e9 f6 85 c0 0f 84 48 fe ff ff e9 d0 fd ff ff 8b 83 b4 00 00 00 48 8b =
7c 24 18 48 03 83 c0 00 00 00 48 29 f8 <66> 89 07 e9 26 fe ff ff 0f 0b =
e9 bc fd ff ff 0f 1f 80 00 00 00 00
Jan  6 16:19:20 78.142.32.70 [ 2982.422874][T21662] RSP: =
0018:ffffb1c247b3fb48 EFLAGS: 00010286
Jan  6 16:19:20 78.142.32.70 [ 2982.437260][T21662] RAX: =
ffff90e372777ec0 RBX: ffff90e37c725300 RCX: 0000000000000000
Jan  6 16:19:20 78.142.32.70 [ 2982.453222][T21662] RDX: =
0000000000000000 RSI: 0000000000000004 RDI: 0000000000000000
Jan  6 16:19:20 78.142.32.70 [ 2982.467263][T21662] RBP: =
ffff90e372777e78 R08: 0000000000000009 R09: ffff90e372777ec0
Jan  6 16:19:20 78.142.32.70 [ 2982.483588][T21662] R10: =
0000000000008000 R11: 0000000000000008 R12: ffff90e341bbb350
Jan  6 16:19:20 78.142.32.70 [ 2982.497260][T21662] R13: =
0000000000000000 R14: ffff90e372777ec0 R15: ffff90e341bbb328
Jan  6 16:19:20 78.142.32.70 [ 2982.517260][T21662] FS:  =
00007f43e82f2740(0000) GS:ffff90e3bbd40000(0000) knlGS:0000000000000000
Jan  6 16:19:20 78.142.32.70 [ 2982.528527][T21662] CS:  0010 DS: 0000 =
ES: 0000 CR0: 0000000080050033
Jan  6 16:19:20 78.142.32.70 [ 2982.547265][T21662] CR2: =
0000000000000000 CR3: 000000010020e000 CR4: 00000000003506e0
Jan  6 16:19:20 78.142.32.70 [ 2982.564542][T21662] Kernel panic - not =
syncing: Fatal exception
Jan  6 16:19:20 78.142.32.70 [ 2982.577260][T21662] Kernel Offset: =
0x36000000 from 0xffffffff81000000 (relocation range: =
0xffffffff80000000-0xffffffffbfffffff)
Jan  6 16:19:20 78.142.32.70 [ 2982.577260][T21662] Rebooting in 10 =
seconds..



> On 6 Jan 2023, at 17:17, Martin Zaharinov <micron10@gmail.com> wrote:
>=20
> Hi Pablo
>=20
> Patch look good and work but in my test after try to add ppp0 on over =
chain 1024 receive : Error: Could not process rule: Argument list too =
long
>=20
>=20
> Test is make like this :
>=20
>=20
> create chain :
>=20
> for i in `seq 2 9999`; do nft create chain netdev x int$i \{ type =
filter hook egress priority -500\; policy accept\; \}; done
>=20
>=20
> after that add device:=20
>=20
> for i in `seq 2 9999`; do nft add chain netdev qos int$i '{ devices =3D =
{ ppp0 }; }'; done
>=20
>=20
> when reach int1023 all is fine but in next 1024 receive this error .
>=20
> change device from ppp0 to eth0 add device on int1024.
>=20
> =E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94
>=20
> And one more when run add device line this for 1023 line added for 30 =
sec
>=20
> Is there options to optimize little more.
>=20
>=20
> Best regards,
> Martin

