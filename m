Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E05DFC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 14:56:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbjKIO4G (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 09:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbjKIO4G (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 09:56:06 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566883588
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 06:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=r+aqpnH+7EpWw6b5N7mHtDMc+lZmhOpPFX+9khrsSCo=; b=kzGiv7n6beC4wje64mbSBq7wbr
        U42RgwUdAWfRSZJvPCjomIF1SnhXV0fdSLmSm+1W/swY4t6O2Ho5goGyHgfB65wUBbHtyANhi3Sim
        10R5/9GJmA5V/V/O/HvkzFFYKBIWqcVI4IW1o+EAFL6/RuhxjzXrW5YRfFk9iOLsVLtvHtab+9D1L
        QhjA9HSPASj0IvHTvMyTNisTAa3erFkCl8uK9G4USxA5su51Q6igC0aKo9kp7HEUFcwig72vb+5GE
        g8dnSSQKVwj5uAFUg3Bn1Kapy11RKFcb1SC/xihjuk78mX2ruyt3hud6Pzgihpv3jgXLd9j/zfxPJ
        hjYzPOJg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1r16Rs-0005so-FL; Thu, 09 Nov 2023 15:56:00 +0100
Date:   Thu, 9 Nov 2023 15:56:00 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 1/3] arptables: Fix formatting of numeric
 --h-type output
Message-ID: <ZUzzAPy3ZlPatrNx@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20231108033130.18747-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231108033130.18747-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 08, 2023 at 04:31:28AM +0100, Phil Sutter wrote:
> Arptables expects numeric arguments to --h-type option in hexadecimal
> form, even if no '0x'-prefix is present. In contrast, it prints such
> values in decimal. This is not just inconsistent, but makes it
> impossible to save and later restore a ruleset without fixing up the
> values in between.
> 
> Assuming that the parser side can't be changed for compatibility
> reasons, fix the output side instead.
> 
> This is a day 1 bug and present in legacy arptables as well, so treat
> this as a "feature" of arptables-nft and omit a Fixes: tag.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Series applied.
