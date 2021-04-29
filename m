Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98264C433ED
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 09:11:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 602EB6144E
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 09:11:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbhD2JMD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 05:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbhD2JMC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 05:12:02 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB54C06138B
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Apr 2021 02:11:16 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id C11A258726480; Thu, 29 Apr 2021 11:11:13 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id BCDA2619D34FB;
        Thu, 29 Apr 2021 11:11:13 +0200 (CEST)
Date:   Thu, 29 Apr 2021 11:11:13 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
cc:     Netfilter Development <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnetfilter_queue v2] build: doc: `make distcheck` passes
 with doxygen enabled
In-Reply-To: <20210428235927.GA1962@smallstar.local.net>
Message-ID: <4n301p68-non1-n72p-77n1-oo1n6n28s3q1@vanv.qr>
References: <s6o3s8n-8486-r468-728s-4384736oqq@vanv.qr> <20210422093544.5460-1-duncan_roe@optusnet.com.au> <20210428235927.GA1962@smallstar.local.net>
User-Agent: Alpine 2.24 (LSU 510 2020-10-10)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thursday 2021-04-29 01:59, Duncan Roe wrote:

>Hi Jan,
>
>Are you satisfied with the v2 patch?

Acked-by: Jan Engelhardt <jengelh@inai.de>
