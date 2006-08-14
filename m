From: Joakim Axelsson <gozem@gozem.se>
Subject: Re: [PATCH] priv_data 0/2
Date: Mon, 14 Aug 2006 17:35:21 +0200
Message-ID: <20060814153521.GV7194@kriss.csbnet.se>
References: <200606261641.47294.max@nucleus.it>
	<20060814141751.GR7194@kriss.csbnet.se>
	<44E08727.6070403@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Massimiliano Hofer <max@nucleus.it>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <44E08727.6070403@trash.net>
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

2006-08-14 16:22:31+0200, Patrick McHardy <kaber@trash.net> ->
> Joakim Axelsson wrote:
> > 
> > I'm currently porting some of my modules to use this API with priv_data.
> > However, I ran into some troubles. For example i'm writing a revision 1 for
> > the quota module which allows the count to go negative, and in the same time
> > I'm porting it to use this API (as it's using the same stupid thing as -m
> > limit with q->master = q;). However, having the quota counter in the
> > priv_data struct makes it impossible to report the counter to userspace when
> > the user issues iptables -L.
> 
> That is actually a bug in the current module IMO (I looked into fixing
> this yesterday as well). iptables-save/restore won't work properly since
> they will save the _remaining_ quota, not the one the rule was created
> with. This might be useful as well, but it diverges from what other
> modules do.
> 

Well, the priv_data patch will then solve this problem. As the userspace
struct will always have the initial quota unaltered. The priv_data quota will
decrease. However i guess you want to be able to see both. And in my case,
saving the remaining quota with iptables-save is what i want. (I case of the
router for some reason craches, the last state must be saved and as accurate
as possible.)

Solution for this might be using two parameters for the userspace struct.
One for initial quota and one for remaining, saving both. Possible even an
option saying with figure should be set when iptables-restore is used.

Still, we can't nicly access the remaining quota with priv_data unless the
modules each time it "matches" writes in both priv_data and userspace info,
which is kinda ugly.

There is also the way of using a /proc-entry to list the current remaining
quota. Also restoring it by echoing a new figure to the entry. Keep the
iptables-save/restore only with the initial quota figure.

I can write this if this is what we want?

--
Joakim Axelsson
