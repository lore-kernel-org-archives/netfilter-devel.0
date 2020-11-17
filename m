Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F18C4C2D0E4
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Nov 2020 08:07:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97139217A0
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Nov 2020 08:07:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgKQIGt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Nov 2020 03:06:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727030AbgKQIGt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Nov 2020 03:06:49 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DD0C0613CF
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2020 00:06:49 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 7349058727084; Tue, 17 Nov 2020 09:06:46 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 6FD4060C22EC1;
        Tue, 17 Nov 2020 09:06:46 +0100 (CET)
Date:   Tue, 17 Nov 2020 09:06:46 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Philip Prindeville <philipp_subx@redfish-solutions.com>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: Issues w/ db-ip country database
In-Reply-To: <8B419AF6-031F-4F6A-A3FB-3118780F6119@redfish-solutions.com>
Message-ID: <2qp4q17-pqpo-2q0-24r0-q466sro3pp44@vanv.qr>
References: <8B419AF6-031F-4F6A-A3FB-3118780F6119@redfish-solutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Tuesday 2020-11-17 04:36, Philip Prindeville wrote:
>
>Many known blocks owned by Chinanet for instance, don’t show up as /11 or /13
>networks, but as dozens of /23 networks instead in China, the US, Japan, and
>Canada. Clearly not correct.

Do you have some sample netnumbers so that we can look at it from our side?
