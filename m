Return-Path: <SRS0=AHIo=Y5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41A53C5DF61
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Nov 2019 22:03:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D22221929
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Nov 2019 22:03:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730302AbfKEWDZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Nov 2019 17:03:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39314 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729830AbfKEWDY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Nov 2019 17:03:24 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 04641150689E4;
        Tue,  5 Nov 2019 14:03:23 -0800 (PST)
Date:   Tue, 05 Nov 2019 14:03:23 -0800 (PST)
Message-Id: <20191105.140323.1324058477518607844.davem@davemloft.net>
To:     mcroce@redhat.com
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] icmp: move duplicate code in helper
 functions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191102001204.83883-1-mcroce@redhat.com>
References: <20191102001204.83883-1-mcroce@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 14:03:24 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>
Date: Sat,  2 Nov 2019 01:12:02 +0100

> Remove some duplicate code by moving it in two helper functions.
> First patch adds the helpers, the second one uses it.

Series applied.
