Return-Path: <SRS0=zt5D=RD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9911BC43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Feb 2019 10:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EB482171F
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Feb 2019 10:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbfB1Ka2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Feb 2019 05:30:28 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:52844 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726918AbfB1Ka2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Feb 2019 05:30:28 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1gzIxO-0003hT-9c; Thu, 28 Feb 2019 11:30:26 +0100
Date:   Thu, 28 Feb 2019 11:30:26 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 4/5] json: Fix memleaks in echo support
Message-ID: <20190228103026.GG2478@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190226211342.15125-1-phil@nwl.cc>
 <20190226211342.15125-5-phil@nwl.cc>
 <20190227102920.waqyt4kp7e7bc7wo@salvia>
 <20190227111525.GF2478@orbyte.nwl.cc>
 <20190227222926.bfj5p2d4civilbao@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190227222926.bfj5p2d4civilbao@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Feb 27, 2019 at 11:29:26PM +0100, Pablo Neira Ayuso wrote:
[...]
> Not related to this patch: IIRC this echo support is not using the
> nlmsg_seq to correlate the command and the result that we obtain,
> right? Telling this because this should work with a batch that
> contains several requests to create rules, then use this sequence
> number to correlate things the reply with the original rule creation
> command.

I think you once suggested that and I promised to look into it. :)

So I just did and while nlmsg_seq would serve nice to clearly identify
which command a returned handle belongs to, I don't know how to map the
command back to the JSON object from which it was created.

Cheers, Phil
