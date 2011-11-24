From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/6] extensions: IPv6 NAT extensions
Date: Thu, 24 Nov 2011 15:41:06 +0100
Message-ID: <20111124144106.GA11178@1984>
References: <1322064750-26744-1-git-send-email-kaber@trash.net>
 <20111124110319.GA7832@1984>
 <4ECE2571.7090003@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, ulrich.weber@sophos.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49687 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756276Ab1KXOlM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Nov 2011 09:41:12 -0500
Content-Disposition: inline
In-Reply-To: <4ECE2571.7090003@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 24, 2011 at 12:07:29PM +0100, Patrick McHardy wrote:
> On 11/24/2011 12:03 PM, Pablo Neira Ayuso wrote:
> >On Wed, Nov 23, 2011 at 05:12:24PM +0100, kaber@trash.net wrote:
> >>The following patches contain the IPv6 NAT extensions for my IPv6
> >>NAT patchset posted on Monday. Nothing particulary interesting about
> >>the patches ...
> >Great Patrick.
> >
> >I can give you access to my tree (I didn't find time to request an
> >account to kernel.org again) so you can apply these patches to net-next
> >by yourself once they are done.
> 
> Me neither. I'm going to send an update for review first though,
> also Rusty had some suggestions I want to look into first.

Nice.

> What I do want to get into 3.2 though is the patch to export the
> nf_nat.h header. We currently have your version in the -rc, my
> patch renames the exported nf_nat_range to IPv4 specific names
> to we don't have to make up strange names for the address family
> independant struct. This of course needs to happen before the
> 3.2 release.

OK, send me a patch for this an I'll pass it to get it included in
3.2.

> >I expect to send updates for 3.2-rc this weekend. Then focus on
> >collecting patches for net-next.
> 
> I'll send an updated patchset tommorrow.

Thanks, I'll try to give them some testing during the weekend.
