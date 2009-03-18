From: Patrick McHardy <kaber@trash.net>
Subject: Re: ctnetlink: remove remaining module refcount usage
Date: Wed, 18 Mar 2009 17:31:33 +0100
Message-ID: <49C121E5.8010809@trash.net>
References: <1237390923-3122-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45378 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbZCRQbh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Mar 2009 12:31:37 -0400
In-Reply-To: <1237390923-3122-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal wrote:
> Hello list,
> 
> The following (small) patch converts the remaining module refcounting
> in conntrack_netlink to RCU.
> 
> First patch does the conversion, 2nd one removes
> nf_ct_l4proto_find_get/put (there are no more in-tree users).

Both patches applied, thanks Florian.
