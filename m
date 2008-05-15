From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: iptables performance and alternatives
Date: Thu, 15 May 2008 14:28:54 +0200
Message-ID: <1210854534.32691.11.camel@henriknordstrom.net>
References: <200805151421.23862.anton.vazir@gmail.com>
	 <20080515093413.GC3442@khasse.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Anton <anton.vazir@gmail.com>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vps1.henriknordstrom.net ([195.20.207.177]:35174 "EHLO
	vps1.henriknordstrom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbYEOMdO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 May 2008 08:33:14 -0400
In-Reply-To: <20080515093413.GC3442@khasse.inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On tor, 2008-05-15 at 11:34 +0200, Eric Leblond wrote:

> On Thursday, 2008 May 15 at 14:21:23 +0500, Anton wrote:
> > Regarding the performance of the lookup of the iptables 
> > rules for match inside the kernel, is there any plans to 
> > improve the behaviour or no plans in this area yet?
> 
> Nf hipac is an alternative: http://www.hipac.org/

Unfortunately a somewhat dead one as MARA Systems after all has selected
to develop this privately in future, so it's quite unlikely NF-HiPAC
will see any significant updates unless someone else picks up the
project.

Also it's insert performance is not the best in all cases (depends on
the structure of your ruleset and what kind of rule you insert). But
lookup speeds is always great.

Regards
Henrik

