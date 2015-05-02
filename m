From: Felix Janda <felix.janda@posteo.de>
Subject: Re: [iptables PATCH 1/2] Consistently use <errno.h>
Date: Sat, 2 May 2015 22:50:26 +0200
Message-ID: <20150502205026.GA28748@euler>
References: <20150502195101.GA17994@euler>
 <20150502195636.GD22481@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:42015 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756771AbbEBUuf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 16:50:35 -0400
Content-Disposition: inline
In-Reply-To: <20150502195636.GD22481@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal wrote:
> Felix Janda <felix.janda@posteo.de> wrote:
> > On glibc, <sys/errno.h> is a synomym for <errno.h>.
> > <errno.h> is specified by POSIX, so use that.
> > 
> > Fixes compilation error with musl libc
> 
> Applied, in future patches please also add a "Signed-off-by" line.

Sorry for the missing Signed-off-by.

Thanks for applying,
Felix
