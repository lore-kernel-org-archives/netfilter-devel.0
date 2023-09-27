Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B2CAE810CE
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 11:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbjI0LKP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 07:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbjI0LKO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 07:10:14 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C86DF3
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 04:10:12 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qlSQj-0008RU-RD; Wed, 27 Sep 2023 13:10:09 +0200
Date:   Wed, 27 Sep 2023 13:10:09 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 3/3,v2] netlink_linearize: skip set element
 expression in map statement key
Message-ID: <ZRQNkSG/dnesQ6Wv@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230926160216.152549-1-pablo@netfilter.org>
 <ZRMNB+3/4rzYb08p@orbyte.nwl.cc>
 <ZRPq/JMoVffTEDM4@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRPq/JMoVffTEDM4@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Wed, Sep 27, 2023 at 10:42:36AM +0200, Pablo Neira Ayuso wrote:
[...]
> Did you ever follow up on your pull request for libjansson or did you
> find a way to dynamically allocate the error reporting area that they
> complain about?

All done. When there were no technical reasons left to reject it, I was
told it's not important enough[1].

> Error reporting with libjansson is very rudimentary, there is no way
> to tell what precisely in the command that is represented in JSON is
> actually causing the error, this coarse grain error reporting is too
> broad.

Indeed, and my implementation would integrate nicely with nftables'
erecs.

I actually considered forking the project. Or we just ship a copy of the
lib with nftables sources?

Cheers, Phil

[1] https://github.com/akheron/jansson/pull/461#issuecomment-531552151
