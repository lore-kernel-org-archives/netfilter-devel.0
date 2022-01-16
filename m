Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0220C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 16 Jan 2022 19:00:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236025AbiAPTA0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 16 Jan 2022 14:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235915AbiAPTAZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 16 Jan 2022 14:00:25 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE52BC061574
        for <netfilter-devel@vger.kernel.org>; Sun, 16 Jan 2022 11:00:25 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1n9AlI-0002Uh-US; Sun, 16 Jan 2022 20:00:21 +0100
Date:   Sun, 16 Jan 2022 20:00:20 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] nft-shared: support native tcp port delinearize
Message-ID: <20220116190020.GA28638@breakpoint.cc>
References: <20220115150316.14503-1-fw@strlen.de>
 <YeL2HLW+EpJPXII7@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeL2HLW+EpJPXII7@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > $ iptables-nft-save
> > -A INPUT -p tcp -m tcp --sport 12345
> > -A INPUT -p tcp -m tcp --sport 12345 --dport 6789
> > -A INPUT -p tcp -m tcp --sport 0:1023
> > -A INPUT -p tcp -m tcp --dport 1024:65535
> 
> You can probably use the range expression, it has been there already
> for quite some time and it is slightly more efficient than two cmp
> expressions. nft still uses cmp for ranges for backward compatibility
> reasons (range support is available since 4.9 and -stable 4.4 enters
> EOL next month apparently), it only uses range for tcp dport != 0-1023.

Thanks for the hint, this was broken indeed, I reworked this to handle
exsiting range handling via two cmp expressions.

range sounds good, will add support for it too.

> > This would allow to extend iptables-nft to prefer
> > native payload expressions for --sport,dport in the future.
> 
> Using the native payload for transport in the near future sounds a
> good idea to me.

Great, I will work on this once the reverse translation is working.
