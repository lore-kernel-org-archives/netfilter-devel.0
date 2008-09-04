From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 09/38] netns ct: per-netns conntrack hash
Date: Thu, 04 Sep 2008 18:31:06 +0200
Message-ID: <48C00D4A.9000808@trash.net>
References: <20080821220015.GI31136@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	containers@lists.linux-foundation.org
To: adobriyan@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33110 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbYIDQbI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Sep 2008 12:31:08 -0400
In-Reply-To: <20080821220015.GI31136@x200.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

adobriyan@gmail.com wrote:
> * make per-netns conntrack hash
> 
>   Other solution is to add ->ct_net pointer to tuplehashes and still has one
>   hash, I tried that it's ugly and requires more code deep down in protocol
>   modules et al.
> 
> * propagate netns pointer to where needed, e. g. to conntrack iterators.

Applied with more overly long line fixes.
