Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00539C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 13 Feb 2022 21:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238368AbiBMVKv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 13 Feb 2022 16:10:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238366AbiBMVKv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 13 Feb 2022 16:10:51 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFECD53736
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Feb 2022 13:10:43 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nJM8m-0003lC-9Z; Sun, 13 Feb 2022 22:10:40 +0100
Date:   Sun, 13 Feb 2022 22:10:40 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables] xshared: Implement xtables lock timeout using
 signals
Message-ID: <Yglz0Oi9snooOto6@strlen.de>
References: <256b8216-77db-cc28-4099-30c7dafb986e@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <256b8216-77db-cc28-4099-30c7dafb986e@fortanix.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jethro Beekman <jethro@fortanix.com> wrote:
> Previously, if a lock timeout is specified using `-w`, flock() is called
> using LOCK_NB in a loop with a sleep. This results in two issues.
>
> The first issue is that the process may wait longer than necessary when
> the lock becomes available. For this the `-W` option was added, but this
> requires fine-tuning.
> 
> The second issue is that if lock contention is high, invocations using
> `-w` without a timeout will always win lock acquisition from
> invocations that use `-w` *with* a timeout. This is because invocations
> using `-w` are actively waiting on the lock whereas the others only
> check from time to time whether the lock is free, which will never be
> the case.
> 
> This patch removes the `-W` option and the sleep loop. Instead, flock()
> is always called in a blocking fashion, but the alarm() function is used
> with a non-SA_RESTART signal handler to cancel the system call.

Doesn't apply anymore, if you send a rebased version I'll apply it.

