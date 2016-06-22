From: Florian Westphal <fw@strlen.de>
Subject: Re: Implicit flow tables can't be listed
Date: Wed, 22 Jun 2016 14:25:47 +0200
Message-ID: <20160622122547.GA10213@breakpoint.cc>
References: <20160616102901.GA27422@breakpoint.cc>
 <20160622121503.GA12472@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	nf-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33362 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752048AbcFVM1Y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 08:27:24 -0400
Content-Disposition: inline
In-Reply-To: <20160622121503.GA12472@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> How can we actually relate the rule with the flow table if we have
> several anonymous flow tables?

nft list table filter
table ip filter {
        chain input {
                type filter hook input priority 0; policy accept;
                flow table __ft0 { ip saddr counter packets 0 bytes 0}
                flow table __ft1 { ip daddr counter packets 0 bytes 0}
        }

... so the internal name will be shown.

[..]

> This also provides a way to restore blacklist/whitelist in case we want
> to save them into file and restore them later. The original idea is
> that flow tables contain volatile information, but I think someone may
> want to store the current state into file and restore it, eg. in case
> it needs to reboot the system.

Agree.
