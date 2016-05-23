From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: kernel 4.5.1 issue at system boot
Date: Mon, 23 May 2016 08:49:27 +0200
Message-ID: <CAOkSjBh-P0RNKhNeR8fBmRVda7mtU9332punaUufO4Rx3aqpqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:38886 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbcEWGts convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 May 2016 02:49:48 -0400
Received: by mail-wm0-f47.google.com with SMTP id n129so58821332wmn.1
        for <netfilter-devel@vger.kernel.org>; Sun, 22 May 2016 23:49:47 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This was in the log of my system boot today:

May 23 08:25:08 debianhost kernel: [  240.104042] INFO: task
modprobe:776 blocked for more than 120 seconds.
May 23 08:25:08 debianhost kernel: [  240.104049]       Tainted: G
       E   4.5.0-2-amd64 #1
May 23 08:25:08 debianhost kernel: [  240.104051] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 23 08:25:08 debianhost kernel: [  240.104054] modprobe        D
ffff88007fa15980     0   776     98 0x00000000
May 23 08:25:08 debianhost kernel: [  240.104060]  ffff880078e4e600
ffffffff81a12500 ffff88007b20c000 ffff88007b20bc88
May 23 08:25:08 debianhost kernel: [  240.104065]  ffffffff81ad9ae4
ffff880078e4e600 00000000ffffffff ffffffff81ad9ae8
May 23 08:25:08 debianhost kernel: [  240.104069]  ffffffff815b36e1
ffffffff81ad9ae0 ffffffff815b396a ffffffff815b53f4
May 23 08:25:08 debianhost kernel: [  240.104073] Call Trace:
May 23 08:25:08 debianhost kernel: [  240.104083]
[<ffffffff815b36e1>] ? schedule+0x31/0x80
May 23 08:25:08 debianhost kernel: [  240.104087]
[<ffffffff815b396a>] ? schedule_preempt_disabled+0xa/0x10
May 23 08:25:08 debianhost kernel: [  240.104091]
[<ffffffff815b53f4>] ? __mutex_lock_slowpath+0xb4/0x130
May 23 08:25:08 debianhost kernel: [  240.104099]
[<ffffffffc06e600c>] ? nf_conntrack_ipv4_compat_init+0xc/0xc
[nf_conntrack_ipv4]
May 23 08:25:08 debianhost kernel: [  240.104103]
[<ffffffff815b548b>] ? mutex_lock+0x1b/0x30
May 23 08:25:08 debianhost kernel: [  240.104108]
[<ffffffff814b0aa5>] ? register_pernet_subsys+0x15/0x40
May 23 08:25:08 debianhost kernel: [  240.104112]
[<ffffffffc06e6048>] ? nf_conntrack_l3proto_ipv4_init+0x3c/0xff4
[nf_conntrack_ipv4]
May 23 08:25:08 debianhost kernel: [  240.104117]
[<ffffffff81002122>] ? do_one_initcall+0xb2/0x200
May 23 08:25:08 debianhost kernel: [  240.104122]
[<ffffffff8116a27a>] ? do_init_module+0x5b/0x1ce
May 23 08:25:08 debianhost kernel: [  240.104126]
[<ffffffff810f98f6>] ? load_module+0x2146/0x2790
May 23 08:25:08 debianhost kernel: [  240.104129]
[<ffffffff810f6450>] ? __symbol_put+0x60/0x60
May 23 08:25:08 debianhost kernel: [  240.104133]
[<ffffffff810f68a8>] ? copy_module_from_fd.isra.51+0xf8/0x140
May 23 08:25:08 debianhost kernel: [  240.104137]
[<ffffffff810fa158>] ? SYSC_finit_module+0xa8/0xd0
May 23 08:25:08 debianhost kernel: [  240.104141]
[<ffffffff815b7472>] ? system_call_fast_compare_end+0xc/0x67
May 23 08:25:08 debianhost kernel: [  240.104145] INFO: task
(ostnamed):780 blocked for more than 120 seconds.
May 23 08:25:08 debianhost kernel: [  240.104148]       Tainted: G
       E   4.5.0-2-amd64 #1
May 23 08:25:08 debianhost kernel: [  240.104150] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 23 08:25:08 debianhost kernel: [  240.104151] (ostnamed)      D
0000000000000000     0   780      1 0x00000004
May 23 08:25:08 debianhost kernel: [  240.104156]  ffff8800797d7040
ffff88007a7aed40 ffff880036688000 ffff880036687dd8
May 23 08:25:08 debianhost kernel: [  240.104160]  ffffffffc04635a4
ffff8800797d7040 00000000ffffffff ffffffffc04635a8
May 23 08:25:08 debianhost kernel: [  240.104164]  ffffffff815b36e1
ffffffffc04635a0 ffffffff815b396a ffffffff815b53f4
May 23 08:25:08 debianhost kernel: [  240.104168] Call Trace:
May 23 08:25:08 debianhost kernel: [  240.104172]
[<ffffffff815b36e1>] ? schedule+0x31/0x80
May 23 08:25:08 debianhost kernel: [  240.104176]
[<ffffffff815b396a>] ? schedule_preempt_disabled+0xa/0x10
May 23 08:25:08 debianhost kernel: [  240.104179]
[<ffffffff815b53f4>] ? __mutex_lock_slowpath+0xb4/0x130
May 23 08:25:08 debianhost kernel: [  240.104183]
[<ffffffff815b548b>] ? mutex_lock+0x1b/0x30
May 23 08:25:08 debianhost kernel: [  240.104191]
[<ffffffffc04a0833>] ? nft_register_afinfo+0x23/0x50 [nf_tables]
May 23 08:25:08 debianhost kernel: [  240.104196]
[<ffffffffc046611d>] ? nf_tables_ipv4_init_net+0xed/0x110
[nf_tables_ipv4]
May 23 08:25:08 debianhost kernel: [  240.104199]
[<ffffffff814b06f9>] ? ops_init+0x39/0x100
May 23 08:25:08 debianhost kernel: [  240.104202]
[<ffffffff814b0845>] ? setup_net+0x85/0x130
May 23 08:25:08 debianhost kernel: [  240.104205]
[<ffffffff814b10d4>] ? copy_net_ns+0x74/0x100
May 23 08:25:08 debianhost kernel: [  240.104209]
[<ffffffff8109768b>] ? create_new_namespaces+0xfb/0x190
May 23 08:25:08 debianhost kernel: [  240.104212]
[<ffffffff81097875>] ? unshare_nsproxy_namespaces+0x55/0xa0
May 23 08:25:08 debianhost kernel: [  240.104216]
[<ffffffff81078a07>] ? SyS_unshare+0x1e7/0x390
May 23 08:25:08 debianhost kernel: [  240.104220]
[<ffffffff815b7472>] ? system_call_fast_compare_end+0xc/0x67
May 23 08:25:08 debianhost kernel: [  240.104224] INFO: task
modprobe:791 blocked for more than 120 seconds.
May 23 08:25:08 debianhost kernel: [  240.104226]       Tainted: G
       E   4.5.0-2-amd64 #1
May 23 08:25:08 debianhost kernel: [  240.104228] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 23 08:25:08 debianhost kernel: [  240.104230] modprobe        D
ffff88007fa95980     0   791    102 0x00000000
May 23 08:25:08 debianhost kernel: [  240.104234]  ffff88007942e600
ffff88007c8ece00 ffff88007b0c8000 ffff88007b0c7c88
May 23 08:25:08 debianhost kernel: [  240.104238]  ffffffff81ad9ae4
ffff88007942e600 00000000ffffffff ffffffff81ad9ae8
May 23 08:25:08 debianhost kernel: [  240.104242]  ffffffff815b36e1
ffffffff81ad9ae0 ffffffff815b396a ffffffff815b53f4
May 23 08:25:08 debianhost kernel: [  240.104246] Call Trace:
May 23 08:25:08 debianhost kernel: [  240.104250]
[<ffffffff815b36e1>] ? schedule+0x31/0x80
May 23 08:25:08 debianhost kernel: [  240.104254]
[<ffffffff815b396a>] ? schedule_preempt_disabled+0xa/0x10
May 23 08:25:08 debianhost kernel: [  240.104257]
[<ffffffff815b53f4>] ? __mutex_lock_slowpath+0xb4/0x130
May 23 08:25:08 debianhost kernel: [  240.104261]
[<ffffffffc06fd000>] ? 0xffffffffc06fd000
May 23 08:25:08 debianhost kernel: [  240.104264]
[<ffffffff815b548b>] ? mutex_lock+0x1b/0x30
May 23 08:25:08 debianhost kernel: [  240.104267]
[<ffffffff814b0aa5>] ? register_pernet_subsys+0x15/0x40
May 23 08:25:08 debianhost kernel: [  240.104273]
[<ffffffffc06fd00d>] ? nfnetlink_log_init+0xd/0x1000 [nfnetlink_log]
May 23 08:25:08 debianhost kernel: [  240.104276]
[<ffffffff81002122>] ? do_one_initcall+0xb2/0x200
May 23 08:25:08 debianhost kernel: [  240.104280]
[<ffffffff8116a27a>] ? do_init_module+0x5b/0x1ce
May 23 08:25:08 debianhost kernel: [  240.104283]
[<ffffffff810f98f6>] ? load_module+0x2146/0x2790
May 23 08:25:08 debianhost kernel: [  240.104286]
[<ffffffff810f6450>] ? __symbol_put+0x60/0x60
May 23 08:25:08 debianhost kernel: [  240.104290]
[<ffffffff810f68a8>] ? copy_module_from_fd.isra.51+0xf8/0x140
May 23 08:25:08 debianhost kernel: [  240.104294]
[<ffffffff810fa158>] ? SYSC_finit_module+0xa8/0xd0
May 23 08:25:08 debianhost kernel: [  240.104297]
[<ffffffff815b7472>] ? system_call_fast_compare_end+0xc/0x67
May 23 08:25:08 debianhost kernel: [  240.104315] INFO: task
(t-daemon):1319 blocked for more than 120 seconds.
May 23 08:25:08 debianhost kernel: [  240.104318]       Tainted: G
       E   4.5.0-2-amd64 #1
May 23 08:25:08 debianhost kernel: [  240.104319] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 23 08:25:08 debianhost kernel: [  240.104321] (t-daemon)      D
0000000000000000     0  1319      1 0x00000004
May 23 08:25:08 debianhost kernel: [  240.104325]  ffff8800790ba400
ffff880079e69140 ffff88005d8a8000 ffff88005d8a7e70
May 23 08:25:08 debianhost kernel: [  240.104329]  ffffffff81ad9ae4
ffff8800790ba400 00000000ffffffff ffffffff81ad9ae8
May 23 08:25:08 debianhost kernel: [  240.104333]  ffffffff815b36e1
ffffffff81ad9ae0 ffffffff815b396a ffffffff815b53f4
May 23 08:25:08 debianhost kernel: [  240.104337] Call Trace:
May 23 08:25:08 debianhost kernel: [  240.104341]
[<ffffffff815b36e1>] ? schedule+0x31/0x80
May 23 08:25:08 debianhost kernel: [  240.104344]
[<ffffffff815b396a>] ? schedule_preempt_disabled+0xa/0x10
May 23 08:25:08 debianhost kernel: [  240.104348]
[<ffffffff815b53f4>] ? __mutex_lock_slowpath+0xb4/0x130
May 23 08:25:08 debianhost kernel: [  240.104351]
[<ffffffff815b548b>] ? mutex_lock+0x1b/0x30
May 23 08:25:08 debianhost kernel: [  240.104355]
[<ffffffff814b10c9>] ? copy_net_ns+0x69/0x100
May 23 08:25:08 debianhost kernel: [  240.104358]
[<ffffffff8109768b>] ? create_new_namespaces+0xfb/0x190
May 23 08:25:08 debianhost kernel: [  240.104361]
[<ffffffff81097875>] ? unshare_nsproxy_namespaces+0x55/0xa0
May 23 08:25:08 debianhost kernel: [  240.104364]
[<ffffffff81078a07>] ? SyS_unshare+0x1e7/0x390
May 23 08:25:08 debianhost kernel: [  240.104368]
[<ffffffff815b7472>] ? system_call_fast_compare_end+0xc/0x67


--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
