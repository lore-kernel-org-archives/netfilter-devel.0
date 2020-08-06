Return-Path: <SRS0=eBSQ=BQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E8C2C47431
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Aug 2020 11:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C599221E2
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Aug 2020 11:05:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbgHFING (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Aug 2020 04:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbgHFINF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Aug 2020 04:13:05 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE3CC061574
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Aug 2020 01:13:05 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 6271D587567AE; Thu,  6 Aug 2020 10:13:02 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 5CF3060D308C4;
        Thu,  6 Aug 2020 10:13:02 +0200 (CEST)
Date:   Thu, 6 Aug 2020 10:13:02 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Amish <anon.amish@gmail.com>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: xtables-addon official website changed from sourceforge to
 inai.de?
In-Reply-To: <a763c01e-e2cc-bd00-b4d9-f0a77c041d24@gmail.com>
Message-ID: <nycvar.YFH.7.77.849.2008061010130.9472@n3.vanv.qr>
References: <2634a5e8-9eba-1c00-8d59-7ad24a4af803@gmail.com> <nycvar.YFH.7.77.849.2008060912350.9330@n3.vanv.qr> <a763c01e-e2cc-bd00-b4d9-f0a77c041d24@gmail.com>
User-Agent: Alpine 2.22 (LSU 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Thursday 2020-08-06 09:48, Amish wrote:
> On 06/08/20 12:44 pm, Jan Engelhardt wrote:
>> On Thursday 2020-08-06 07:28, Amish wrote:
>>> I see no mention of shifting the website on netfilter-devel mailing list.
>> https://www.spinics.net/lists/netfilter-devel/msg68255.html
>
> Ah ok! Thank you very much.
> The announcement was kind of hidden under another thread as a reply.
> I think new release announcement should be started as separate thread.

xtables-addons releases are generally not list-announced to begin with.
