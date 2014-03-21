From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [nft PATCH] src: check if the set name is too long
Date: Fri, 21 Mar 2014 12:43:57 +0200
Message-ID: <532C17ED.3060509@linux.intel.com>
References: <1395332403-3823-1-git-send-email-giuseppelng@gmail.com>	<532BE93F.6010400@linux.intel.com> <CAG7Tj4qscXJbuMU+vFo10jFmk1Reu2x+C9WMDaFQskN1t3UZ2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Giuseppe Longo <giuseppelng@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Wei Dai <daiweix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:47336 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964951AbaCUKn7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Mar 2014 06:43:59 -0400
In-Reply-To: <CAG7Tj4qscXJbuMU+vFo10jFmk1Reu2x+C9WMDaFQskN1t3UZ2w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Wei,

I don't know how you ended up finding a relation between nftables API 
and genetlink, but it's bogus.

The set name has a fixed size of 16 characters (IFNAMSIZ), not 15.
And its netlink policy has nothing to do with genetlink.

Have a look at include/net/netfilter/nf_tables.h in kernel tree, there 
struct  nft_set is declared.
Its netlink related policy is in net/netfilter/nf_tables_api.c 
(nft_set_policy)

Br,

Tomasz
