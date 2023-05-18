Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00159C7EE23
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 May 2023 15:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbjERPGq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 May 2023 11:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231906AbjERPGc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 May 2023 11:06:32 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E570B19F
        for <netfilter-devel@vger.kernel.org>; Thu, 18 May 2023 08:06:05 -0700 (PDT)
Date:   Thu, 18 May 2023 17:05:24 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] evaluate: Reject set stmt refs to sets without
 dynamic flag
Message-ID: <ZGY+tAXE9chv6mlM@calendula>
References: <20230503105022.5728-1-phil@nwl.cc>
 <ZFt35MXmXZWxcb56@calendula>
 <ZFuEcXxYCG9U9eMQ@orbyte.nwl.cc>
 <ZGXytiRHHS5O6U2v@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZGXytiRHHS5O6U2v@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 18, 2023 at 11:41:10AM +0200, Pablo Neira Ayuso wrote:
> On Wed, May 10, 2023 at 01:48:01PM +0200, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Wed, May 10, 2023 at 12:54:28PM +0200, Pablo Neira Ayuso wrote:
> > > On Wed, May 03, 2023 at 12:50:22PM +0200, Phil Sutter wrote:
> > > > This is a revert of commit 8d443adfcc8c1 ("evaluate: attempt to set_eval
> > > > flag if dynamic updates requested"), implementing the alternative
> > > > mentioned in the comment it added.
> > > > 
> > > > Reason is the inconsistent behaviour when applying the same ruleset
> > > > twice: In the first call, the set lacking 'dynamic' flag does not exist
> > > > and is therefore added to the cache. Consequently, both the 'add set'
> > > > command and the set statement point at the same set object. In the
> > > > second call, a set with same name exists already, so the object created
> > > > for 'add set' command is not added to cache and consequently not updated
> > > > with the missing flag. The kernel thus rejects the NEWSET request as the
> > > > existing set differs from the new one.
> > > 
> > > # cat test.nft
> > > flush ruleset
> > 
> > Just remove this 'flush ruleset' call, then it should trigger.
> 
> I cannot reproduce it yet :(

I can reproduce it. For the record, I have applied this alternate fix:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230518125806.11100-1-pablo@netfilter.org/
