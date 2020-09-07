Return-Path: <SRS0=Y+c4=CQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00E97C43461
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Sep 2020 01:22:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC6222080A
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Sep 2020 01:22:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgIGBW7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 6 Sep 2020 21:22:59 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:51407 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726620AbgIGBW7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 6 Sep 2020 21:22:59 -0400
Received: from dimstar.local.net (n49-192-221-78.sun4.vic.optusnet.com.au [49.192.221.78])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 87CBD824B60
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2020 11:22:55 +1000 (AEST)
Received: (qmail 3607 invoked by uid 501); 7 Sep 2020 01:22:55 -0000
Date:   Mon, 7 Sep 2020 11:22:55 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: Can someone please update libnetfilter_queue online documentation
Message-ID: <20200907012255.GC6585@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20200906001817.GB6585@dimstar.local.net>
 <20200906214904.GA7550@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200906214904.GA7550@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=XJ9OtjpE c=1 sm=1 tr=0 cx=a_idp_d
        a=6xKf4iIoQv62Sz4byRKdFA==:117 a=6xKf4iIoQv62Sz4byRKdFA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=RSmzAf-M6YYA:10 a=3HDBlxybAAAA:8
        a=JGlQy3c8u2y2SAM3plQA:9 a=CjuIK1q_8ugA:10 a=5f-XVLFa7YsA:10
        a=laEoCiVfU_Unz3mSdgXN:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Sep 06, 2020 at 11:49:04PM +0200, Pablo Neira Ayuso wrote:
> On Sun, Sep 06, 2020 at 10:18:17AM +1000, Duncan Roe wrote:
> > Hi everyone,
> >
> > The online doc for libnetfilter_queue at
> > https://netfilter.org/projects/libnetfilter_queue/doxygen/html/ is still at
> > release 1.0.3.
>
> Refreshed.

Thanks, Pablo.

It looks like you don't have the 'graphviz' package installed, so there are
lines like

> Collaboration diagram for User-space network packet buffer:

with no diagram.

(e.g. in
https://netfilter.org/projects/libnetfilter_queue/doxygen/html/group__pktbuff.html).

'graphviz' supplies the 'dot' program which you may have seen doxygen
complaining about. I didn't see the problem originally because I have graphviz
but it didn't come with Slackware so the lack of it may be common.

The fix would be to have config.ac create HAVE_DOT and use that in
doxygen.cfg.in to put YES or NO on the HAVE_DOT and maybe some other lines.

I may tackle that sometime as I gain more confidence with aoutotools.

Cheers ... Duncan.
