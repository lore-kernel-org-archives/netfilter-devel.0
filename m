Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3AF1C77B7C
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 May 2023 07:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbjE1HhH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 May 2023 03:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjE1HhG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 May 2023 03:37:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4511ED9;
        Sun, 28 May 2023 00:37:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3B2561704;
        Sun, 28 May 2023 07:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4544C433D2;
        Sun, 28 May 2023 07:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1685259425;
        bh=Qd9tnD9wSONZWbb18aZSjI7munDSHaVoGfwt8AS34JI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RbLCHRLMprJtpT6iQHE0fL2tk6nvka0Hd6RTDbQsKfaMjfRTrjOrBsExSd/K/JKS4
         wV34ToAkyuVp/C49TNMlKOpeZWljsTmZsUQwgLwf1g/efMaSgA5c3S6SoT1Q+MTgS8
         gl5at09OuQYtkV6GfupuvduPLyOurVcCaJKHzRkQ=
Date:   Sun, 28 May 2023 08:36:31 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, stable@vger.kernel.org,
        sashal@kernel.org
Subject: Re: [PATCH -stable,4.14 00/11] more stable fixes for 4.14
Message-ID: <2023052822-resupply-copartner-acdd@gregkh>
References: <20230527160811.67779-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230527160811.67779-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, May 27, 2023 at 06:08:00PM +0200, Pablo Neira Ayuso wrote:
> Hi Greg, Sasha,
> 
> [ This is v2 including two initial missing backport patches and one new
>   patch at the end of this batch. ]
> 
> This is second round of -stable backport fixes for 4.14. This batch
> includes dependency patches which are not currently in the 4.14 branch.

All now queued up, thanks.

greg k-h
