Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88FE6C433FE
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 Jan 2022 22:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237302AbiAIWcH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 9 Jan 2022 17:32:07 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42012 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237299AbiAIWcH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 9 Jan 2022 17:32:07 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 36D4562BD8;
        Sun,  9 Jan 2022 23:29:16 +0100 (CET)
Date:   Sun, 9 Jan 2022 23:32:01 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 0/5] netfilter: conntrack related cleanups
Message-ID: <YdtiYYvmx3IM6DO7@salvia>
References: <20220107040326.28038-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220107040326.28038-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jan 07, 2022 at 05:03:21AM +0100, Florian Westphal wrote:
> This patch series contains cleanups to conntrack and related
> users such as ovs and act_ct.
> 
> First patch converts conntrack reference counting to refcount_t api.
> Second patch gets rid of ip_ct_attach hook, we can use existing
> nf_ct_hook for this.
> 
> Third patch constifies a couple of structures that don't need to be
> writeable.
> 
> Last two patches splits nf_ct_put and nf_conntrack_put.
> These functions still do the same thing, but now only nf_conntrack_put
> uses the nf_ct_hook indirection, nf_ct_put uses a direct call.
> Virtually all places should use nf_ct_put -- only core kernel code
> needs to use the indirection.
> 
> Before this change, nf_ct_put was merely an alias for nf_conntrack_put
> so even conntrack itself did additional indirection.

Series applied, thanks
