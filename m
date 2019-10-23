Return-Path: <SRS0=QRwA=YQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E3D1CA9EB6
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Oct 2019 15:31:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDF7E2084C
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Oct 2019 15:31:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403858AbfJWPb4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Oct 2019 11:31:56 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:32795 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390400AbfJWPb4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Oct 2019 11:31:56 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 5B8DC362259
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Oct 2019 02:31:42 +1100 (AEDT)
Received: (qmail 6245 invoked by uid 501); 23 Oct 2019 15:31:42 -0000
Date:   Thu, 24 Oct 2019 02:31:42 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnfnetlink 1/1] src: Minimally resurrect doxygen
 documentation
Message-ID: <20191023153142.GB5848@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20191014020223.21757-1-duncan_roe@optusnet.com.au>
 <20191014020223.21757-2-duncan_roe@optusnet.com.au>
 <20191023111346.4xoujsy6h2j7cv6y@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023111346.4xoujsy6h2j7cv6y@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=TRlWqBj8q3w8py2h_mgA:9 a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 23, 2019 at 01:13:46PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Oct 14, 2019 at 01:02:23PM +1100, Duncan Roe wrote:
> > The documentation was written in the days before doxygen required groups or even
> > doxygen.cfg, so create doxygen.cfg.in and introduce one \defgroup per source
> > file, encompassing pretty-much the whole file.
> >
[...]
> >
>
> I'm ambivalent about this, it's been up on the table for a while.
>
> This library is rather old, and new applications should probably
> be based instead used libmnl, which is a better choice.
>
The thing is, the Deprecated functions in libnetfilter_queue are much better
documented than the newer functions and that documentation refers to
libnfnetlink functions.

So I think that while the deprecated functions are documented, you should really
have documentation for the old library they use.

BTW, ldd of my app shows libnfnetlink.so although it doesn't use any deprecated
functions. Is that expected?

Cheers ... Duncan.
