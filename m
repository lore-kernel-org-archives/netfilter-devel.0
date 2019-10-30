Return-Path: <SRS0=SDnU=YX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99879CA9EC5
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 09:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7403C20874
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 09:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbfJ3JiP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Oct 2019 05:38:15 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:36840 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726028AbfJ3JiP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Oct 2019 05:38:15 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id EC98643EE7D
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Oct 2019 20:38:02 +1100 (AEDT)
Received: (qmail 6812 invoked by uid 501); 30 Oct 2019 09:38:02 -0000
Date:   Wed, 30 Oct 2019 20:38:02 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: Documentation question
Message-ID: <20191030093802.GC6302@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20191030090707.GB6302@dimstar.local.net>
 <20191030091521.gosjooprb27xgoc6@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030091521.gosjooprb27xgoc6@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=G6BsK5s5 c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=zljpY9yY4QGW4pjK5vkA:9 a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 30, 2019 at 10:15:21AM +0100, Pablo Neira Ayuso wrote:
> On Wed, Oct 30, 2019 at 08:07:07PM +1100, Duncan Roe wrote:
> > Hi Pablo,
> >
> > When setting verdicts, does sending amended packet contents imply to accept the
> > packet? In my app I have assumed not and that seems to work fine, but I'd like
> > to be sure for the doco.
>
> If you set the verdict to NF_ACCEPT and the packet that you send back
> to the kernel is mangled, then the kernel takes your mangled packet
> contents.
>
> Thanks.

Thanks Pablo I knew that, but what happens if you send back mangled contents
and no NF_ACCEPT or NF_DROP?

Does the kernel keep waiting until you send one of these?

Cheers ... Duncan.
