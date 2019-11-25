Return-Path: <SRS0=kuYc=ZR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99AB3C432C3
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Nov 2019 06:08:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BC4F20674
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Nov 2019 06:08:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbfKYGIb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Nov 2019 01:08:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43850 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbfKYGIb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Nov 2019 01:08:31 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 76F7414C7C131;
        Sun, 24 Nov 2019 22:08:30 -0800 (PST)
Date:   Sun, 24 Nov 2019 22:08:30 -0800 (PST)
Message-Id: <20191124.220830.60669306672995389.davem@davemloft.net>
To:     netdev@vger.kernel.org
CC:     netfilter-devel@vger.kernel.org, linux-wireless@vger.kernel.org,
        bpf@vger.kernel.org
Subject: net-next is CLOSED
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 24 Nov 2019 22:08:30 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


If it's not in patchwork right now it will miss the merge window this
time around, don't try to sneak things in, thank you.

	http://vger.kernel.org/~davem/net-next.html

Bug fixes only please.
