Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97D6AECAAD4
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Aug 2022 09:47:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbiHaJrC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Aug 2022 05:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiHaJqz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Aug 2022 05:46:55 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9425DD022D
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Aug 2022 02:46:48 -0700 (PDT)
Date:   Wed, 31 Aug 2022 11:46:41 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Harsh Modi <harshmodi@google.com>, netfilter-devel@vger.kernel.org,
        sdf@google.com, kadlec@netfilter.org
Subject: Re: [PATCH bridge, v3] br_netfilter: Drop dst references before
 setting.
Message-ID: <Yw8uATAfEDeQ1f7X@salvia>
References: <20220831053603.4168395-1-harshmodi@google.com>
 <20220831064447.GA1352@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220831064447.GA1352@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 31, 2022 at 08:44:47AM +0200, Florian Westphal wrote:
> Harsh Modi <harshmodi@google.com> wrote:
> > The IPv6 path already drops dst in the daddr changed case, but the IPv4
> > path does not. This change makes the two code paths consistent.
> 
> Acked-by: Florian Westphal <fw@strlen.de>

Applied, thanks

> Probably best to add a
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> 
> ... just to make sure this gets propagated to stable.
> 
> Original code was likely fine because nothing ever did set a skb->dst
> entry earlier than bridge in those days.

I have appended this comment for the record.
