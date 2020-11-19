Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,URI_HEX autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E248CC63777
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Nov 2020 22:07:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 824C52168B
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Nov 2020 22:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgKSWHr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Nov 2020 17:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbgKSWHr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Nov 2020 17:07:47 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52221C0613CF;
        Thu, 19 Nov 2020 14:07:47 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 25121)
        id D738B589BBA0C; Thu, 19 Nov 2020 23:07:45 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id D34C060F323A8;
        Thu, 19 Nov 2020 23:07:45 +0100 (CET)
Date:   Thu, 19 Nov 2020 23:07:45 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [ANNOUNCE] ipset 7.8 released
In-Reply-To: <alpine.DEB.2.23.453.2011192237290.19567@blackhole.kfki.hu>
Message-ID: <83oq5412-o0sq-5q31-s7o5-s0q28s12844@vanv.qr>
References: <alpine.DEB.2.23.453.2011192141150.19567@blackhole.kfki.hu> <45rqn0n5-5385-o997-rn9q-os784nqrn9p@vanv.qr> <alpine.DEB.2.23.453.2011192237290.19567@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thursday 2020-11-19 22:46, Jozsef Kadlecsik wrote:

>Hi Jan,
>
>On Thu, 19 Nov 2020, Jan Engelhardt wrote:
>
>> LIBVERSION changed from 14:0:1 (ipset 7.6) to 14:1:2,
>> producing libipset.so.13 (7.6) and now libipset.so.12
>> 
>> That seems incorrect! It should have been
>> - 14:0:1 (no changes)
>> - 15:0:2 (compatible changes)
>> - 15:0:0 (incompatible changes)
>
>Oh, my. It should be 15:0:2 (compatible changes). I dunno how many times I 
>can mix it up, this numbering scheme is simply alien to my brain wiring.

If in doubt, always use :0:0 --- and make a mental note of exactly the 
:0:0 requirement in Make_global.am. :-)

Distros can always rebuild transitively. They have to do that anyway for 
things like /usr/lib64/libbfd-2.35.0.20200915-1.so (with a date, it 
could change daily anyway). But recovering from a backjumping lib...
