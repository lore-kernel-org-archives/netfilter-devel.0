Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A2E0C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Oct 2022 13:04:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbiJFNEm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Oct 2022 09:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiJFNEk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Oct 2022 09:04:40 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E137FA346C;
        Thu,  6 Oct 2022 06:04:28 -0700 (PDT)
Date:   Thu, 6 Oct 2022 15:04:24 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org,
        netfilter <netfilter@vger.kernel.org>
Subject: Re: Kernel 6.0.0 bug pptp not work
Message-ID: <Yz7SWCDFjFLommZY@salvia>
References: <3D70BC1B-A19E-45E3-B6BC-6B2719BA9B46@gmail.com>
 <20221006111811.GA3034@breakpoint.cc>
 <0DF040F3-ACC8-447E-99DA-BB77FEE03C7E@gmail.com>
 <BDFD3407-955E-4FB4-B124-229978690BFF@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BDFD3407-955E-4FB4-B124-229978690BFF@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 06, 2022 at 03:57:23PM +0300, Martin Zaharinov wrote:
> Hm.. in kernel 6.0-rc7 
> 
> Pablo Neira Ayuso (2):
>       netfilter: nfnetlink_osf: fix possible bogus match in nf_osf_find()
>       netfilter: conntrack: remove nf_conntrack_helper documentation

No, it was earlier in the 6.0-rc process.
