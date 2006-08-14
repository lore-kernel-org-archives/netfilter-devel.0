From: Joakim Axelsson <gozem@gozem.se>
Subject: Re: xt_quota (Was: [PATCH] priv_data 0/2)
Date: Mon, 14 Aug 2006 18:24:51 +0200
Message-ID: <20060814162451.GZ7194@kriss.csbnet.se>
References: <200606261641.47294.max@nucleus.it>
	<20060814141751.GR7194@kriss.csbnet.se>
	<44E08727.6070403@trash.net>
	<20060814153521.GV7194@kriss.csbnet.se>
	<44E09A21.6000503@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Massimiliano Hofer <max@nucleus.it>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <44E09A21.6000503@trash.net>
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

2006-08-14 17:43:29+0200, Patrick McHardy <kaber@trash.net> ->
>
> As I said, I don't see saving current state as necessary (we don't do
> it anywhere and it solves an entirely different problem). The
> unfortunate fact though is that we need to pass it to userspace anyway,
> because of the limitations of the userspace interface.
> 

That might be correct. However the other modules doesn't normally suffer
that much as they will farily quickly work thier way to the same state
again. I guess it's very uncommon that you are using so low limits like a
few packets each hour.

> > There is also the way of using a /proc-entry to list the current remaining
> > quota. Also restoring it by echoing a new figure to the entry. Keep the
> > iptables-save/restore only with the initial quota figure.
> > 
> > I can write this if this is what we want?
> 
> 
> Definitely not :) We want a better userspace interface that doesn't
> require us to put in hacks like this.

I however really needs some way of figuring out how much of the quota that
remains. This is to be able to report this to our users (that receives a
certain number of gigabytes each day). So they can see how much they have
left (using som scripted interface to iptables). Also saving this holy
figure (as it has become :-)) for the user if the router for some reason
craches. This is also the reason i need negative quota figures. The users
are allowed to "borrow" from their future quota. Doing so only under a byte
limiting match (-m lim --limit-bytes 20k/s).

In my opinion its more important to save the remaining quota, rather than
the original. And most important to in some way be able to see how much
is left of the quota.

Perhaps this wil satisfy both of us:

Somehting put out by iptables-save
iptables -m quota --init-quota 1000 --remain-quota 123 --use-quota remain

Somthing you write with iptables to create a new rule:
iptables -m quota --init-quota 1000   (using --use-quota init explicity)
iptables -m quota --init-quota 1000 --use-quota remain 

But this sure is ugly.

--
Joakim Axelsson
