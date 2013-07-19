From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH conntrack-tools] conntrack: introduce -l option to
 filter by labels
Date: Fri, 19 Jul 2013 17:45:09 +0200
Message-ID: <20130719154509.GG22686@breakpoint.cc>
References: <1374244363-5385-1-git-send-email-fw@strlen.de>
 <20130719153132.GA19291@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41164 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752147Ab3GSPpM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:45:12 -0400
Content-Disposition: inline
In-Reply-To: <20130719153132.GA19291@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Oester <kernel@linuxace.com> wrote:
> On Fri, Jul 19, 2013 at 04:32:43PM +0200, Florian Westphal wrote:
> 
> +This option is only available in conjunctions with "-L, --dump" or "-E, --event".
> 					     ^
> conjunction should be single

Thanks, I'll fix that up before committing.
