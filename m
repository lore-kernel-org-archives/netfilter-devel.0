Return-Path: <SRS0=wrU5=37=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4536FC35242
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Feb 2020 04:36:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D01762072C
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Feb 2020 04:36:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.ch header.i=@protonmail.ch header.b="fts4sqpX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbgBKEgv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Feb 2020 23:36:51 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:58944 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727900AbgBKEgv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 23:36:51 -0500
Date:   Tue, 11 Feb 2020 04:36:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
        s=default; t=1581395808;
        bh=vewVrwJGRwCJ7ouBRS/nz/7b/VlVzw4VVz5IkIWu3qo=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=fts4sqpXEiOXPNfA8RywLsZNyrxeNdoSJ6SBZDtSAZ8RJbwtoYMwTmzqxDr2tshaN
         u8Xd4zqq8G+lyEG8+CS5EszolZOq2egFdASyQ1LJMcdvcrYlHtMvgMJbYcswApy90D
         OcPX9YtPQcdDpK6vnsjB7b+plT6LJOJkJOQcxkwM=
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
From:   Laurent Fasnacht <fasnacht@protonmail.ch>
Cc:     "pablo@netfilter.org" <pablo@netfilter.org>
Reply-To: Laurent Fasnacht <fasnacht@protonmail.ch>
Subject: Re: [PATCH nft include v2 4/7] scanner: remove parser_state->indescs static array
Message-ID: <B0GhcdgsD8gKeSn6wk4mAmzGp6cAi-uxHSUVpr5yexgU0kmx4o3uoS_ci4H49xeBrf7F39IoG5OC-peD3kC6TlNtL7zpvbBzQZP7FYu5GRY=@protonmail.ch>
In-Reply-To: <20200210233256.bis2igtwje77vimm@salvia>
References: <20200210101709.9182-1-fasnacht@protonmail.ch>
 <20200210101709.9182-5-fasnacht@protonmail.ch>
 <20200210233256.bis2igtwje77vimm@salvia>
Feedback-ID: 67Kw-YMwrBchoIMLcnFuA64ZnJub6AgnNvfJUjsgbTTSp4dmymKgGy_PLLqmOsJ9F58iClONCeGYaqp9YPx84w==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tuesday, February 11, 2020 12:32 AM, Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:

> On Mon, Feb 10, 2020 at 10:17:24AM +0000, Laurent Fasnacht wrote:
>
> > This static array is redundant wth the indesc_list structure, but
> > is less flexible.
>
> Skipping this patch and taking 5/7, I get a crash.

Probably was out of bounds in state->indescs[MAX_INCLUDE_DEPTH].

> Sorry, I'm trying to understand if there is an easy fix for this,
> without simplifying things. I mean, first fix things, then move on and
> improve everything.

In my opinion, there isn't, unfortunately. That's why it took me quite some=
 time to fix. Let me explain:

The data structure the original code is trying to achieve is a stack of inp=
ut descriptors, where one entry in that stack is one level of include. This=
 stack is implemented using the indesc_idx variable and the indescs and fd =
array.

Unfortunately, there is an issue with that design for glob includes: glob i=
ncludes add all the discovered files to that stack at once (in reverse alph=
abetic order so the parsing happens in alphabetic order). The bound check f=
or the static array incorrectly leads to the error message that the maximum=
 inclusion depth is reached. However, removing that check alone will result=
 in out of bound access of both fd and indescs arrays)

So basically, in order to apply patch 5/7, you need 2/7 and 4/7 (and 3/7, w=
hich is minor refactoring) to get rid the static arrays.

As an example, the test supplied in patch 1/7 only has one level of inclusi=
on, but adds all the files to the stack, so the static arrays will overflow=
.

As a side note, the stack implementation is incorrect, both in the original=
 code and after patch 5/7 is applied (since it's a minimal patch, as you pr=
eviously ask). The stack implementation is fixed in patch 6/7. That specifi=
c patch is however unrelated to the include depth problem. I believe howeve=
r that it's the correct fix of bug #1383, and should be applied in order to=
 have a sane data structure.

Does that help?
