Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DED4C64ED8
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Feb 2023 16:13:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjB0QNN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Feb 2023 11:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjB0QNN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2023 11:13:13 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CDFF742
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Feb 2023 08:13:12 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pWg7i-0000yW-Oj; Mon, 27 Feb 2023 17:13:10 +0100
Date:   Mon, 27 Feb 2023 17:13:10 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Bryce Kahle <bryce.kahle@datadoghq.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: PROBLEM: nf_conntrack_events autodetect mode invalidates
 NETLINK_LISTEN_ALL_NSID netlink socket option
Message-ID: <20230227161310.GB31439@breakpoint.cc>
References: <CALvGib_xHOVD2+6tKm2Sf0wVkQwut2_z2gksZPcGw30tOvOAAA@mail.gmail.com>
 <20230215100236.GC9908@breakpoint.cc>
 <CALvGib8TSNk47Spapt2dMe+R_ohzZZz9yC5Ou3qqRxJqtYfBmg@mail.gmail.com>
 <20230216151822.GB14032@breakpoint.cc>
 <Y/OHJKR7eh+DhymU@salvia>
 <CALvGib_UWuvWYx2H6pXxJnVUkoo3_txD+SNV7WhDMjMP9KKTdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALvGib_UWuvWYx2H6pXxJnVUkoo3_txD+SNV7WhDMjMP9KKTdQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Bryce Kahle <bryce.kahle@datadoghq.com> wrote:
> I see there was a patch applied. Is there any chance of getting this
> backported to the affected versions 5.19+, since it broke existing
> functionality?

stable should pick this up automatically due to 'Fixes' tag.
