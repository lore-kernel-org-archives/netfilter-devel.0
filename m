From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/7] extensions: remove MIRROR
Date: Thu, 19 Feb 2015 16:27:40 +0100
Message-ID: <20150219152740.GB3410@salvia>
References: <1424351483-27617-1-git-send-email-fw@strlen.de>
 <1424351483-27617-2-git-send-email-fw@strlen.de>
 <alpine.LSU.2.11.1502191428000.27892@nerf60.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53020 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbbBSPYR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Feb 2015 10:24:17 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1502191428000.27892@nerf60.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 19, 2015 at 02:28:53PM +0100, Jan Engelhardt wrote:
> On Thursday 2015-02-19 14:11, Florian Westphal wrote:
> 
> >removed from the kernel back in 2003.
> 
> Last time I remember, Pablo wanted to keep this. Because modern iptables 
> may still be used with overly old preexisting kernels.

No objections from my side to get rid of these old extensions.
