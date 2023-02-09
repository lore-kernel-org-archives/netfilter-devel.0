Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA76AC61DA4
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Feb 2023 16:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjBIQKF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Feb 2023 11:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbjBIQKE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Feb 2023 11:10:04 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FEBD272A;
        Thu,  9 Feb 2023 08:10:00 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 7A3FF58726698; Thu,  9 Feb 2023 17:09:58 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 77FC060C04850;
        Thu,  9 Feb 2023 17:09:58 +0100 (CET)
Date:   Thu, 9 Feb 2023 17:09:58 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Florian Westphal <fw@strlen.de>
cc:     Igor Artemiev <Igor.A.Artemiev@mcst.ru>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [lvc-project] [PATCH] netfilter: xt_recent: Fix attempt to update
 removed entry
In-Reply-To: <20230209150733.GA17303@breakpoint.cc>
Message-ID: <6152n4q7-1ssr-521p-786s-71q4q9731370@vanv.qr>
References: <20230209125831.2674811-1-Igor.A.Artemiev@mcst.ru> <20230209150733.GA17303@breakpoint.cc>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thursday 2023-02-09 16:07, Florian Westphal wrote:

>Igor Artemiev <Igor.A.Artemiev@mcst.ru> wrote:
>> When both --remove and --update flag are specified, there's a code
>> path at which the entry to be updated is removed beforehand,
>> that leads to kernel crash. Update entry, if --remove flag
>> don't specified.
>> 
>> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>
>How did you manage to do this?  --update and --remove are supposed
>to be mutually exclusive.

I suppose the exclusivity is only checked at the iptables command-line
and neverwhere else.
