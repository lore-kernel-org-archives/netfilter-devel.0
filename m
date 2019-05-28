Return-Path: <SRS0=QEZg=T4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF497C04AB6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 22:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC48A208CB
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 22:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfE1WXQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 May 2019 18:23:16 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:38648 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726492AbfE1WXQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 May 2019 18:23:16 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hVkV0-0003tX-0u; Wed, 29 May 2019 00:23:14 +0200
Date:   Wed, 29 May 2019 00:23:14 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Eric Garver <eric@garver.life>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v4 1/7] src: Fix cache_flush() in cache_needs_more()
 logic
Message-ID: <20190528222313.GB31548@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, Eric Garver <eric@garver.life>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190528210323.14605-1-phil@nwl.cc>
 <20190528210323.14605-2-phil@nwl.cc>
 <20190528213244.teiqi7y7rxz5b5ri@egarver.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528213244.teiqi7y7rxz5b5ri@egarver.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 28, 2019 at 05:32:44PM -0400, Eric Garver wrote:
> On Tue, May 28, 2019 at 11:03:17PM +0200, Phil Sutter wrote:
> > Commit 34a20645d54fa enabled cache updates depending on command causing
> 
> Actual hash is eeda228c2d17. 

Oh, thanks for the catch! No idea where the other hash came from, but it
exists in my repository at least.

Thanks, Phil
