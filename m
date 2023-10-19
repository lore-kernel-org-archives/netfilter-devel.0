Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EDF5C001DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 23:38:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235563AbjJSXim (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 19:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233522AbjJSXim (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 19:38:42 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F64131
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 16:38:39 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qtcb7-0000MV-7v; Fri, 20 Oct 2023 01:38:37 +0200
Date:   Fri, 20 Oct 2023 01:38:37 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2] parser_bison: Fix for broken compatibility with
 older dumps
Message-ID: <ZTG9/Q+zguf7kJ6e@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20231019164134.23478-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231019164134.23478-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 19, 2023 at 06:41:34PM +0200, Phil Sutter wrote:
> Commit e6d1d0d611958 ("src: add set element multi-statement
> support") changed the order of expressions and other state attached to set
> elements are expected in input. This broke parsing of ruleset dumps
> created by nft commands prior to that commit.
> 
> Restore compatibility by also accepting the old ordering.
> 
> Fixes: e6d1d0d611958 ("src: add set element multi-statement support")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
