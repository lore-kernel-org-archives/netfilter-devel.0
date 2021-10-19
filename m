Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FBB9C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Oct 2021 10:41:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81B77610E7
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Oct 2021 10:41:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235292AbhJSKnT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Oct 2021 06:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235286AbhJSKnS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Oct 2021 06:43:18 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E961CC06161C
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Oct 2021 03:41:05 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mcmYK-0004ED-0o; Tue, 19 Oct 2021 12:41:04 +0200
Date:   Tue, 19 Oct 2021 12:41:03 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] main: _exit() if setuid
Message-ID: <20211019104103.GC28644@breakpoint.cc>
References: <20211016225623.155790-1-fw@strlen.de>
 <YWyhCwDYq8zYd8Lm@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWyhCwDYq8zYd8Lm@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, Oct 17, 2021 at 12:56:23AM +0200, Florian Westphal wrote:
> > Apparently some people think its a good idea to make nft setuid so
> > unrivilged users can change settings.
> > 
> > "nft -f /etc/shadow" is just one example of why this is a bad idea.
> > Disable this.  Do not print anything, fd cannot be trusted.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  src/main.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/src/main.c b/src/main.c
> > index 21096fc7398b..5847fc4ad514 100644
> > --- a/src/main.c
> > +++ b/src/main.c
> > @@ -363,6 +363,10 @@ int main(int argc, char * const *argv)
> >  	unsigned int len;
> >  	int i, val, rc;
> >  
> > +	/* nftables cannot be used with setuid in a safe way. */
> > +	if (getuid() != geteuid())
> > +		_exit(111);
> 
> Applications using libnftables would still face the same issue.

Yes, but there is an off-chance they know what they are doing.
