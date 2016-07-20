From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH iptables] connlabel: clarify default config path
Date: Wed, 20 Jul 2016 18:31:27 +0200
Message-ID: <20160720163127.GA9123@breakpoint.cc>
References: <1469008704-22989-1-git-send-email-fw@strlen.de>
 <20160720162226.GB1413@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55937 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751681AbcGTQbe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jul 2016 12:31:34 -0400
Content-Disposition: inline
In-Reply-To: <20160720162226.GB1413@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> And libnetfilter_conntrack is coming with IPv6 NAT support.

Ah, I forgot about this.

> So I can schedule a release before end of this week / beginning next
> weekend with accumulated updates so this comes in the next release.

Ok, I will send a patch for lnf-conntrack and iptables later today.
