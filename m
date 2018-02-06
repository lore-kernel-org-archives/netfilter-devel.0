From: Tugrul Erdogan <h.tugrul.erdogan@gmail.com>
Subject: CPU load on queued_spin_lock_slowpath
Date: Tue, 6 Feb 2018 10:56:20 +0300
Message-ID: <CA+whn7Qkg9ZJ-owuukfoA4+RHP26mBQG0oGoBCCtwL9oAs6MxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:40368 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752187AbeBFH4V (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 02:56:21 -0500
Received: by mail-qk0-f182.google.com with SMTP id d18so1177917qke.7
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Feb 2018 23:56:21 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi All,

My server had a locking problem with the logs located below. I can not
reproduce this erroneous situation again but I think that there is an
active vulnerability at my server because of this error.

My server's kernel version is v4.6.4.

What can be the cause of this error or do you have any opinion about
how can I reproduce this logs again? Thanks for your helps.

Best regards,
Tugrul

Feb  5 13:20:42 serv kernel: [<ffffffff81182ad7>]
queued_spin_lock_slowpath+0xb/0xf
Feb  5 13:20:42 serv kernel: [<ffffffff816ab7bb>] _raw_spin_lock_bh+0x2b/0x30
Feb  5 13:20:42 serv kernel: [<ffffffffa0312864>]
connlimit_mt+0x114/0x30 [xt_connlimit]
Feb  5 13:20:42 serv kernel: [<ffffffffa0284fe7>] ?
hashlimit_mt+0x2b7/0x71 [xt_hashlimit]
Feb  5 13:20:42 serv kernel: [<ffffffff816ab59e>] ?
_raw_spin_unlock_bh+0x1e/0x20
Feb  5 13:20:42 serv kernel: [<ffffffffa0097c3f>]
ipt_do_table+0x25f/0x710 [ipt_tables]
Feb  5 13:20:42 serv kernel: [<ffffffffa0097d12>] ?
ipt_do_table+0x332/0x710 [ipt_tables]
Feb  5 13:20:42 serv kernel: [<ffffffff815d092d>] ? tcp_packet+0x39d/0x9a0
Feb  5 13:20:42 serv kernel: [<ffffffffa0097d12>] ?
dev_hard_start_xmit+0x22f/0x3e0
Feb  5 13:20:42 serv kernel: [<ffffffff81590dbf>]
iptable_mangle_hook+0x37/0x110 [iptable_mangle]
Feb  5 13:20:42 serv kernel: [<ffffffffa030d077>] nf_iterate+0x5d/0x70
Feb  5 13:20:42 serv kernel: [<ffffffff815c678d>] nf_hook_slow+0x5d/0x70
Feb  5 13:20:42 serv kernel: [<ffffffff815c6816>] ip_output+0xdb/0xf0
Feb  5 13:20:42 serv kernel: [<ffffffff815e09cb>] ? __ip_local_out+0xa2/0x110
Feb  5 13:20:42 serv kernel: [<ffffffff815e0002>] ?
ip_fragment.constprop.51+0x80/0x80
Feb  5 13:20:42 serv kernel: [<ffffffff815df330>] ip_local_out+0x35/0x40
Feb  5 13:20:42 serv kernel: [<ffffffffa036318a>]
synproxy_send_tcp.isra.8+0xca/0xf0 [ipt_SYNPROXY]
Feb  5 13:20:42 serv kernel: [<ffffffffa03633b0>]
synproxy_recv_client_ack+0x200/0x340 [ipt_SYNPROXY]
Feb  5 13:20:42 serv kernel: [<ffffffffa0363b1c>]
synproxy_tg4+0x11c/0x308 [ipt_SYNPROXY]
