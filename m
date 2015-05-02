From: Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH 1/2] Consistently use <errno.h>
Date: Sat, 2 May 2015 21:56:36 +0200
Message-ID: <20150502195636.GD22481@breakpoint.cc>
References: <20150502195101.GA17994@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Felix Janda <felix.janda@posteo.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:43493 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754059AbbEBT4h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 15:56:37 -0400
Content-Disposition: inline
In-Reply-To: <20150502195101.GA17994@euler>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Felix Janda <felix.janda@posteo.de> wrote:
> On glibc, <sys/errno.h> is a synomym for <errno.h>.
> <errno.h> is specified by POSIX, so use that.
> 
> Fixes compilation error with musl libc

Applied, in future patches please also add a "Signed-off-by" line.

Thanks.
