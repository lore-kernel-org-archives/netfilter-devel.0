From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [patch] fix nla_policy_len to actually _iterate_ over
 the policy
Date: Mon, 28 Feb 2011 13:26:02 -0800
Message-ID: <20110228212602.GA9495@kroah.com>
References: <20110228203559.GD8906@barkeeper1-xen.linbit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org,
	Holger Eitzenberger <holger@eitzenberger.org>,
	stable@kernel.org
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:38199 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab1B1V00 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Feb 2011 16:26:26 -0500
Content-Disposition: inline
In-Reply-To: <20110228203559.GD8906@barkeeper1-xen.linbit>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 28, 2011 at 09:35:59PM +0100, Lars Ellenberg wrote:
> Currently nla_policy_len always returns n * NLA_HDRLEN:
> It loops, but does not advance it's iterator.
> NLA_UNSPEC == 0 does not contain a .len in any policy.
> 
> Trivially fixed by adding p++.
> 
> Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> 
> diff --git a/lib/nlattr.c b/lib/nlattr.c

Please read how to properly get patches into the stable kernel tree in
the file Documentation/stable_kernel_rules.txt (hint, randomly cc:ing
stable@kernel.org is NOT how to do it...)

thanks,

greg k-h
