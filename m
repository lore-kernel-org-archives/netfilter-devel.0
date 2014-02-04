From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: nf_conntrack: don't release a conntrack with
 non-zero refcnt
Date: Tue, 4 Feb 2014 14:27:37 +0100
Message-ID: <20140204132737.GB9881@breakpoint.cc>
References: <1391465397-3856-1-git-send-email-pablo@netfilter.org>
 <20140203232925.GA3695@breakpoint.cc>
 <20140204102143.GA4711@localhost>
 <20140204124637.GA9881@breakpoint.cc>
 <20140204131602.GA22968@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	avagin@parallels.com, eric.dumazet@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35486 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753684AbaBDN1j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Feb 2014 08:27:39 -0500
Content-Disposition: inline
In-Reply-To: <20140204131602.GA22968@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > I think you could just leave hash_check_insert() alone?
> 
> hash_check_insert() is only used by ctnetlink in the creation path for
> new conntracks.

I see.  In that case I see nothing wrong with your patch.

Thanks for explaining!
