Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 817D2C433ED
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Apr 2021 13:44:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 436366141C
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Apr 2021 13:44:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238637AbhDUNoc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Apr 2021 09:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242746AbhDUNoC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Apr 2021 09:44:02 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4850C061342
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Apr 2021 06:43:23 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lZD8S-0006cz-OO; Wed, 21 Apr 2021 15:43:20 +0200
Date:   Wed, 21 Apr 2021 15:43:20 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: nf_log_syslog: Unset bridge logger in pernet
 exit
Message-ID: <20210421134320.GE4841@breakpoint.cc>
References: <20210421103421.6168-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421103421.6168-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Without this, a stale pointer remains in pernet loggers after module
> unload causing a kernel oops during dereference. Easily reproduced by:
> 
> | # modprobe nf_log_syslog
> | # rmmod nf_log_syslog
> | # cat /proc/net/netfilter/nf_log

Ouch, thanks for fixing this.

Acked-by: Florian Westphal <fw@strlen.de>
