From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 05/11] xt_psd: remove unneeded variables
Date: Mon, 17 Sep 2012 09:35:57 +0200
Message-ID: <20120917073557.GA9909@breakpoint.cc>
References: <1347830995-19226-1-git-send-email-fw@strlen.de>
 <1347830995-19226-6-git-send-email-fw@strlen.de>
 <alpine.LNX.2.01.1209170453550.13524@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34817 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753537Ab2IQHf7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Sep 2012 03:35:59 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1209170453550.13524@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@inai.de> wrote:
> On Sunday 2012-09-16 23:29, Florian Westphal wrote:
> >
> >- dest port and dest address were only written, never read
> >- struct inaddr isn't needed either, just look at iph->saddr
> 
> 
> I have applied 01..04, with some redactional changes (diff 
> 975f017..093f3b0).

Alright, the changes are ok; I'll update the remaining
patches to use stdint-types.

> >-static inline int hashfunc(struct in_addr addr)
> >+static unsigned int hashfunc(__be32 addr)
> 
> You are changing the type of hash here. While I concur with using an 
> unsigned quantity for a hash value, this is not done consistenly - there 
> are some (signed) "int hash"s left in the code. Can I get a patch that 
> rectifies this consistently across the entire .c file as well?

Sure; I'll rebase to remaining patches on top of your tree.

> BTW, does the _10 in your branch name have any significance? :)

Not really; I usually start out with foo_01 and then increment the
number when rebasing/structuring the changeset.
