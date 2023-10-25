Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D6DEC0032E
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Oct 2023 15:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235131AbjJYP2r (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 11:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235108AbjJYP2f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 11:28:35 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229641BF3
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Oct 2023 08:27:14 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qvfmq-00078Z-Am; Wed, 25 Oct 2023 17:27:12 +0200
Date:   Wed, 25 Oct 2023 17:27:12 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH 0/2] Fix up string match man page
Message-ID: <ZTkz0KPeAZi09caR@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20231024114357.23271-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024114357.23271-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 24, 2023 at 01:43:55PM +0200, Phil Sutter wrote:
> My earlier adjustment to describe the actual behaviour is obsolete given
> that I adjusted said behaviour upon request. Revert the change in patch
> 1 and introduce a new copy-edit in patch 2 making the text a bit more
> clear and removing a mistake.
> 
> I will fold both commits before pushing them out. Keeping them separated
> for the sake of easier reviews.

Patch applied after folding the series into one.
