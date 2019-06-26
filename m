Return-Path: <SRS0=TDc5=UZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 293A8C48BD6
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 21:12:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 058972085A
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 21:12:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfFZVM4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 17:12:56 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:43584 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726320AbfFZVM4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 17:12:56 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hgFDr-0006HH-DD; Wed, 26 Jun 2019 23:12:55 +0200
Date:   Wed, 26 Jun 2019 23:12:55 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 7/7] nftables: tests/py: More tests for day and hour
Message-ID: <20190626211255.5rgtfsc7kogn37bv@breakpoint.cc>
References: <20190626204402.5257-1-a@juaristi.eus>
 <20190626204402.5257-7-a@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626204402.5257-7-a@juaristi.eus>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ander Juaristi <a@juaristi.eus> wrote:
> I still have some problems to test the 'time' key.
> 
> It always prints one hour earlier than the introduced time,
> even though it works perfectly when I introduce the same rules manually,
> and there is code that specifically checks for that issue by checking TZ to UTC
> and substracting the GMT offset accordingly. Maybe there is some issue with
> env variables or localtime() in the Python test environment?
> 
> Need to investigate further.

If you're stuck let me know and I can take a look at this too.
