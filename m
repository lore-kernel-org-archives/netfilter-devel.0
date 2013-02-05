From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: fix missing dependencies for
 NETFILTER_XT_MATCH_CONNLABEL
Date: Tue, 5 Feb 2013 04:00:33 +0100
Message-ID: <20130205030032.GA12794@localhost>
References: <510DC976.7000008@infradead.org>
 <1359890647-25846-1-git-send-email-fw@strlen.de>
 <510E8A93.6050300@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:61394 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755333Ab3BEDAh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Feb 2013 22:00:37 -0500
Content-Disposition: inline
In-Reply-To: <510E8A93.6050300@infradead.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Feb 03, 2013 at 08:04:35AM -0800, Randy Dunlap wrote:
> On 02/03/13 03:24, Florian Westphal wrote:
> > It was possible to set
> > NF_CONNTRACK=n
> > NF_CONNTRACK_LABELS=y
> > 
> > via NETFILTER_XT_MATCH_CONNLABEL=y:
> > 
> > warning: (NETFILTER_XT_MATCH_CONNLABEL) selects NF_CONNTRACK_LABELS which has
> > unmet direct dependencies (NET && INET && NETFILTER && NF_CONNTRACK)
> > 
> > Reported-by: Randy Dunlap <rdunlap@infradead.org>
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> Acked-by: Randy Dunlap <rdunlap@infradead.org>

Applied, thanks.
