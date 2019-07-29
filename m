Return-Path: <SRS0=chdK=V2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61DA4C433FF
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Jul 2019 10:33:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E19E206E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Jul 2019 10:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbfG2KdU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 Jul 2019 06:33:20 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:33782 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728203AbfG2KdU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Jul 2019 06:33:20 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hs2xx-0002Vs-EJ; Mon, 29 Jul 2019 12:33:18 +0200
Date:   Mon, 29 Jul 2019 12:33:17 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nfacct: Fix alignment mismatch in
 xt_nfacct_match_info
Message-ID: <20190729103317.ujlx4larhtzeijp3@breakpoint.cc>
References: <2781693.KLf3iWz6jR@rocinante.m.i2n>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2781693.KLf3iWz6jR@rocinante.m.i2n>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com> wrote:
> When running a 64-bit kernel with a 32-bit iptables binary, the size of
> the xt_nfacct_match_info struct diverges.
> 
>     kernel: sizeof(struct xt_nfacct_match_info) : 40
>     iptables: sizeof(struct xt_nfacct_match_info)) : 36
> 
> Trying to append nfacct related rules results in an unhelpful message.
> Although it is suggested to look for more information in dmesg, nothing
> can be found there.
> 
>     # iptables -A <chain> -m nfacct --nfacct-name <acct-object>
>     iptables: Invalid argument. Run `dmesg' for more information.
> 
> This patch fixes the memory misalignment by enforcing 8-byte alignment
> within the struct. This solution is often used in many other uapi
> netfilter headers.

Yes, but this breaks the 32bit abi.

Its best to add a 'v1' match revision to fix this.
