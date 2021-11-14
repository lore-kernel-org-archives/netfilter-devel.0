Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84A8AC433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 11:04:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6505D61177
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 11:04:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234673AbhKNLHm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Nov 2021 06:07:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233656AbhKNLHl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 06:07:41 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29EE0C061766
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2021 03:04:38 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mmDJK-0004he-Vm; Sun, 14 Nov 2021 12:04:35 +0100
Date:   Sun, 14 Nov 2021 12:04:34 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Matt Zagrabelny <mzagrabe@d.umn.edu>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: redefining a variable
Message-ID: <20211114110434.GA6326@breakpoint.cc>
References: <CAOLfK3Xq-vre2+vG6k4shjKnEJ+Dq=-z1isVCsgqNLjh=xxfXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOLfK3Xq-vre2+vG6k4shjKnEJ+Dq=-z1isVCsgqNLjh=xxfXg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Matt Zagrabelny <mzagrabe@d.umn.edu> wrote:
> Greetings,
> 
> I would like to be able to redefine variables in nft.
> 
> Would you folks consider a switch or a new keyword to achieve something like:
> 
> define ints = eth0
> 
> define --redefine-ok ints = { $ints, eth1 }
> 
> define_or_redefine ints = { $ints, eth2 }
> 
> Thanks for your help and support.

nft has undefine & redefine keywords.
