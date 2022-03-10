Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DABEDC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Mar 2022 12:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242160AbiCJM4I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Mar 2022 07:56:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242188AbiCJM4C (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Mar 2022 07:56:02 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09D214A07B
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2022 04:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/+TUp2PWaEW/9KN8Xw38fRQvBtLE02gq6vjVy4dHRQQ=; b=OuZeExLT1PRHJv+50SGsLFxbG9
        e3G2WcOub7Nr+CqDlfe68B/VGhEmLsUmsTa2VLIjN7GMTKzOOrGx8We2i597G/z283A+rksU607f1
        K/bqL1Yd5Ss8JGhDziYpKHWyEd9tgdpF1AQnH0xmK7uXxblm95E9IR5tc94mGn40mJOqnFiQONz8m
        kBQePv+erqvkpyC+v0wwU9mau3xQQnQrHwmtu7NZhwqkjeFz1516xn9GBJD/BxacgKC5XggTcWoLV
        NtVm8QSmOSrW9bUjd2Kpv9Au8tGPON3cKGOftMjJE0TlQmvZKtw8Uw38U+SU1NG9WdWEzxomjCp0+
        i8CVh1mw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nSIJf-0001Bo-GF; Thu, 10 Mar 2022 13:54:51 +0100
Date:   Thu, 10 Mar 2022 13:54:51 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH 3/4] xshared: Prefer xtables_chain_protos lookup
 over getprotoent
Message-ID: <Yin1G7Vhe41BaTcY@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20220302151807.12185-1-phil@nwl.cc>
 <20220302151807.12185-4-phil@nwl.cc>
 <20220310121155.GF26501@breakpoint.cc>
 <YintDFxH4sLpnAoE@orbyte.nwl.cc>
 <20220310122303.GC13772@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310122303.GC13772@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

[restored Cc list]

On Thu, Mar 10, 2022 at 01:23:03PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > On Thu, Mar 10, 2022 at 01:11:55PM +0100, Florian Westphal wrote:
> > > Phil Sutter <phil@nwl.cc> wrote:
> > > > When dumping a large ruleset, common protocol matches such as for TCP
> > > > port number significantly slow down rule printing due to repeated calls
> > > > for getprotobynumber(). The latter does not involve any caching, so
> > > > /etc/protocols is consulted over and over again.
> > > 
> > > > As a simple countermeasure, make functions converting between proto
> > > > number and name prefer the built-in list of "well-known" protocols. This
> > > > is not a perfect solution, repeated rules for protocol names libxtables
> > > > does not cache (e.g. igmp or dccp) will still be slow. Implementing
> > > > getprotoent() result caching could solve this.
> > > 
> > > Hmm, I think we could just extend xtables_chain_protos[].
> > 
> > Statically, i.e. add more entries based on "usual" /etc/protocols
> > contents or dynamically from getprotoent() results?
> 
> I meant statically, I don't see why you'd need to do that for igmp or
> dccp (or any other well-known protocol for that matter).

I hesitated because we take users' ability to override the definitions.
Yet giving it another thought, you're right:

When translating name to number, it is very unlikely users would reuse
a common name ('tcp' for instance) for another protocol value. They'll
probably just add new ones.

In reverse direction, it is inconvenient at most: People may prefer
'ipv6-icmp' over 'icmpv6', but whatever name libxtables has stored will
at least parse OK later.

Thanks, Phil
