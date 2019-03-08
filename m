Return-Path: <SRS0=0Xdd=RL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD5DC43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 10:50:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9775420811
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 10:50:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbfCHKum (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 05:50:42 -0500
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:34088 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726249AbfCHKum (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 05:50:42 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1h2D5L-0004k5-Dd; Fri, 08 Mar 2019 11:50:39 +0100
Date:   Fri, 8 Mar 2019 11:50:39 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Dmitrii Tcvetkov <demfloro@demfloro.ru>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: NULL pointer dereference in nft_set_elem_destroy()
Message-ID: <20190308105039.xmf3ho3nixhfnnmh@breakpoint.cc>
References: <20190308131746.5899877a@fire.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190308131746.5899877a@fire.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Dmitrii Tcvetkov <demfloro@demfloro.ru> wrote:
> After upgrade to 5.0 on XPS 13 9360 I get NULL pointer dereference in
> dmesg (attached). Distro is Arch Linux, kernel is built with custom
> config (attached), but distro kernel[1] reproduces the issue on the
> laptop as well.
> 
> Bisect led me to commit f6ac858589768 (netfilter: nf_tables: unbind set
> in rule from commit path), bisect log attached. The commit doesn't
> revert cleanly on top of v5.0, and conflicts aren't trivial for me to
> resolve.

Please see
https://patchwork.ozlabs.org/patch/1053232/

this probably resolves this crash as well.
