Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88761C00528
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jul 2023 10:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbjG0Kzi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jul 2023 06:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbjG0Kzh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jul 2023 06:55:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023711FEC;
        Thu, 27 Jul 2023 03:55:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8ABC961E2B;
        Thu, 27 Jul 2023 10:55:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F66AC433C8;
        Thu, 27 Jul 2023 10:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1690455336;
        bh=/n4Q4c520RL7Dl1tKjCtWlPmGbvq9IJDChGjJVXs3iA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G4yjxx+pq0FC2yz380v4JjUcdM4+LM7YQtI2TQLiO9WcWE63wZB2I3VkXI3VqcP7m
         mrBG5ZkBRTH0WCQgbCSX7Uzf8xw4f5ZEC8YBgQpVbNa0Szik89JJ8GaiX3VuPJbbhT
         prPYc1g+Qf9s4l5OmxdsXlT2iLR/zgKc1oDBFClQ=
Date:   Thu, 27 Jul 2023 12:55:32 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: Netfilter -stable patches for 6.1.y
Message-ID: <2023072724-thing-unselect-9f67@gregkh>
References: <ZMGbe24I9I+FOH57@calendula>
 <ZMGeeQiPNLhIlAd4@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZMGeeQiPNLhIlAd4@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jul 27, 2023 at 12:30:17AM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jul 27, 2023 at 12:17:31AM +0200, Pablo Neira Ayuso wrote:
> > Hi Greg, Sasha,
> > 
> > Could you please cherry-pick:
> > 
> >  29ad9a305943 ("netfilter: nf_tables: fix underflow in chain reference counter")
> >  b8ae60de6fd3 ("netfilter: nf_tables: fix underflow in object reference counter"
> 
> Err. Wrong commit IDs and patch order, apologies.
> 
> Correct commit IDs are:
> 
> Patch #1 d6b478666ffa ("netfilter: nf_tables: fix underflow in object reference counter")
> Patch #2 b389139f12f2 ("netfilter: nf_tables: fix underflow in chain reference counter")

Both now queued up, thanks.

greg k-h
