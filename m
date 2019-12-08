Return-Path: <SRS0=ZPzN=Z6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE8B2C43603
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Dec 2019 03:49:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 916CA208C4
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Dec 2019 03:49:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfLHDtu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 7 Dec 2019 22:49:50 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:38497 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725834AbfLHDtu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Dec 2019 22:49:50 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id A9A357EA733
        for <netfilter-devel@vger.kernel.org>; Sun,  8 Dec 2019 14:49:31 +1100 (AEDT)
Received: (qmail 15111 invoked by uid 501); 8 Dec 2019 03:49:30 -0000
Date:   Sun, 8 Dec 2019 14:49:30 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: RFC: libnetfilter_queue: nfq_udp_get_payload_len() gives wrong answer
Message-ID: <20191208034930.GA10353@dimstar.local.net>
Mail-Followup-To: Netfilter Development <netfilter-devel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=kj9zAlcOel0A:10 a=pxVhFHJ0LMsA:10 a=RSmzAf-M6YYA:10
        a=7Mc3m683rO2x_ZhIoBoA:9 a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nfq_udp_get_payload() correctly returns a pointer to the first data byte in a
UDP message, e.g. to "A" in the message "ASD\n".

BUT nfq_udp_get_payload_len() returns 12 for the length of the above message,
i.e. combined lengths of payload and UDP header.

I plan to do an update of the documentation in src/extra/udp.c so I can document
this behaviour then.

OR

Should I change the behaviour of nfq_udp_get_payload_len() to what one would
expect? (e.g. return 4 in the example above)

OR

Should there be a new function, say nfq_udp_get_payload_len2(), to give the
expected answer?

AND, should the new or updated function guard against returning a -ve result?
(which, being unsigned, would become a large +ve result)

Any opinions?

Cheers ... Duncan.
