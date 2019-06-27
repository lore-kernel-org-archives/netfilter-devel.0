Return-Path: <SRS0=TR/Z=U2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2D2FC48BD6
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 11:22:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CFF820656
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 11:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfF0LWH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jun 2019 07:22:07 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:47236 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726308AbfF0LWH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jun 2019 07:22:07 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hgSTd-0002QK-Gf; Thu, 27 Jun 2019 13:22:05 +0200
Date:   Thu, 27 Jun 2019 13:22:05 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 2/3] libnftables: reallocate definition of
 nft_print() and nft_gmp_print()
Message-ID: <20190627112205.7zmbygyalmw3fsmq@breakpoint.cc>
References: <156163260014.22035.13586288868224137755.stgit@endurance>
 <156163261193.22035.5939540630503363251.stgit@endurance>
 <a766c2a4-602f-19f1-24d5-be1f8cabe056@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a766c2a4-602f-19f1-24d5-be1f8cabe056@netfilter.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Arturo Borrero Gonzalez <arturo@netfilter.org> wrote:
> On 6/27/19 12:50 PM, Arturo Borrero Gonzalez wrote:
> > They are not part of the libnftables library API, they are not public symbols,
> > so it doesn't not make sense to have them there. Move the two functions to a
> > different source file.
> > 
> > Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
> > ---
> >  src/libnftables.c |   27 ---------------------------
> >  src/utils.c       |   26 ++++++++++++++++++++++++++
> >  2 files changed, 26 insertions(+), 27 deletions(-)
> > 
> 
> This patch is probably not required, it does not affect how visible the symbols
> of the library are.
> 
> Drop it or apply it, I'm fine either way.

I'd be inclinded to skip because of the nft_ prefix (and removing that
adds useless code churn), provided patch 3 is accepted of course.


