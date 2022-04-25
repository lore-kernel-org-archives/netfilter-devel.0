Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEEA4C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Apr 2022 22:34:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbiDYWhb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Apr 2022 18:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbiDYWha (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Apr 2022 18:37:30 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1418FE5EE
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2022 15:34:24 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nj7Hh-0006vO-Ig; Tue, 26 Apr 2022 00:34:21 +0200
Date:   Tue, 26 Apr 2022 00:34:21 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Topi Miettinen <toiwoton@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_socket: socket expressions for GID & UID
Message-ID: <20220425223421.GA14400@breakpoint.cc>
References: <20220420185447.10199-1-toiwoton@gmail.com>
 <5a292abd-7f2e-728f-5594-86d85fbd1c00@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a292abd-7f2e-728f-5594-86d85fbd1c00@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Topi Miettinen <toiwoton@gmail.com> wrote:
> On 20.4.2022 21.54, Topi Miettinen wrote:
> > Add socket expressions for checking GID or UID of the originating
> > socket. These work also on input side, unlike meta skuid/skgid.
> 
> Unfortunately, there's a reproducible kernel BUG when closing a local
> connection:
> 
> Apr 25 21:18:13 kernel:
> ==================================================================
> Apr 25 21:18:13 kernel: BUG: KASAN: null-ptr-deref in
> nf_sk_lookup_slow_v6+0x45b/0x590 [nf_socket_ipv6]

You can pass this to scripts/faddr2line to get the location of the null deref.
