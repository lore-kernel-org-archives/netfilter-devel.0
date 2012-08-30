From: Oliver <olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: [PATCH] death_by_event() does not check IPS_DYING_BIT - race condition against ctnetlink_del_conntrack
Date: Thu, 30 Aug 2012 19:49:24 +0200
Message-ID: <10622350.k1HJ7t2ROS@gentoovm>
References: <7353554.n89QJXU3eh@gentoovm> <149613366.axl8ME3any@gentoovm> <20120830162248.GA3783@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:40428 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2H3RtV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Aug 2012 13:49:21 -0400
In-Reply-To: <20120830162248.GA3783@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 30 August 2012 18:22:48 you wrote:
> Unfortunately, asymmetric active-active is a crazy setup for conntrack
> (documentation already discuss this). The state synchronization that
> we are doing is asynchronous, so state-updates race with TCP packet.
> We don't support this, sorry.

The environment does fulfil the assumptions necessary for replication to happen 
within the handshake so under 3.2 there is no issue with handshakes completing 
under an asymmetric path.

Nonetheless, what doesn't make sense is that this operates under 3.2 and not 
3.4 - also is the fact that having a "-j CT --notrack" on specific traffic (i.e. 
asymmetric should not matter because there is no stateful tracking)

Kind Regards,
Oliver
