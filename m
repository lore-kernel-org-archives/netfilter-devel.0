From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: NAT for IPv6
Date: Fri, 21 Nov 2003 01:24:15 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311210110290.23998-100000@filer.marasystems.com>
References: <20031120174847.GA2254@balabit.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
   Maciej Soltysiak <solt@dns.toxicfilms.tv>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Balazs Scheidler <bazsi@balabit.hu>
In-Reply-To: <20031120174847.GA2254@balabit.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 20 Nov 2003, Balazs Scheidler wrote:

> I still can't see what you think the "kinds of problems TPROXY and silimar
> tools try to solve" is.

In case of TPROXY it is any problem where you need to have traffic
terminated at another place than the intended destination server for
whatever reason without the knowledge of the sender. This is outside of IP
specifications for very good reasons.

I don't see TPROXY or other interception techniques as that bad if every
single packet is intercepted. If it is used for selective interception of
only certain ports or similar then it is a different beast.

> We (and our customers) have the following requirements:
> 
> - application layer verification (URL filtering, virus checking, tasks that
>   are difficult/impossible to solve from kernel space)

Yes.

> - transparency
>   - because there are protocols which do not have a proxy mode 
>   - because they do not want to reconfigure their clients when a firewall
>     is installed.

And these points I say should not be taken for granted when moving to a 
IPv6 environment.

There is very few protocols which can not be proxied using the proper 
tools. And given some thought clients should not be needed to be manually 
reconfigured when installing a firewall.

> I can see cases when end-to-end IP connections are a must, but there are
> other cases when proxying is the only viable solution, and I can't see why
> we can't have a solution for both worlds.

I am not against proxying (quite naturally given who I am). What I am
against is violation of the fundamental end-to-end property of IP. Per
definition proxying is not a violation of end-to-end, transparent
interception is.

In the state of IPv4 it is unfortunately a neccesary bad due to the large
installed base of dumb applications not capable of using proxies. The
situation in IPv6 is better and in my opinion in a position allowing this
kind of problems to be solved at the application level without having to 
resort to "dirty hacks".

Regards
Henrik
