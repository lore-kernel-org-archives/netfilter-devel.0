Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CDA2CDB474
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Oct 2023 10:12:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjJWKMh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Oct 2023 06:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjJWKMg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Oct 2023 06:12:36 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B8BDA;
        Mon, 23 Oct 2023 03:12:33 -0700 (PDT)
Received: from [78.30.35.151] (port=33152 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qurv5-00EyJm-M8; Mon, 23 Oct 2023 12:12:26 +0200
Date:   Mon, 23 Oct 2023 12:12:22 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Kaustubh Pandey <quic_kapandey@quicinc.com>
Cc:     mark.tomlinson@alliedtelesis.co.nz, netdev@vger.kernel.org,
        quic_sharathv@quicinc.com, quic_subashab@quicinc.com,
        netfilter-devel@vger.kernel.org
Subject: Re: KASAN: vmalloc-out-of-bounds in ipt_do_table
Message-ID: <ZTZHBgHovKrN8q6w@calendula>
References: <7ce196a5-9477-41df-b0fa-c208021a35ba@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7ce196a5-9477-41df-b0fa-c208021a35ba@quicinc.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Cc'ing netfilter-devel.

On Mon, Oct 23, 2023 at 03:31:25PM +0530, Kaustubh Pandey wrote:
> Hi Everyone,
> 
> We have observed below issue on v5.15 kernel
> 
> [83180.055298]
> ==================================================================
> [83180.055376] BUG: KASAN: vmalloc-out-of-bounds in ipt_do_table+0x43c/0xaf4
> [83180.055464] Read of size 8 at addr ffffffc02c0f9000 by task Disposer/1686
> [83180.055544] CPU: 1 PID: 1686 Comm: Disposer Tainted: G S      W  OE
>   5.15.78-android13-8-g3d973ad4cc47 #1

This is slightly behind current -stable. Perhaps this is missing?

commit e58a171d35e32e6e8c37cfe0e8a94406732a331f
Author: Florian Westphal <fw@strlen.de>
Date:   Fri Feb 17 23:20:06 2023 +0100

    netfilter: ebtables: fix table blob use-after-free

> [83180.055613] Hardware name: Qualcomm Technologies, Inc. Kalama
> MTP,davinci DVT (DT)
> [83180.055655] Call trace:
> [83180.055677]  dump_backtrace+0x0/0x3b0
> [83180.055740]  show_stack+0x2c/0x3c
> [83180.055792]  dump_stack_lvl+0x8c/0xa8
> [83180.055866]  print_address_description+0x74/0x384
> [83180.055940]  kasan_report+0x180/0x260
> [83180.056002]  __asan_load8+0xb4/0xb8
> [83180.056064]  ipt_do_table+0x43c/0xaf4
> [83180.056120]  iptable_mangle_hook+0xf4/0x22c
> [83180.056182]  nf_hook_slow+0x90/0x198
> [83180.056245]  ip_mc_output+0x50c/0x67c
> [83180.056302]  ip_send_skb+0x88/0x1bc
> [83180.056355]  udp_send_skb+0x524/0x930
> [83180.056415]  udp_sendmsg+0x126c/0x13ac
> [83180.056474]  udpv6_sendmsg+0x6d4/0x1764
> [83180.056539]  inet6_sendmsg+0x78/0x98
> [83180.056605]  __sys_sendto+0x360/0x450
> [83180.056667]  __arm64_sys_sendto+0x80/0x9c
> [83180.056725]  invoke_syscall+0x80/0x218
> [83180.056791]  el0_svc_common+0x18c/0x1bc
> [83180.056857]  do_el0_svc+0x44/0xfc
> [83180.056918]  el0_svc+0x20/0x50
> [83180.056966]  el0t_64_sync_handler+0x84/0xe4
> [83180.057020]  el0t_64_sync+0x1a4/0x1a8
> [83180.057110] Memory state around the buggy address:
> [83180.057150]  ffffffc02c0f8f00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
> f8 f8 f8
> [83180.057193]  ffffffc02c0f8f80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
> f8 f8 f8
> [83180.057237] >ffffffc02c0f9000: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
> f8 f8 f8
> [83180.057269]                    ^
> [83180.057304]  ffffffc02c0f9080: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
> f8 f8 f8
> [83180.057345]  ffffffc02c0f9100: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
> f8 f8 f8
> [83180.057378]
> ==================================================================
> 
> There are no reproduction steps available for this.
> 
> I have checked along the lines and see that
> https://github.com/torvalds/linux/commit/175e476b8cdf2a4de7432583b49c871345e4f8a1
> is still present in this kernel.
> Checked around similar lines in latest kernel and still see that
> implementation hasnt  changed much.
> 
> Can you pls help check if this is a known issue and was fixed in latest
> or help in pointing out how to debug this further ?
> 
> Thanks,
> Kaustubh
> 
