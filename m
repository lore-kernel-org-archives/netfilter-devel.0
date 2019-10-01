Return-Path: <SRS0=ZC8Q=X2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B031C32792
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Oct 2019 01:29:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D15B20842
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Oct 2019 01:29:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbfJAB3D (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Sep 2019 21:29:03 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58375 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726789AbfJAB3D (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Sep 2019 21:29:03 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 55DCD43E6FB
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Oct 2019 11:28:51 +1000 (AEST)
Received: (qmail 22112 invoked by uid 501); 1 Oct 2019 01:28:50 -0000
Date:   Tue, 1 Oct 2019 11:28:50 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] BUG: src: Fix UDP checksum calculation
Message-ID: <20191001012850.GA27559@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20190927121838.7680-1-duncan_roe@optusnet.com.au>
 <20190930142840.l6wsena3hfki56qn@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930142840.l6wsena3hfki56qn@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=voM4FWlXAAAA:8 a=PO7r1zJSAAAA:8 a=A-9kNuJ67zNmM8BpBvcA:9
        a=CjuIK1q_8ugA:10 a=IC2XNlieTeVoXbcui8wp:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 30, 2019 at 04:28:40PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Sep 27, 2019 at 10:18:38PM +1000, Duncan Roe wrote:
> > The level 4 protocol is part of the UDP and TCP calculations.
> > nfq_checksum_tcpudp_ipv4() was using IPPROTO_TCP in this calculation,
> > which gave the wrong answer for UDP.
>
> Thanks Duncan, I sent this patch to fix IPv6 too:
>
> https://patchwork.ozlabs.org/patch/1169407/
>
LGTM

Acked-by: Duncan Roe <duncan_roe@optusnet.com.au>
