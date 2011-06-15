From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/2] conntrack: permit updating only a part of the ctmark
Date: Wed, 15 Jun 2011 14:47:37 +0200
Message-ID: <4DF8A9E9.8060508@netfilter.org>
References: <1308140020-13487-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54477 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832Ab1FOMrx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jun 2011 08:47:53 -0400
In-Reply-To: <1308140020-13487-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 15/06/11 14:13, Florian Westphal wrote:
> Hello Pablo,
> 
> here are two patches for conntrack(8).
> 
> I want to alter the upper 8 bits of the conntrack mark while keeping
> the rest intact.  At the moment it is only possible to specifiy
> an absolute value, so i've extended --mark to optionally handle
> a mask argument.  Its possible to either filter by mark (e.g.
> list conntracks with a particular mark bit set) or to update
> parts of the mark.
> 
> The 2nd patch is not absolutely needed, but it speeds up operation
> when only a couple of conntracks are affected by the modification.

I like them both, I've applied them.

Would you send me another patch for the qa/testsuite/ to include some
test to check that --mark works with absolute value and masks?

Thank you.
