From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libmnl: security context retrieval in nf-queue example
Date: Tue, 16 Jun 2015 14:37:06 +0200
Message-ID: <20150616123706.GA32486@salvia>
References: <5565A4D2.70701@samsung.com>
 <5565A6AA.90908@samsung.com>
 <20150527124957.GA19819@salvia>
 <557855B2.8030803@samsung.com>
 <20150610160541.GD7125@breakpoint.cc>
 <55798582.1040903@samsung.com>
 <20150611233757.GE7125@breakpoint.cc>
 <557AB559.1000001@samsung.com>
 <20150612130240.GA29551@salvia>
 <558015A9.8060703@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	=?utf-8?B?UmFmYcWC?= Krypa <r.krypa@samsung.com>
To: Roman Kubiak <r.kubiak@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44196 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbbFPMbu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 08:31:50 -0400
Content-Disposition: inline
In-Reply-To: <558015A9.8060703@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 16, 2015 at 02:25:13PM +0200, Roman Kubiak wrote:
> This patch is an addition to "[PATCH v3] nfnetlink_queue: add security context information"
> It adds and example to libmnl that illustrates how to fetch security context.
> A corresponding patch was sent for libnetfilter_queue already.
> 
> -- cut here
> 
> This patch modifies the example program for nf-queue
> to demonstrate how to retriece security context information
> for queued packages. This can also be easily extended to
> retrieve other information supported by this subsystem.

This extension for the libmnl example is fine.

However, when we asked for changes, we actually mean that you enhance:

        libnetfilter_queue/src/nlmsg.c

to support this. Thanks.

