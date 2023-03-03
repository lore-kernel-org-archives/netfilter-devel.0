Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EDC7C64EC4
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Mar 2023 09:45:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjCCJpc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Mar 2023 04:45:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjCCJpb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Mar 2023 04:45:31 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62275B770
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2023 01:45:30 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pY1yi-00006v-Vy; Fri, 03 Mar 2023 10:45:29 +0100
Date:   Fri, 3 Mar 2023 10:45:28 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Major =?iso-8859-15?Q?D=E1vid?= <major.david@balasys.hu>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: CPU soft lockup in a spin lock using tproxy and nfqueue
Message-ID: <20230303094528.GD20617@breakpoint.cc>
References: <401bd6ed-314a-a196-1cdc-e13c720cc8f2@balasys.hu>
 <20230302142946.GB309@breakpoint.cc>
 <f8d03b81-8980-b54e-a2a3-57f8e54044be@balasys.hu>
 <20230303000926.GC9239@breakpoint.cc>
 <374ce7bf-e953-ab61-15ac-d99efce9152d@balasys.hu>
 <20230303093310.GC20617@breakpoint.cc>
 <31f0312c-7410-dbcd-4c35-5adbc036714c@balasys.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <31f0312c-7410-dbcd-4c35-5adbc036714c@balasys.hu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Major Dávid <major.david@balasys.hu> wrote:
> Okay, I agree with this, and thanks again the quick fix here.
> 
> When we could expect this in the mainline or 5.15 LTS?

I'll post the patch for merging in a few minutes, I just need
to add a proper fixes-tag so -stable team will know to which
kernel releases the patch needs to be applied to.
