From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3] nfnetlink_queue: add security context information
Date: Fri, 12 Jun 2015 12:42:05 +0200
Message-ID: <20150612104205.GA31987@breakpoint.cc>
References: <55646731.9040803@samsung.com>
 <20150526130623.GD7817@breakpoint.cc>
 <5565A4D2.70701@samsung.com>
 <5565A6AA.90908@samsung.com>
 <20150527124957.GA19819@salvia>
 <557855B2.8030803@samsung.com>
 <20150610160541.GD7125@breakpoint.cc>
 <55798582.1040903@samsung.com>
 <20150611233757.GE7125@breakpoint.cc>
 <557AB559.1000001@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	=?utf-8?B?UmFmYcWC?= Krypa <r.krypa@samsung.com>
To: Roman Kubiak <r.kubiak@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52807 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750970AbbFLKmH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Jun 2015 06:42:07 -0400
Content-Disposition: inline
In-Reply-To: <557AB559.1000001@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Roman Kubiak <r.kubiak@samsung.com> wrote:
> This patch adds an additional attribute when sending
> packet information via netlink in netfilter_queue module.
> It will send additional security context data, so that
> userspace applications can verify this context against
> their own security databases.
> 
> Signed-off-by: Roman Kubiak <r.kubiak@samsung.com>

Looks good to me.

Acked-by: Florian Westphal <fw@strlen.de>
