Return-Path: <SRS0=dbJk=VL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61C70C73C66
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Jul 2019 23:20:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D0F52063F
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Jul 2019 23:20:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbfGNXUt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Jul 2019 19:20:49 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46916 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728754AbfGNXUs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Jul 2019 19:20:48 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hmnnT-00017S-QE; Mon, 15 Jul 2019 01:20:47 +0200
Date:   Mon, 15 Jul 2019 01:20:47 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v5 2/3] tests/py: Add tests for 'time', 'day' and 'hour'
Message-ID: <20190714232047.vsc4w6urjed4gmv3@breakpoint.cc>
References: <20190707205531.6628-1-a@juaristi.eus>
 <20190707205531.6628-2-a@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190707205531.6628-2-a@juaristi.eus>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ander Juaristi <a@juaristi.eus> wrote:
> This commit also modifies nft to print the days of the week in short
> format (e.g. "Sat" instead of "Saturday").

Please do that in the first patch.
It makes little sense to first add the long versions just to shorten
them again in next patch.
