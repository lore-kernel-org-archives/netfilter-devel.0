Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A22C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 10:14:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62F7A60F02
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 10:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239560AbhJ0KQ1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Oct 2021 06:16:27 -0400
Received: from mail.netfilter.org ([217.70.188.207]:47968 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239518AbhJ0KQ0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 06:16:26 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0D4ED63ED7;
        Wed, 27 Oct 2021 12:12:12 +0200 (CEST)
Date:   Wed, 27 Oct 2021 12:13:57 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/3] tests: shell: README: copy edit
Message-ID: <YXkmZaJit3R8XpzL@salvia>
References: <20211020124512.490288-1-snemec@redhat.com>
 <20211020150402.GJ1668@orbyte.nwl.cc>
 <20211021103025+0200.945334-snemec@redhat.com>
 <20211021102644.GM1668@orbyte.nwl.cc>
 <20211021130323+0200.342006-snemec@redhat.com>
 <YXkWeFPM3ixQ2cTb@salvia>
 <20211027115112+0200.686229-snemec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211027115112+0200.686229-snemec@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 27, 2021 at 11:51:12AM +0200, Štěpán Němec wrote:
> On Wed, 27 Oct 2021 11:06:00 +0200
> Pablo Neira Ayuso wrote:
> 
> > I also prefer if there is oneline description in the patch. My
> > suggestions:
> >
> > * patch 1/3, not clear to me what "copy edit" means either.
> 
> Description proposal:
> 
>   Grammar, wording, formatting fixes (no substantial change of meaning).
> 
> > * patch 2/3, what is the intention there? a path to the nft executable
> >   is most generic way to refer how you use $NFT, right?
> 
> No, not since 7c8a44b25c22. I've always thought that 'Fixes:' is mostly
> or at least also meant for humans, i.e., that the person reading the
> commit message and wanting to better understand the change would look at
> the referenced commit, but if that is a wrong assumption to make, I
> propose to add the following description:

>   Since commit 7c8a44b25c22, $NFT can contain an arbitrary command, e.g.
>   'valgrind nft'.

OK, but why the reader need to know about former behaviour? The git
repository already provides the historical information if this is of
his interest. To me, the README file should contain the most up to
date information that is relevant to run the test infrastructure.

> > * patch 3/3, I'd add a terse sentence so I do not need to scroll down
> >   and read the update to README to understand what this patch updates.
> >   I'd suggest: "Test files are located with find, so they can be placed
> >   in any location."
> 
> That text was just split to a separate paragraph, it has nothing to do
> with the actual change.

OK, then please document every update in your patch.

> > Regarding reference to 4d26b6dd3c4c, not sure it is worth to add this
> > to the README file. The test infrastructure is only used for internal
> > development use, this is included in tarballs but distributors do not
> > package this.
> 
> IMO this argument should speak _for_ including the commit reference
> rather than omitting it, as the developer is more likely to be
> interested in the commit than the consumer.
>
> I thought about making the wording simply describe the current state
> without any historical explanations, but saying "Test files are
> executable files matching the pattern <<name_N>>, where N doesn't mean
> anything." seemed weird.

For historical explanations, you can dig into git.

Thanks.
