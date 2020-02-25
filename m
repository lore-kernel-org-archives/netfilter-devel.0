Return-Path: <SRS0=2ZCu=4N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,URIBL_RHS_DOB autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A4C9C4BA04
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 23:42:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C14502072D
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 23:42:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=datto.com header.i=@datto.com header.b="Q4UnDibv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729170AbgBYXmq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Feb 2020 18:42:46 -0500
Received: from us-smtp-delivery-195.mimecast.com ([63.128.21.195]:56712 "EHLO
        us-smtp-delivery-195.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726827AbgBYXmq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Feb 2020 18:42:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datto.com;
        s=mimecast20190208; t=1582674164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=AzF6iBIph2hXA1833Y5ta0YMBCPD3HDXrvszJD9KerY=;
        b=Q4UnDibv6mix9hcpRPrR3zUs/A1yGwzVoJpYEfaCV05JqJ5EMsXv2xhwVaOJRrlyU0CD8o
        UWGw7ziCw/NZmEgmb67eX2wZnY+X/xmxnaDR13iYfKU1lwmNAUhqvmtGdz19o4BkdqI3Xa
        wReHt23BXdhoazFHBLUxsKJ7VJx/0ec=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-1heySRRxMpCDIYVzbDNxWQ-1; Tue, 25 Feb 2020 18:42:42 -0500
X-MC-Unique: 1heySRRxMpCDIYVzbDNxWQ-1
Received: by mail-il1-f200.google.com with SMTP id z12so1046581ilh.17
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Feb 2020 15:42:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=vwLMFJef7602EO0bMFoV1KtP0O5Gcux+I9H3OlBPbt4=;
        b=snbe6LQ0l8K9JVIbEv7teWWsvL+IfEf3jJBXQAM/+uUVOE/h4nxmEnyS8zxQ6qIRWr
         ofbwpDD6Akf2hLPgmQqYc/4fEtCVwmqLeh5YTIGFkc2vSrabIJ69Git5hTHG5sMN4UUp
         u8Q3Gq75UGwDMbBo/95JFmoqVWGNngyho5YF32Y9d+jk90s5CcW1f35XIgElxC85gkki
         s7LpwbsF7Z4C7cHLufDY4AsF+1SItXNP8QDf9kU3qhG0u5EKodQLuK53RK8b6c5jyAMj
         n1Uy/fHIRcbLrYuhmUv3pd68bipfe3FUj3bPzMZPnHONRoH/H6hwTYQ2mXbVyBMwJ9/7
         1D9A==
X-Gm-Message-State: APjAAAWJnOTQYyD5SF3+mfGRWuLMzRGfrDaUXTgg6uRHbh5Dp6KFXfGo
        tWznW9l+Uyk0bLFO97QX3xRFxds8wl7IegxkTuvgoF3VKxUkvCMlrBg2a/acLlrhFzK7/6wYSFF
        2PQQ5440Pl5BXLHuq5zRNqC4qrC3tMeIzm7+jWNI5gGPq
X-Received: by 2002:a92:7606:: with SMTP id r6mr1177852ilc.120.1582674160941;
        Tue, 25 Feb 2020 15:42:40 -0800 (PST)
X-Google-Smtp-Source: APXvYqyvGV7W3qHNJcX/h6wLRr94TLG76zwM2zcDvt61Z4mnfZCrwd1WJbpafo1+MaAs84W8JAadHmYAel3OaqWnZGk=
X-Received: by 2002:a92:7606:: with SMTP id r6mr1177823ilc.120.1582674160395;
 Tue, 25 Feb 2020 15:42:40 -0800 (PST)
MIME-Version: 1.0
From:   Alex Buie <alex.buie@datto.com>
Date:   Tue, 25 Feb 2020 18:42:29 -0500
Message-ID: <CANGix0AUuajHm4+5nQcNkiKV=K9=T7DmMbNxRQyBZ6grr4zkaQ@mail.gmail.com>
Subject: Null Pointer Dereference in nf_nat
To:     netfilter-devel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: datto.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello All,

I am working on a rather thorny kernel panic issue I've been having
with netfilter / nf_nat.

Kernel version is 4.4.92 with this patch backported:
https://www.spinics.net/lists/netdev/msg539418.html (yes, I am aware
that this is a very old tree - but this is an embedded platform, so
kernel upgrades are difficult for external reasons - trying to
identify what I can do to fix this in-situ)

The panic is difficult to induce - it does not seem to be triggered by
a specific traffic type or signature, and there seems likely to be a
race-y element.


Originally, the behavior we were seeing would result in a stack trace
that looked like this:

    [51860.436150] BUG: unable to handle kernel NULL pointer
dereference at 0000000000000046
    [51860.444048] IP: [<ffffffffa0e1347e>]
nf_xfrm_me_harder+0x256/0x38f [nf_nat]
    [51860.451052] PGD 24d35c067 PUD 249b0c067 PMD 0
    [51860.455583] Oops: 0000 [#1] SMP
    [51860.458875] Modules linked in: cdc_ether pppoe ppp_async option
iptable_nat ath9k usb_wwan qmi_wwan pppox ppp_generic
nft_chain_nat_ipv4 nf_tables_inet nf_nat_pptp nf_nat_ipv6 nf_nat_ipv4
nf_nat_amanda nf_conntrack_pptp nf_conntrack_ipv6 nf_conntrack_ipv4
nf_conntrack_amanda ipt_REJECT ipt_MASQUERADE cdc_ncm ath9k_common
xt_time xt_tcpudp xt_tcpmss xt_string xt_statistic xt_state xt_recent
xt_quota xt_policy xt_pkttype xt_physdev xt_owner xt_nat xt_multiport
xt_mark xt_mac xt_limit xt_length xt_hl xt_helper xt_geoip xt_esp
xt_ecn xt_dscp xt_conntrack xt_connmark xt_connlimit xt_connbytes
xt_commentxt_addrtype xt_TRACE xt_TCPMSS xt_REDIRECT xt_NFQUEUE
xt_NFLOG xt_NETMAP xt_LOG xt_HL xt_DSCP xt_CT xt_CLASSIFY via_velocity
via_rhine usbserial usbnet ts_kmp ts_fsm ts_bm slhc sis900 r8169
pcnet32 nft_reject_ipv6
    [51860.532232]  nft_reject_ipv4 nft_reject_inet nft_reject
nft_redir_ipv4 nft_redir nft_rbtree nft_nat nft_meta nft_masq_ipv6
nft_masq_ipv4 nft_masq nft_log nft_limit nft_hash nft_exthdr nft_ct
nft_counter nft_chain_route_ipv6 nft_chain_route_ipv4 nfnetlink_queue
nfnetlink_log nf_tables_ipv6 nf_tables_ipv4 nf_tables nf_reject_ipv4
nf_nat_tftp nf_nat_snmp_basic nf_nat_redirect nf_nat_proto_gre
nf_nat_masquerade_ipv6 nf_nat_masquerade_ipv4 nf_nat_irc nf_nat_h323
nf_nat_ftp nf_nat nf_log_ipv4 nf_defrag_ipv6 nf_defrag_ipv4
nf_conntrack_tftp nf_conntrack_snmp nf_conntrack_proto_gre
nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp
nf_conntrack_broadcast ne2k_pci iptable_raw iptable_mangle
iptable_filter ipt_ah ipt_ECN ip6table_raw ip_tables e1000e e100
crc_ccitt cdc_wdm cdc_acm ath9k_hw 8390 8139too em_cmp
    [51860.603173]  sch_teql em_nbyte cls_basic sch_dsmark sch_pie
em_meta sch_gred act_ipt sch_prio act_police em_text sch_codel sch_red
sch_sfq sch_fq act_skbedit act_mirred em_u32 cls_u32 cls_tcindex
cls_flow cls_route cls_fw sch_tbf sch_htb sch_hfsc sch_ingress
i2c_smbus i2c_i801 ath10k_pci ath10k_core ath mac80211 cfg80211 compat
UDSMARK udsmac i2c_dev tc_classid_mapper(P) filter_group snd_pcsp
classifier_dumper(P) classifier_dns(P) classifier_netblock(P)
classifier_bittorrent(P) classifier_rtmp(P) classifier_ssl(P)
classifier_content(P) classifier_quic(P) classifier_skype(P)
kernel_classifier nf_conntrack xt_set ip_set_list_set
ip_set_hash_netiface ip_set_hash_netport ip_set_hash_netnet
ip_set_hash_net ip_set_hash_netportnet ip_set_hash_mac
ip_set_hash_ipportnet ip_set_hash_ipportip ip_set_hash_ipport
    [51860.674143]  ip_set_hash_ipmark ip_set_hash_ip
ip_set_bitmap_port ip_set_bitmap_ipmac ip_set_bitmap_ip ip_set
nfnetlink ip6t_REJECT nf_reject_ipv6 nf_log_ipv6 nf_log_common
ip6table_mangle ip6table_filter ip6_tables x_tables bonding 3c59x igb
i2c_algo_bit i2c_core e1000 ifb dummy ipcomp6 xfrm6_tunnel
xfrm6_mode_tunnel xfrm6_mode_transport xfrm6_mode_beet esp6 ah6 ipcomp
xfrm4_tunnel xfrm4_mode_tunnel xfrm4_mode_transport xfrm4_mode_beet
esp4 ah4 tunnel6 tunnel4 veth tun snd_compress snd_pcm_oss
snd_mixer_oss snd_pcm snd_timer snd_rawmidi snd_seq_device snd_hwdep
snd soundcore af_key xfrm_user xfrm_ipcomp xfrm_algo vfat fat nls_utf8
nls_iso8859_1 nls_cp437 natsemi algif_skcipher algif_hash af_alg
sha256_ssse3 sha256_generic sha1_ssse3 sha1_generic jitterentropy_rng
drbg md5 hmac echainiv des_generic
    [51860.745221]  deflate zlib_deflate cbc authenc button_hotplug
tg3 hwmon ptp pps_core mii libphy
    [51860.752833] CPU: 0 PID: 14283 Comm: snort Tainted: P
    4.4.92 #0
    [51860.759981] Hardware name: To be filled by O.E.M. To be filled
by O.E.M./To be filled by O.E.M., BIOS 5.6.5 03/29/2018
    [51860.770683] task: ffff880273282600 ti: ffff8802492b4000
task.ti: ffff8802492b4000
    [51860.778177] RIP: 0010:[<ffffffffa0e1347e>]
[<ffffffffa0e1347e>] nf_xfrm_me_harder+0x256/0x38f [nf_nat]
    [51860.787616] RSP: 0018:ffff8802492b76f8  EFLAGS: 00010286
    [51860.792939] RAX: 0000000000000011 RBX: ffff8802392c3860 RCX:
00000000a5cdcd81
    [51860.800082] RDX: 0000000000010000 RSI: 0000000000000000 RDI:
ffffffff8185c4c0
    [51860.807230] RBP: ffff8802492b7788 R08: 0000000000000002 R09:
00000000bbb545e0
    [51860.814371] R10: ffff880079d0e000 R11: 0000000000000020 R12:
ffff8802497580a0
    [51860.821511] R13: ffff8802492b77b0 R14: ffffffffa1426ce0 R15:
ffffffffa0e14de0
    [51860.828653] FS:  00007f5454a88b08(0000)
GS:ffff88027fc00000(0000) knlGS:0000000000000000
    [51860.836753] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
    [51860.842511] CR2: 0000000000000046 CR3: 00000002492ab000 CR4:
00000000001006f0
    [51860.849650] Stack:
    [51860.851677]  ffff8802492b77b0 ffff8802492b7788 ffff8802492b7830
ffff88023927e000
    [51860.859188]  0000000000000000 ffffffffa0e14de0 ffffffffa0e13a4d
ffff8802492b7830
    [51860.866702]  ffff8802497580a0 ffffffffa1426ce0 ffffffff8185c4c0
ffff88023927e000
    [51860.874216] Call Trace:
    [51860.876687]  [<ffffffffa0e13a4d>] ?
nf_ct_nat_ext_add+0x376/0x45c [nf_nat]
    [51860.883579]  [<ffffffffa0e13bae>] ? nf_nat_setup_info+0x7b/0x430 [nf=
_nat]
    [51860.890379]  [<ffffffffa065305a>] ? 0xffffffffa065305a
    [51860.895533]  [<ffffffffa0652308>] ? 0xffffffffa0652308
    [51860.900691]  [<ffffffffa0e78171>] ?
nf_nat_masquerade_ipv4+0x117/0x13e [nf_nat_masquerade_ipv4]
    [51860.909406]  [<ffffffffa13b60a6>] ? 0xffffffffa13b60a6
    [51860.914557]  [<ffffffffa0cd9a23>] ? ipt_do_table+0x573/0xe50 [ip_tab=
les]
    [51860.921274]  [<ffffffffa14e5024>] ? 0xffffffffa14e5024
    [51860.926430]  [<ffffffffa142668c>] ? nf_nat_ipv4_fn+0xec/0x265
[nf_nat_ipv4]
    [51860.933404]  [<ffffffffa14e500e>] ? 0xffffffffa14e500e
    [51860.938553]  [<ffffffffa14268ab>] ? nf_nat_ipv4_out+0x3c/0x131
[nf_nat_ipv4]
    [51860.945614]  [<ffffffffa14e5040>] ? 0xffffffffa14e5040
    [51860.950765]  [<ffffffff814a8c67>] ? nf_iterate+0x35/0x5e
    [51860.956094]  [<ffffffff814a8cb8>] ? nf_hook_slow+0x28/0xad
    [51860.961597]  [<ffffffff814b4427>] ? ip_output+0x9c/0xbf
    [51860.966838]  [<ffffffff814b2dcf>] ? ip_finish_output_gso+0x111/0x111
    [51860.973201]  [<ffffffff814b0b83>] ? ip_forward_finish+0x4d/0x52
    [51860.979137]  [<ffffffff814a9c48>] ? nf_reinject+0xc5/0x125
    [51860.984640]  [<ffffffffa0f30a4e>] ? 0xffffffffa0f30a4e
    [51860.989797]  [<ffffffff81282dd0>] ? nla_parse+0x5a/0x10d
    [51860.995129]  [<ffffffffa056933d>] ?
nfnetlink_unicast+0x224/0x90b [nfnetlink]
    [51861.002278]  [<ffffffffa05691d9>] ?
nfnetlink_unicast+0xc0/0x90b [nfnetlink]
    [51861.009340]  [<ffffffff814a6774>] ? netlink_rcv_skb+0x34/0x93
    [51861.015102]  [<ffffffffa05699b4>] ?
nfnetlink_unicast+0x89b/0x90b [nfnetlink]
    [51861.022251]  [<ffffffff814a3792>] ? netlink_unicast_kernel+0x46/0x89
    [51861.028613]  [<ffffffff814a6248>] ? netlink_unicast+0x95/0x116
    [51861.034462]  [<ffffffff814a65c5>] ? netlink_sendmsg+0x271/0x2d7
    [51861.040393]  [<ffffffff81461541>] ? sock_sendmsg+0xb/0x16
    [51861.045805]  [<ffffffff814623c2>] ? ___sys_sendmsg+0x13d/0x1de
    [51861.051650]  [<ffffffff810aea65>] ? __wake_up+0x3d/0x46
    [51861.056892]  [<ffffffff8111f409>] ? lru_cache_add+0x5/0x7
    [51861.062306]  [<ffffffff8111f4f6>] ?
lru_cache_add_active_or_unevictable+0x1e/0x74
    [51861.069801]  [<ffffffff81133bf3>] ? do_anonymous_page+0x2ed/0x32b
    [51861.075905]  [<ffffffff8113758f>] ? handle_pte_fault+0x4d/0x16c
    [51861.081842]  [<ffffffff81138a93>] ? __handle_mm_fault+0x178/0x198
    [51861.087952]  [<ffffffff81166ff1>] ? __fget_light+0x44/0x60
    [51861.093452]  [<ffffffff814630f1>] ? __sys_sendmsg+0x3c/0x5d
    [51861.099034]  [<ffffffff81463117>] ? SyS_sendmsg+0x5/0x7
    [51861.104270]  [<ffffffff8156c4ee>] ? entry_SYSCALL_64_fastpath+0x12/0=
x71
    [51861.110898] Code: 89 c0 8b 97 78 10 00 00 48 0f af c2 48 c1 e8
20 48 c1 e0 03 48 03 87 70 10 00 00 48 8b 18 e9 21 01 00 00 48 8b 73
10 0f b6 45 26 <38> 46 46 75 56 8b 45 00 39 46 20 75 1f 8b 45 04 3946
24 75 1e
    [51861.131443] RIP  [<ffffffffa0e1347e>]
nf_xfrm_me_harder+0x256/0x38f [nf_nat]
    [51861.138526]  RSP <ffff8802492b76f8>
    [51861.142026] CR2: 0000000000000046


Building a kernel and modules with debug symbols allowed me to isolate
that the problem was specifically in this line:
https://elixir.bootlin.com/linux/v4.4.92/source/net/netfilter/nf_nat_core.c=
#L106

Further googling led me to find the dst_hold patch, which we
incorporated into our build toolchain, as the symptoms in the patch
exactly matched what we were experiencing. These panics went away
after adding that patch.


However, we are now seeing a new panic, that looks like this:

    [130726.517751] BUG: unable to handle kernel NULL pointer
dereference at 0000000000000046
    [130726.525752] IP: [<ffffffffa0e134be>]
nf_xfrm_me_harder+0x296/0x3cf [nf_nat]
    [130726.532844] PGD 24a18b067 PUD 25e8b5067 PMD 0
    [130726.537462] Oops: 0000 [#1] SMP
    [130726.540841] Modules linked in: cdc_ether pppoe ppp_async
option iptable_nat ath9k usb_wwan qmi_wwan pppox ppa nf_conntrack_pptp
nf_conntrack_ipv6 nf_conntrack_ipv4 nf_conntrack_amanda ipt_REJECT
ipt_MASQUERADE cdc_ncm at_policy xt_pkttype xt_physdev xt_owner xt_nat
xt_multiport xt_mark xt_mac xt_limit xt_length xt_hl xt_helper
xt__addrtype xt_TRACE xt_TCPMSS xt_REDIRECT xt_NFQUEUE xt_NFLOG
xt_NETMAP xt_LOG xt_HL xt_DSCP xt_CT xt_CLASSIFY vict_ipv6
    [130726.614288]  nft_reject_ipv4 nft_reject_inet nft_reject
nft_redir_ipv4 nft_redir nft_rbtree nft_nat nft_metaer
nft_chain_route_ipv6 nft_chain_route_ipv4 nfnetlink_queue
nfnetlink_log nf_tables_ipv6 nf_tables_ipv4 nf_tabluerade_ipv6
nf_nat_masquerade_ipv4 nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat
nf_log_ipv4 nf_defrag_ipv6 nf_defragck_h323 nf_conntrack_ftp
nf_conntrack_broadcast ne2k_pci iptable_raw iptable_mangle
iptable_filter ipt_ah ipt_ECe
    [130726.685415]  cls_basic sch_prio sch_dsmark sch_pie act_ipt
sch_gred em_meta sch_teql act_police em_text sch_ow cls_route cls_fw
sch_tbf sch_htb sch_hfsc sch_ingress i2c_smbus i2c_i801 ath10k_pci
ath10k_core ath mac80211 _dumper(P) classifier_dns(P)
classifier_netblock(P) classifier_bittorrent(P) classifier_rtmp(P)
classifier_ssl(Pk xt_set ip_set_list_set ip_set_hash_netiface
ip_set_hash_netport ip_set_hash_netnet ip_set_hash_net ip_set_hash
    [130726.756210]  ip_set_hash_ipmark ip_set_hash_ip
ip_set_bitmap_port ip_set_bitmap_ipmac ip_set_bitmap_ip ip_selter
ip6_tables x_tables bonding 3c59x igb i2c_algo_bit i2c_core e1000 ifb
dummy ipcomp6 xfrm6_tunnel xfrm6_modexfrm4_mode_transport
xfrm4_mode_beet esp4 ah4 tunnel6 tunnel4 veth tun snd_compress
snd_pcm_oss snd_mixer_oss snomp xfrm_algo vfat fat nls_utf8
nls_iso8859_1 nls_cp437 natsemi algif_skcipher algif_hash af_alg
sha256_ssse3 sh
    [130726.827314]  deflate zlib_deflate cbc authenc button_hotplug
tg3 hwmon ptp pps_core mii libphy
    [130726.834929] CPU: 2 PID: 14810 Comm: snort Tainted: P
     4.4.92 #0
    [130726.842170] Hardware name: To be filled by O.E.M. To be filled
by O.E.M./To be filled by O.E.M., BIOS 5.6.5
    [130726.852962] task: ffff880242abd580 ti: ffff88024929c000
task.ti: ffff88024929c000
    [130726.860549] RIP: 0010:[<ffffffffa0e134be>]
[<ffffffffa0e134be>] nf_xfrm_me_harder+0x296/0x3cf [nf_nat]
    [130726.870084] RSP: 0018:ffff88024929f6f8  EFLAGS: 00010282
    [130726.875493] RAX: 0000000000000006 RBX: ffffffff817e30e0 RCX:
000000008cabd5cc
    [130726.882737] RDX: 0000000000010000 RSI: 0000000000000000 RDI:
ffffffff8185c4c0
    [130726.889983] RBP: ffff88024929f788 R08: 0000000000000002 R09:
00000000a467edbc
    [130726.897228] R10: ffff88027294c000 R11: 0000000000000020 R12:
ffff880249dc9ca0
    [130726.904473] R13: ffff88024929f7b0 R14: ffffffffa1426ce0 R15:
ffffffffa0e14e60
    [130726.911726] FS:  00007fb3244a9b08(0000)
GS:ffff88027fc80000(0000) knlGS:0000000000000000
    [130726.919913] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
    [130726.925758] CR2: 0000000000000046 CR3: 0000000242a19000 CR4:
00000000001006e0
    [130726.932999] Stack:
    [130726.935114]  ffff88024929f7b0 ffff88024929f788
ffff88024929f830 ffff88006b88a360
    [130726.942723]  0000000000000000 ffffffffa0e14e60
ffffffffa0e13a8d ffff88024929f830
    [130726.950339]  ffff880249dc9ca0 ffffffffa1426ce0
ffffffff8185c4c0 ffff88006b88a360
    [130726.957939] Call Trace:
    [130726.960498]  [<ffffffffa0e13a8d>] ?
nf_ct_nat_ext_add+0x376/0x45c [nf_nat]
    [130726.967475]  [<ffffffffa0e13bee>] ?
nf_nat_setup_info+0x7b/0x430 [nf_nat]
    [130726.974361]  [<ffffffffa065305a>] ? 0xffffffffa065305a
    [130726.979601]  [<ffffffffa0652308>] ? 0xffffffffa0652308
    [130726.984847]  [<ffffffffa0e78171>] ?
nf_nat_masquerade_ipv4+0x117/0x13e [nf_nat_masquerade_ipv4]
    [130726.993650]  [<ffffffffa13b60a6>] ? 0xffffffffa13b60a6
    [130726.998894]  [<ffffffffa0cd9a23>] ? ipt_do_table+0x573/0xe50 [ip_ta=
bles]
    [130727.005697]  [<ffffffffa11b4391>] ? 0xffffffffa11b4391
    [130727.010941]  [<ffffffffa14e5024>] ? 0xffffffffa14e5024
    [130727.016184]  [<ffffffffa142668c>] ? nf_nat_ipv4_fn+0xec/0x265
[nf_nat_ipv4]
    [130727.023246]  [<ffffffffa14e500e>] ? 0xffffffffa14e500e
    [130727.028492]  [<ffffffffa14268ab>] ? nf_nat_ipv4_out+0x3c/0x131
[nf_nat_ipv4]
    [130727.035639]  [<ffffffffa14e5040>] ? 0xffffffffa14e5040
    [130727.040885]  [<ffffffff814a8c67>] ? nf_iterate+0x35/0x5e
    [130727.046299]  [<ffffffff814a8cb8>] ? nf_hook_slow+0x28/0xad
    [130727.051888]  [<ffffffff814b4427>] ? ip_output+0x9c/0xbf
    [130727.057219]  [<ffffffff814b2dcf>] ? ip_finish_output_gso+0x111/0x11=
1
    [130727.063676]  [<ffffffff814b0b83>] ? ip_forward_finish+0x4d/0x52
    [130727.069698]  [<ffffffff814a9c48>] ? nf_reinject+0xc5/0x125
    [130727.075289]  [<ffffffffa0f30a4e>] ? 0xffffffffa0f30a4e
    [130727.080532]  [<ffffffff81282dd0>] ? nla_parse+0x5a/0x10d
    [130727.085949]  [<ffffffffa056933d>] ?
nfnetlink_unicast+0x224/0x90b [nfnetlink]
    [130727.093193]  [<ffffffffa05691d9>] ?
nfnetlink_unicast+0xc0/0x90b [nfnetlink]
    [130727.100343]  [<ffffffff814a6774>] ? netlink_rcv_skb+0x34/0x93
    [130727.106194]  [<ffffffffa05699b4>] ?
nfnetlink_unicast+0x89b/0x90b [nfnetlink]
    [130727.113435]  [<ffffffff814a3792>] ? netlink_unicast_kernel+0x46/0x8=
9
    [130727.119886]  [<ffffffff814a6248>] ? netlink_unicast+0x95/0x116
    [130727.125821]  [<ffffffff814a65c5>] ? netlink_sendmsg+0x271/0x2d7
    [130727.131855]  [<ffffffff81461541>] ? sock_sendmsg+0xb/0x16
    [130727.137355]  [<ffffffff814623c2>] ? ___sys_sendmsg+0x13d/0x1de
    [130727.143309]  [<ffffffff810aea65>] ? __wake_up+0x3d/0x46
    [130727.148638]  [<ffffffff814a2f3b>] ? netlink_rcv_wake+0x3e/0x40
    [130727.154577]  [<ffffffff814a42d4>] ? netlink_recvmsg+0x283/0x2a4
    [130727.160600]  [<ffffffff81460cfe>] ? sock_recvmsg+0x7/0x9
    [130727.166015]  [<ffffffff81462eff>] ? SyS_recvfrom+0x104/0x130
    [130727.171782]  [<ffffffff81166ff1>] ? __fget_light+0x44/0x60
    [130727.177377]  [<ffffffff814630f1>] ? __sys_sendmsg+0x3c/0x5d
    [130727.183053]  [<ffffffff81463117>] ? SyS_sendmsg+0x5/0x7
    [130727.188384]  [<ffffffff8156c4ee>] ? entry_SYSCALL_64_fastpath+0x12/=
0x71
    [130727.195099] Code: 89 c0 8b 97 78 10 00 00 48 0f af c2 48 c1 e8
20 48 c1 e0 03 48 03 87 70 10 00 00 48 8b 18 46 24 75 1e
    [130727.215747] RIP  [<ffffffffa0e134be>]
nf_xfrm_me_harder+0x296/0x3cf [nf_nat]
    [130727.222924]  RSP <ffff88024929f6f8>
    [130727.226513] CR2: 0000000000000046

The instruction pointer there is pointing to this line in our source
tree: https://elixir.bootlin.com/linux/v4.4.92/source/net/netfilter/nf_nat_=
core.c#L112

Doing further research, it seems similar to this bug:
https://www.spinics.net/lists/netfilter-devel/msg19923.html , but I
tried building a kernel with the hh_len-skb_headroom call wrapped in
the HH_DATA_ALIGN macro, and this lead to all sorts of other crazy
panics elsewhere, in various inconsistent stack traces, so that does
not seem to be it.



I have kdump vmcores from these systems, if they are helpful, but
they're 7.5GB a pop. Unwinding the backtraces of all active threads in
them does not seem to provide any useful/related info, though.

I feel like I've been barking up a lot of trees here, and chasing my
tail a bit. Hopeful that someone has ideas for either next best places
to look, or ideas for further troubleshooting steps/data I could
collect to help in nailing down these panics.


Thanks in advance for any of your time!

Alex

