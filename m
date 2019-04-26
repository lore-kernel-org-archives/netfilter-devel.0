Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC73C43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 20:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6221A2084F
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 20:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfDZUv3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 16:51:29 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:42550 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfDZUv3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 16:51:29 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hK7oc-000218-Ty; Fri, 26 Apr 2019 22:51:27 +0200
Message-ID: <cfcf08c7e29ce3dfc3209245c60beb021e7f421e.camel@sipsolutions.net>
Subject: Re: [PATCH RFC 4/4] netfilter: nf_tables: add netlink description
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Date:   Fri, 26 Apr 2019 22:51:25 +0200
In-Reply-To: <20190426204758.GK26549@unicorn.suse.cz>
References: <20180207013713.2432-1-pablo@netfilter.org>
         <20180207013713.2432-5-pablo@netfilter.org>
         <f882918e408247a4e0e8d0007feead5bbf311003.camel@sipsolutions.net>
         <20190411192647.xsnhno6gcf5fen5u@salvia>
         <beb5d59393d8dbf466b0d728ca85842afb6cd039.camel@sipsolutions.net>
         <20190426164252.a2yxjxf3thotrqu3@salvia>
         <8a754fb122da038b540583708315e5782beefbd2.camel@sipsolutions.net>
         <5d2a03325b4121c2f91bc78bb0e44c3592af4220.camel@sipsolutions.net>
         <20190426180430.h5h7lqivx2qufuyi@salvia>
         <0c7f81c740a5670abfbc6249b58bbd318a24eaec.camel@sipsolutions.net>
         <20190426204758.GK26549@unicorn.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 2019-04-26 at 22:47 +0200, Michal Kubecek wrote:
> On Fri, Apr 26, 2019 at 09:14:43PM +0200, Johannes Berg wrote:
> > Yeah, ok. Each object you had is basically its own policy. I just
> > *removed* having a separate policy for each command in generic netlink,
> > as  ;-)
> 
> But that only affects genetlink users who let genetlink validate and
> parse messages for them. Those validating/parsing the messages
> themselves can still have different policy (and completely different set
> of attributes) for each command.

Sure. I already argued elsewhere though that you should only have one
policy for each set of attributes, but if you do in fact have different
attributes then that's perfectly valid.

Not sure whether I think it all that reasonable, since you then burden
userspace with having to know even more intricate detail and not being
able to share code well between commands, but hey :-)

johannes

