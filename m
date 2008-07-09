From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ULOGD PATCH] rework, fill MAC address in ULOG for ethernet.
Date: Wed, 09 Jul 2008 23:18:30 +0200
Message-ID: <48752B26.3010404@trash.net>
References: <486B88F4.7060704@trash.net> <1215554219-13763-1-git-send-email-eric@inl.fr> <487497F4.8070004@netfilter.org> <48749899.7070505@trash.net> <48749AF1.60900@netfilter.org> <48749CAA.3030306@trash.net> <20080709210454.GA4461@ghlodit.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Eric Leblond <eric@inl.fr>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39737 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbYGIVSh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:18:37 -0400
In-Reply-To: <20080709210454.GA4461@ghlodit.inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> I think the proposed patch is a best effort work. It should be enough
> for most users as ethernet headers are the more common. But I agree, we
> can't have a full working solution with ULOG.
> 
> I will try to find some time to rework my NFLOG patch to see if it is
> possible to cleanly send the source and destination hardware address to
> userspace via NFLOG.
> 
> IMHO, this patch is not harmfull and will help some people. It may worth
> to be push in the git tree.

> +			ulogd_log(ULOGD_DEBUG, "Unknown mac_len (%d), "
> +					"rejecting packet", pkt->mac_len);

This comment made me believe that it would break header
printing for non-ethernet packets. If that is not true,
I have no objections.
