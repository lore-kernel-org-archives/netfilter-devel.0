Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 306D0C43218
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 20:48:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04EBB2084F
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 20:48:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbfDZUsA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 16:48:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:38310 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725966AbfDZUsA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 16:48:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 174BFACB7;
        Fri, 26 Apr 2019 20:47:59 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 68C2CE0143; Fri, 26 Apr 2019 22:47:58 +0200 (CEST)
Date:   Fri, 26 Apr 2019 22:47:58 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH RFC 4/4] netfilter: nf_tables: add netlink description
Message-ID: <20190426204758.GK26549@unicorn.suse.cz>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c7f81c740a5670abfbc6249b58bbd318a24eaec.camel@sipsolutions.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Apr 26, 2019 at 09:14:43PM +0200, Johannes Berg wrote:
> Yeah, ok. Each object you had is basically its own policy. I just
> *removed* having a separate policy for each command in generic netlink,
> as  ;-)

But that only affects genetlink users who let genetlink validate and
parse messages for them. Those validating/parsing the messages
themselves can still have different policy (and completely different set
of attributes) for each command.

Michal
