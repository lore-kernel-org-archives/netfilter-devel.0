From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC v3 0/2] per-netns sysctl for br_netfilter
Date: Thu, 29 May 2014 14:28:59 +0200
Message-ID: <20140529122859.GA5412@localhost>
References: <20140512140706.GA22082@macbook.localnet>
 <5370F772.3050004@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	Patrick McHardy <kaber@trash.net>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
To: Vasily Averin <vvs@parallels.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42201 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546AbaE2M3P (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 May 2014 08:29:15 -0400
Content-Disposition: inline
In-Reply-To: <5370F772.3050004@parallels.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Vasily,

On Mon, May 12, 2014 at 08:31:46PM +0400, Vasily Averin wrote:
> Dear Patrick,
> thank you for feedback.
> Frankly speaking I still badly understand how it's better to split this patch set.
> Finally I've decided to combine v2 patches to 2 parts (1-8 and 9-11). 
> Could you please explain how to it better?
> 
> This patch set enables per network namespace managemnt for br_netfiltes sysctls,
> it allows to enable processing br-nf-call hooks in ones network namespaces 
> and keep it disabled in another ones.
> 
> v3: patches are merged into more large chunks 
> v2: removed extra overhead for CONFIG_SYSCTL=n

Any further concern with this v3 patchset? Thanks.
