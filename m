From: Marcus Sundberg <marcus@ingate.com>
Subject: Re: [PATCH] ip_ct_refresh_optimization.patch
Date: 14 Sep 2002 14:52:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <velm64u40t.fsf@inigo.ingate.se>
References: <vebs73bnx1.fsf@inigo.ingate.se> <1031835954.28101.82.camel@tux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1031835954.28101.82.camel@tux>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Martin Josefsson <gandalf@wlug.westbo.se> writes:

> Yes I know it's broken, I do have a newer version but I havn't committed
> it to cvs. I think Patrick Shaaf's solution is a better one and we
> should probably go with something like that.

Probably yes, but that's no reason to have a completely broken patch
which can be fixed by a one-liner in CVS. It should IMHO either be
fixed or removed asap.

> you can find a few optimisation and other patches over at
> http://www.netfilter.org/~gandalf/
> 
> timer-update2-inc.diff is almost like your patch. I'm using it right now
> and it seems to be working fine.

That patch is also incorrect, but it works because it updates to
often, not to seldom. If the new timeout is one jiffie earlier than
the previous timeout your expression will evaluate to 0xffffffff
and thus update the timer even though there's no need. The cast
is useless btw, because all operands, and thus the result also, are
already unsigned long.

//Marcus
-- 
---------------------------------------+--------------------------
  Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
 Firewall Developer, Ingate Systems AB |  http://www.ingate.com/
