Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8185EC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Mar 2022 21:28:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243370AbiCOV3L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Mar 2022 17:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbiCOV3K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Mar 2022 17:29:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5293212AB2;
        Tue, 15 Mar 2022 14:27:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 46E80CE1C87;
        Tue, 15 Mar 2022 21:27:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B9AC340E8;
        Tue, 15 Mar 2022 21:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647379673;
        bh=0ddtZ//kxhQuMv99OV1t3SHqo/wbAgIY5upDOleeyGA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EwyQf7Wttk/kpFZ+3g1V3IJNLPx/TmVMcRrSiISVVUPDbhYaJOaIj5Zr5usKylQd3
         RVozvMfdZmbUoqYonmkmy5kk8JssaLk7MmalSUxjisznuoMUZ5MdSQEVzlWmIePh0k
         LpQgTb7LleBZcX9hYk4cGus3psQjl4lKD16aZPhNmWQmQ7eyYPZvEMMsDhIcU7qG65
         3+Aba9Rb+cr6Zkfgy9ETEZRoJX9DGzXrE5Vw5PlL+YQEs2TW9DISALmbeKTBxy+eYI
         0jW8aR0N/xyaj+q1OHjJQP3PXgePOv3iNTPi7j+qK0AiUxUoyngiouXMl6ea1Z7gCq
         3sItwUbX67oeA==
Date:   Tue, 15 Mar 2022 14:27:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 2/6] netfilter: nf_tables: Reject tables of
 unsupported family
Message-ID: <20220315142750.31d1a4b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YjD2wbXm8XFiXgI8@salvia>
References: <20220315091513.66544-1-pablo@netfilter.org>
        <20220315091513.66544-3-pablo@netfilter.org>
        <20220315115644.66fab74b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YjD2wbXm8XFiXgI8@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 15 Mar 2022 21:27:45 +0100 Pablo Neira Ayuso wrote:
> > is there a reason this one is IS_ENABLED() and everything else is ifdef?  
> 
> bridge might be compiled as a module, if the bridge infrastructure
> also comes a module as well.
> 
> Anything else is either built-in or off.

:o I thought ifdef works for modules, after checking the code 
it makes sense, thanks!
