Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 833FDC38A02
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Oct 2022 11:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiJaLd3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 Oct 2022 07:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiJaLd2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Oct 2022 07:33:28 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA473E086
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2022 04:33:27 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1opT2j-0005oL-Gt; Mon, 31 Oct 2022 12:33:25 +0100
Date:   Mon, 31 Oct 2022 12:33:25 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] payload: do not kill dependency for proto_unknown
Message-ID: <20221031113325.GD5040@breakpoint.cc>
References: <20221031111616.96702-1-pablo@netfilter.org>
 <20221031111616.96702-2-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031111616.96702-2-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Unsupported meta match on layer 4 protocol sets on protocol context to
> proto_unknown, handle anything coming after it as a raw expression in
> payload_expr_expand().
> 
> Moreover, payload_dependency_kill() skips dependency removal if protocol
> is unknown, so raw payload expression leaves meta layer 4 protocol
> remains in place.
> 
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1641
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  src/payload.c                     |  6 ++++--
>  tests/py/any/rawpayload.t         |  2 ++
>  tests/py/any/rawpayload.t.json    | 31 +++++++++++++++++++++++++++++++
>  tests/py/any/rawpayload.t.payload |  8 ++++++++

LGTM, thanks for including testcases!

