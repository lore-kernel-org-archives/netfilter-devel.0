From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] Enable automerge feature for anonymous sets
Date: Wed, 7 Feb 2018 00:39:43 +0100
Message-ID: <20180206233943.6shg7qeg2mg6u2gg@salvia>
References: <20180206181847.14434-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Jeff Kletsky <netfilter@allycomm.com>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38770 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932090AbeBFXjs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 18:39:48 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1C7B0303D23
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 00:39:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0A481BAAA4
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 00:39:46 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180206181847.14434-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Phil,

On Tue, Feb 06, 2018 at 07:18:47PM +0100, Phil Sutter wrote:
> Automatic merging of adjacent/overlapping ranges upon insertion has
> clear benefits performance- and readability-wise. The drawbacks which
> led to disabling it by default don't apply to anonymous sets since they
> are read-only anyway, so enable this feature for them again.

Question is, why someone would be adding elements with overlapping
ranges in an anonymous set? Then, when listing the ruleset you will
get something different to what you've added. This would also be
inconsistent with regards to the existing behaviour in named sets,
where this is turned off by default.

For named sets, that are useful to maintain white/blacklists, I
understand this simplifies complexity for people dealing with them.
But not sure for anonymous sets.

@Jeff: Is this also useful to you in the anonymous set use-case? IIRC
we agreed that this was good for named sets, but not for anonymous
sets.

Thanks.
