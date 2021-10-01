Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CFCFC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Oct 2021 20:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26F2261ACF
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Oct 2021 20:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhJAUJS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Oct 2021 16:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbhJAUJS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Oct 2021 16:09:18 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960F5C061775
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Oct 2021 13:07:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mWOoe-0002S5-1F; Fri, 01 Oct 2021 22:07:32 +0200
Date:   Fri, 1 Oct 2021 22:07:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [iptables PATCH] tests: shell: fix bashism
Message-ID: <20211001200732.GH2935@breakpoint.cc>
References: <20211001191228.1315767-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211001191228.1315767-1-jeremy@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jeremy Sowden <jeremy@azazel.net> wrote:
> The `<(cmd)` redirection is specific to Bash.  Update the shebang
> accordingly.
> 
> Fixes: 63ab4fe3a191 ("ebtables: Avoid dropping policy when flushing")

Applied, thanks.
