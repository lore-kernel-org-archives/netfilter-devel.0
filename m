Return-Path: <SRS0=ps4H=6J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15B04C54FCB
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Apr 2020 23:57:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDAC3206BF
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Apr 2020 23:57:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbgDYX5E (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 25 Apr 2020 19:57:04 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:34526 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726070AbgDYX5E (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Apr 2020 19:57:04 -0400
Received: from dimstar.local.net (n175-34-64-112.sun1.vic.optusnet.com.au [175.34.64.112])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id F0AFA820C7F
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Apr 2020 09:57:00 +1000 (AEST)
Received: (qmail 13534 invoked by uid 501); 25 Apr 2020 23:56:59 -0000
Date:   Sun, 26 Apr 2020 09:56:59 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: FW: pktb_alloc2
Message-ID: <20200425235659.GJ30155@dimstar.local.net>
Mail-Followup-To: Netfilter Development <netfilter-devel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=keeXcwCgVCrAuxOn72dlvA==:117 a=keeXcwCgVCrAuxOn72dlvA==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=RSmzAf-M6YYA:10 a=PO7r1zJSAAAA:8
        a=3HDBlxybAAAA:8 a=OLL_FvSJAAAA:8 a=H60_074oE17iYOvfmaUA:9
        a=CjuIK1q_8ugA:10 a=OVJnjtlDKZIA:10 a=AH0NCSqBHYIA:10
        a=laEoCiVfU_Unz3mSdgXN:22 a=oIrB72frpwYPwTMnlWqB:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

oops! - meant to cc: the list

----- Forwarded message from Duncan Roe <duncan_roe@optusnet.com.au> -----

Date: Sat, 25 Apr 2020 17:15:55 +1000
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: pktb_alloc2
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Pablo,

Did you notice my email
https://www.spinics.net/lists/netfilter-devel/msg66710.html ?

Is that the calling sequence you suggested? It did seem to me simpler to
document that you need a packet copy buffer if mangling may increase packet
size, rather than document pktb must be dimensioned differently (so can tack
buffer onto end of it as in pktb_alloc). I can do a v2 if you'd rather have it
that way, of course.

Cheers ... Duncan.

----- End forwarded message -----
