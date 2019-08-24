Return-Path: <SRS0=H+Om=WU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B5EC3A59E
	for <netfilter-devel@archiver.kernel.org>; Sat, 24 Aug 2019 20:33:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2E0A2054F
	for <netfilter-devel@archiver.kernel.org>; Sat, 24 Aug 2019 20:33:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727679AbfHXUdG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 24 Aug 2019 16:33:06 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:56058 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727497AbfHXUdG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 24 Aug 2019 16:33:06 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i1cif-0001kZ-51; Sat, 24 Aug 2019 22:33:05 +0200
Date:   Sat, 24 Aug 2019 22:33:05 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v9 2/2] meta: Introduce new conditions 'time', 'day'
 and 'hour'
Message-ID: <20190824203305.GN20113@breakpoint.cc>
References: <20190824140500.9077-1-a@juaristi.eus>
 <20190824140500.9077-2-a@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190824140500.9077-2-a@juaristi.eus>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ander Juaristi <a@juaristi.eus> wrote:
> These keywords introduce new checks for a timestamp, an absolute date (which is converted to a timestamp),
> an hour in the day (which is converted to the number of seconds since midnight) and a day of week.

Reviewed-by: Florian Westphal <fw@strlen.de>

I plan to apply the series once the kernel patch is in net-next.

Thanks Ander!
