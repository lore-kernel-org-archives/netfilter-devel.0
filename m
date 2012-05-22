From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] tests: add rateest match rules
Date: Tue, 22 May 2012 22:36:31 +0200
Message-ID: <20120522203631.GB30077@1984>
References: <1337252589-1363-1-git-send-email-fw@strlen.de>
 <1337252589-1363-2-git-send-email-fw@strlen.de>
 <20120522183558.GA28870@1984>
 <20120522191003.GA11818@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58729 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932849Ab2EVUgf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 May 2012 16:36:35 -0400
Content-Disposition: inline
In-Reply-To: <20120522191003.GA11818@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 22, 2012 at 09:10:03PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, May 17, 2012 at 01:03:09PM +0200, Florian Westphal wrote:
> > > also, -p mobility gets us EINVAL from kernel, use -p ipv6-mh instead.
> > 
> > /etc/services in debian uses mobility-header instead mobility.
> 
> Should still work, iptables has ipv6-mh hardwired as fallback,
> see xtables_parse_protocol() in libxtables/xtables.c .
> 
> Do you still want me to resend it with -p 135?

No, as long as it still works. No need to resend, thanks.
