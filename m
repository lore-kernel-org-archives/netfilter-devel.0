Return-Path: <SRS0=8p/T=ZF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6953FC432C3
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Nov 2019 22:58:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AE65206EE
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Nov 2019 22:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfKMW6j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Nov 2019 17:58:39 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:48316 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726303AbfKMW6i (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Nov 2019 17:58:38 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 0FAB37EA17D
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2019 09:58:23 +1100 (AEDT)
Received: (qmail 15987 invoked by uid 501); 13 Nov 2019 22:58:23 -0000
Date:   Thu, 14 Nov 2019 09:58:23 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: libnetfilter_queue git pull has stopped working
Message-ID: <20191113225823.GA10736@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10 a=RSmzAf-M6YYA:10
        a=F7lP9Ql6sooWZgPE1RMA:9 a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Are you the right person to inform?

"git pull" in directory src/libnetfilter_queue is giving this error:

> 09:51:46$ git pull
> fatal: read error: Connection reset by peer
> 09:53:04$

Please fix or tell thi right person,

Cheers ... Duncan.
