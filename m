From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 2/2] tests: add rateest match rules
Date: Tue, 22 May 2012 21:10:03 +0200
Message-ID: <20120522191003.GA11818@breakpoint.cc>
References: <1337252589-1363-1-git-send-email-fw@strlen.de>
 <1337252589-1363-2-git-send-email-fw@strlen.de>
 <20120522183558.GA28870@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:56484 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760186Ab2EVTKF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 May 2012 15:10:05 -0400
Content-Disposition: inline
In-Reply-To: <20120522183558.GA28870@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, May 17, 2012 at 01:03:09PM +0200, Florian Westphal wrote:
> > also, -p mobility gets us EINVAL from kernel, use -p ipv6-mh instead.
> 
> /etc/services in debian uses mobility-header instead mobility.

Should still work, iptables has ipv6-mh hardwired as fallback,
see xtables_parse_protocol() in libxtables/xtables.c .

Do you still want me to resend it with -p 135?
