Return-Path: <SRS0=Lm+H=63=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E525C2D0F8
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 May 2020 06:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04FF820708
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 May 2020 06:49:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729451AbgEMGto (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 May 2020 02:49:44 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:55233 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728101AbgEMGto (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 May 2020 02:49:44 -0400
X-Greylist: delayed 464 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 May 2020 02:49:43 EDT
Received: from dimstar.local.net (n175-34-64-112.sun1.vic.optusnet.com.au [175.34.64.112])
        by mail108.syd.optusnet.com.au (Postfix) with SMTP id 6385C1A758C
        for <netfilter-devel@vger.kernel.org>; Wed, 13 May 2020 16:49:42 +1000 (AEST)
Received: (qmail 28451 invoked by uid 501); 13 May 2020 06:49:41 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue 1/1] src: add pktb_alloc2() and pktb_head_size()
Date:   Wed, 13 May 2020 16:49:40 +1000
Message-Id: <20200513064941.28408-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200510151001.GA6216@salvia>
References: <20200510151001.GA6216@salvia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=keeXcwCgVCrAuxOn72dlvA==:117 a=keeXcwCgVCrAuxOn72dlvA==:17
        a=sTwFKg_x9MkA:10 a=RSmzAf-M6YYA:10 a=n6PxgeP8Fo7jKsx18m8A:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Sun, May 10, 2020 at 05:10:01PM +0200, Pablo Neira Ayuso wrote:
> On Sun, May 10, 2020 at 11:53:17PM +1000, Duncan Roe wrote:
> > pktb_alloc2() avoids the malloc/free overhead in pktb_alloc() and also
> > eliminates memcpy() of the payload except when mangling increases the
> > packet length.
> >
> >  - pktb_mangle() does the memcpy() if need be.
> >    Packet metadata is altered in this case
> >  - All the _mangle functions are altered to account for possible change tp
> >    packet metadata
> >  - Documentation is updated
>
> Many chunks of this patchset look very much the same I posted. I'll
> apply my patchset and please rebase any update on top of it.
>
> Thanks.

Apologies for the colourful language in the previous post. I could see
something was very wrong but was too tired to formulate a reasoned response.

My concern is with the calling sequence of pktb_setup().
There's a detailed explanation in one of the patch reviews I just posted.
As long as you're happy with that bit, commit what you like.
If it would save you time, the following patch applied on top of my initial
patch aligns with what you posted, after making the corrections in my reviews.
You might like to try them and see what you think.
Or, just apply yours and I'll rebase. But that *will* include changing the
calling sequence of pktb_setup().

Cheers ... Duncan.

Duncan Roe (1):
  src & doc: Rename pktb_alloc2 to pktb_setup

 fixmanpages.sh                       |  2 +-
 include/libnetfilter_queue/pktbuff.h |  4 +++-
 src/extra/pktbuff.c                  | 37 ++++++++++++++++++------------------
 src/nlmsg.c                          |  2 +-
 4 files changed, 23 insertions(+), 22 deletions(-)

--
2.14.5

