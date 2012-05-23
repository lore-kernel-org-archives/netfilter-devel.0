From: Krishna Kumar2 <krkumar2@in.ibm.com>
Subject: Re: [v3 PATCH 1/1] netfilter: Add fail-open support.
Date: Wed, 23 May 2012 19:41:10 +0530
Message-ID: <OF70AD8B07.E2E1E116-ON65257A07.004DB723-65257A07.004DFAE8@in.ibm.com>
References: <20120522121037.880.44203.sendpatchset@localhost.localdomain> <20120522121048.880.22605.sendpatchset@localhost.localdomain> <20120522143858.GB14029@breakpoint.cc> <OF2AAA0ADB.EE750110-ON65257A06.005144D9-65257A07.002538D4@in.ibm.com> <20120523075456.GC11818@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Florian Westphal <fw@strlen.de>, kaber@trash.net,
	netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	sri@us.ibm.com, Sulakshan Vajipayajula <svajipay@in.ibm.com>,
	vivk@us.ibm.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:35886 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239Ab2EWOS5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 May 2012 10:18:57 -0400
Received: from /spool/local
	by e28smtp06.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <krkumar2@in.ibm.com>;
	Wed, 23 May 2012 19:44:43 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q4NEBme839387342
	for <netfilter-devel@vger.kernel.org>; Wed, 23 May 2012 19:41:48 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q4NJfPZd020723
	for <netfilter-devel@vger.kernel.org>; Thu, 24 May 2012 01:11:26 +0530
In-Reply-To: <20120523075456.GC11818@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote on 05/23/2012 01:24:56 PM:

>
> > Maybe this needs a check for ESRCH and return back to hook_slow
> > to work correctly? If this is the case, I can submit a patch to
> > fix this, and piggy-back ESRCH for fail-open too.
>
> The idea for queue-bypass was to free the original (gso) skb
> if we were able to queue at least one packet, i.e. the original
> skb only continues traversal if queue bypassing is enabled
> and no single segment could be queued.
>
> If it is a requirement for you that any remaining segments
> that could not be queued continue traversal, then yes,
> the existing code won't work for you.

Yes, all segments need to be processed for this option. I will
check if it is possible to do any code-sharing, and post the
patches tomorrow with your other feedback incorporated.

Thanks for your review,
- KK

