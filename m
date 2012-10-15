From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] Netfilter/IPVS updates for stable 3.0 onwards
Date: Mon, 15 Oct 2012 16:39:19 -0700
Message-ID: <20121015233919.GA667@kroah.com>
References: <1349950539-12491-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57950 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab2JOXjY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:39:24 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so5404198pbb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Oct 2012 16:39:23 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1349950539-12491-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 11, 2012 at 12:15:33PM +0200, pablo@netfilter.org wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Hi!
> 
> The following patchset aims to reduce the Netfilter debt with stable 3.0 and
> onwards.
> 
> The selected six patches are:
> 
> 07153c6 netfilter: nf_ct_ipv4: packets with wrong ihl are invalid
> 3f509c6 netfilter: nf_nat_sip: fix incorrect handling of EBUSY for RTCP expectation
> f22eb25 netfilter: nf_nat_sip: fix via header translation with multiple parameters
> 2614f86 netfilter: nf_ct_expect: fix possible access to uninitialized timer
> 9e33ce4 ipvs: fix oops on NAT reply in br_nf context
> 82e6bfe netfilter: xt_limit: have r->cost != 0 case work [REQUIRES 7a909ac netfilter: limit, hashlimit: avoid duplicated inline]
> 
> I have read stable_rules.txt and I consider they match the requirements.

All now applied to 3.4 and 3.0 trees, where applicable.

greg k-h
