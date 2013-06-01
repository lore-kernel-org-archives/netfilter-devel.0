From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] libnetfilter_queue: Fix Valgrind errors of unitialized
 byte(s) during call to nfq_unbind_pf
Date: Sat, 1 Jun 2013 11:34:30 +0200
Message-ID: <20130601093430.GA10925@breakpoint.cc>
References: <CABfawhm7V6htNehkNrf-pCSsHt-gjZCOgBhAMAoCh7UyY=rapQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tamas Lengyel <tamas.k.lengyel@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55290 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751566Ab3FAJec (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:34:32 -0400
Content-Disposition: inline
In-Reply-To: <CABfawhm7V6htNehkNrf-pCSsHt-gjZCOgBhAMAoCh7UyY=rapQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Tamas Lengyel <tamas.k.lengyel@gmail.com> wrote:
> Valgrind generates error reports of unitialized byte(s) during a call
> to the nfq_unbind_pf function:
> ==00:00:00:08.662 22111== 4 errors in context 1 of 1:
> ==00:00:00:08.662 22111== Syscall param socketcall.sendto(msg) points
> to uninitialised byte(s)

Since the kernel doesn't use this value nothing bad will happen.
But, since __send_cgf_msg is hardly a fastpath I've applied the patch,
thanks.

For your next patch submission, please

> The following (tiny) patch gets rid of the issue. I made the patch
> available on github as well at
> git://github.com/tklengyel/libnetfilter_queue.git

move this snippet
> ---

Here, so that git-am can remove the non-changelog part
automatically.

Also, please send a copy of the patch to yourself
and try to apply the patch yourself with git-am.

Your mailer program mangled the tabs in the patch so it didn't apply
without manual editing.

Thanks.
