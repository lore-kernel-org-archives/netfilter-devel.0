Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAA8DECE588
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 10:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 949C32067B
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 10:33:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730279AbfJOKdQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 06:33:16 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:36446 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726208AbfJOKdQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 06:33:16 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iKK8g-0008Pb-MW; Tue, 15 Oct 2019 12:33:14 +0200
Date:   Tue, 15 Oct 2019 12:33:14 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     UDAY MEWADA <udaymewada1@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: First Contribution
Message-ID: <20191015103314.GA26123@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        UDAY MEWADA <udaymewada1@gmail.com>,
        netfilter-devel@vger.kernel.org
References: <CAA6WKfwC-pqFPCmsFnCDaRzvzxk7CuGw+7RW-rMu60=UOCB2Cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA6WKfwC-pqFPCmsFnCDaRzvzxk7CuGw+7RW-rMu60=UOCB2Cw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Mon, Oct 14, 2019 at 08:44:05PM +0530, UDAY MEWADA wrote:
> My name is Uday Mewada, pursuing engineering in Computer Science.
> 
> I'm looking forward to contributing to Netfilter. Can someone guide me
> how to start contributing in it and what are the initial bugs where I
> can start.

You could have a look at https://bugzilla.netfilter.org/ for starters.

Cheers, Phil
