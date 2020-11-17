Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28AF2C2D0E4
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Nov 2020 19:20:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBEF424248
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Nov 2020 19:20:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgKQTUd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Nov 2020 14:20:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgKQTUd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Nov 2020 14:20:33 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543FBC0613CF
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2020 11:20:33 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 25121)
        id B223660E12ECA; Tue, 17 Nov 2020 20:20:31 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id B13A260E12EC7;
        Tue, 17 Nov 2020 20:20:31 +0100 (CET)
Date:   Tue, 17 Nov 2020 20:20:31 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Philip Prindeville <philipp_subx@redfish-solutions.com>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: Issues w/ db-ip country database
In-Reply-To: <B6D36DF0-178A-4985-AB85-4BEE2AAD9116@redfish-solutions.com>
Message-ID: <548ron6o-rq26-725-rqp4-r0p6n83r36r@vanv.qr>
References: <8B419AF6-031F-4F6A-A3FB-3118780F6119@redfish-solutions.com> <2qp4q17-pqpo-2q0-24r0-q466sro3pp44@vanv.qr> <B6D36DF0-178A-4985-AB85-4BEE2AAD9116@redfish-solutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Tuesday 2020-11-17 19:08, Philip Prindeville wrote:
>>> Many known blocks owned by Chinanet for instance, don’t show up as /11 or /13
>>> networks, but as dozens of /23 networks instead in China, the US, Japan, and
>>> Canada. Clearly not correct.
>
>183.128.0.0/11 is supposedly a single block of Chinanet, but the database
>shows it as being 329 subnets (164 supposedly in the US), again mostly /23’s
>and /22’s:
>183.136.192.0,183.136.193.99,CN
>183.136.193.100,183.136.193.255,US

100 is not "nicely divisible" along a bit boundary, that's already a giveaway
that something is atypical.
Maybe it's a set of VPN endpoints (into China) for external 
companies registered with MIIT/PSB or something.


>212.174.0.0/15 supposedly is a single block of TurkTelecom, but the database
>shows it as being 296 subnets, mostly /23’s.

and to add icing, WHOIS has four entries for it.
212.174.0.0/17 212.174.128.0/17 212.175.0.0/17 212.175.128.0/17
