From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 3/6] netfilter: nf_tables: disable old tracing if
 listener is present
Date: Thu, 26 Nov 2015 00:56:37 +0100
Message-ID: <20151125235637.GO23215@breakpoint.cc>
References: <20151124151542.GA20972@breakpoint.cc>
 <20151124152649.GK14478@macbook.localdomain>
 <20151124153550.GC20972@breakpoint.cc>
 <20151124154241.GL14478@macbook.localdomain>
 <20151125150640.GE18449@macbook.localdomain>
 <20151125162424.GJ23215@breakpoint.cc>
 <20151125164629.GB30712@macbook.localdomain>
 <20151125173240.GG30712@macbook.localdomain>
 <20151125222710.GK23215@breakpoint.cc>
 <20151125234223.GG20093@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35111 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751198AbbKYX4k (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 18:56:40 -0500
Content-Disposition: inline
In-Reply-To: <20151125234223.GG20093@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> Even nicer would be to include the dummy VLAN header in the payload itself
> and hide the offloading details, but that we can also do in userspace of
> course.

Will do that.
