Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06751C433DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 10:32:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A60A96198A
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 10:32:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbhCaKcU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 06:32:20 -0400
Received: from relay.sw.ru ([185.231.240.75]:50584 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234701AbhCaKb5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 06:31:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:Mime-Version:Message-Id:Subject:From
        :Date; bh=PgCrVx2Eg9b7GYK4+2M8Vs3zXciEnazErd4A6A8oCoM=; b=b7ukb3Ow8jxi7Wo7dUw
        E6bU1A0PBEOLpL9K2YkwZwMeebAf0uo171ZjOAsMC6b2tRz/4GS0LWyspZcb3As3mu9Dr3XAvQd9Z
        nABveyN4GEtYIbRfFmpKeTPQceFqxXlI0xJvmZ8aEXj1IcWQUYJfDprQT8DEfuzNE9MZekQOclM=
Received: from [192.168.15.221] (helo=alexm-laptop.lan)
        by relay.sw.ru with smtp (Exim 4.94)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1lRY8h-000CSK-SP; Wed, 31 Mar 2021 13:31:55 +0300
Date:   Wed, 31 Mar 2021 13:31:55 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>
Subject: Re: [iptables PATCH v2 2/2] extensions: libxt_conntrack: print
 xlate status as set
Message-Id: <20210331133155.24a1ef3872e4e1873c66338c@virtuozzo.com>
In-Reply-To: <20210330182136.GC17285@breakpoint.cc>
References: <20210330141524.747259-1-alexander.mikhalitsyn@virtuozzo.com>
        <20210330141524.747259-2-alexander.mikhalitsyn@virtuozzo.com>
        <20210330173900.GB17285@breakpoint.cc>
        <DB7PR08MB357940C3E31AFB983408FFE7E87D9@DB7PR08MB3579.eurprd08.prod.outlook.com>
        <20210330182136.GC17285@breakpoint.cc>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi, Florian,

On Tue, 30 Mar 2021 20:21:36 +0200
Florian Westphal <fw@strlen.de> wrote:

> Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> wrote:
> > Hi Florian,
> > 
> > Thank you!
> > So, I need to fix nft and support that syntax?
> 
> That would be one way.  The other is to fix the != translation
> to use binary logic (the example i gave).

I've prepared 3rd version of patchset.

> 
> > Do I understand correctly, that the same issue for state flags like
> > "established, related, ..."?
> 
> Yes and no.  A connection can't be both established and related at the
> same time, so anonymous set will work in that case.

Got it.

Thank you very much!

Regards,
Alex
