Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61586C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Apr 2022 10:22:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238182AbiDIKYZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Apr 2022 06:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233317AbiDIKYY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Apr 2022 06:24:24 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21B4AAB4F
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Apr 2022 03:22:17 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nd8ES-0007XH-6H; Sat, 09 Apr 2022 12:22:16 +0200
Date:   Sat, 9 Apr 2022 12:22:16 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Topi Miettinen <toiwoton@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] doc: Document that kernel may accept unimplemented
 expressions
Message-ID: <20220409102216.GF19371@breakpoint.cc>
References: <20220409094402.22567-1-toiwoton@gmail.com>
 <20220409095152.GA19371@breakpoint.cc>
 <9277ac40-4175-62b3-d777-bdfa9434d187@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9277ac40-4175-62b3-d777-bdfa9434d187@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Topi Miettinen <toiwoton@gmail.com> wrote:
> Note that the kernel may accept expressions without errors even if it
> doesn't implement the feature. For example, input chain filters using
> *meta skuid*, *meta skgid*, *meta cgroup* or *socket cgroupv2*
> expressions are silently accepted but they don't work yet, except when used
> with *tproxy* rules, early demultiplexing or BPF programs.

This is what iptables-extensions(8) says:

IMPORTANT:  when  being  used in the INPUT chain, the cgroup matcher is currently only of limited functionality, meaning it will only match on packets that are processed for local sockets through early socket demuxing. Therefore, general usage on the INPUT chain is not advised unless the implications
are well understood.

For nftables, this is true for all meta types that use skb->sk internally,
such as skuid, skgid, cgroup, ...

> Could you please explain this 'early demux' concept? Is this something that
> can be triggered with NFT rules, kernel configuration etc? I can't find any
> documentation.

sysctl.
net.ipv4.ip_early_demux = 1
net.ipv4.tcp_early_demux = 1
net.ipv4.udp_early_demux = 1

This is a performance optimization, tcp edemux only works for
sockets in established state, udp demux has restrictions as well.

So, no guarantee that this will set the socket reliably, hence the
paragraph in the iptables-extensions manpage.
