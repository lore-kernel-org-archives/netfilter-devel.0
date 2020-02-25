Return-Path: <SRS0=2ZCu=4N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B538C35E01
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 18:49:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B24621556
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 18:49:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731540AbgBYStA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Feb 2020 13:49:00 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:39062 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727983AbgBYStA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Feb 2020 13:49:00 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1j6fGL-0006KR-51; Tue, 25 Feb 2020 19:48:57 +0100
Date:   Tue, 25 Feb 2020 19:48:57 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf 0/2] nft_set_pipapo: Fix crash due to dangling entries
 in mapping table
Message-ID: <20200225184857.GC9532@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <cover.1582250437.git.sbrivio@redhat.com>
 <20200221211704.GM20005@orbyte.nwl.cc>
 <20200221232218.2157d72b@elisabeth>
 <20200222011933.GO20005@orbyte.nwl.cc>
 <20200223222258.2bb7516a@redhat.com>
 <20200225123934.p3vru3tmbsjj2o7y@salvia>
 <20200225141346.7406e06b@redhat.com>
 <20200225134236.sdz5ujufvxm2in3h@salvia>
 <20200225153435.17319874@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225153435.17319874@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

Sorry for jumping back into the discussion this late.

On Tue, Feb 25, 2020 at 03:34:35PM +0100, Stefano Brivio wrote:
[...]
> Or also simply with:
> 
> # nft add element t s '{ 20-30 . 40 }'
> # nft add element t s '{ 25-35 . 40 }'
> 
> the second element is silently ignored. I'm returning -EEXIST from
> nft_pipapo_insert(), but nft_add_set_elem() clears it because NLM_F_EXCL
> is not set.
> 
> Are you suggesting that this is consistent and therefore not a problem?
> 
> Or are you proposing that I should handle this in userspace as it's done
> for non-concatenated ranges?

The problem is that user tried to add a new element which is not yet
contained and the 'add element' command is the same as if it was
identical to an existing one. We must not ignore this situation as the
user needs to know: In the above case e.g., element '35 . 40' won't
match after the zero-return from 'add element' command.

At first I assumed we could merge e.g.:

| { 20-30 . 40-50, 25-35 . 45-55 }

into:

| { 20-35 . 40-55 }

But now I realize this is wrong. We would match e.g. '{ 20 . 55 }', a
combination the user never specified.

Given that merging multiple concatenated ranges is a non-trivial task, I
guess the only sane thing to do (for now at least) is to perform overlap
detection in user space and reject the command if an overlap is
detected. Stefano, do you see any problems with that?

Thanks, Phil
