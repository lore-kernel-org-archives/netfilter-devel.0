From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2 3/3] netfilter: nf_conntrack: add efficient
 mark to zone mapping
Date: Wed, 15 Jul 2015 19:50:56 +0200
Message-ID: <20150715175056.GA7436@salvia>
References: <cover.1436574843.git.daniel@iogearbox.net>
 <8b1e8907e8dd9a51f2e40b39cd5f5c2b0eae94fd.1436574843.git.daniel@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59108 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbbGORpO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jul 2015 13:45:14 -0400
Content-Disposition: inline
In-Reply-To: <8b1e8907e8dd9a51f2e40b39cd5f5c2b0eae94fd.1436574843.git.daniel@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 11, 2015 at 03:14:07AM +0200, Daniel Borkmann wrote:
> This work adds the possibility of deriving the zone id from the skb->mark
> field in a scalable manner. This allows for having only a single template
> serving 100s .. 1000s of different zones, for example, instead of needing
> to have one match for each zone as an extra CT jump target. Note that we'd
> need to have this information attached to the template as at the time when
> we're trying to lookup a possible ct object, we already need to know zone
> information for a possible match when going into __nf_conntrack_find_get().
> This work provides a minimal implementation for a possible mapping.

I think connmark is a better place for this feature, given that the
zone is a ct extension. Moreover, I guess it will not take long until
someone sends us a patch to perform some bitwise operation to only
fetch some of the skb->mark bits into the zone.
