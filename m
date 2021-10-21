Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED6AC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Oct 2021 10:26:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B063860F6E
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Oct 2021 10:26:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbhJUK3D (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Oct 2021 06:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhJUK3C (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Oct 2021 06:29:02 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8ED3C06161C
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Oct 2021 03:26:46 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1mdVHY-0006g1-NB; Thu, 21 Oct 2021 12:26:44 +0200
Date:   Thu, 21 Oct 2021 12:26:44 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/3] tests: shell: README: copy edit
Message-ID: <20211021102644.GM1668@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20211020124512.490288-1-snemec@redhat.com>
 <20211020150402.GJ1668@orbyte.nwl.cc>
 <20211021103025+0200.945334-snemec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211021103025+0200.945334-snemec@redhat.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Oct 21, 2021 at 10:30:25AM +0200, Štěpán Němec wrote:
> On Wed, 20 Oct 2021 17:04:02 +0200
> Phil Sutter wrote:
> 
> > What you you mean with 'copy edit'?
> 
> https://en.wikipedia.org/wiki/Copy_editing

Ah, thanks! I didn't know the term.

> > Please make subject line a bit more comprehensible.
> 
> Would "fix language issues" work for you? Or, could we perhaps keep the
> original subject, and add "fix language issues" in the body, to address
> your other concern?

Yes, I'm fine with keeping the subject if a description is added.

> > Also, adding at least a single line of description is mandatory, even
> > if the subject speaks for itself.
> 
> Commit messages consisting of only the subject and trailers (SOB et al.)
> are quite common, both in this project and elsewhere. [1]

Well yes, roughly 10% of all commits in nftables repo are. In iptables
repo it's even worse with close to 50%. Thanks a lot for providing the
script, BTW! :)

> I suppose that as someone responsible for reviewing and applying
> patches, you're free to install any hoops you see fit for contributors
> to jump through, but if it is the project's and contributors' best
> interest you have in mind, I think it would be better if you mentioned
> the "description is always mandatory" rule explicitly in patch
> submission guidelines [2] (providing a rationale and being consistent
> about it in reality would be better still).

Sorry for not checking the guideline but quoting advice I once received
from the top of my head instead. Maybe I was incorrect and in obvious
cases the description is optional. The relevant text in [2] at least
doesn't explicitly state it is, while being pretty verbose about it
regarding cover letters.

Cheers, Phil

> [2] https://wiki.nftables.org/wiki-nftables/index.php/Portal:DeveloperDocs/Patch_submission_guidelines
