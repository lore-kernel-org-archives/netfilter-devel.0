From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Developing a user space library for filtering
Date: Tue, 22 May 2007 08:27:25 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0705220826110.4452@yvahk01.tjqt.qr>
References: <46521CB9.2040309@Sun.COM> <46522166.1090603@gmx.net>
	<465222C0.8050601@Sun.COM>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org,
	Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
To: Darren.Reed@Sun.COM
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <465222C0.8050601@Sun.COM>
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


On May 21 2007 15:52, Darren.Reed@Sun.COM wrote:
>> 
>> Sorry if I'm being dense. Do you want to target firewall frontends
>> or applications which have the desire to punch holes into the
>> firewall?
>
> Neither.  Applications that sit on top of firewall software.
>
> As an example, using squid on your Linux firewall/router in
> transparent proxying mode requires that squid has some code
> in it that knows how to talk to Linux in order to discover the
> original destination

As with most client-side transparent proxies, it uses the Host: header.

> and change the outgoing connection
> such that the original address is used again.  Doing that
> requires specific knowledge of the API that netfilter/iptables
> uses.

	Jan
-- 
