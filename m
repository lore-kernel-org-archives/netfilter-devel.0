Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC7CBC433B4
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Apr 2021 10:23:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAA0861450
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Apr 2021 10:23:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhD3KYX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Apr 2021 06:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhD3KYV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Apr 2021 06:24:21 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B30C06174A
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Apr 2021 03:23:31 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 884465872FB51; Fri, 30 Apr 2021 12:23:28 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 8756660AC93FB;
        Fri, 30 Apr 2021 12:23:28 +0200 (CEST)
Date:   Fri, 30 Apr 2021 12:23:28 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Phil Sutter <phil@nwl.cc>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [net-next PATCH] netfilter: xt_SECMARK: add new revision to fix
 structure layout
In-Reply-To: <20210430102225.GV3158@orbyte.nwl.cc>
Message-ID: <9npr2nn6-por7-rnn4-1059-pn1444oqr4ss@vanv.qr>
References: <20210429133929.20161-1-phil@nwl.cc> <4q6r71np-5085-177o-15p6-r3ss3s601rp@vanv.qr> <20210430102225.GV3158@orbyte.nwl.cc>
User-Agent: Alpine 2.24 (LSU 510 2020-10-10)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Friday 2021-04-30 12:22, Phil Sutter wrote:
>On Thu, Apr 29, 2021 at 05:11:49PM +0200, Jan Engelhardt wrote:
>[...]
>> >+struct xt_secmark_tginfo {
>> >+	__u8 mode;
>> >+	char secctx[SECMARK_SECCTX_MAX];
>> >+	__u32 secid;
>> >+};
>> 
>> that should be struct xt_secmark_tginfo_v1.
>
>The v0 struct is called xt_secmark_target_info, I guess Pablo tried to
>shorten the name a bit. In conforming to "the standard", I'd then go
>with xt_secmark_target_info_v1 instead. Fine with you?

That's ok.

>> >+		.checkentry	= secmark_tg_check_v2,
>> 
>> Can't have revision=1 and then call it _v2. That's just confusing.
>
>ACK, I missed that.
