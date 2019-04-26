Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E84DC43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 12:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20A4F2084F
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 12:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbfDZMRv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 08:17:51 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:57788 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfDZMRv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 08:17:51 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hJznT-0004MU-OZ; Fri, 26 Apr 2019 14:17:44 +0200
Message-ID: <18db9ac8b398b215e3523dd5b79c7f86e21864ce.camel@sipsolutions.net>
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
Date:   Fri, 26 Apr 2019 14:17:42 +0200
In-Reply-To: <20190426115629.GH26549@unicorn.suse.cz>
References: <cover.1556269635.git.mkubecek@suse.cz>
         <1dcb87486a96785e3b9e6f337392aa904d977a0d.camel@sipsolutions.net>
         <20190426111954.GG26549@unicorn.suse.cz>
         <a3626aeca20280e8253b575fe72309b2009474a8.camel@sipsolutions.net>
         <20190426115629.GH26549@unicorn.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 2019-04-26 at 13:56 +0200, Michal Kubecek wrote:

> > > I suppose we should, at least the part that attribute with NLA_NESTED
> > > policy has NLA_F_NESTED flag. I'm not so sure about the opposite (i.e.
> > > that attributes with other policies do not have the flag) as when I was
> > > checking where kernel accesses nlattr::nla_type directly rather than
> > > with nla_type(), I stumbled upon an attribute NL80211_ATTR_VENDOR_DATA
> > > which has policy NLA_BINARY but is sometimes a nest, AFAICS.
> > 
> > I guess anyway we can only do it for *new* things, not really for all
> > existing attributes.
> 
> Right... but what I wanted to say is that if there is already (at least)
> one attribute which may or may not be a nest, depending on a context, we
> should expect there may be also new attributes like that in the future.

Yeah, but we can handle that as we see it?

I just reposted my strict validation series - maybe we can right now, as
it's not released yet, quickly add an NL_VALIDATED_NESTED_FLAG or so to
it?

Do you want to take a stab at that? I have to go now, but I could check
in the next few days.

johannes

