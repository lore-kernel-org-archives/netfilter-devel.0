Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DB33EE7FF4
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Sep 2023 07:51:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbjIKHvm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Sep 2023 03:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbjIKHvl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Sep 2023 03:51:41 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16020CD8
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Sep 2023 00:51:18 -0700 (PDT)
Received: from [46.222.166.110] (port=12466 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qfbhO-006fTu-UZ; Mon, 11 Sep 2023 09:51:13 +0200
Date:   Mon, 11 Sep 2023 09:51:07 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH RFC libnetfilter_queue] doc: Get rid of DEPRECATED tag
 (Work In Progress)
Message-ID: <ZP7G68U/HKxIkUmp@calendula>
References: <20230911055425.8524-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230911055425.8524-1-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 11, 2023 at 03:54:25PM +1000, Duncan Roe wrote:
> This is a call for comments on how we want the documentation to look.
> In conjunction with the git diff, readers may find it helpful to apply the patch
> in a temporary branch and check how the web page / man pages look.
> To get web & man pages, do something like
> 
> ./configure --enable-html-doc; make -j; firefox doxygen/html/index.html
> MANPATH=$PWD/doxygen/man:$MANPATH
> 
> Some changes are documented below - I'll post more later
> 
> --- Preparation for man 7 libnetfilter_queue
> The /anchor / <h1> ... </h1> combo is in preparation for making
> libnetfilter_queue.7 from the main page. mainpage is morphed to a group
> (temporarily) so all \section lines have to be changed to <h1> because \section
> doesn't work in a group. The appearance stays the same.
> 
> ---1st stab at commit message for finished patch
> libnetfilter_queue effectively supports 2 ABIs, the older being based on
> libnfnetlink and the newer on libmnl.

Yes, there are two APIs, same thing occurs in other existing
libnetfilter_* libraries, each of these APIs are based on libnfnetlink
and libmnl respectively.

> The libnetfilter_queue-based functions were tagged DEPRECATED but
> there is a fading hope to re-implement these functions using libmnl.
> So change DEPRECATED to "OLD API" and update the main page to
> explain stuff.

libnfnetlink will go away sooner or later. We are steadily replacing
all client of this library for netfilter.org projects. Telling that
this is not deprecated without providing a compatible "old API" for
libmnl adds more confusion to this subject.

If you want to explore providing a patch that makes the
libnfnetlink-based API work over libmnl, then go for it.
