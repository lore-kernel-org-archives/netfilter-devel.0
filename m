From: Philip Craig <philipc@snapgear.com>
Subject: Re: Bridge netfilter defered hooks
Date: Fri, 09 Jun 2006 09:43:37 +1000
Message-ID: <4488B629.1070608@snapgear.com>
References: <448051F3.1070509@trash.net>	<4487CEA8.8060701@trash.net>	<44888CD7.8090601@rtij.nl>	<200606082340.41755.simonl@parknet.dk>
	<4488A215.5030305@rtij.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martijn Lievaart <m@rtij.nl>
In-Reply-To: <4488A215.5030305@rtij.nl>
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

On 06/09/2006 08:17 AM, Martijn Lievaart wrote:
> Simon Lodal wrote:
> 
>> Why not define the mark size at compile time, in case you need more bits?
>>  
>>
> 
> Because that probably would cause the skb to grow beyond a cache line, 
> though I'm nowhere an expert on these things. Opinions?

It may be enough to extend the conntrack mark, but not the packet mark,
so that we aren't growing the skb.  Would need fancier operations for
transferring only parts of the conntrack mark to the packet mark.
