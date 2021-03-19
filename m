Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 799E0C433DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Mar 2021 12:53:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5678464E60
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Mar 2021 12:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhCSMw5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Mar 2021 08:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbhCSMws (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Mar 2021 08:52:48 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5300BC06174A;
        Fri, 19 Mar 2021 05:52:48 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1lNEcN-0004yP-RN; Fri, 19 Mar 2021 13:52:43 +0100
Date:   Fri, 19 Mar 2021 13:52:43 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>,
        Florian Westphal <fw@strlen.de>, twoerner@redhat.com,
        tgraf@infradead.org, dan.carpenter@oracle.com,
        Jones Desougi <jones.desougi+netfilter@gmail.com>
Subject: Re: [PATCH] audit: log nftables configuration change events once per
 table
Message-ID: <20210319125243.GU5298@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Richard Guy Briggs <rgb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>, Steve Grubb <sgrubb@redhat.com>,
        Florian Westphal <fw@strlen.de>, twoerner@redhat.com,
        tgraf@infradead.org, dan.carpenter@oracle.com,
        Jones Desougi <jones.desougi+netfilter@gmail.com>
References: <7e73ce4aa84b2e46e650b5727ee7a8244ec4a0ac.1616078123.git.rgb@redhat.com>
 <20210318163032.GS5298@orbyte.nwl.cc>
 <20210318183703.GL3141668@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318183703.GL3141668@madcap2.tricolour.ca>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 18, 2021 at 02:37:03PM -0400, Richard Guy Briggs wrote:
> On 2021-03-18 17:30, Phil Sutter wrote:
[...]
> > Why did you leave the object-related logs in place? They should reappear
> > at commit time just like chains and sets for instance, no?
> 
> There are other paths that can trigger these messages that don't go
> through nf_tables_commit() that affect the configuration data.  The
> counters are considered config data for auditing purposes and the act of
> resetting them is audittable.  And the only time we want to emit a
> record is when they are being reset.

Oh, I see. I wasn't aware 'nft reset' bypasses the transaction logic,
thanks for clarifying!

Cheers, Phil
