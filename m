Return-Path: <SRS0=ECQ/=X7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76D4BC4360C
	for <netfilter-devel@archiver.kernel.org>; Sun,  6 Oct 2019 10:55:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 483122084D
	for <netfilter-devel@archiver.kernel.org>; Sun,  6 Oct 2019 10:55:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbfJFKzl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 6 Oct 2019 06:55:41 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:41949 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726224AbfJFKzk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 6 Oct 2019 06:55:40 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 57773363A97
        for <netfilter-devel@vger.kernel.org>; Sun,  6 Oct 2019 21:55:26 +1100 (AEDT)
Received: (qmail 1090 invoked by uid 501); 6 Oct 2019 10:55:25 -0000
Date:   Sun, 6 Oct 2019 21:55:25 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libmnl] src: fix doxygen function documentation
Message-ID: <20191006105525.GA15026@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20190925131418.7711-1-ffmancera@riseup.net>
 <20190930141753.6wxuweyyspeldfx4@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930141753.6wxuweyyspeldfx4@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=t8dxe4_RjaY1-BQgWIMA:9 a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Mon, Sep 30, 2019 at 04:17:53PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 25, 2019 at 03:14:19PM +0200, Fernando Fernandez Mancera wrote:
> > Currently clang requires EXPORT_SYMBOL() to be above the function
> > implementation. At the same time doxygen is not generating the proper
> > documentation because of that.
> >
> > This patch solves that problem but EXPORT_SYMBOL looks less like the Linux
> > kernel way exporting symbols.
>
> Applied, thanks.

I missed this earlier - take a look at the man pages / html doc with this patch.

E.g. man attr:

> attr(3)                             libmnl                            attr(3)
>
>
>
> NAME
>        attr - Netlink attribute helpers
>
>    Functions
>        EXPORT_SYMBOL uint16_t mnl_attr_get_type (const struct nlattr *attr)
>        EXPORT_SYMBOL uint16_t mnl_attr_get_len (const struct nlattr *attr)
>        EXPORT_SYMBOL uint16_t mnl_attr_get_payload_len (const struct nlattr
>            *attr)
>        EXPORT_SYMBOL void * mnl_attr_get_payload (const struct nlattr *attr)
>        EXPORT_SYMBOL bool mnl_attr_ok (const struct nlattr *attr, int len)

The web pages are the same.

Shunting all the EXPORT_SYMBOL lines to the start of the file as in my rejected
patch might have been ugly, but at least it left the documentation looking as it
should.

I just finished making a patch for libnetfilter_queue using the redefined
EXPORT_SYMBOL as above but taking care to avoid generating lines over 80 chars
and preserving (or fixing!) alignment of subsequent parameter lines. But I won't
submit it, because it results in the same horrible documentation.

I think it should be not too onerous to move the EXPORT_SYMBOL lines to before
the start of documentation, which should satisfy both doxygen adn clang. Would
you like me to go ahead with that?

Cheers ... Duncan.
