Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D840C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Dec 2021 02:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345653AbhLWCKJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Dec 2021 21:10:09 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42000 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbhLWCKJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Dec 2021 21:10:09 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 922AC62BD6;
        Thu, 23 Dec 2021 03:07:32 +0100 (CET)
Date:   Thu, 23 Dec 2021 03:10:04 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 0/3] ruleset optimization infrastructure
Message-ID: <YcPafECXZu4q60YD@salvia>
References: <20211215195615.139902-1-pablo@netfilter.org>
 <d878f630-adff-1522-c953-ec845d72a89c@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d878f630-adff-1522-c953-ec845d72a89c@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Arturo,

On Thu, Dec 16, 2021 at 12:54:02PM +0100, Arturo Borrero Gonzalez wrote:
> On 12/15/21 20:56, Pablo Neira Ayuso wrote:
> > Hi,
> > 
> > This patchset adds a new -o/--optimize option to enable ruleset
> > optimization.
> > 
> 
> Thanks for working on this. From what I see in the community, this feature
> will be of high value to some folks: users often struggle with doing this
> kind of optimizations by hand.
>
> > The ruleset optimization first loads the ruleset in "dry run" mode to
> > validate that the original ruleset is correct. Then, on a second pass it
> > performs the ruleset optimization before adding the rules into the
> > kernel.
> > 
> 
> Could you please describe how to work with this if all I want is to check
> how an optimized version of my ruleset would look like, but not load it into
> the kernel?
>
> The use case would be: I just need a diff between my ruleset.nft file and
> whatever the optimized version would be, without performing any actual
> change.

This is feasible. I could probably add a flags field instead of simple
boolean to the API so it is possible to specify an option such as:

        # nft -o offline -f ruleset.nft

which would print the ruleset listing without loading it.

> Of course this can be added later on if not supported in this patch.
>
> > This infrastructure collects the statements that are used in rules. Then,
> > it builds a matrix of rules vs. statements. Then, it looks for common
> > statements in consecutive rules that are candidate to be merged. Finally,
> > it merges rules.
> 
> clever!
> 
> Is this infra extensible enough to support scanning non-adjacent rules in
> the future?

This requires another step to group rules with the same statements
whenever possible, such routine would need to make sure that the rule
verdict is the same and that no stateful statements (eg. limit) is
used.

> ie, being able to transform:
> 
> * ip daddr 1.1.1.1 counter accept
> * tcp dport 80 accept
> * ip daddr 2.2.2.2 counter accept
> 
> into:
> 
> * ip daddr { 1.1.1.1, 2.2.2.2 } counter accept
> * tcp dport 80 accept

or even this:

* ip daddr . tcp dport { 1.1.1.1 . 0-65535, 2.2.2.2 . 0-65535, 0.0.0.0/0 . 80 } counter accept

but this requires a Linux kernel >= 5.6.

There are a few more transformations that come to my mind, such as
packing several snat/dnat rules into a map.

I'll be posting v2 of this patchset with many fixes and tests soon.
