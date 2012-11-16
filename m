From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/3] netfilter: add connlabel conntrack extension
Date: Fri, 16 Nov 2012 11:02:57 +0100
Message-ID: <20121116100256.GA25964@1984>
References: <1352994915-3859-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53113 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab2KPKDE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2012 05:03:04 -0500
Content-Disposition: inline
In-Reply-To: <1352994915-3859-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Thu, Nov 15, 2012 at 04:55:12PM +0100, Florian Westphal wrote:
> The following three patches add the connlabel extension, plus
> ctnetlink support.
> 
> Connlabels are similar to connmarks, except labels are bit-based; i.e.
> all labels may be attached to a flow at the same time.
> 
> Up to 128 labels are supported at this time.
> 
> Mapping of bit-identifier to label name is done in userspace.
> 
> The extension is enabled at run-time once "-m connlabel" netfilter rules
> are added.
> 
> The '128-labels' limit could be increased, but we need to check that
> extension array won't wrap, when all conntrack extensions are being
> used (offsets are stored in 'u8' array).
> 
> Changes since RFCv2:
> - make it a variable-size extension and remove dynamic
>   reallocation of the label array
> - add ctnetlink support for receiving/setting labels
> - limit to 128 instead of 1k labels due to limited extension
>   space (128 is more than enough for now, so this is no problem).

At a quick glance I like this round, you got this simplified :-).

My only concern is that (if I'm not missing anything) it
inconditionally add the extension even if we don't need it. I can
think of two choices for this:

a) enable this via some /proc interface (which is something we have
tried to avoid in the past, although it's been used for cases in which
we had no choice, eg. conntrack helper compatibility behaviour).

b) use the CT target, which you were not convinced last time we
discussed this.
