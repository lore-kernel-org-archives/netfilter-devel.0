From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] src: check if the set name is too long
Date: Fri, 21 Mar 2014 10:56:34 +0100
Message-ID: <20140321095634.GA12165@localhost>
References: <1395332403-3823-1-git-send-email-giuseppelng@gmail.com>
 <532BE93F.6010400@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Giuseppe Longo <giuseppelng@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56677 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755061AbaCUJ4o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Mar 2014 05:56:44 -0400
Content-Disposition: inline
In-Reply-To: <532BE93F.6010400@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 21, 2014 at 09:24:47AM +0200, Tomasz Bursztyka wrote:
> Hi Giuseppe,
> 
> >checks if the name of set is larger than 15 chars
> 
> You mean 16 characters
> 
> Btw, have you tested 16 chars length name: when listing the set back,
> is such name cut to 15 chars?
> 
> That sounds to be an issue from kernel side, at least looking quickly,
> I could not find any code shortening this in  libmnl, libnftnl or nftables.

The kernel is indeed limiting the name length in nf_tables_newset, see
nla_strcpy there.
