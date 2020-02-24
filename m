Return-Path: <SRS0=eo3W=4M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E6CBC38BF9
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 23:19:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DFFD2080D
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 23:19:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbgBXXTl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Feb 2020 18:19:41 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:57678 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726651AbgBXXTl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Feb 2020 18:19:41 -0500
Received: from dimstar.local.net (n122-110-29-255.sun2.vic.optusnet.com.au [122.110.29.255])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 056793A1D2B
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Feb 2020 10:19:22 +1100 (AEDT)
Received: (qmail 8470 invoked by uid 501); 24 Feb 2020 23:19:22 -0000
Date:   Tue, 25 Feb 2020 10:19:22 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] src: add nfq_get_skbinfo()
Message-ID: <20200224231922.GA4516@dimstar.local.net>
Mail-Followup-To: Florian Westphal <fw@strlen.de>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20200223234941.44877-1-fw@strlen.de>
 <20200224010344.GA3564@dimstar.local.net>
 <20200224101648.GF19559@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224101648.GF19559@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=xEIwVUYJq7t7CX9UEWuoUA==:117 a=xEIwVUYJq7t7CX9UEWuoUA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=RSmzAf-M6YYA:10 a=PO7r1zJSAAAA:8 a=Z4cdAhcMAePSP6NWx6IA:9
        a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi again Florian,

On Mon, Feb 24, 2020 at 11:16:48AM +0100, Florian Westphal wrote:
> Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> > Can I suggest:
> >
> >   > + *   example because this is an incoming packet and the NIC does not
> >   > + *   perform checksum validation at hardware level.
> > - > + * See nfq_set_queue_flags() documentation for more information.
> >   > + *
> >   > + * \return the skbinfo value
> > + > + * \sa __nfq_set_queue_flags__(3)
> >   > + */
> >   > +EXPORT_SYMBOL
> >
> > I think this will look better, especially on the man page.
>
> Its does, thanks.  I've made this change in my local tree.

Sorry to do this to you, but would you mind changing line ~56 in fixmanpages.sh
from "function   add2group" to "function add2group" please?.

I.e. remove 2 unnecessary spaces. This will then match commit cbe9959921 (src:
expose nfq_nlmsg_put)

Cheers ... Duncan.
