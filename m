Return-Path: <SRS0=w/jS=XG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48A5AECDE20
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Sep 2019 08:17:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A72B2085B
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Sep 2019 08:17:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfIKIRN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Sep 2019 04:17:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:44090 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725924AbfIKIRN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Sep 2019 04:17:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 93A3EAEEC;
        Wed, 11 Sep 2019 08:17:11 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id F047CE03B1; Wed, 11 Sep 2019 10:17:10 +0200 (CEST)
Date:   Wed, 11 Sep 2019 10:17:10 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: userspace conntrack helper and confirming the master conntrack
Message-ID: <20190911081710.GD24779@unicorn.suse.cz>
References: <20190718084943.GE24551@unicorn.suse.cz>
 <20190718092128.zbw4qappq6jsb4ja@breakpoint.cc>
 <20190718101806.GF24551@unicorn.suse.cz>
 <20190719164742.iasbyklx47sqpw7y@salvia>
 <20190904121651.GA25494@unicorn.suse.cz>
 <20190910232426.4ccs7jo7jwhni7az@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190910232426.4ccs7jo7jwhni7az@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 11, 2019 at 01:24:26AM +0200, Pablo Neira Ayuso wrote:
> Hi Michal,
> 
> On Wed, Sep 04, 2019 at 02:16:51PM +0200, Michal Kubecek wrote:
> > This seems to have fallen through the cracks. I tried to do the revert
> > but it's not completely straightforward as bridge conntrack has been
> > introduced in between and I'm not sure I got the bridge part right.
> > Could someone more familiar with the code take a look?
> 
> I'm exploring a different path, see attached patch (still untested).
> 
> I'm trying to avoid this large revert from Florian. The idea with this
> patch is to invoke the conntrack confirmation path from the
> nf_reinject() path, which is what it is missing.

Thank you for looking into it. I'll take a look at your patch.

> I'm at a conference right now, I'll try scratch time to sort out this
> asap. Most likely we'll have to request a patch to be included in
> -stable in the next release I'm afraid.

As the regression didn't happen in this cycle but in 5.1-rc1, there are 
already two releases affected so that it's IMHO more important to get it
right than to catch 5.3 at any cost.

Michal
