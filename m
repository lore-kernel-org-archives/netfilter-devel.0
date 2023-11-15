Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DAB5C07548
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Nov 2023 08:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234609AbjKOISO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Nov 2023 03:18:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjKOISN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Nov 2023 03:18:13 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FE8DF
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Nov 2023 00:18:10 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1r3B69-0005fP-FI; Wed, 15 Nov 2023 09:18:09 +0100
Date:   Wed, 15 Nov 2023 09:18:09 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: iptables manpage updates
Message-ID: <20231115081809.GB14621@breakpoint.cc>
References: <20231113103156.57745-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113103156.57745-1-jengelh@inai.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jan Engelhardt <jengelh@inai.de> wrote:
> 
> The following changes since commit 3be599b62869f2437f499e2386008d73b8c2e71b:
> 
>   extensions: libarpt_standard.t: Add a rule with builtin option masks (2023-11-09 15:55:33 +0100)
> 
> are available in the Git repository at:
> 
>   https://git.inai.de/iptables master

Also pulled, thanks Jan.
