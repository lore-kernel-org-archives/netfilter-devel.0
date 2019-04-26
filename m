Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8293EC43218
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 11:24:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53F0C206A3
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 11:24:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbfDZLX4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 07:23:56 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:56896 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfDZLXz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 07:23:55 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hJyxH-0002uu-8G; Fri, 26 Apr 2019 13:23:47 +0200
Message-ID: <a3626aeca20280e8253b575fe72309b2009474a8.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 0/3] make nla_nest_start() add NLA_F_NESTED flag
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Fri, 26 Apr 2019 13:23:46 +0200
In-Reply-To: <20190426111954.GG26549@unicorn.suse.cz>
References: <cover.1556269635.git.mkubecek@suse.cz>
         <1dcb87486a96785e3b9e6f337392aa904d977a0d.camel@sipsolutions.net>
         <20190426111954.GG26549@unicorn.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 2019-04-26 at 13:19 +0200, Michal Kubecek wrote:
> On Fri, Apr 26, 2019 at 11:24:15AM +0200, Johannes Berg wrote:
> > On Fri, 2019-04-26 at 09:13 +0000, Michal Kubecek wrote:
> > 
> > > Another observation was that even if NLA_F_NESTED flag was introduced in
> > > 2007, only few netlink based interfaces set it in kernel generated messages
> > > and even many recently added APIs omit it. That is unfortunate as without
> > > the flag, message parsers not familiar with attribute semantics cannot
> > > recognize nested attributes and do not see message structure; this affects
> > > e.g. wireshark dissector or mnl_nlmsg_fprintf() from libmnl.
> > 
> > Indeed.
> > 
> > I wonder if we should also (start) enforcing that the userspace sender
> > side sets this, if the policy is strict?
> 
> I suppose we should, at least the part that attribute with NLA_NESTED
> policy has NLA_F_NESTED flag. I'm not so sure about the opposite (i.e.
> that attributes with other policies do not have the flag) as when I was
> checking where kernel accesses nlattr::nla_type directly rather than
> with nla_type(), I stumbled upon an attribute NL80211_ATTR_VENDOR_DATA
> which has policy NLA_BINARY but is sometimes a nest, AFAICS.

I guess anyway we can only do it for *new* things, not really for all
existing attributes.

Regarding that attribute - I guess we'd have to come up with a policy
flag saying "may or may not be nested" (if it was a new one) or so?

johannes

