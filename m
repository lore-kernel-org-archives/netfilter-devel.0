Return-Path: <SRS0=IzLZ=RZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C5D9C43381
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Mar 2019 12:55:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77C9B21873
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Mar 2019 12:55:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732635AbfCVMz5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Mar 2019 08:55:57 -0400
Received: from a3.inai.de ([88.198.85.195]:36994 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732119AbfCVMz4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Mar 2019 08:55:56 -0400
Received: by a3.inai.de (Postfix, from userid 25121)
        id 6D12F3B8BC2E; Fri, 22 Mar 2019 13:55:54 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 5EFFF3BB696B;
        Fri, 22 Mar 2019 13:55:54 +0100 (CET)
Date:   Fri, 22 Mar 2019 13:55:54 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
cc:     netfilter-devel@vger.kernel.org, eric@regit.org,
        Chris Boot <bootc@debian.org>, myon@debian.org
Subject: Re: [PATCH] build: adjust configure for postgresql 11
In-Reply-To: <a377fcf6-8940-34de-b1d6-0de07f10e046@netfilter.org>
Message-ID: <nycvar.YFH.7.76.1903221354530.7557@n3.vanv.qr>
References: <20190321115456.24137-1-jengelh@inai.de> <a377fcf6-8940-34de-b1d6-0de07f10e046@netfilter.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Friday 2019-03-22 10:04, Arturo Borrero Gonzalez wrote:
>On 3/21/19 12:54 PM, Jan Engelhardt wrote:
>> At least in openSUSE, PostgreSQL 11 no longer ships the pg_config
>> program. Instead, there is has been a pkg-config file around for a
>> while (also in pg10), so make use of that, by default.
>
>Debian ships pg_config. In fact, the same package libpq-dev [0] contains both
>things:
>
>* /usr/bin/pg_config
>* /usr/lib/x86_64-linux-gnu/pkgconfig/libpq.pc

pg_config is regarded for the server part only, says the respective maintainer.
https://bugzilla.opensuse.org/show_bug.cgi?id=1120035#c1
