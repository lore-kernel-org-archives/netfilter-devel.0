From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] priv_data 0/2
Date: Mon, 14 Aug 2006 16:22:31 +0200
Message-ID: <44E08727.6070403@trash.net>
References: <200606261641.47294.max@nucleus.it>
	<20060814141751.GR7194@kriss.csbnet.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Massimiliano Hofer <max@nucleus.it>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Joakim Axelsson <gozem@gozem.se>
In-Reply-To: <20060814141751.GR7194@kriss.csbnet.se>
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
> 
> I'm currently porting some of my modules to use this API with priv_data.
> However, I ran into some troubles. For example i'm writing a revision 1 for
> the quota module which allows the count to go negative, and in the same time
> I'm porting it to use this API (as it's using the same stupid thing as -m
> limit with q->master = q;). However, having the quota counter in the
> priv_data struct makes it impossible to report the counter to userspace when
> the user issues iptables -L.

That is actually a bug in the current module IMO (I looked into fixing
this yesterday as well). iptables-save/restore won't work properly since
they will save the _remaining_ quota, not the one the rule was created
with. This might be useful as well, but it diverges from what other
modules do.

> "Hidden", kernel data only is good with priv_data, but sometimes it will be
> too hidden.
> 
> Do we have any good solution for this?

Not really, see the mail I just wrote.
