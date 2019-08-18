Return-Path: <SRS0=n9X8=WO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2A05C3A589
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Aug 2019 18:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CAC42086C
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Aug 2019 18:27:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfHRS16 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Aug 2019 14:27:58 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:51854 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726270AbfHRS16 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Aug 2019 14:27:58 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1hzPuH-00052c-0e; Sun, 18 Aug 2019 20:27:57 +0200
Date:   Sun, 18 Aug 2019 20:27:57 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v7 1/2] evaluate: New internal helper
 __expr_evaluate_range
Message-ID: <20190818182757.5fdxjlvachtdhtur@breakpoint.cc>
References: <20190818182013.6765-1-a@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190818182013.6765-1-a@juaristi.eus>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ander Juaristi <a@juaristi.eus> wrote:
> Signed-off-by: Ander Juaristi <a@juaristi.eus>

This could use a changelog.

Example:

This is used by the followup patch to evaluate a range without emitting
an error when the left value is larger than the right one.

This is done to handle time-matching such as
23:00-01:00 -- expr_evaluate_range() will reject this, but
we want to be able to evaluate and then handle this as a request
to match from 23:00 to 1am.
