Return-Path: <SRS0=4S6R=YT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE70CA9EB9
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 07:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72DE721655
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 07:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfJZHkR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 26 Oct 2019 03:40:17 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:39125 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725966AbfJZHkQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 26 Oct 2019 03:40:16 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id DE0EC43F273
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 18:40:01 +1100 (AEDT)
Received: (qmail 18180 invoked by uid 501); 26 Oct 2019 07:40:00 -0000
Date:   Sat, 26 Oct 2019 18:40:00 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnfnetlink 1/1] src: Minimally resurrect doxygen
 documentation
Message-ID: <20191026074000.GA17706@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20191014020223.21757-1-duncan_roe@optusnet.com.au>
 <20191014020223.21757-2-duncan_roe@optusnet.com.au>
 <20191023111346.4xoujsy6h2j7cv6y@salvia>
 <20191023153142.GB5848@dimstar.local.net>
 <20191023204836.ws4rv55f2dczhq2q@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023204836.ws4rv55f2dczhq2q@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=ZXZDk62DEMap8S-gwAAA:9 a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 23, 2019 at 10:48:36PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Oct 24, 2019 at 02:31:42AM +1100, Duncan Roe wrote:
> > BTW, ldd of my app shows libnfnetlink.so although it doesn't use any deprecated
> > functions. Is that expected?
> 
> Yes, there is still code in the libraries that refer to libnfnetlink.
> Replacing some of that code should be feasible via libmnl, it is a
> task that has been in my TODO list for long time. There's always
> something with more priority in the queue.

Using *nm -D* (dynamic symbols) I see
 - libmnl.so: no U (undefined) symbols satisfied by libnfnetlink.so
 - nfq (my app): no U symbols satisfied by libnfnetlink.so
 - libnetfilter_queue.so: many U symbols satisfied by libnfnetlink.so
Only way to tell whether the libnfnetlink.so references in libnetfilter_queue.so
are confined to the deprecated functions would be to do a build without them.
If that eliminates libnfnetlink references, then maybe we could think about a
configure option to not build them (also excluding them from the doco).
But that's for another day - I'll get back to libnetfilter_queue doco for now.

Cheers ... Duncan.
