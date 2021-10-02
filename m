Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55C09C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Oct 2021 18:50:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25B9461B40
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Oct 2021 18:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbhJBSw0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Oct 2021 14:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233799AbhJBSwZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Oct 2021 14:52:25 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987B2C0613EC
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Oct 2021 11:50:39 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mWk5k-0006M6-MW; Sat, 02 Oct 2021 20:50:36 +0200
Date:   Sat, 2 Oct 2021 20:50:36 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Eugene Crosser <crosser@average.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: In raw prerouting, `iif` matches different interfaces in
 different kernels when enslaved in a vrf
Message-ID: <20211002185036.GJ2935@breakpoint.cc>
References: <17326577-1ab7-aaaa-0911-13ee131bdee0@average.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17326577-1ab7-aaaa-0911-13ee131bdee0@average.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Eugene Crosser <crosser@average.org> wrote:
> Is this a known situation? Which behavior is "correct"?

No idea, your reproducer gives this on my laptop:

 unshare -n bash repro.sh
net.ipv4.conf.veout.accept_local = 1
5.14.9-200.fc34.x86_64
conntrack v1.4.5 (conntrack-tools): connection tracking table has been emptied.
PING 172.30.30.2 (172.30.30.2) from 172.30.30.1 vein: 56(84) bytes of data.

--- 172.30.30.2 ping statistics ---
1 packets transmitted, 0 received, 100% packet loss, time 0ms

conntrack v1.4.5 (conntrack-tools): 0 flow entries have been shown.

A bisection is needed to figure out what introduced a change.

However, if this is already changeed for a few releases then we can't
revert it again.
