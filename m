Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CA39C00140
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Aug 2022 11:07:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236396AbiHBLH1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Aug 2022 07:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbiHBLH1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Aug 2022 07:07:27 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72AF3F33F
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Aug 2022 04:07:25 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oIpkC-0000nS-3U; Tue, 02 Aug 2022 13:07:24 +0200
Date:   Tue, 2 Aug 2022 13:07:24 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Nicolas MAFFRE <nicolas.maffre.external@airbus.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: iptables v1.6.2 EOS date
Message-ID: <20220802110724.GG29493@breakpoint.cc>
References: <CAHWqpUO3v0gtUYND=JNHwCU3W2qVaeVujYaKvZudvmmFqMpwpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHWqpUO3v0gtUYND=JNHwCU3W2qVaeVujYaKvZudvmmFqMpwpQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Nicolas MAFFRE <nicolas.maffre.external@airbus.com> wrote:
> I'm working on a project that uses iptables v1.6.2 and I need to know
> if there is an "End of support" date for this version of the software
> iptables ?

We only accept changes on top of the latest version
(https://git.netfilter.org/iptables/).

Of course we still fix bugs reported with older releases provided
the latest version is still affected.
