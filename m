From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH next v2] libnetfilter_conntrack: don't ignore
 ATTR_CONNLABELS
Date: Mon, 20 May 2013 21:26:48 +0200
Message-ID: <20130520192648.GB16412@breakpoint.cc>
References: <1368696643-6731-1-git-send-email-Afschin.Hormozdiary@sophos.com>
 <2544e4f5-3cdf-4e2a-99f9-722ce7f344f3@de-wie-exch3b.green.sophos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Afschin Hormozdiary <Afschin.Hormozdiary@sophos.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:36064 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757785Ab3ETT0x (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 May 2013 15:26:53 -0400
Content-Disposition: inline
In-Reply-To: <2544e4f5-3cdf-4e2a-99f9-722ce7f344f3@de-wie-exch3b.green.sophos>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Afschin Hormozdiary <Afschin.Hormozdiary@sophos.com> wrote:
> The libnfnetlink based backend 'build.c' currently ignores
> ATTR_CONNLABELS and ATTR_CONNLABELS_MASK.

Yes, I forgot to add the glue for libnfnetlink backend.

> Add function to set CTA_LABELS and CTA_LABELS_MASK
> if required.

Applied this to -next branch, thanks.
