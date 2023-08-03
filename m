Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BBCAC0015E
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Aug 2023 10:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235130AbjHCKJo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Aug 2023 06:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235071AbjHCKJm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Aug 2023 06:09:42 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4DF2D73
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Aug 2023 03:09:38 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qRVGx-00024P-DW; Thu, 03 Aug 2023 12:09:35 +0200
Date:   Thu, 3 Aug 2023 12:09:35 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     "Fernando F. Mancera" <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: shell: Review test-cases for destroy command
Message-ID: <ZMt83w+uPz55z6kf@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        "Fernando F. Mancera" <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org
References: <20230801114236.27235-1-phil@nwl.cc>
 <8e5ab358-23dd-56dd-bc7a-b551ef950689@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e5ab358-23dd-56dd-bc7a-b551ef950689@riseup.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 03, 2023 at 12:45:14AM +0200, Fernando F. Mancera wrote:
> Thanks Phil, LGTM. Just one comment:
> 
> On 01/08/2023 13:42, Phil Sutter wrote:
> > Having separate files for successful destroy of existing and
> > non-existing objects is a bit too much, just combine them into one.
> > 
> > While being at it:
> > 
> > * Check that deleted objects are actually gone
> 
> I think that is done automatically with the expected ruleset.. isn't? If 
> not, what is the purpose of having them?

Oh, I missed those entirely! I'll prepare a v2 dropping the manual
checks and deleting the leftovers.

Thanks, Phil
