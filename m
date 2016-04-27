From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] evaluate: better error reporting in too long sets
 names
Date: Wed, 27 Apr 2016 19:37:13 +0200
Message-ID: <20160427173713.GA12894@salvia>
References: <146115978018.25287.16460508385150502285.stgit@nfdev2.cica.es>
 <20160427171419.GA7625@salvia>
 <alpine.DEB.2.10.1604271929480.24314@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44777 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbcD0RhW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Apr 2016 13:37:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 7BE75E83B0
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 19:37:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6F90C6447D
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 19:37:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 63DACAD81
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 19:37:18 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1604271929480.24314@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 27, 2016 at 07:36:38PM +0200, Jozsef Kadlecsik wrote:
> On Wed, 27 Apr 2016, Pablo Neira Ayuso wrote:
> 
> > On Wed, Apr 20, 2016 at 03:43:00PM +0200, Arturo Borrero Gonzalez wrote:
> > > Currently, if we choose a set name larger than allowed, the error message is:
> > >  Error: Could not process rule: Numerical result out of range
> > > 
> > > Let's inform the user with a better error message.
> > > 
> > > We can discuss later if length of set names should be increased, but I think
> > > this better error reporting is necessary right now to avoid headaches to users.
> > 
> > /* The max length of strings including NUL: set and type identifiers */
> > #define IPSET_MAXNAMELEN        32
> > 
> > I would like that we get the same length as ipset, this should make it
> > easier for people to migrate.
> 
> I think it's all right if set names are longer in nftables. That won't 
> cause incompatibilites, unless someone wants to move from nftables to 
> ipset.

Currently in nftables we have 16 bytes, so we're smaller than ipset.
