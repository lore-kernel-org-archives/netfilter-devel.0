Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E706C64E7B
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Dec 2020 12:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 997C32084C
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Dec 2020 12:50:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390887AbgLAMuE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Dec 2020 07:50:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389374AbgLAMuD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Dec 2020 07:50:03 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77599C0613CF
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Dec 2020 04:49:23 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 25121)
        id D891C5890D0E6; Tue,  1 Dec 2020 13:49:21 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id D51DC60D7219F;
        Tue,  1 Dec 2020 13:49:21 +0100 (CET)
Date:   Tue, 1 Dec 2020 13:49:21 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: use actual socket sk for REJECT action
In-Reply-To: <20201201084955.GC26468@salvia>
Message-ID: <3s5q4s74-7q3n-69po-1q26-5qr718np489@vanv.qr>
References: <20201121111151.15960-1-jengelh@inai.de> <20201201084955.GC26468@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tuesday 2020-12-01 09:49, Pablo Neira Ayuso wrote:

>Hi Jan,
>
>On Sat, Nov 21, 2020 at 12:11:51PM +0100, Jan Engelhardt wrote:
>> True to the message of commit v5.10-rc1-105-g46d6c5ae953c, _do_
>> actually make use of state->sk when possible, such as in the REJECT
>> modules.
>
>Could you rebase and resend a v2? I think this patch is clashing with
>recent updates to add REJECT support for ingress.

I observed no conflict when attempting the rebase command, either onto
 cb7fb043e69a (/pub/scm/linux/kernel/git/netdev/net-next.git #master) or
 f7583f02a538 (/pub/scm/linux/kernel/git/pablo/nf-next #master)
