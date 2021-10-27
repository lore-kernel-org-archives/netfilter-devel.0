Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 057A6C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 09:06:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E13CD61039
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 09:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241134AbhJ0JIb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Oct 2021 05:08:31 -0400
Received: from mail.netfilter.org ([217.70.188.207]:47726 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241122AbhJ0JIa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 05:08:30 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8CE9563F04;
        Wed, 27 Oct 2021 11:04:17 +0200 (CEST)
Date:   Wed, 27 Oct 2021 11:06:00 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/3] tests: shell: README: copy edit
Message-ID: <YXkWeFPM3ixQ2cTb@salvia>
References: <20211020124512.490288-1-snemec@redhat.com>
 <20211020150402.GJ1668@orbyte.nwl.cc>
 <20211021103025+0200.945334-snemec@redhat.com>
 <20211021102644.GM1668@orbyte.nwl.cc>
 <20211021130323+0200.342006-snemec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211021130323+0200.342006-snemec@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 21, 2021 at 01:03:23PM +0200, Štěpán Němec wrote:
> On Thu, 21 Oct 2021 12:26:44 +0200
> Phil Sutter wrote:
> 
> > Sorry for not checking the guideline but quoting advice I once received
> > from the top of my head instead. Maybe I was incorrect and in obvious
> > cases the description is optional. The relevant text in [2] at least
> > doesn't explicitly state it is, while being pretty verbose about it
> > regarding cover letters.
> 
> Does this mean that you retract your requirement? If not, could you
> please make sure that you and the other maintainers are on the same page
> about this, and document the requirement?
> 
> Regarding this patch series (if it is to be resent, in part or as a
> whole): we've discussed the first patch so far; the other two patches
> have no description, either. Do they need one? If so, could you provide
> some suggestions? I can't think of anything sensible that isn't already
> said in the subject, Fixes:, or the modified README text itself.

I also prefer if there is oneline description in the patch. My
suggestions:

* patch 1/3, not clear to me what "copy edit" means either.

* patch 2/3, what is the intention there? a path to the nft executable
  is most generic way to refer how you use $NFT, right?

* patch 3/3, I'd add a terse sentence so I do not need to scroll down
  and read the update to README to understand what this patch updates.
  I'd suggest: "Test files are located with find, so they can be placed
  in any location."

Regarding reference to 4d26b6dd3c4c, not sure it is worth to add this
to the README file. The test infrastructure is only used for internal
development use, this is included in tarballs but distributors do not
package this.

So please address Phil's feedback.

Thanks.
