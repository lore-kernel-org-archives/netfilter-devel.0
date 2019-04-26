Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AA57C43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 11:56:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CF8A206C1
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 11:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbfDZL4c (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 07:56:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:56314 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725877AbfDZL4b (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 07:56:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 511C2AD21;
        Fri, 26 Apr 2019 11:56:30 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id B46D1E0143; Fri, 26 Apr 2019 13:56:29 +0200 (CEST)
Date:   Fri, 26 Apr 2019 13:56:29 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/3] make nla_nest_start() add NLA_F_NESTED flag
Message-ID: <20190426115629.GH26549@unicorn.suse.cz>
References: <cover.1556269635.git.mkubecek@suse.cz>
 <1dcb87486a96785e3b9e6f337392aa904d977a0d.camel@sipsolutions.net>
 <20190426111954.GG26549@unicorn.suse.cz>
 <a3626aeca20280e8253b575fe72309b2009474a8.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3626aeca20280e8253b575fe72309b2009474a8.camel@sipsolutions.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Apr 26, 2019 at 01:23:46PM +0200, Johannes Berg wrote:
> On Fri, 2019-04-26 at 13:19 +0200, Michal Kubecek wrote:
> > On Fri, Apr 26, 2019 at 11:24:15AM +0200, Johannes Berg wrote:
> > > On Fri, 2019-04-26 at 09:13 +0000, Michal Kubecek wrote:
> > > 
> > > > Another observation was that even if NLA_F_NESTED flag was introduced in
> > > > 2007, only few netlink based interfaces set it in kernel generated messages
> > > > and even many recently added APIs omit it. That is unfortunate as without
> > > > the flag, message parsers not familiar with attribute semantics cannot
> > > > recognize nested attributes and do not see message structure; this affects
> > > > e.g. wireshark dissector or mnl_nlmsg_fprintf() from libmnl.
> > > 
> > > Indeed.
> > > 
> > > I wonder if we should also (start) enforcing that the userspace sender
> > > side sets this, if the policy is strict?
> > 
> > I suppose we should, at least the part that attribute with NLA_NESTED
> > policy has NLA_F_NESTED flag. I'm not so sure about the opposite (i.e.
> > that attributes with other policies do not have the flag) as when I was
> > checking where kernel accesses nlattr::nla_type directly rather than
> > with nla_type(), I stumbled upon an attribute NL80211_ATTR_VENDOR_DATA
> > which has policy NLA_BINARY but is sometimes a nest, AFAICS.
> 
> I guess anyway we can only do it for *new* things, not really for all
> existing attributes.

Right... but what I wanted to say is that if there is already (at least)
one attribute which may or may not be a nest, depending on a context, we
should expect there may be also new attributes like that in the future.

Michal
