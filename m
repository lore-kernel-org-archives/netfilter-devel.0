From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_queue: add NFQA_SKB_CSUM_NOTVERIFIED info
 flag
Date: Sat, 29 Jun 2013 14:45:19 +0200
Message-ID: <20130629124519.GA24256@localhost>
References: <20130526204826.GC6578@breakpoint.cc>
 <1369601289-12743-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56484 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab3F2Mpa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Jun 2013 08:45:30 -0400
Content-Disposition: inline
In-Reply-To: <1369601289-12743-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Sun, May 26, 2013 at 10:48:09PM +0200, Florian Westphal wrote:
> The common case is that TCP/IP checksums have already been
> verified, e.g. by hardware (rx checksum offload), or conntrack.
> 
> Userspace can use this flag to determine when the checksum
> has not been validated yet.
> 
> If the flag is set, this doesn't necessarily mean that the packet has
> an invalid checksum, e.g. if NIC doesn't support rx checksum.
> 
> Userspace that sucessfully enabled NFQA_CFG_F_GSO queue feature flag can
> infer that IP/TCP checksum has already been validated if either the
> SKB_INFO attribute is not present or the NFQA_SKB_CSUM_NOTVERIFIED
> flag is unset.

I have applied this patch to nf-next, thanks.
