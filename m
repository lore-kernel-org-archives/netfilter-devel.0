Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF0FBE810D0
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 11:19:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbjI0LTj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 07:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbjI0LTi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 07:19:38 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BCAE180
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 04:19:37 -0700 (PDT)
Received: from [78.30.34.192] (port=34222 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qlSZp-00Bx8m-8q; Wed, 27 Sep 2023 13:19:35 +0200
Date:   Wed, 27 Sep 2023 13:19:31 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 3/3,v2] netlink_linearize: skip set element
 expression in map statement key
Message-ID: <ZRQPw+jMI+i9qSyE@calendula>
References: <20230926160216.152549-1-pablo@netfilter.org>
 <ZRMNB+3/4rzYb08p@orbyte.nwl.cc>
 <ZRPq/JMoVffTEDM4@calendula>
 <ZRQNkSG/dnesQ6Wv@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZRQNkSG/dnesQ6Wv@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Wed, Sep 27, 2023 at 01:10:09PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Wed, Sep 27, 2023 at 10:42:36AM +0200, Pablo Neira Ayuso wrote:
> [...]
> > Did you ever follow up on your pull request for libjansson or did you
> > find a way to dynamically allocate the error reporting area that they
> > complain about?
> 
> All done. When there were no technical reasons left to reject it, I was
> told it's not important enough[1].

Concern seems to be related to extra memory consumption.

Would it be possible to revisit your patchset so the extra memory
consumption for error reporting only happens if some flag is toggle to
request this? Some sort of opt-in mechanism. Would that be feasible?

> > Error reporting with libjansson is very rudimentary, there is no way
> > to tell what precisely in the command that is represented in JSON is
> > actually causing the error, this coarse grain error reporting is too
> > broad.
> 
> Indeed, and my implementation would integrate nicely with nftables'
> erecs.

Yes, I like that.

> I actually considered forking the project. Or we just ship a copy of the
> lib with nftables sources?

I would try to get back to them to refresh and retry.

> Cheers, Phil
> 
> [1] https://github.com/akheron/jansson/pull/461#issuecomment-531552151
