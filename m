From: Ronny Janssen <ronny.janssen@gmail.com>
Subject: Re: x_tables: eb_tables: limit.0 match: invalid size 32 (kernel) !=
 (user) 24
Date: Thu, 13 Nov 2014 17:43:30 +0100
Message-ID: <CAJsRc6iObZoNLiJtCu5UvUtrBUf7e-ERWFjM7D1EcB6rdnTJ0w@mail.gmail.com>
References: <CAJsRc6i_vEWAOEUJVrx5t0DtNHZdMg5jj3N726YSOs7zX_pCcg@mail.gmail.com>
	<alpine.LSU.2.11.1411131608030.26202@nerf08.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:52165 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933094AbaKMQnc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Nov 2014 11:43:32 -0500
Received: by mail-lb0-f177.google.com with SMTP id z12so4497790lbi.8
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2014 08:43:30 -0800 (PST)
In-Reply-To: <alpine.LSU.2.11.1411131608030.26202@nerf08.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

forgive my ignorance, but I don't think that's the problem here.. is it ?

I mean, I have both 32bit iptables and ebtables using the same ABI and
I have no issue using iptables.

~ # file ./iptables-1.4.21/xtables-multi
./iptables/xtables-multi: ELF 32-bit MSB executable, MIPS, N32 MIPS64
rel2 version 1, dynamically linked (uses shared libs), for GNU/Linux
2.6.32, with unknown capability 0x41000000 = 0xf676e75, with unknown
capability 0x10000 = 0x70403, not stripped

~ # file ./ebtables-2.0.10-4/ebtables
./ebtables-2.0.10-4/ebtables: ELF 32-bit MSB executable, MIPS, N32
MIPS64 rel2 version 1, dynamically linked (uses shared libs), for
GNU/Linux 2.6.32, with unknown capability 0x41000000 = 0xf676e75, with
unknown capability 0x10000 = 0x70403, not stripped

for my understanding I added a stacktrace to where it goes wrong:

[  228.132523] Call Trace:
[  228.147507] [<ffffffff8014be50>] show_stack+0x68/0x80
[  228.165097] [<ffffffff80404348>] xt_check_match+0x1c8/0x1d0
[  228.183215] [<ffffffff804756f8>] translate_table+0x7e0/0xef0
[  228.201411] [<ffffffff80477698>] do_replace_finish+0x1e8/0x780
[  228.219777] [<ffffffff80477d48>] do_replace.constprop.9+0x118/0x1e0
[  228.238583] [<ffffffff80478870>] compat_do_replace.constprop.8+0x230/0x2b0
[  228.258002] [<ffffffff804789dc>] compat_do_ebt_set_ctl+0xec/0x138
[  228.276637] [<ffffffff803f0150>] compat_nf_setsockopt+0x88/0xc8
[  228.295086] [<ffffffff80415458>] compat_ip_setsockopt+0x98/0xf8
[  228.313557] [<ffffffff803e5010>] compat_sys_setsockopt+0x70/0x1e8
[  228.332186] [<ffffffff80155184>] handle_sysn32+0x44/0x70
[  228.350032]







On Thu, Nov 13, 2014 at 4:10 PM, Jan Engelhardt <jengelh@inai.de> wrote:
> On Thursday 2014-11-13 15:25, Ronny Janssen wrote:
>
>>[  320.376828] x_tables: eb_tables: limit.0 match: invalid size 32
>>(kernel) != (user) 24
>>
>>Question is.. what would be the proper solution?
>
> This has been reported so often already - did you check?
> There is no programmatic solution. The kernel can only recognize at most
> two formats, which breaks down when people throw in userspaces with a
> third ABI.
