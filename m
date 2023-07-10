Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E5EEB64DA
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jul 2023 11:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbjGJLVi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jul 2023 07:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbjGJLVi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jul 2023 07:21:38 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64609D2
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jul 2023 04:21:37 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qIoxT-0004Hu-4y; Mon, 10 Jul 2023 13:21:35 +0200
Date:   Mon, 10 Jul 2023 13:21:35 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Igor Raits <igor@gooddata.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: ebtables-nft can't delete complex rules by specifying complete
 rule with kernel 6.3+
Message-ID: <20230710112135.GA12203@breakpoint.cc>
References: <CA+9S74jbOefRzu1YxUrXC7gbYY8xDKH6QNJBuAQoNnnLODxWrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+9S74jbOefRzu1YxUrXC7gbYY8xDKH6QNJBuAQoNnnLODxWrg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Igor Raits <igor@gooddata.com> wrote:
> Hello,
> 
> We started to observe the issue regarding ebtables-nft and how it
> can't wipe rules when specifying full rule. Removing the rule by index
> works fine, though. Also with kernel 6.1.y it works completely fine.
> 
> I've started with 1.8.8 provided in CentOS Stream 9, then tried the
> latest git version and all behave exactly the same. See the behavior
> below. As you can see, simple DROP works, but more complex one do not.
> 
> As bugzilla requires some special sign-up procedure, apologize for
> reporting it directly here in the ML.

Thanks for the report, I'll look into it later today.
