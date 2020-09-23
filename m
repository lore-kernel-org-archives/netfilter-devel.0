Return-Path: <SRS0=+Cxx=DA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB835C2D0A8
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Sep 2020 12:43:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48F2720BED
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Sep 2020 12:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgIWMnD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Sep 2020 08:43:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51174 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726513AbgIWMnC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Sep 2020 08:43:02 -0400
X-Greylist: delayed 2130 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Sep 2020 08:43:02 EDT
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kL3YC-00FsR9-OA; Wed, 23 Sep 2020 14:07:08 +0200
Date:   Wed, 23 Sep 2020 14:07:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     yue longguang <yuelongguang@gmail.com>
Cc:     wensong@linux-vs.org, horms@verge.net.au, ja@ssi.bg,
        pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ipvs: adjust the debug order of src and dst
Message-ID: <20200923120708.GD3770354@lunn.ch>
References: <CAPaK2r921GtJVhwGKnZyCcQ1qkcWA=8TBWwNkW03R_=7TKzo6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPaK2r921GtJVhwGKnZyCcQ1qkcWA=8TBWwNkW03R_=7TKzo6g@mail.gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 23, 2020 at 02:06:25PM +0800, yue longguang wrote:
> From: ylg <bigclouds@163.com>
> 
> adjust the debug order of src and dst when tcp state changes

Hi Yue

You need to explain why you are doing something, not what you are
doing, in the commit message.

	Andrew
