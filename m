From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH 1/2] updates for [nf|ct]netlink and event API
Date: Mon, 04 Jul 2005 13:59:45 +0100
Message-ID: <42C932C1.6090609@ufomechanic.net>
References: <42C03F2E.30706@eurodev.net>	<20050627202621.GY19928@sunbeam.de.gnumonks.org>	<42C0AF26.1040705@eurodev.net>
	<42C0C9B2.20704@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42C0C9B2.20704@trash.net>
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

Patrick McHardy wrote:
> Pablo Neira wrote:
> 
>>Harald Welte wrote:
>>
>>>>- Implement ip_conntrack_stats dumping and reset (accounting)
>>>
>>>you want to dump the statistics via netlink?  i'm not sure whether that
>>>is required.  lnstat is the only program using those counters, and using
>>>/proc seems fine for that.
>>
>>Could this be useful for accounting purposes? I mean, dump and reset as
>>a single operation, something similar to conntrack -L -z, say conntrack
>>-S -z.

I use this, reading and zeroing conntracks at the same time.

> I think it is convenient for anyone wanting to access these statistics
> without parsing /proc to have everything accessible through a single
> interface.

Yes; it also preserves synchronicity.

In other words it is nice to be sure if an event-update comes 
chronologically before or after the stats for the same conntrack were read.

Over netlink this is easy, over netlink AND /proc is impossible.

Azez
