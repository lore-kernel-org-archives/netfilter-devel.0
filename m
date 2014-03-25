From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [iptables 0/3] ebtables patchset
Date: Tue, 25 Mar 2014 13:37:06 +0200
Message-ID: <53316A62.7020501@linux.intel.com>
References: <1394220805-18021-1-git-send-email-giuseppelng@gmail.com> <531D98DF.5070507@linux.intel.com> <20140324150956.GA32546@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Giuseppe Longo <giuseppelng@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:12472 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695AbaCYLiV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2014 07:38:21 -0400
In-Reply-To: <20140324150956.GA32546@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> I think you
> have to do something similar to what Patrick did with nft_reject, by
> adding a specific flavour of nft_meta for the bridge family.

In case of nft_meta, it would mean quite much code change,
since most of the keys are valid also for NFPROTO_BRIDGE.
Or maybe I miss something. (I don't know if it's proper to register a 
second expr
in the same nft_meta.c, dedicated to bridge)

Wouldn't it be easier if I just check ctx->afi->family to be NFPROTO_BRIDGE
in nft_meta_init  if the given key is one of the bridge related?

At evaluation, I can still check pkt->ops->pf as well.

Does the logic sound relevant?

Tomasz
