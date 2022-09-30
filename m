Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 983D5C433FE
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Sep 2022 13:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiI3NJh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Sep 2022 09:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiI3NJg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Sep 2022 09:09:36 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E011EC07
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Sep 2022 06:09:32 -0700 (PDT)
Date:   Fri, 30 Sep 2022 15:09:29 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 0/3] vlan followup fixes
Message-ID: <YzbqiUYb/EryNjOo@salvia>
References: <20220929130113.22289-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220929130113.22289-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 29, 2022 at 03:01:10PM +0200, Florian Westphal wrote:
> vlan header matching in ip/ip6/inet families may not work, because
> default behaviour is to remove the vlan header/tag information.
> 
> Update documentation to mention this.
> Furthermore, dependency generation was broken so that even if the
> vlan striping is disabled matching did not work, as the offset was
> not computed correctly.
> 
> Add test cases for this too.

LGTM
