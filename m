From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] nfnetlink_queue: add security context informationg
Date: Fri, 12 Jun 2015 15:02:40 +0200
Message-ID: <20150612130240.GA29551@salvia>
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
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	=?utf-8?B?UmFmYcWC?= Krypa <r.krypa@samsung.com>
To: Roman Kubiak <r.kubiak@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35781 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150AbbFLM5Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Jun 2015 08:57:24 -0400
Content-Disposition: inline
In-Reply-To: <557AB559.1000001@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 12, 2015 at 12:32:57PM +0200, Roman Kubiak wrote:
> This way works and seems sensible (i tested it)
> 
> a fixed patch below
> 
> -- cut here
> 
> This patch adds an additional attribute when sending
> packet information via netlink in netfilter_queue module.
> It will send additional security context data, so that
> userspace applications can verify this context against
> their own security databases.

Please, send the corresponding userspace updates for this. Thanks.
