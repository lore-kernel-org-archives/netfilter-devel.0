Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4CA0C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Mar 2022 12:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241944AbiCJMVb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Mar 2022 07:21:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233962AbiCJMVb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Mar 2022 07:21:31 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6142C129BA3
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2022 04:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pPaq6JFkBXGGXhW51KHbHJhxO0RZHiT5B5fz04kLBaE=; b=qShvU7QCFPZcD5eHrDDn6q7Mp1
        Kf3olKxSu/kc4XqEL5WYwJn3EE4Ka3tizX2tcXHJS2KCIRlXyQEur3v6upwAPHusa0uVKIuTfjYWw
        E0Z/eZMKD2LA5uV8UqbfNUIBDkUlmvkTznBzqIAbD22+FY5inxp8wUXrlF2hQJWbWMl5y0gy1zbVD
        hoqms/n2vS6PllPfheyOkzAcMhu9asKSipbJ58/ezisifGWxFzPwnT77og+S83PGoAEozQEIdxv6n
        4kUqOMDIhVXQQFy70yAUQWTf5wbCOEKOgLDNlunU1xcuPlaYaUC/AFnpNE7Kj6994fzAY1dZr5g/E
        L05CRn9g==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nSHmO-0000tG-8y; Thu, 10 Mar 2022 13:20:28 +0100
Date:   Thu, 10 Mar 2022 13:20:28 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 3/4] xshared: Prefer xtables_chain_protos lookup
 over getprotoent
Message-ID: <YintDFxH4sLpnAoE@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220302151807.12185-1-phil@nwl.cc>
 <20220302151807.12185-4-phil@nwl.cc>
 <20220310121155.GF26501@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310121155.GF26501@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 10, 2022 at 01:11:55PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > When dumping a large ruleset, common protocol matches such as for TCP
> > port number significantly slow down rule printing due to repeated calls
> > for getprotobynumber(). The latter does not involve any caching, so
> > /etc/protocols is consulted over and over again.
> 
> > As a simple countermeasure, make functions converting between proto
> > number and name prefer the built-in list of "well-known" protocols. This
> > is not a perfect solution, repeated rules for protocol names libxtables
> > does not cache (e.g. igmp or dccp) will still be slow. Implementing
> > getprotoent() result caching could solve this.
> 
> Hmm, I think we could just extend xtables_chain_protos[].

Statically, i.e. add more entries based on "usual" /etc/protocols
contents or dynamically from getprotoent() results?

> Anyway, this looks safe to me, so
> 
> Acked-by: Florian Westphal <fw@strlen.de>

Thanks!
