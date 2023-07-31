Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A64C001DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Jul 2023 22:15:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjGaWPR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 Jul 2023 18:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjGaWPQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jul 2023 18:15:16 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7237CB2
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2023 15:15:15 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qQbAX-0008SP-Ng; Tue, 01 Aug 2023 00:15:13 +0200
Date:   Tue, 1 Aug 2023 00:15:13 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ulogd2 patch ping
Message-ID: <20230731221513.GA32288@breakpoint.cc>
References: <20230725191128.GE84273@celephais.dreamlands>
 <20230726143533.GB2963@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230726143533.GB2963@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> I'll apply it on Friday in case noone objects until then.

Just for completeness: I did not apply it due to the unanswered
question from Pablo.

Also, don't we risk ambiguity here, or is there a guarantee that kernel
never emits mapped addresses?
