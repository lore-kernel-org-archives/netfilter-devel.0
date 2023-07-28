Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28FE2C001DE
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jul 2023 14:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235624AbjG1OKR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Jul 2023 10:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbjG1OKQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jul 2023 10:10:16 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8EF35A8
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jul 2023 07:10:15 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qPOAX-00070m-S0; Fri, 28 Jul 2023 16:10:13 +0200
Date:   Fri, 28 Jul 2023 16:10:13 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, arturo@netfilter.org,
        jengelh@inai.de
Subject: Re: [PATCH nft 2/2] py: remove setup.py integration with autotools
Message-ID: <ZMPMRUvcG//ZJF9W@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, arturo@netfilter.org,
        jengelh@inai.de
References: <20230718120119.172757-1-pablo@netfilter.org>
 <20230718120119.172757-2-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230718120119.172757-2-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 18, 2023 at 02:01:19PM +0200, Pablo Neira Ayuso wrote:
> With Python distutils and setuptools going deprecated, remove
> integration with autotools. This integration is causing issues
> in modern environments.
> 
> Note that setup.py is still left in place under the py/ folder.
> 
> Update INSTALL file to refer to Python support and setup.py.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Phil Sutter <phil@nwl.cc>
