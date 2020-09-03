Return-Path: <SRS0=Qpa8=CM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4057BC433E2
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Sep 2020 08:15:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B9732145D
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Sep 2020 08:15:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=armitage.org.uk header.i=@armitage.org.uk header.b="P+pBDtPp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbgICIPS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Sep 2020 04:15:18 -0400
Received: from host-92-27-6-192.static.as13285.net ([92.27.6.192]:36668 "EHLO
        nabal.armitage.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728306AbgICIPP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Sep 2020 04:15:15 -0400
Received: from localhost (nabal.armitage.org.uk [127.0.0.1])
        by nabal.armitage.org.uk (Postfix) with ESMTP id 38E1D2E3583;
        Thu,  3 Sep 2020 09:15:12 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=armitage.org.uk;
         h=content-transfer-encoding:mime-version:user-agent
        :content-type:content-type:references:in-reply-to:date:date:from
        :from:subject:subject:message-id:received; s=20200110; t=
        1599120907; x=1599984908; bh=WYdWNbZcfGEgkzhHXOlzyIGuBSftfDEDOVq
        wx4msdmY=; b=P+pBDtPpsWWKu59Pi3qKFzpj58KbywoABPmZIdmk7ZOaUaFXek+
        XfAF7BNpsXZzFwjlIK6b57pIPwYcEkta4Il5bD5irMippMuUneP3djRrSDjltLjL
        +vSKSCNtIgswQvoFRACLg+Lv20l2x9mSqcKYzEvqzmkjunhacZ0Nxra0=
X-Virus-Scanned: amavisd-new at armitage.org.uk
Received: from samson.armitage.org.uk (samson.armitage.org.uk [IPv6:2001:470:69dd:35::210])
        by nabal.armitage.org.uk (Postfix) with ESMTPSA id 9873B2E34F0;
        Thu,  3 Sep 2020 09:15:06 +0100 (BST)
Message-ID: <76fa07e0671e26cf0d4464f14030df47d3368727.camel@armitage.org.uk>
Subject: Re: [PATCH] netfilter: nftables: fix documentation for dup statement
From:   Quentin Armitage <quentin@armitage.org.uk>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Date:   Thu, 03 Sep 2020 09:15:06 +0100
In-Reply-To: <20200831164906.GY23632@orbyte.nwl.cc>
References: <f9bc9e191b03728fe233ca7a75fdc40ede0fde8e.camel@armitage.org.uk>
         <20200827170203.GM23632@orbyte.nwl.cc>
         <20200827174015.GC7319@breakpoint.cc>
         <1c9c80c0645a79d93ccecdc7ecceb22e15bba5df.camel@armitage.org.uk>
         <20200831164906.GY23632@orbyte.nwl.cc>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Mon, 2020-08-31 at 18:49 +0200, Phil Sutter wrote:
> Hi Quentin,
> 
> On Thu, Aug 27, 2020 at 07:59:19PM +0100, Quentin Armitage wrote:
> > On Thu, 2020-08-27 at 19:40 +0200, Florian Westphal wrote:
> > > Phil Sutter <
> > > phil@nwl.cc
> > > > wrote:
> > > > Hi,
> > > > 
> > > > On Thu, Aug 27, 2020 at 04:42:00PM +0100, Quentin Armitage wrote:
> > > > > The dup statement requires an address, and the device is optional,
> > > > > not the other way round.
> > > > > 
> > > > > Signed-off-by: Quentin Armitage <
> > > > > quentin@armitage.org.uk
> > > > > 
> > > > > 
> > > > > ---
> > > > >  doc/statements.txt | 2 +-
> > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/doc/statements.txt b/doc/statements.txt
> > > > > index 9155f286..835db087 100644
> > > > > --- a/doc/statements.txt
> > > > > +++ b/doc/statements.txt
> > > > > @@ -648,7 +648,7 @@ The dup statement is used to duplicate a packet
> > > > > and
> > > > > send the
> > > > > copy to a different
> > > > >  destination.
> > > > >  
> > > > >  [verse]
> > > > > -*dup to* 'device'
> > > > > +*dup to* 'address'
> > > > >  *dup to* 'address' *device* 'device'
> > > > >  
> > > > >  .Dup statement values
> > > > 
> > > > The examples are wrong, too. I wonder if this is really just a mistake
> > > > and all three examples given (including the "advanced" usage using a
> > > > map) are just wrong or if 'dup' actually was meant to support
> > > > duplicating to a device in mirror port fashion.
> > > 
> > > Right, 'dup to eth0' can be used in the netdev ingress hook.
> > > 
> > > For dup from ipv4/ipv6 families the address is needed.
> > 
> > So it seems the valid options are:
> > *dup to* 'device'			# netdev ingress hook only
> > *dup to* 'address'  			# ipv4/ipv6 only
> > *dup to* 'address' *device* 'device'	# ipv4/ipv6 only
> > 
> > From a user perspective being able to specify "dup to 'device'" is something
> > that is useful to be able to specify. I am now using:
> >   dup to ip[6] daddr device 'device'
> > but it seems to me that having to specify "to ip[6] daddr" is unnecessary.
> 
> Oh, and that works? From reading nf_dup_ipv4.c, the kernel seems to
> perform a route lookup for the packet's daddr on given iface. Did you
> add an onlink route or something to make sure that succeeds?
> 
> Cheers, Phil

It is working for me, both with IPv4 and IPv6, and I suspect the reason is that
I am using this for multicast packets. In particular, I have a macvlan and I want to join multicast groups on the macvlan interface but I want the IGMP/MLD join group messages to be sent with the MAC address of the "parent" interface of the macvlan, and not the mac address of the macvlan itself.

The rules I am using are:
 map vmac_map {
	type iface_index : iface_index
	elements = { "macvlan0" : "eth0" }
 }

 ip protocol igmp dup to ip daddr device oif map @vmac_map drop
and
 icmpv6 type mld2-listener-report dup to ip6 daddr device oif map @vmac_map drop

With many thanks for your help,

Quentin

