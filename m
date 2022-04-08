Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F971C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Apr 2022 14:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234876AbiDHOS6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Apr 2022 10:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbiDHOS6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Apr 2022 10:18:58 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A88417A8D
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2022 07:16:54 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ncpPw-0002am-5V; Fri, 08 Apr 2022 16:16:52 +0200
Date:   Fri, 8 Apr 2022 16:16:52 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: py: Don't colorize output if stderr is
 redirected
Message-ID: <20220408141652.GB7920@breakpoint.cc>
References: <20220408134707.24384-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408134707.24384-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Cover for calls with '2>/tmp/log' and avoid printing escape sequences to
> that file. One could still keep colored output on stdout, but that
> required a printing routine for non-errors.

Thanks!  Please push.
