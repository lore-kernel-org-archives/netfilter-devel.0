Return-Path: <SRS0=dbJk=VL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C9ABC742D2
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Jul 2019 23:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F240620C01
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Jul 2019 23:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbfGNXeC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Jul 2019 19:34:02 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46940 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728949AbfGNXeC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Jul 2019 19:34:02 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hmo0H-0001A0-FZ; Mon, 15 Jul 2019 01:34:01 +0200
Date:   Mon, 15 Jul 2019 01:34:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     Ander Juaristi <a@juaristi.eus>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v5 1/3] meta: Introduce new conditions 'time', 'day' and
 'hour'
Message-ID: <20190714233401.frxc63fky53yfqft@breakpoint.cc>
References: <20190707205531.6628-1-a@juaristi.eus>
 <20190714231958.wtyiusnqpazmwbgl@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190714231958.wtyiusnqpazmwbgl@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> Ander Juaristi <a@juaristi.eus> wrote:
> This looks good to me, but there are three usability issues.
> 
> The worst one first:
> 
> nft add rule filter input hour 23:15-00:22 counter
> 
> This works. But this fails:
> nft add rule filter input hour 23:15-03:22  counter
> Error: Range has zero or negative size
> 
> Because values are converted to UTC, the first one will be a range from
> 21:15 to 22:22 UTC, so left < right. Second one is not.
> 
> The obvious workaround:
> 
> meta hour < "04:22" will NOT match at 00:28 (GMT+2), as its still 22:28 in
> the UTC time zone.
> 
> It will match once local time is past 0 hours UTC.
> 
> I suggest to try to fix this from the evaluation step, by
> swapping left and right and inverting the match.
> 
> So 76500-8520 (left larger right) turns into "!= 8520-76500",
> which appears to do the right thing.
> 
> shape and I have no idea how to fix this without using/relying on kernel time zone.

Argh, I reworded this and forgot to delete this half-sentence above.

> Even when relying on kernel time zone for everything, I don't see
> how we can support cross-day ("22:23-00:42") matching, as the range is
> invalid.

And that as well of course, swap and invert should work just fine.

> Second problem:
> Only solution I see is to change kernel patch to rely on
> sys_tz, just like xt_time, with all the pain this brings.

This stands, as the weekday is computed in the kernel, we will
need to bring sys_tz into this on the kernel side, the current
code uses UTC so we could be several hours off.

This can be restricted to the 'DAY' case of course.
