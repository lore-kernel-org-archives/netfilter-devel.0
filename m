Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B63DC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 May 2022 13:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237702AbiERNVm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 May 2022 09:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237742AbiERNVm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 May 2022 09:21:42 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D16A76F1
        for <netfilter-devel@vger.kernel.org>; Wed, 18 May 2022 06:21:40 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nrJcP-0001Y5-JL; Wed, 18 May 2022 15:21:37 +0200
Date:   Wed, 18 May 2022 15:21:37 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     vincent@systemli.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] treewide: use uint* instead of u_int*
Message-ID: <YoTy4YCH1UjqmPAG@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jan Engelhardt <jengelh@inai.de>, vincent@systemli.org,
        netfilter-devel@vger.kernel.org
References: <9n33705n-4s4r-q4s1-q97-76n73p18s99r@vanv.qr>
 <20220516161641.15321-1-vincent@systemli.org>
 <YoNYjq2yDr3jbnyv@orbyte.nwl.cc>
 <r4s26683-61sq-8p27-o94-92rr8sqo796@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <r4s26683-61sq-8p27-o94-92rr8sqo796@vanv.qr>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 17, 2022 at 10:14:10AM +0200, Jan Engelhardt wrote:
> On Tuesday 2022-05-17 10:10, Phil Sutter wrote:
> >> +++ b/include/libipq/libipq.h
> 
> >> -	u_int8_t blocking;
> >> +	uint8_t blocking;
> >
> >Might this break API compatibility? ABI won't change, but I suppose
> >users would have to include stdint.h prior to this header. Are we safe
> >if we change the include from sys/types.h to stdint.h in line 27 of that
> >file?
> 
> Always include what you use, so yeah, libipq.h should include stdint.h.

Thanks. Patch pushed with the two changes I suggested.

Thanks, Phil
