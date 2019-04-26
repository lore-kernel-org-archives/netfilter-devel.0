Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 604B8C43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 16:45:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31CE020679
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 16:45:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbfDZQpN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 12:45:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:53506 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726049AbfDZQpN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 12:45:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 02AA5ACB1;
        Fri, 26 Apr 2019 16:45:11 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 3B8B5E0143; Fri, 26 Apr 2019 18:45:11 +0200 (CEST)
Date:   Fri, 26 Apr 2019 18:45:11 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/3] make nla_nest_start() add NLA_F_NESTED flag
Message-ID: <20190426164511.GJ26549@unicorn.suse.cz>
References: <cover.1556269635.git.mkubecek@suse.cz>
 <1dcb87486a96785e3b9e6f337392aa904d977a0d.camel@sipsolutions.net>
 <20190426111954.GG26549@unicorn.suse.cz>
 <a3626aeca20280e8253b575fe72309b2009474a8.camel@sipsolutions.net>
 <20190426115629.GH26549@unicorn.suse.cz>
 <18db9ac8b398b215e3523dd5b79c7f86e21864ce.camel@sipsolutions.net>
 <47f6daf9-2d14-1566-8ed1-fb5d4dd57bf8@gmail.com>
 <9d9f2e4465ce80593b3a5d08e9948304bdcefbf4.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d9f2e4465ce80593b3a5d08e9948304bdcefbf4.camel@sipsolutions.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Apr 26, 2019 at 06:02:38PM +0200, Johannes Berg wrote:
> On Fri, 2019-04-26 at 09:00 -0600, David Ahern wrote:
> > 
> > What is a valid use case for an attribute sometimes being a nest and
> > sometimes not? That seems really weird to me (ie., wrong). They should
> > be 2 separate attributes even if the backend processing is the same.
> 
> Yeah, well, in the mentioned case - NL80211_ATTR_VENDOR_DATA - we
> basically have something that each driver (sometimes each operation that
> uses it) decides what it means, and most drivers like proper netlink
> attributes so have nested stuff there. Sometimes not, though in Prague
> we decided we should make that documented by requiring a nested policy
> and (perhaps, TBD) using something like an ERR_PTR() for "I really want
> this to be binary".
> 
> I think as far as this particular attribute is concerned the ship has
> sailed, but in the future I'd probably advocate having two attributes.

Or put the binary into the nest which would also make it easier to
add more data or switch to structured information later.

Michal
