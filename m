From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2 libnetfilter_conntrack] zero value handling of mark
 and zone
Date: Tue, 17 Jun 2014 18:40:21 +0200
Message-ID: <20140617164021.GA31101@breakpoint.cc>
References: <20140617120405.GA24712@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:36407 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964872AbaFQQkX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:40:23 -0400
Content-Disposition: inline
In-Reply-To: <20140617120405.GA24712@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ken-ichirou MATSUZAWA <chamaken@gmail.com> wrote:
> This patch enables comparison of 0 value with mark and zone since
> both CTA_MARK and CTA_ZONE are not set in case of its value is 0.
> These changes has been done in cmp_meta() and its own cmp function
> as Florian pointed out.

Looks good to me.

I'll apply this soon if there are no other objections.
