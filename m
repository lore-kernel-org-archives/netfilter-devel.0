From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_quota (Was: [PATCH] priv_data 0/2)
Date: Mon, 14 Aug 2006 18:39:57 +0200
Message-ID: <44E0A75D.10205@trash.net>
References: <200606261641.47294.max@nucleus.it>
	<20060814141751.GR7194@kriss.csbnet.se>
	<44E08727.6070403@trash.net>
	<20060814153521.GV7194@kriss.csbnet.se>
	<44E09A21.6000503@trash.net>
	<20060814162451.GZ7194@kriss.csbnet.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Massimiliano Hofer <max@nucleus.it>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Joakim Axelsson <gozem@gozem.se>
In-Reply-To: <20060814162451.GZ7194@kriss.csbnet.se>
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

Joakim Axelsson wrote:
> I however really needs some way of figuring out how much of the quota that
> remains. This is to be able to report this to our users (that receives a
> certain number of gigabytes each day). So they can see how much they have
> left (using som scripted interface to iptables). Also saving this holy
> figure (as it has become :-)) for the user if the router for some reason
> craches. This is also the reason i need negative quota figures. The users
> are allowed to "borrow" from their future quota. Doing so only under a byte
> limiting match (-m lim --limit-bytes 20k/s).
> 
> In my opinion its more important to save the remaining quota, rather than
> the original. And most important to in some way be able to see how much
> is left of the quota.
> 
> Perhaps this wil satisfy both of us:
> 
> Somehting put out by iptables-save
> iptables -m quota --init-quota 1000 --remain-quota 123 --use-quota remain
> 
> Somthing you write with iptables to create a new rule:
> iptables -m quota --init-quota 1000   (using --use-quota init explicity)
> iptables -m quota --init-quota 1000 --use-quota remain 
> 
> But this sure is ugly.


It should be an explicit flag to iptable-save/restore to save the
current state, because we don't do it anywhere else and therefore
it is unexpected. The limit match for example does neither show nor
save the current amount of tokens, last refill time, ...
And I'm not too much of a fan of adding such a flag because it can
only be done for a subset of all modules, hashlimit, recent etc.
all can't do it. The most extreme case would be the state match :)

With a netlink API we could actually dump all internal state (including
things like recently seen IP addresses) and accept changes from
userspace. This would allow us to get rid of the ugly proc interfaces
and covers your need as well.
