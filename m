From: Florian Westphal <fw@strlen.de>
Subject: Re: Unable to DNAT packets back into originating bridge port
Date: Fri, 27 Jun 2014 20:52:07 +0200
Message-ID: <20140627185207.GA2843@breakpoint.cc>
References: <20140627174837.GG1353@login.tika.stderr.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Matthijs Kooijman <matthijs@stdin.nl>,
	Stephen Hemminger <stephen@networkplumber.org>,
	Bart De Schuymer <bart.de.schuymer@pandora.be>,
	bridge@lists.linux-foundation.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34871 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751675AbaF0SwP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Jun 2014 14:52:15 -0400
Content-Disposition: inline
In-Reply-To: <20140627174837.GG1353@login.tika.stderr.nl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Matthijs Kooijman <matthijs@stdin.nl> wrote:
> I recently stumbled upon an issue in my iptables setup. After some
> extensive debugging, I've found that the problem occurs when trying to
> DNAT (+SNAT) a packet that comes in through a bridge, back into the same bridge
> port it originated from.
> 
> The code ultimately responsible for this is the should_deliver function
> [1], which prevents packets from being delivered back to their
> originating port (ultimately to prevent bouncing broadcast message, I
> believe).

Sounds like
http://marc.info/?t=136627796900001&r=1&w=2
