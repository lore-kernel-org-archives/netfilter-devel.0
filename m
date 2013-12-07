From: Florian Westphal <fw@strlen.de>
Subject: Re: libmnl [PATCH 0/8] some cleanups and minor fixes
Date: Sat, 7 Dec 2013 13:12:01 +0100
Message-ID: <20131207121201.GB15614@breakpoint.cc>
References: <87ob4saox9.wl%chamaken@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44977 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753190Ab3LGMMD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Dec 2013 07:12:03 -0500
Content-Disposition: inline
In-Reply-To: <87ob4saox9.wl%chamaken@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ken-ichirou MATSUZAWA <chamaken@gmail.com> wrote:
> At Thu, 5 Dec 2013 15:27:46 +0100,
> Florian Westphal wrote:
> > Something corrupted the patch formattig, breaking long lines,
> > converting tabs/spaces, etc:
> 
> I am sorry for that. I've confirmed and am going to resend.
> Would you try again?

Series applied, thanks!

Minor nit: next time, please include the library name prefix inside the
[], like this:

[PATCH libmnl x/y] example: <description>

If you use

bla [PATCH ..], then git-am won't remove the [] content, requiring
manual editing.  If you put it inside the brackets, the subject will
be
example: <description>
instead.

Best regards,
Florian
