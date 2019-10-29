Return-Path: <SRS0=pwfE=YW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7EF9CA9EAE
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Oct 2019 23:54:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC13220862
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Oct 2019 23:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbfJ2Xyh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Oct 2019 19:54:37 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:35056 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725974AbfJ2Xyh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Oct 2019 19:54:37 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id B71A83A201C
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Oct 2019 10:54:20 +1100 (AEDT)
Received: (qmail 4986 invoked by uid 501); 29 Oct 2019 23:54:20 -0000
Date:   Wed, 30 Oct 2019 10:54:20 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] src: doc: Document
 nfq_nlmsg_verdict_put_mark() and nfq_nlmsg_verdict_put_pkt()
Message-ID: <20191029235420.GB3149@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20191027083804.24152-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191027083804.24152-1-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=PO7r1zJSAAAA:8 a=YLcMaBHcLSTh42Mm0xoA:9 a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Sun, Oct 27, 2019 at 07:38:04PM +1100, Duncan Roe wrote:
> This completes the "Verdict helpers" module.
>
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
>  src/nlmsg.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 44 insertions(+), 1 deletion(-)
>
> diff --git a/src/nlmsg.c b/src/nlmsg.c
[...]

Anything wrong with this? It's the first of many libnetfilter_queue
documentation updates I was planning to send.

Is there anything I could do to make it more obvious (for you) that they are
doco updates?
 (I thought tagging them "src: doc:" would do that)
 (Should I send them to you cc: the list?)

Cheers ... Duncan.
