From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 0/3] netfilter: connlimit: scalability improvements
Date: Mon, 17 Mar 2014 12:44:44 +0100
Message-ID: <20140317114444.GA9555@localhost>
References: <1394664591-21843-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37680 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932672AbaCQLow (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Mar 2014 07:44:52 -0400
Content-Disposition: inline
In-Reply-To: <1394664591-21843-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 12, 2014 at 11:49:48PM +0100, Florian Westphal wrote:
> Resending the last three patches of the set; I have addressed
> the comments I've received.  See individual patches on whats
> changed vs v1.
> 
> I've done a brief re-rest with 2-hrs of synflooding and
> nf_conntrack_max=2000000 plus conntrack -F every 10 seconds and did not
> encounter any issues.
> 
> I am copying the original v1 cover letter below.
> 
> The connlimit match suffers from two problems:
> 
> - lock contention when multiple cpus invoke the match function
> - algorithmic complexity: on average the connlimit match will need to
>   examine NUMBER_OF_CONNTRACKS % HASH_BUCKET (always 256) connections
>   as the match will test for every connection assigned to the same bucked
>   as the new one wheter the conntrack is still active.
> 
> This patch set tries to solve both issues.

Series applied, thanks Florian.
