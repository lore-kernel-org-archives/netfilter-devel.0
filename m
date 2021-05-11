Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E141C43470
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 May 2021 08:26:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB51D6147E
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 May 2021 08:26:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhEKIZu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 May 2021 04:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbhEKIZu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 May 2021 04:25:50 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7078DC061574
        for <netfilter-devel@vger.kernel.org>; Tue, 11 May 2021 01:24:44 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1lgNh3-0008Q1-PL; Tue, 11 May 2021 10:24:41 +0200
Date:   Tue, 11 May 2021 10:24:41 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables 2/2] src: add set element catch-all support
Message-ID: <20210511082441.GN12403@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20210510165322.130181-1-pablo@netfilter.org>
 <20210510165322.130181-2-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510165322.130181-2-pablo@netfilter.org>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Mon, May 10, 2021 at 06:53:21PM +0200, Pablo Neira Ayuso wrote:
> Add a catchall expression (EXPR_SET_ELEM_CATCHALL).
> 
> Use the underscore (_) to represent the catch-all set element, e.g.

Why did you choose this over asterisk? We have the latter as wildcard
symbol already (although a bit limited), so I think it would be more
intuitive than underscore.

Cheers, Phil
