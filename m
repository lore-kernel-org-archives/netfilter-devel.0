Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16CC1C678D4
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Mar 2023 09:04:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjCBJEp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Mar 2023 04:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbjCBJEo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Mar 2023 04:04:44 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6A430E87
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Mar 2023 01:04:18 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1pXerG-0001Ig-Nw; Thu, 02 Mar 2023 10:04:14 +0100
Date:   Thu, 2 Mar 2023 10:04:14 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [ipset PATCH 0/2] Two minor code fixes
Message-ID: <ZABmjujQuFgknGXR@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230222170241.26208-1-phil@nwl.cc>
 <Y//RlHWq86REFVu6@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y//RlHWq86REFVu6@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 01, 2023 at 11:28:36PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Feb 22, 2023 at 06:02:39PM +0100, Phil Sutter wrote:
> > These were identified by Coverity tool, no problems in practice. Still
> > worth fixing to reduce noise in code checkers.
> 
> LGTM.
> 
> Did you run ipset xlate tests? These should not break those but just
> in case.

I didn't, thanks for the reminder. Testsuite fails, but it does with
HEAD as well. And so does the other testsuite ("make tests"), BtW. I'll
investigate.

Cheers, Phil
