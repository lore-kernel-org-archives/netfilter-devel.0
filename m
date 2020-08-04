Return-Path: <SRS0=6lPY=BO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B900FC433E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 12:23:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90C1722BED
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 12:23:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="Gck++3QJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgHDMXa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Aug 2020 08:23:30 -0400
Received: from mx1.riseup.net ([198.252.153.129]:34146 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725864AbgHDMWa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Aug 2020 08:22:30 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4BLYYX5W5nzDsXn;
        Tue,  4 Aug 2020 05:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1596543184; bh=sxsdp8XKCFZ5TZ9GkzfagnS18JgDMEie/7kPOXSqsjs=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Gck++3QJAD3lxYgnkMvV0MzSpRHckbI9BzNgaZevYXgERFwo3lVOF2CvYrGO83qqE
         f2AlwKnvjjCO5fDISP+E1kcvX0+uQel4Gni46TZblp5Yx6LZ1TVgaEstm65VNFaK4p
         LDq6lEDDNJ4833UIRPLc59htDLkkwAsoQwVUwsNo=
X-Riseup-User-ID: 4BC24CAE8B18062EBD038941945670BB7113963E2F14A63154A6BDEE54B48C57
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 4BLYYW5W8zzJmm0;
        Tue,  4 Aug 2020 05:13:03 -0700 (PDT)
Subject: Re: [PATCH nft v4] src: enable json echo output when reading native
 syntax
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, erig@erig.me, phil@nwl.cc
References: <20200731104944.21384-1-guigom@riseup.net>
 <20200804103846.58872-1-guigom@riseup.net> <20200804110552.GA18345@salvia>
From:   "Jose M. Guisado" <guigom@riseup.net>
Message-ID: <12943ed7-2836-0201-73f4-7dc8ed0d91cb@riseup.net>
Date:   Tue, 4 Aug 2020 14:13:01 +0200
MIME-Version: 1.0
In-Reply-To: <20200804110552.GA18345@salvia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo, sorry about the formatting issues.

One thing about your suggestion:

On 4/8/20 13:05, Pablo Neira Ayuso wrote:
> if (!ctx->json_root)
>                  return;

Checking uniquely for the absence of json_root is not enough as 
json_echo may have been initialized. In essence, the case the patch is 
fixing is when json_root is null but json_echo is not, to denote that we 
want json echo output but have not read json from input.

In addition, v5 will contain a check for json_echo initialization inside 
monitor.c to avoid re-initializing nft->json_echo when the callback is 
built again, this happens when reading multiple times from a mnl socket 
(see mnl.c:433 inside mnl_batch_talk).

Regards.
