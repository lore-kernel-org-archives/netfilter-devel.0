Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C92EC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Oct 2021 11:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86EC160FD8
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Oct 2021 11:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235466AbhJSL5F (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Oct 2021 07:57:05 -0400
Received: from mail.netfilter.org ([217.70.188.207]:57566 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235431AbhJSL5E (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Oct 2021 07:57:04 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8454A60056;
        Tue, 19 Oct 2021 13:53:08 +0200 (CEST)
Date:   Tue, 19 Oct 2021 13:54:45 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] main: _exit() if setuid
Message-ID: <YW6yBaF+ELt1nkr+@salvia>
References: <20211016225623.155790-1-fw@strlen.de>
 <YWyhCwDYq8zYd8Lm@salvia>
 <20211019104103.GC28644@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211019104103.GC28644@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 19, 2021 at 12:41:03PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Sun, Oct 17, 2021 at 12:56:23AM +0200, Florian Westphal wrote:
> > > Apparently some people think its a good idea to make nft setuid so
> > > unrivilged users can change settings.
> > > 
> > > "nft -f /etc/shadow" is just one example of why this is a bad idea.
> > > Disable this.  Do not print anything, fd cannot be trusted.
> > > 
> > > Signed-off-by: Florian Westphal <fw@strlen.de>
> > > ---
> > >  src/main.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/src/main.c b/src/main.c
> > > index 21096fc7398b..5847fc4ad514 100644
> > > --- a/src/main.c
> > > +++ b/src/main.c
> > > @@ -363,6 +363,10 @@ int main(int argc, char * const *argv)
> > >  	unsigned int len;
> > >  	int i, val, rc;
> > >  
> > > +	/* nftables cannot be used with setuid in a safe way. */
> > > +	if (getuid() != geteuid())
> > > +		_exit(111);
> > 
> > Applications using libnftables would still face the same issue.
> 
> Yes, but there is an off-chance they know what they are doing.

Sounds sensible, I'd suggest you document this in the commit before
pushing.
