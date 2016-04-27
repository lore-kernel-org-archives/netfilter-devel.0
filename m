From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] evaluate: better error reporting in too long sets
 names
Date: Wed, 27 Apr 2016 19:14:19 +0200
Message-ID: <20160427171419.GA7625@salvia>
References: <146115978018.25287.16460508385150502285.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40894 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbcD0ROj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Apr 2016 13:14:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 5FA3BE83A4
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 19:14:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4609BA865
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 19:14:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7DA61AD81
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 19:14:35 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <146115978018.25287.16460508385150502285.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 20, 2016 at 03:43:00PM +0200, Arturo Borrero Gonzalez wrote:
> Currently, if we choose a set name larger than allowed, the error message is:
>  Error: Could not process rule: Numerical result out of range
> 
> Let's inform the user with a better error message.
> 
> We can discuss later if length of set names should be increased, but I think
> this better error reporting is necessary right now to avoid headaches to users.

/* The max length of strings including NUL: set and type identifiers */
#define IPSET_MAXNAMELEN        32

I would like that we get the same length as ipset, this should make it
easier for people to migrate.

This would require a bit of work though since the interface name size
is limited by the register size. Not much a problem, but it would
require a bit of code adjustments from the kernel.

So let me postpone this userspace check.
