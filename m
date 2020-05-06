Return-Path: <SRS0=4pKc=6U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADFD8C28CBC
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 12:09:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85441206B8
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 12:09:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbgEFMJM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 May 2020 08:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726516AbgEFMJM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 May 2020 08:09:12 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF979C061A0F
        for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2020 05:09:11 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jWIrN-0006DI-Tu; Wed, 06 May 2020 14:09:09 +0200
Date:   Wed, 6 May 2020 14:09:09 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Etienne Champetier <champetier.etienne@gmail.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: iptables 1.8.5 ETA ?
Message-ID: <20200506120909.GA10344@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Etienne Champetier <champetier.etienne@gmail.com>,
        netfilter-devel@vger.kernel.org
References: <CAOdf3gqGQQCFJ8O8KVM7fVBYcKLy=UCf+AOvEdaoArMAx98ezg@mail.gmail.com>
 <20200506120012.GA21153@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506120012.GA21153@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, May 06, 2020 at 02:00:12PM +0200, Pablo Neira Ayuso wrote:
> On Wed, May 06, 2020 at 07:44:12AM -0400, Etienne Champetier wrote:
> > Hi All,
> > 
> > Pablo told me 3 weeks ago that "It might take a few weeks to make the
> > new release."
> > (https://bugzilla.netfilter.org/show_bug.cgi?id=1422#c13)
> > 
> > I'm sure it'll be release when it's ready :) but do you see an
> > iptables release happening this month ? (to know if I should just wait
> > or go ask maintainers for backports)

Luckily, the month has just begun. ;)

> Cc'ing Phil. He's got some pending work to push it out.

Seriously, I wanted to push it already but then discovered some leaks
here and there. To improve coverage, I implemented a valgrind mode into
shell testsuite. This helps identify old and new issues, I'm trying to
fix them all at once. Will fold into the cache rework series what's
introduced by that and keep the rest separate.

Expect a series showcasing the additional changes and new commits today
or tomorrow. If there are no complaints, I'll push everything out until
the end of this week.

If above goes well, maybe release next week to leave at least a small
margin for any fallout to show up?

Cheers, Phil
