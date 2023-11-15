Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76955C07548
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Nov 2023 10:31:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234420AbjKOKbS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Nov 2023 05:31:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234116AbjKOKbR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Nov 2023 05:31:17 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77304C2
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Nov 2023 02:31:14 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1r3DAu-0006f4-Kb; Wed, 15 Nov 2023 11:31:12 +0100
Date:   Wed, 15 Nov 2023 11:31:12 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v3 2/6] tests/shell: check and generate JSON dump
 files
Message-ID: <20231115103112.GC23742@breakpoint.cc>
References: <20231114153150.406334-1-thaller@redhat.com>
 <20231114160903.409552-1-thaller@redhat.com>
 <20231115082427.GC14621@breakpoint.cc>
 <ZVSVPgRFv9tTF4yQ@calendula>
 <20231115100101.GA23742@breakpoint.cc>
 <ZVSX/lO7/0sOmHQS@calendula>
 <20231115101020.GB23742@breakpoint.cc>
 <ZVScxgV0mWorg0PR@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZVScxgV0mWorg0PR@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I can skip it by now, that is easy, I was just trying not to reduce
> coverage.

Sure, I understand that, but OTOH I think there are limitations
as to what we should provide for, in this case the work/benefit ratio
is quite bad...
