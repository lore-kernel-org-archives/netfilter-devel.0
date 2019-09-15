Return-Path: <SRS0=dRBk=XK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EC9BC4CEC7
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Sep 2019 19:07:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A167214AF
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Sep 2019 19:07:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbfIOTHM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Sep 2019 15:07:12 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:59816 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726595AbfIOTHM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Sep 2019 15:07:12 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i9Zra-00058i-B5; Sun, 15 Sep 2019 21:07:10 +0200
Date:   Sun, 15 Sep 2019 21:07:10 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] json: tests: fix typo in ct expectation json test
Message-ID: <20190915190710.GK10656@breakpoint.cc>
References: <20190915123955.1969-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190915123955.1969-1-ffmancera@riseup.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fernando Fernandez Mancera <ffmancera@riseup.net> wrote:
> The correct form is "ct expectation" not "ct expect". That was causing the
> tests/py/ip/object.t json test to fail.

pushed out, thanks Fernando.
