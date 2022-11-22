Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82975C433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Nov 2022 16:19:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234322AbiKVQTk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Nov 2022 11:19:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234332AbiKVQTR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Nov 2022 11:19:17 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43E72712
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Nov 2022 08:16:45 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1oxVwx-0006cJ-V3; Tue, 22 Nov 2022 17:16:44 +0100
Date:   Tue, 22 Nov 2022 17:16:43 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables-nft RFC 5/5] generic.xlate: make one replay test case
 work
Message-ID: <Y3z160WHbmhzKbt7@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20221121111932.18222-1-fw@strlen.de>
 <20221121111932.18222-6-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121111932.18222-6-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Nov 21, 2022 at 12:19:32PM +0100, Florian Westphal wrote:
> This is just to demonstrate yet another problem.
> 
> For the rule itself it doesn't matter if '-i' or '-s' is passed first,
> but the test script has no deeper understanding for the rules and will
> do a simple textual comparision, this will fail because as-is the output
> is different than the input (options are written out in different
> order).
> 
> We either need to sanoitize the input or update the test script to
> split lines and re-order the options or similar.

My solution was to add replay records to test files like so:

| diff --git a/extensions/generic.txlate b/extensions/generic.txlate
| index 6779d6f86dec8..8c3b7dbeb7320 100644
| --- a/extensions/generic.txlate
| +++ b/extensions/generic.txlate
| @@ -1,69 +1,70 @@
| -iptables-translate -I OUTPUT -p udp -d 8.8.8.8 -j ACCEPT
| +iptables-translate -I OUTPUT -p udp -d 8.8.8.8 -j ACCEPT;-d 8.8.8.8/32 -p udp -j ACCEPT
|  nft insert rule ip filter OUTPUT ip protocol udp ip daddr 8.8.8.8 counter accept
|  
|  iptables-translate -F -t nat
|  nft flush table ip nat

Since iptables is able to compare rules though, we could utilize this.
So when checking the replay, instead of calling iptables-save and
searching the output, we could call 'iptables -C'. I'll try this, it
sounds simple and doable.

Thanks, Phil
