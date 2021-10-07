Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE19AC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Oct 2021 17:40:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A304B61245
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Oct 2021 17:40:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243348AbhJGRmM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Oct 2021 13:42:12 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60170 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242882AbhJGRmM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Oct 2021 13:42:12 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 490B363EE1;
        Thu,  7 Oct 2021 19:38:46 +0200 (CEST)
Date:   Thu, 7 Oct 2021 19:40:14 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot+154bd5be532a63aa778b@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: nftables: skip netdev events generated on
 netns removal
Message-ID: <YV8w/sjaJSPt9KwX@salvia>
References: <0000000000008ce91e05bf9f62bc@google.com>
 <20211006142034.10362-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211006142034.10362-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 06, 2021 at 04:20:34PM +0200, Florian Westphal wrote:
> syzbot reported following (harmless) WARN:
> 
>  WARNING: CPU: 1 PID: 2648 at net/netfilter/core.c:468
>   nft_netdev_unregister_hooks net/netfilter/nf_tables_api.c:230 [inline]
>   nf_tables_unregister_hook include/net/netfilter/nf_tables.h:1090 [inline]
>   __nft_release_basechain+0x138/0x640 net/netfilter/nf_tables_api.c:9524
>   nft_netdev_event net/netfilter/nft_chain_filter.c:351 [inline]
>   nf_tables_netdev_event+0x521/0x8a0 net/netfilter/nft_chain_filter.c:382
> 
> reproducer:
> unshare -n bash -c 'ip link add br0 type bridge; nft add table netdev t ; \
>  nft add chain netdev t ingress \{ type filter hook ingress device "br0" \
>  priority 0\; policy drop\; \}'
> 
> Problem is that when netns device exit hooks create the UNREGISTER
> event, the .pre_exit hook for nf_tables core has already removed the
> base hook.  Notifier attempts to do this again.
> 
> The need to do base hook unregister unconditionally was needed in the past,
> because notifier was last stage where reg->dev dereference was safe.
> 
> Now that nf_tables does the hook removal in .pre_exit, this isn't
> needed anymore.

Applied, thanks.
