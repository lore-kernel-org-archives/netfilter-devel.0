Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A7E1C761A6
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Apr 2023 18:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbjDDSu1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Apr 2023 14:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235825AbjDDSu1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Apr 2023 14:50:27 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160AE3AAA
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Apr 2023 11:50:25 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pjlja-00080l-Ue; Tue, 04 Apr 2023 20:50:22 +0200
Date:   Tue, 4 Apr 2023 20:50:22 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Cc:     Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH iptables 2/2] ebtables-nft: add broute table emulation
Message-ID: <20230404185022.GB21940@breakpoint.cc>
References: <20230404094544.2892-1-fw@strlen.de>
 <20230404094544.2892-2-fw@strlen.de>
 <DBBP189MB14338B5099BDFC457EC2490495939@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DBBP189MB14338B5099BDFC457EC2490495939@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sriram Yagnaraman <sriram.yagnaraman@est.tech> wrote:
> Thank you so much for fixing this, I attempted to update ebtables-nft for broute support but couldn’t understand all the details.
> Does this close https://bugzilla.netfilter.org/show_bug.cgi?id=1316?

Yes, simple -t broute -DROP will work with this patch.
