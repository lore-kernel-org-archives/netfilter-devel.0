From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3/3] NETFILTER: New PPTP helper
Date: Fri, 16 Sep 2005 15:45:56 -0700 (PDT)
Message-ID: <20050916.154556.116608678.davem@davemloft.net>
References: <20050915145406.GC17121@rama.de.gnumonks.org>
	<4329F94E.4060107@trash.net>
	<20050916091548.GO5034@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20050916091548.GO5034@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

From: Harald Welte <laforge@netfilter.org>
Date: Fri, 16 Sep 2005 11:15:48 +0200

> On Fri, Sep 16, 2005 at 12:44:30AM +0200, Patrick McHardy wrote:
> > Harald Welte wrote:
> > >NETFILTER: Add new PPTP conntrack and NAT helper
> > 
> > I noticed a number of problems, this first batch of patches
> > fixes the worst ones I hope. There's also one or two small
> > cleanup patches. I can't test them here, please review and
> > ACK/NACK for Dave.
> 
> Ok, I'm at the moment hunting down some strange linux-2.6.13 <-> solaris
> 9 TCP window scaling problems.  Will look into your patches later today.

Since Linus GIT doesn't have the PPTP addition changes yet, I think
I'm going to hold off on merging it for now.

Why don't you guys work together to integrate all of the fixes, and
then resubmit PPTP as one changeset with all the bug fixes already
applied?  I think that would work best and prevent changeset bloat.

I will, however, integrate all of the non-PPTP changes as they were
seemingly all bug fixes in one way or another.

Thanks.
