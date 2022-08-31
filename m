Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87679ECAAD1
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Aug 2022 06:54:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiHaGyr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Aug 2022 02:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiHaGyq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Aug 2022 02:54:46 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2303F59
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2022 23:44:50 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oTHSx-0000ij-Ui; Wed, 31 Aug 2022 08:44:48 +0200
Date:   Wed, 31 Aug 2022 08:44:47 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Harsh Modi <harshmodi@google.com>
Cc:     netfilter-devel@vger.kernel.org, sdf@google.com,
        pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Subject: Re: [PATCH bridge, v3] br_netfilter: Drop dst references before
 setting.
Message-ID: <20220831064447.GA1352@breakpoint.cc>
References: <20220831053603.4168395-1-harshmodi@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831053603.4168395-1-harshmodi@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Harsh Modi <harshmodi@google.com> wrote:
> The IPv6 path already drops dst in the daddr changed case, but the IPv4
> path does not. This change makes the two code paths consistent.

Acked-by: Florian Westphal <fw@strlen.de>

Probably best to add a

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

... just to make sure this gets propagated to stable.

Original code was likely fine because nothing ever did set a skb->dst
entry earlier than bridge in those days.
