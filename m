From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] death_by_event() does not check IPS_DYING_BIT - race
 condition against ctnetlink_del_conntrack
Date: Thu, 30 Aug 2012 20:39:50 +0200
Message-ID: <20120830183950.GB13190@1984>
References: <7353554.n89QJXU3eh@gentoovm>
 <149613366.axl8ME3any@gentoovm>
 <20120830162248.GA3783@1984>
 <10622350.k1HJ7t2ROS@gentoovm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Oliver <olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34720 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247Ab2H3Sj4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Aug 2012 14:39:56 -0400
Content-Disposition: inline
In-Reply-To: <10622350.k1HJ7t2ROS@gentoovm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 30, 2012 at 07:49:24PM +0200, Oliver wrote:
> On Thursday 30 August 2012 18:22:48 you wrote:
> > Unfortunately, asymmetric active-active is a crazy setup for conntrack
> > (documentation already discuss this). The state synchronization that
> > we are doing is asynchronous, so state-updates race with TCP packet.
> > We don't support this, sorry.
> 
> The environment does fulfil the assumptions necessary for replication to happen 
> within the handshake so under 3.2 there is no issue with handshakes completing 
> under an asymmetric path.

Interesting, how are those assumptions fulfilled?

> Nonetheless, what doesn't make sense is that this operates under 3.2 and not 
> 3.4 - also is the fact that having a "-j CT --notrack" on specific traffic (i.e. 
> asymmetric should not matter because there is no stateful tracking)

Agreed. But I don't come with any netfilter change that may result in
that problem you're reporting. You'll have to debug this and get back
to me with more information.
