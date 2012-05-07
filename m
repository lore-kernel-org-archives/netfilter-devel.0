From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC] [PATCH 0/4] netfilter: "fail-open" feature support for
 NFQUEUE
Date: Mon, 7 May 2012 16:52:28 +0200
Message-ID: <20120507145228.GC5015@breakpoint.cc>
References: <20120507060338.19528.29403.sendpatchset@localhost.localdomain>
 <20120507081029.GB5015@breakpoint.cc>
 <OF72EDDD93.E0BF0FC1-ON652579F7.002FC182-652579F7.004C26E2@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	sri@us.ibm.com, Sulakshan Vajipayajula <svajipay@in.ibm.com>,
	vivk@us.ibm.com
To: Krishna Kumar2 <krkumar2@in.ibm.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49724 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756467Ab2EGOwd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 May 2012 10:52:33 -0400
Content-Disposition: inline
In-Reply-To: <OF72EDDD93.E0BF0FC1-ON652579F7.002FC182-652579F7.004C26E2@in.ibm.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Krishna Kumar2 <krkumar2@in.ibm.com> wrote:
> Florian Westphal <fw@strlen.de> wrote on 05/07/2012 01:40:29 PM:
> > I think that exposing this feature as userspace-changeable via netlink
> > (eg. by adding "NFQA_CFG_FAILOPEN" attribute) rather than via ruleset
> > would make most sense, as only the application can know wheter it
> > can cope with missing packets.
> 
> Thanks for your review. With this change, is there any reason to
> modify xt_NFQ_info_v2's bypass field, since app can specify this
> option directly? I tested without this for now and it works.

I don't think so. If the netlink attribute works for you we should
leave xt_NFQUEUE as-is.

Regards,
Florian
