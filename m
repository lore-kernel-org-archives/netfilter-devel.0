From: Patrick Schaaf <bof@bof.de>
Subject: Re: RBAC Integration
Date: Sat, 28 Jun 2003 07:48:35 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030628054834.GC10045@oknodo.bof.de>
References: <1056734756.7156.2.camel@skinny.gideonolam.com> <20030627174010.GB10045@oknodo.bof.de> <1056741347.7156.10.camel@skinny.gideonolam.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: gideon olam <gideon@gideonolam.com>
Content-Disposition: inline
In-Reply-To: <1056741347.7156.10.camel@skinny.gideonolam.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Joe,

> Well,  I was thinking about "role" matches for filters and other policy
> type matches,  be it MAC or whatever.

In the existing RBAC systems, is there already a well defined notion
of "role" for individual network packets (aka sk_buffs), as they pass
through the stack?

> Matches like owner might be able to benefit.

That one is obvious. It should be straightforward to do, in that
case, right? Processes have role tags, the owner match is the
sole point which knows process context, so process roles could
be checked by some clone of the owner match.

> Userspace could use roles to determine who has what access rights
> to a table.

You mean something like this: who is permitted to modify this or that chain,
e.g. a userspace role "permitted to set MARKs from 1 to 100 in
mangle/PREROUTING"?

That could be very useful. Also very complex to get all interesting
criteria (like the MARK range I mention) covered.

A last comment: an owner like role match, and probably other similar
things, would better be part of the respective RBAC system. At least
until the time when that RBAC system is part of the base kernel.
I don't think that the iptables core implementation could / should
contain parts useful solely by out-of-kernel patches / modules.
Maybe patch-o-matic/extra could cope with this.

best regards
  Patrick
