Return-Path: <SRS0=wVpJ=EP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61EC5C2D0A3
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Nov 2020 11:10:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10F07206ED
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Nov 2020 11:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgKILKR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Nov 2020 06:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbgKILKR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Nov 2020 06:10:17 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE3EC0613CF
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Nov 2020 03:10:17 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kc53u-00025l-ON; Mon, 09 Nov 2020 12:10:14 +0100
Date:   Mon, 9 Nov 2020 12:10:14 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 5/7] tcpopt: allow to check for presence of any tcp
 option
Message-ID: <20201109111014.GC23619@breakpoint.cc>
References: <20201105141144.31430-1-fw@strlen.de>
 <20201105141144.31430-6-fw@strlen.de>
 <20201105191146.GA49955@ulthar.dreamlands>
 <20201105205742.GB49955@ulthar.dreamlands>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201105205742.GB49955@ulthar.dreamlands>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jeremy Sowden <jeremy@azazel.net> wrote:
> This seems to dedup' the payloads correctly:
> 
>   perl -nle '
>     our @payload;
>     our $rule;
>     if (/^# (.+)/) {
>       if ($rule ne $1) {
>         print for @payload;
>         $rule = $1
>       }
>       @payload = ()
>     }
>     push @payload, $_;
>     END { print for @payload }
>   ' tests/py/any/tcpopt.t.payload > tests/py/any/tcpopt.t.payload.tmp
>   mv tests/py/any/tcpopt.t.payload.tmp tests/py/any/tcpopt.t.payload
> 
> One could use perl's -i switch, but the printing of the final payload
> will be to stdout and not in-place.

Feel free to send a patch that weeds out all duplicates.
