Return-Path: <SRS0=uN83=25=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63CB3C282DD
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jan 2020 22:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 361EA2053B
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jan 2020 22:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgAHWrT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jan 2020 17:47:19 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58280 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726721AbgAHWrS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jan 2020 17:47:18 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 59CCF821682
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2020 09:47:04 +1100 (AEDT)
Received: (qmail 13672 invoked by uid 501); 8 Jan 2020 22:47:03 -0000
Date:   Thu, 9 Jan 2020 09:47:03 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH RFC libnetfilter_queue 0/1] Make usable man pages
Message-ID: <20200108224703.GA11763@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20200106070915.4700-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200106070915.4700-1-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=Jdjhy38mL1oA:10
        a=RSmzAf-M6YYA:10 a=QOA-nrLUAAAA:8 a=TluRFNyD8vwea7-fG5UA:9
        a=CjuIK1q_8ugA:10 a=DJmr9hQBE-8A:10 a=gA6IeH5FQcgA:10 a=NWVoK91CQyQA:10
        a=gT9E5cLyRG57uJBLyEb_:22 a=pHzHmUro8NiASowvMSCR:22
        a=6VlIyEUom7LUIeUMNQJH:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Mon, Jan 06, 2020 at 06:09:14PM +1100, Duncan Roe wrote:
> fixmanpages.sh generates a top-level man page file tree such that man/man3
> contains an entry for every documented nfq function. This is what users expect.
>
> See main commit for how fixmanpages.sh works.
>
> Itwould be nice to have "make" run "doxygen doxygen.cfg; ./fixmanpages.sh" and
> "make install" install the man pages but I'm not yet that good with autotools.
>
> There could be a similar script for libmnl.
>
> Duncan Roe (1):
>   doc: setup: Add shell script fixmanpages.sh to make usable man pages
>
>  fixmanpages.sh | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 60 insertions(+)
>  create mode 100755 fixmanpages.sh
>
> --
> 2.14.5
>
Don't worry about applying this, it's is just a Proof Of Concept. Personally
I've found it useful because I can now easily review generated man format doco.

I've found some instructions for integrating doxygen into autotools at
http://chris-miceli.blogspot.com/2011/01/integrating-doxygen-with-autotools.html
so will be giving that a go.

Cheers ... Duncan.
