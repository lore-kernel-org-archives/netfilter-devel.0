From: Martijn Lievaart <m@rtij.nl>
Subject: Re: snat bridge routes reply packets
Date: Fri, 30 Sep 2005 07:27:46 +0200
Message-ID: <433CCCD2.9030504@rtij.nl>
References: <dhef0t$mj3$1@sea.gmane.org>	<Pine.LNX.4.61.0509282147100.8767@filer.marasystems.com>	<433BA8F6.7000606@ufomechanic.net>	<Pine.LNX.4.61.0509291155310.25933@filer.marasystems.com>	<433BDBD7.6030609@ufomechanic.net>	<20214.217.166.60.19.1127998151.squirrel@ma.rtij.nl>	<433BE841.2090203@ufomechanic.net>	<41060.217.166.60.19.1128007213.squirrel@ma.rtij.nl>
	<Pine.LNX.4.61.0509291817370.4714@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, azez@ufomechanic.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0509291817370.4714@filer.marasystems.com>
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

Henrik Nordstrom wrote:

> On Thu, 29 Sep 2005, Martijn Lievaart wrote:
>
>> so I think I'm still missing something.
>
>
> Simplest setup explaining the case as I understood it:
>
> unknown network mesh -> Bridge running SNAT -> Internet
>
> and you want the bridge to SNAT whatever is seen from the internal 
> network, no matter what address is being used. The bridge does not 
> have full knowledge of how the internal network mesh looks like, only 
> that packets coming in on that interface is from the internal network.
>
>

Ah, now I see. The unknown network mesh uses multiple routers which are 
unknown to the bridge, so the bridge does not know where to route the 
return packets, although it could know if it saved the mac the original 
packet came from. Right?

M4
