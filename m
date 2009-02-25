From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Wed, 25 Feb 2009 06:52:21 +0100
Message-ID: <49A4DC95.8090708@trash.net>
References: <20090223101354.7104.45999.stgit@Decadence> <49A3FA4B.5000107@trash.net> <49A3FE90.50305@netfilter.org> <49A3FEE2.3000601@trash.net> <49A47F2B.6040704@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51993 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbZBYFwX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Feb 2009 00:52:23 -0500
In-Reply-To: <49A47F2B.6040704@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> The fact that you have to specify it for deletion still seems unnecesary
>> though. You would never have two rules differing only in the seed value
>> since that would mean the node is part of two clusters. So we might as
>> well move it to the end and ignore it in userspace. What do you think?
> 
> But the value has to be the same in all the cluster nodes, so how can it
> be set to ensure that it is the same value?

I only meant ignoring it on comparisons of course, just as we do
with all the private pointer stuff. Anyways, its not that important
and it in fact would be slightly different behaviour from what we
do in other cases, where we only ignore state. So perhaps not a good
idea after all.

>> In case you agree, I also think "secret" would be a more fitting name.
> 
> I can rename the field to "secret" in the structure or change the
> iptables cluster match option to be "--cluster-secret" instead of
> "--cluster-hash-seed" if you like.

Its more fitting in my opinion, but I don't really care.
