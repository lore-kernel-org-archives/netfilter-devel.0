Return-Path: <SRS0=8tM5=3J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A98EC32771
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 22:36:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1A3422525
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 22:36:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="n16Plmc2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgATWgw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jan 2020 17:36:52 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:40406 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726607AbgATWgw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jan 2020 17:36:52 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1579559812; h=Message-ID: Subject: Cc: To: From: Date:
 Content-Transfer-Encoding: Content-Type: MIME-Version: Sender;
 bh=yVS7HGUIIcqs01ZcZdpIrMij/ideRP6BbyGl/SPUmL0=; b=n16Plmc20xFuPuzO0iDS+VESGplnI1fhjqLYjttSmkVh5cbu3otzt0X/plCKc9WVno17mmyY
 kJu0UGyUA6gcxTp1g8np3iJ0XGNB8TA/zpo/lHKSPM5+dshv3zPVnEI7ayNgQj97A7xCItmW
 N/IZBW5oIgSMNkm72P17rCb8qms=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlM2NhZSIsICJuZXRmaWx0ZXItZGV2ZWxAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e262b7e.7fd3c3684960-smtp-out-n01;
 Mon, 20 Jan 2020 22:36:46 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AA0C6C433A2; Mon, 20 Jan 2020 22:36:46 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: stranche)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7BE67C43383;
        Mon, 20 Jan 2020 22:36:46 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 20 Jan 2020 15:36:46 -0700
From:   stranche@codeaurora.org
To:     netfilter-devel@vger.kernel.org
Cc:     subashab@codeaurora.org
Subject: Update on UAF in ip6_do_table on 4.19.X kernel
Message-ID: <a714cb7a671411196557ccae56d1395b@codeaurora.org>
X-Sender: stranche@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi all,

Following up on the thread we submitted earlier here: 
https://lore.kernel.org/netfilter-devel/44a69247-87bd-905d-bd1c-e9dcb5027641@gmail.com/

In short, we've seen that on the 4.19.X kernels, there is a crash in the 
Xtables framework where the jumpstack can potentially be used after it 
is freed. We've narrowed down the cause of this crash to a single patch: 
f31e5f1a891f ("netfilter: unlock xt_table earlier in __do_replace"); if 
this patch is reverted, the crash is no longer seen.

It seems that the xt_table lock is needed for get_old_counters() to be 
synchronized properly with the rest of the framework.

Thanks,
Sean
