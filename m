Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF69C64EC4
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Mar 2023 12:05:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjCJMFm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Mar 2023 07:05:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjCJMF0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Mar 2023 07:05:26 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2EE8F0FD8
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Mar 2023 04:05:24 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1pabUx-0001lj-11; Fri, 10 Mar 2023 13:05:23 +0100
Date:   Fri, 10 Mar 2023 13:05:23 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [ipset PATCH 0/2] Two minor code fixes
Message-ID: <ZAsdAyikGXVmd8QS@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230222170241.26208-1-phil@nwl.cc>
 <Y//RlHWq86REFVu6@salvia>
 <ZABmjujQuFgknGXR@orbyte.nwl.cc>
 <ZAsa7a2mF7wGk8fI@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAsa7a2mF7wGk8fI@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 10, 2023 at 12:56:29PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Mar 02, 2023 at 10:04:14AM +0100, Phil Sutter wrote:
> > On Wed, Mar 01, 2023 at 11:28:36PM +0100, Pablo Neira Ayuso wrote:
> > > On Wed, Feb 22, 2023 at 06:02:39PM +0100, Phil Sutter wrote:
> > > > These were identified by Coverity tool, no problems in practice. Still
> > > > worth fixing to reduce noise in code checkers.
> > > 
> > > LGTM.
> > > 
> > > Did you run ipset xlate tests? These should not break those but just
> > > in case.
> > 
> > I didn't, thanks for the reminder. Testsuite fails, but it does with
> > HEAD as well. And so does the other testsuite ("make tests"), BtW. I'll
> > investigate.
> 
> Does this work after your testsuite updates? If so, push them out.

Yes, it does. Should I push the testsuite updates, too? I'm uncertain
about the s/vrrp/carp/, don't want to break anyone's test setup.

Cheers, Phil
