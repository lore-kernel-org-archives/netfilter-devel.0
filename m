From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: Added vlan matching extension
Date: Wed, 27 May 2015 14:35:50 +0200
Message-ID: <20150527123550.GA19737@salvia>
References: <1432586250-42147-1-git-send-email-eddi@guardicore.com>
 <20150525215108.GH3629@breakpoint.cc>
 <CADgXnSO8EOwA_2tPgoZN=nHrsemhteep3ROSRLK6L-0Dn57NHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eddi Linder <eddi@guardicore.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41251 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbbE0Mas (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 May 2015 08:30:48 -0400
Content-Disposition: inline
In-Reply-To: <CADgXnSO8EOwA_2tPgoZN=nHrsemhteep3ROSRLK6L-0Dn57NHA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 26, 2015 at 05:24:56PM +0300, Eddi Linder wrote:
[...]
> Yes, I do plan to use it with a bridge, but I don't think ebtables is
> the proper solution, as I'd like to be able to use the matches and the
> targets provided by the iptables extensions.

If we follow this path, we'll open the door to get more patches to
bloat iptables with features that actually belong to the bridge
family, just because you don't want to use ebtables for this.

We have the chance to resolve this situation from nf_tables.

Sorry, I'm not applying this.
