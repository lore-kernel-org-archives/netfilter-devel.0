From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Multiple Address specification or match
Date: Thu, 30 Sep 2004 13:38:10 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409301336380.29461@filer.marasystems.com>
References: <003301c4a6cc$069e3fb0$2201010a@bluereef.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org, Swapnil Nagle <swapsn@rediffmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Temp02 <temp02@bluereef.com.au>
In-Reply-To: <003301c4a6cc$069e3fb0$2201010a@bluereef.local>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 30 Sep 2004, Temp02 wrote:

> The problem with the IPset/pool options are that they match only on a range
> of addresses, not specifically by source or destination

Eh? They match specificaly on either source or destination.

> also they seem to require the use of another userspace program to 
> actually build the sets which in itself complicates the process.

True.

> Is it hard to extend the source and destination match functions to accept
> multiple arguments?

Yes and no.

It is not hard to make a custom match matching multiple IP addresses, but 
it would be restricted in the number of addresses you can match.

If you need to group very many addresses then ippool/ipset is the correct 
tool.

Regards
Henrik
