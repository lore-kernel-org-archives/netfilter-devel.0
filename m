Return-Path: <SRS0=dC0K=W7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08DCFC3A5A8
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 06:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA5B622CED
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 06:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbfIDG6P (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Sep 2019 02:58:15 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:49924 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728921AbfIDG6P (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Sep 2019 02:58:15 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1i5PF7-0004hS-NQ; Wed, 04 Sep 2019 08:58:13 +0200
Date:   Wed, 4 Sep 2019 08:58:13 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: fix possible null-pointer
 dereference in object update
Message-ID: <20190904065813.GG25650@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org
References: <20190903213313.1080-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903213313.1080-1-ffmancera@riseup.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Fernando,

On Tue, Sep 03, 2019 at 11:33:13PM +0200, Fernando Fernandez Mancera wrote:
> Fixes: d62d0ba97b58 ("netfilter: nf_tables: Introduce stateful object update operation")
> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>

Your patch looks good but please (always) provide a bit of explanation.
In this case typical questions to answer in commit message are:
- Why may obj->ops->update be NULL? For which object type are they not
  defined?
- How could one trigger the issue? In other words, why is
  nft_obj_commit_update() called for the "wrong" object?

Cheers, Phil
