Return-Path: <SRS0=dCSv=65=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 804E3C433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 May 2020 15:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F1B820728
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 May 2020 15:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgEOPRk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 May 2020 11:17:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:56934 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726240AbgEOPRk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 May 2020 11:17:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A47ADAC6E;
        Fri, 15 May 2020 15:17:41 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 8BEF6604B1; Fri, 15 May 2020 17:17:38 +0200 (CEST)
Date:   Fri, 15 May 2020 17:17:38 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Florian Westphal <fw@strlen.de>
Cc:     Jacob Rasmussen <jacobraz@chromium.org>,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: userspace conntrack helper and confirming the master conntrack
Message-ID: <20200515151738.GA19526@lion.mk-sys.cz>
References: <20190911081710.GD24779@unicorn.suse.cz>
 <20200513175408.195863-1-jacobraz@google.com>
 <20200515143632.GF11406@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515143632.GF11406@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 15, 2020 at 04:36:32PM +0200, Florian Westphal wrote:
> Jacob Rasmussen <jacobraz@chromium.org> wrote:
> > I'm encountering a bug on Chrome OS that I believe to be caused by commit 827318feb69cb07ed58bb9b9dd6c2eaa81a116ad and I was wondering if there was any update on a fix/revert landing for this. 
> > If a fix has already landed would anyone mind pointing me to the specific commit because I haven't been able to find it on my own.
> 
> Right, sorry about this.
> Its most definitely caused by 827318feb69cb07ed58bb9b9dd6c2eaa81a116ad.
> 
> Unfortunately I have no easy way to validate the fix.
> If you could help speeding this up it would be great if you could test
> the candidate fix which I will send in a minute.
> 
> I've checked that it doesn't break conntrack in obvious ways and that
> nft_queue.sh self test still passes.

Ah, my fault, I completely forgot this. Hopefully I'll be able to test
the fix this weekend.

Michal
