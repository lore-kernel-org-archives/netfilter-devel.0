Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65D52C433FE
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Nov 2021 16:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbhKURCN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Nov 2021 12:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237885AbhKURCN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Nov 2021 12:02:13 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EC3C061574
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Nov 2021 08:59:08 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1moqBE-0005kj-AT; Sun, 21 Nov 2021 17:59:05 +0100
Date:   Sun, 21 Nov 2021 17:59:04 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        shmulik.ladkani@gmail.com
Subject: Re: [PATCH nf-next,v2] netfilter: conntrack: configurable conntrack
 gc scan interval
Message-ID: <20211121165904.GK6326@breakpoint.cc>
References: <20211121105448.2756593-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211121105448.2756593-1-eyal.birger@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Eyal Birger <eyal.birger@gmail.com> wrote:
> In Commit 4608fdfc07e1 ("netfilter: conntrack: collect all entries in one cycle")
> conntrack gc was changed to run periodically every 2 minutes.
> 
> On systems handling many UDP connections, this leads to bursts of session
> termination handling.
> 
> As suggested in the original commit, provide the ability to control the gc
> interval using a sysctl knob.

Apologies, I was afk and could not respond sooner.

I'd like to propose an additional knob that allows to switch to partial
scan to spread netlink event bursts.

Its largely identical to this proposed change.

Will submit a patch soon and put you on CC.
