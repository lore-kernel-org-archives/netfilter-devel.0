Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D2C8C433ED
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 20:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48E8061073
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 20:57:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhCaU47 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 16:56:59 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49038 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232644AbhCaU4m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 16:56:42 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4B22A63E47;
        Wed, 31 Mar 2021 22:56:26 +0200 (CEST)
Date:   Wed, 31 Mar 2021 22:56:39 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>,
        Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        twoerner@redhat.com, tgraf@infradead.org, dan.carpenter@oracle.com,
        Jones Desougi <jones.desougi+netfilter@gmail.com>
Subject: Re: [PATCH v5] audit: log nftables configuration change events once
 per table
Message-ID: <20210331205639.GA4972@salvia>
References: <28de34275f58b45fd4626a92ccae96b6d2b4e287.1616702731.git.rgb@redhat.com>
 <20210331202230.GA4109@salvia>
 <20210331205310.GA3141668@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210331205310.GA3141668@madcap2.tricolour.ca>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 31, 2021 at 04:53:10PM -0400, Richard Guy Briggs wrote:
> On 2021-03-31 22:22, Pablo Neira Ayuso wrote:
> > On Fri, Mar 26, 2021 at 01:38:59PM -0400, Richard Guy Briggs wrote:
> > > Reduce logging of nftables events to a level similar to iptables.
> > > Restore the table field to list the table, adding the generation.
> > > 
> > > Indicate the op as the most significant operation in the event.
> > 
> > There's a UAF, Florian reported. I'm attaching an incremental fix.
> > 
> > nf_tables_commit_audit_collect() refers to the trans object which
> > might have been already released.
> 
> Got it.  Thanks Pablo.  I didn't see it when running nft-test.py Where
> was it reported?

CONFIG_KASAN.

> Here I tried to stay out of the way by putting that
> call at the end of the loop but that was obviously a mistake in
> hindsight.  :-)

No problem, I'll squash this incremental fix into your audit patch.
