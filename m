From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 03/12]: Fix section mismatch warnings
Date: Fri, 07 Apr 2006 00:42:24 +0200
Message-ID: <44359950.7080805@trash.net>
References: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>	<20060406100456.17409.89515.sendpatchset@localhost.localdomain>
	<20060406.141309.51862771.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20060406.141309.51862771.davem@davemloft.net>
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

David S. Miller wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Thu,  6 Apr 2006 12:04:56 +0200 (MEST)
> 
> 
>>[NETFILTER]: Fix section mismatch warnings
>>
>>Fix section mismatch warnings caused by netfilter's init_or_cleanup
>>functions used in many places by splitting the init from the cleanup
>>parts.
>>
>>Signed-off-by: Patrick McHardy <kaber@trash.net>
> 
> 
> Applied, but lots of trailing whitespace I had to clean up
> before applying.  Please test your patches with:
> 
>    git apply --check --whitespace=error-all $1

Sorry, I know you already mentioned this. I already had the feeling
something is wrong with my whitespace-stripping regexes recently,
but didn't investigate. Most of my scripts need a rework anyway,
I'll make sure to fix this before submitting the next batch.
