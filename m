Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D6B2C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Mar 2022 11:36:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241665AbiCJLhN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Mar 2022 06:37:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241770AbiCJLhD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Mar 2022 06:37:03 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061361470C7
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2022 03:35:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vEyH7ahQOAQgIZD8d4lI92YwNX8QUK9R8sj/nHozipg=; b=Ln5W7FtGvD67DWhMy3wWzMxoqC
        rHgyDyJOKYMcCSegcFyR9rM2Q8dNKQqlbZnpo5B/AAPJLSlJLNmni9DtOgdnmlnhazDpROAhS2QT9
        Pss8zqaTMyC6qNKS91pmbDjS8KAHUM1qEDlVkSyl2FA4mfxjQC1ysK2C1SyTECjw+hURgdzm3Q7iK
        wRqv93NmB1rCfTLWsp15Vak1YYLZUqvbNB3LR9Wd7iJJLh6DOmgxxw256YCa1kWCP5MR4MTufCWuP
        0Do9W4shh//I4Xn34QxLVCdtg3My6T4lJLto5vo3U7w9aqgH0rkc05sqItUuGbUrwGw5jKYVjg8yw
        fkPKCBaA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nSH5J-0000Ok-EJ; Thu, 10 Mar 2022 12:35:57 +0100
Date:   Thu, 10 Mar 2022 12:35:57 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnftnl 0/3] add description infrastructure
Message-ID: <YininWZnQ8gAY+cw@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220120000402.916332-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120000402.916332-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Thu, Jan 20, 2022 at 01:03:59AM +0100, Pablo Neira Ayuso wrote:
> This is my proposal to address the snprintf data printing depending on
> the arch. The idea is to add description objects that can be used to
> build the userdata area as well as to parse the userdata to create the
> description object.

I tried to integrate this into nftables, but failed to understand how
this all is supposed to come together: In nftables, concat is treated
like any other expression. Your series seems to require special
treatment? At least there are separate "desc" data structures for each.
It seems like one can't just replace build_udata callbacks to populate
an nftnl_expr_desc object?

Cheers, Phil
