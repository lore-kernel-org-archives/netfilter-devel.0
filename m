Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E74C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Oct 2022 12:58:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbiJFM6W (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Oct 2022 08:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbiJFM6F (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Oct 2022 08:58:05 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4C2F51759F;
        Thu,  6 Oct 2022 05:57:34 -0700 (PDT)
Date:   Thu, 6 Oct 2022 14:57:29 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org,
        netfilter <netfilter@vger.kernel.org>
Subject: Re: Kernel 6.0.0 bug pptp not work
Message-ID: <Yz7QuaHF1P7oDAUN@salvia>
References: <3D70BC1B-A19E-45E3-B6BC-6B2719BA9B46@gmail.com>
 <20221006111811.GA3034@breakpoint.cc>
 <0DF040F3-ACC8-447E-99DA-BB77FEE03C7E@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0DF040F3-ACC8-447E-99DA-BB77FEE03C7E@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 06, 2022 at 03:46:37PM +0300, Martin Zaharinov wrote:
> Huh
> Very strange in kernel 6.0.0 i not found : net.netfilter.nf_conntrack_helper
> 
> 
> in old kernel 5.19.14 in sysctl -a | grep net.netfilter.nf_conntrack_helper 
> 
> net.netfilter.nf_conntrack_helper = 1

Yes, default conntrack helper attachment was disabled 10 years ago,
and this option was disabled 6 years ago by default.

See: https://github.com/regit/secure-conntrack-helpers/blob/master/secure-conntrack-helpers.rst
