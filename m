Return-Path: <SRS0=Uzq3=CF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98324C433DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Aug 2020 19:00:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6701C20786
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Aug 2020 19:00:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armitage.org.uk header.i=@armitage.org.uk header.b="Y2q2scmp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgH0TAh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Aug 2020 15:00:37 -0400
Received: from host-92-27-6-192.static.as13285.net ([92.27.6.192]:51824 "EHLO
        nabal.armitage.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728088AbgH0S71 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Aug 2020 14:59:27 -0400
X-Greylist: delayed 11835 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Aug 2020 14:59:25 EDT
Received: from localhost (nabal.armitage.org.uk [127.0.0.1])
        by nabal.armitage.org.uk (Postfix) with ESMTP id 0E8F62E34D9;
        Thu, 27 Aug 2020 19:59:23 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=armitage.org.uk;
         h=content-transfer-encoding:mime-version:user-agent
        :content-type:content-type:references:in-reply-to:date:date:from
        :from:subject:subject:message-id:received; s=20200110; t=
        1598554760; x=1599418761; bh=Gy+0G5hXGxql9WZB/CKcqRtE5tTm40SLax5
        mt+CzYeE=; b=Y2q2scmpl0Y58aJGiY1dPV7cz/12NfTmQGCYti+NSizccjZ16xP
        cNgde7MBlok8aeDnBZUazlM4+p6PK2yJd5KlPvUKy5t5F3/ncbIE7Ky5XrOz9jyr
        qk1UfDgtGXJhF/+dC6/CmUqSEa/37lqfM/E1gkNGFctAyfVqdyVmdVLo=
X-Virus-Scanned: amavisd-new at armitage.org.uk
Received: from samson.armitage.org.uk (samson.armitage.org.uk [IPv6:2001:470:69dd:35::210])
        by nabal.armitage.org.uk (Postfix) with ESMTPSA id 815D02E34CF;
        Thu, 27 Aug 2020 19:59:19 +0100 (BST)
Message-ID: <1c9c80c0645a79d93ccecdc7ecceb22e15bba5df.camel@armitage.org.uk>
Subject: Re: [PATCH] netfilter: nftables: fix documentation for dup statement
From:   Quentin Armitage <quentin@armitage.org.uk>
To:     Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Date:   Thu, 27 Aug 2020 19:59:19 +0100
In-Reply-To: <20200827174015.GC7319@breakpoint.cc>
References: <f9bc9e191b03728fe233ca7a75fdc40ede0fde8e.camel@armitage.org.uk>
         <20200827170203.GM23632@orbyte.nwl.cc>
         <20200827174015.GC7319@breakpoint.cc>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 2020-08-27 at 19:40 +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Hi,
> > 
> > On Thu, Aug 27, 2020 at 04:42:00PM +0100, Quentin Armitage wrote:
> > > The dup statement requires an address, and the device is optional,
> > > not the other way round.
> > > 
> > > Signed-off-by: Quentin Armitage <
> > > quentin@armitage.org.uk
> > > >
> > > ---
> > >  doc/statements.txt | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/doc/statements.txt b/doc/statements.txt
> > > index 9155f286..835db087 100644
> > > --- a/doc/statements.txt
> > > +++ b/doc/statements.txt
> > > @@ -648,7 +648,7 @@ The dup statement is used to duplicate a packet and
> > > send the
> > > copy to a different
> > >  destination.
> > >  
> > >  [verse]
> > > -*dup to* 'device'
> > > +*dup to* 'address'
> > >  *dup to* 'address' *device* 'device'
> > >  
> > >  .Dup statement values
> > 
> > The examples are wrong, too. I wonder if this is really just a mistake
> > and all three examples given (including the "advanced" usage using a
> > map) are just wrong or if 'dup' actually was meant to support
> > duplicating to a device in mirror port fashion.
> 
> Right, 'dup to eth0' can be used in the netdev ingress hook.
> 
> For dup from ipv4/ipv6 families the address is needed.

So it seems the valid options are:
*dup to* 'device'			# netdev ingress hook only
*dup to* 'address'  			# ipv4/ipv6 only
*dup to* 'address' *device* 'device'	# ipv4/ipv6 only

From a user perspective being able to specify "dup to 'device'" is something
that is useful to be able to specify. I am now using:
  dup to ip[6] daddr device 'device'
but it seems to me that having to specify "to ip[6] daddr" is unnecessary.

So far as I can see, it would be quite straightforward to allow "dup to
'device'" to be specified and for nft to handle it with an implied "to ip[6]
addr". I am happy to produce a patch to do this if it would be helpful.

I am also happy to submit a revised patch for statements.txt if that would be
useful.

Quentin Armitage

