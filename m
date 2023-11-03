Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 315F8C4167D
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 12:21:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjKCMVP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 08:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233785AbjKCMVO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 08:21:14 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A676184
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 05:21:07 -0700 (PDT)
Received: from [78.30.35.151] (port=42066 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qytAa-00EpIr-Tg; Fri, 03 Nov 2023 13:21:05 +0100
Date:   Fri, 3 Nov 2023 13:21:00 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>, fw@strlen.de
Subject: Re: [PATCH nft v2 4/7] build: no recursive make for
 "files/**/Makefile.am"
Message-ID: <ZUTlrLF/ocsRuaqg@calendula>
References: <20231019130057.2719096-1-thaller@redhat.com>
 <20231019130057.2719096-5-thaller@redhat.com>
 <ZUOEpOU96ai+dmT7@calendula>
 <ZUOIWNT3sjmqd8EM@calendula>
 <db1347b7716868923326a870d87ccaf9d2572633.camel@redhat.com>
 <ZUPI2ItCERJy8a+3@calendula>
 <174b4dbc0df7fec4d0fdbe2c9cb96d4fca5ecd5b.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <174b4dbc0df7fec4d0fdbe2c9cb96d4fca5ecd5b.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 02, 2023 at 05:53:43PM +0100, Thomas Haller wrote:
> On Thu, 2023-11-02 at 17:05 +0100, Pablo Neira Ayuso wrote:
[...]
> > But this is completely inconsistent with what we have in other
> > existing Netfilter trees.
> 
> That would also be fixable, by adjusting those trees (I'd volunteer). 
> 
> The question is what's better, and not what the projects copy-pasted
> since 1995 do.

I don't think it is worth the update, maybe some simplification to
remove silly things such as Makefile.am with one singleton line, but
there are better things to look at IMO.

[...]
> > Please do not couple tests with make process.
> 
> On the branch, those tests work and it's convenient to run them and
> reasonably fast! `make -j distcheck` takes 59 seconds on my machine.

CI is what is missing, a single run is proving not giving much in
return these days after your improvements.

The recent bugs that were uncovered have been spotted by running this
is a loop, and also exercising standalone 30s-stress from Florian for
many hours.

A few minutes does not harm (I can check how long it takes on my AMD
Epyc box that I use for testing), but CI might provide more reliable
information on what is going on.

Thanks.
