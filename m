Return-Path: <SRS0=tJiL=YV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69846CA9EC0
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Oct 2019 20:42:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B4DC20830
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Oct 2019 20:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387864AbfJ1Ums (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Oct 2019 16:42:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44752 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbfJ1Ums (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Oct 2019 16:42:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 24F791484EA67;
        Mon, 28 Oct 2019 13:42:47 -0700 (PDT)
Date:   Mon, 28 Oct 2019 13:42:46 -0700 (PDT)
Message-Id: <20191028.134246.2282811510705892165.davem@davemloft.net>
To:     geert+renesas@glider.be
Cc:     pkshih@realtek.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, wensong@linux-vs.org,
        horms@verge.net.au, ja@ssi.bg, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, trivial@kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH trivial] net: Fix various misspellings of "connect"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191024152323.29987-1-geert+renesas@glider.be>
References: <20191024152323.29987-1-geert+renesas@glider.be>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Oct 2019 13:42:47 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>
Date: Thu, 24 Oct 2019 17:23:23 +0200

> Fix misspellings of "disconnect", "disconnecting", "connections", and
> "disconnected".
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Applied to net-next.
