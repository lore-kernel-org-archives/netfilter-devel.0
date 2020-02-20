Return-Path: <SRS0=kbfM=4I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35BA0C11D00
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Feb 2020 23:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1324120801
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Feb 2020 23:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729379AbgBTXWo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Feb 2020 18:22:44 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:55368 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729234AbgBTXWo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Feb 2020 18:22:44 -0500
Received: from dimstar.local.net (n122-110-29-255.sun2.vic.optusnet.com.au [122.110.29.255])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 33200820B80
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Feb 2020 10:22:31 +1100 (AEDT)
Received: (qmail 19985 invoked by uid 501); 20 Feb 2020 23:22:30 -0000
Date:   Fri, 21 Feb 2020 10:22:29 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v2] src: Add faster alternatives to
 pktb_alloc()
Message-ID: <20200220232229.GA19954@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20200108225323.io724vuxuzsydjzs@salvia>
 <20200201062127.4729-1-duncan_roe@optusnet.com.au>
 <20200219180410.e56psjovne3y43rc@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219180410.e56psjovne3y43rc@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=xEIwVUYJq7t7CX9UEWuoUA==:117 a=xEIwVUYJq7t7CX9UEWuoUA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=RSmzAf-M6YYA:10 a=OLL_FvSJAAAA:8 a=csPL-m2dGY2BizXmgCAA:9
        a=CjuIK1q_8ugA:10 a=2RsHJzH7CMAA:10 a=HAg69MfTcCgA:10 a=wvMYNXCZtGYA:10
        a=H9SuFdNxUskA:10 a=oIrB72frpwYPwTMnlWqB:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Wed, Feb 19, 2020 at 07:04:10PM +0100, Pablo Neira Ayuso wrote:
> On Sat, Feb 01, 2020 at 05:21:27PM +1100, Duncan Roe wrote:
[...]
> >  struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra);
> > +struct pkt_buff *pktb_alloc_data(int family, void *data, size_t len);
> > +struct pkt_buff *pktb_make(int family, void *data, size_t len, size_t extra, void *buf, size_t bufsize);
> > +struct pkt_buff *pktb_make_data(int family, void *data, size_t len, void *buf, size_t bufsize);
>
> Hm, when I delivered the patch to you, I forgot that you main point
> was that you wanted to skip the memory allocation.
>
> I wonder if all these new functions can be consolidated into one
> single function, something like:
>
>         struct pkt_buff *pktb_alloc2(int family, void *head, size_t head_size, void *data, size_t len, size_t extra);
>
> The idea is that:
>
> * head is the memory area that is large enough for the struct pkt_buff
>   (metadata). You can add a new pktb_head_size() function that returns
>   the size of opaque struct pkt_buff structure (whose layout is not
>   exposed to the user). I think you can this void *buf in your pktb_make
>   function.
>
> * data is the memory area to store the network packet itself.
>
> Then, you can allocate head and data in the stack and skip
> malloc/calloc.
>
> Would this work for you? I would prefer if there is just one single
> advanced function to do this.
>
> Thanks for your patience.

This patch set is not the last word. It would really help my development process
if you could just apply the patch set as-is.

> I would prefer if there is just one single advanced function ...

There *is* only 1 "advanced" function listed on the "User-space network packet
buffer" web page: pktb_make_data.

pktb_alloc must be kept for legacy support but it's documented on the "Other
functions" page.

pktb_alloc_data was only written for the benefit of timing tests. I can send a
patch to withdraw it as soon as this set is accepted.

Or, I can submit v4 with pktb_alloc_data removed. But only if you agree you will
then commit the patch.

> * data is the memory area to store the network packet itself.

Eh?? The plan is to leave the data where it is. pktb_make_data does that, it's
fine to use unless mangling could increase the packet size.

A more advance set of functions could lift that restriction. I'm still keen to
investigate the savings to be had by not having to move packet data for an
advanced variant of nfq_nlmsg_verdict_put_pkt. The idea is to use a new
structure (essentially metadata plus a struct nlmsghdr) which I have tentatively
named struct nlmsg_buffer. A number of advanced funtion variants would use it in
place of struct nlmsghdr. Please LMK if you would be interested in this.

> Thanks for your patience.

I have been working on something else :/

I had to put libnetfilter_queue development on hold because juggling 3 branches
was just getting to be too much.

(others are https://www.spinics.net/lists/netfilter-devel/msg65661.html (man
pages) and https://www.spinics.net/lists/netfilter-devel/msg65585.html (add more
helper functions to simplify coding)).

I can send a man pages update as soon as you commit something.

Cheers ... Duncan.
