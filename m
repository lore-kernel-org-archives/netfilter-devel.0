From: Eldad Zack <eldad@stoneshaft.ath.cx>
Subject: Re: 2.4 SNAT fails randomly
Date: Wed, 19 Nov 2003 09:46:00 +0200 (IST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0311190942290.31702@localhost>
References: <200311151103.47454.timg@tpi.com> <20031116095206.GA32471@balabit.hu>
 <200311160953.51722.timg@tpi.com> <200311180835.09794.timg@tpi.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Balazs Scheidler <bazsi@balabit.hu>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Tim Gardner <timg@tpi.com>
In-Reply-To: <200311180835.09794.timg@tpi.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


On Tue, 18 Nov 2003, Tim Gardner wrote:

> I've been thinking more about this scenario. When a standard distribution like 
> SuSE-9.0 boots, the interfaces are  IFF_UP sometime before firewall rules are 
> installed. This is particularly a problem in the case of a NAT router. Is 
> there any way to flush /proc/net/ip_conntrack to make sure that you get rid 
> of entries that were established between the time the interfaces were brought 
> up and the time the rules were installed? Removing the ip_conntrack modules 
> seems kind of brute force, and does not work on kernels where ip_conntrack is 
> not a module.

There is a quick and dirty way to do it - forging a RST packet to the 
tuple you want to flush. I've used hping to forge such packets and 
iptstate to look at the conntrack table.

There really should be another way, though.



Eldad
