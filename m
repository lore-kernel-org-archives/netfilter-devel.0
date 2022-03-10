Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34F68C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Mar 2022 13:57:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242607AbiCJN6q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Mar 2022 08:58:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242632AbiCJN6m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Mar 2022 08:58:42 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA818AE57
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2022 05:57:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TS51mQikYikOMUx5CgY3Zp89cNyygSiXIJ/AD+ov3hI=; b=jW+hAfWu9J8g0T6c268CBkBtIj
        P6drs20B2UsK9qWGJn2F+0LDZz3Fy18FC1Qe3udKaEglDU1lBVDMAs/oakOYR/ACjt6aE8nsGqcAw
        zBn/kUk3ZYZ7Vd5EwokLkNp4jm3oCC1sf0C6x14NlwFy5zU0ZPrTtjPwZUzaqupdrmbU1uqCSnTHp
        BjKP/rZAYb1wsyJiY9umsxZuAR3xD3IsqG1a/g3IrKdiUGMY2d7hsMNyAVssi0wFBG5NMt2dOJoHo
        SVIHaCHd4e7UuCqcr07aOckNcW37UcxLrwWnb6QPyn5sTtsD9R6u8Jo+wmMAuu2WJfRosIE/f550/
        hcYmu6cg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nSJIG-0001pt-La; Thu, 10 Mar 2022 14:57:28 +0100
Date:   Thu, 10 Mar 2022 14:57:28 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables RFC 2/2] libxtables: Boost rule target checks by
 announcing chain names
Message-ID: <YioDyBnNiJ0y846C@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220304131944.30801-1-phil@nwl.cc>
 <20220304131944.30801-3-phil@nwl.cc>
 <20220310122157.GB13772@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310122157.GB13772@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 10, 2022 at 01:21:57PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > This is kind of a double-edged blade: the obvious downside is that
> > *tables-restore won't detect user-defined chain name and extension
> > clashes anymore. The upside is a tremendous performance improvement
> > restoring large rulesets. The same crooked ruleset as mentioned in
> > earlier patches (50k chains, 130k rules of which 90k jump to a chain)
> > yields these numbers:
> > 
> > variant	 unoptimized	non-targets cache	announced chains
> > ----------------------------------------------------------------
> > legacy   1m12s		37s			2.5s
> > nft      1m35s		53s			8s
> 
> I think the benefits outweight the possible issues.
> 
> > Note that iptables-legacy-restore allows the clashes already as long as
> > the name does not match a standard target, but with this patch it stops
> > warning about it.
> 
> Hmm.  That seems fixable by refusing the announce in the clash case?

When parsing a chain line, iptables-restore does not know there is a
clash because this series effectively disables that check. Due to the
non-targets hash, any chain name is looked up (as target) only once
anyway, so keeping that check in iptables-restore yields the same
performance as without the annotate.

> > iptables-nft-restore does not care at all, even allows
> > adding a chain named 'ACCEPT' (and rules can't reach it because '-j
> > ACCEPT' translates to a native nftables verdict). The latter is a bug by
> > itself.
> 
> Agree, thats a bug, it should not allow users to do that.

ACK, I'll find a fix. In legacy, libiptc (TC_CREATE_CHAIN) does it, so
an nft-specific one it will be.

Thanks, Phil
