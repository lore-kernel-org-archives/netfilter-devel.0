Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20AB1C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jan 2022 06:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358722AbiATG1c (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jan 2022 01:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358760AbiATG1b (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jan 2022 01:27:31 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70313C061753
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jan 2022 22:27:28 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nAQur-0001An-As; Thu, 20 Jan 2022 07:27:25 +0100
Date:   Thu, 20 Jan 2022 07:27:25 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v3 1-5/5] src: Speed-up
Message-ID: <20220120062725.GB31905@breakpoint.cc>
References: <20220109031653.23835-1-duncan_roe@optusnet.com.au>
 <20220109031653.23835-6-duncan_roe@optusnet.com.au>
 <YeYClrLxYGDeD8ua@slk1.local.net>
 <YeYTzwpxiqLz8ulb@salvia>
 <YejdVZaoUz+t1qRU@slk1.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YejdVZaoUz+t1qRU@slk1.local.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> On Tue, Jan 18, 2022 at 02:11:43AM +0100, Pablo Neira Ayuso wrote:
> >
> > This patch have a number of showstoppers such as exposing structure
> > layout on the header files.
> >
> That's only in patch 5. You could apply 1-4. There are actually no other
> showstoppers, right?

Why does patch 3 exist? Shouldn't that just get squashed into patch 1?
