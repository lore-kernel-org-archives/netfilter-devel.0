Return-Path: <SRS0=dCSv=65=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC0FC433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 May 2020 14:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ED1A20671
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 May 2020 14:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgEOOgg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 May 2020 10:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726140AbgEOOgg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 May 2020 10:36:36 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E3BC061A0C
        for <netfilter-devel@vger.kernel.org>; Fri, 15 May 2020 07:36:36 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jZbRw-0000k1-1h; Fri, 15 May 2020 16:36:32 +0200
Date:   Fri, 15 May 2020 16:36:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jacob Rasmussen <jacobraz@chromium.org>
Cc:     mkubecek@suse.cz, fw@strlen.de, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org
Subject: Re: userspace conntrack helper and confirming the master conntrack
Message-ID: <20200515143632.GF11406@breakpoint.cc>
References: <20190911081710.GD24779@unicorn.suse.cz>
 <20200513175408.195863-1-jacobraz@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513175408.195863-1-jacobraz@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jacob Rasmussen <jacobraz@chromium.org> wrote:
> I'm encountering a bug on Chrome OS that I believe to be caused by commit 827318feb69cb07ed58bb9b9dd6c2eaa81a116ad and I was wondering if there was any update on a fix/revert landing for this. 
> If a fix has already landed would anyone mind pointing me to the specific commit because I haven't been able to find it on my own.

Right, sorry about this.
Its most definitely caused by 827318feb69cb07ed58bb9b9dd6c2eaa81a116ad.

Unfortunately I have no easy way to validate the fix.
If you could help speeding this up it would be great if you could test
the candidate fix which I will send in a minute.

I've checked that it doesn't break conntrack in obvious ways and that
nft_queue.sh self test still passes.
