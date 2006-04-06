From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER 03/12]: Fix section mismatch warnings
Date: Thu, 06 Apr 2006 14:13:09 -0700 (PDT)
Message-ID: <20060406.141309.51862771.davem@davemloft.net>
References: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
	<20060406100456.17409.89515.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20060406100456.17409.89515.sendpatchset@localhost.localdomain>
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

From: Patrick McHardy <kaber@trash.net>
Date: Thu,  6 Apr 2006 12:04:56 +0200 (MEST)

> [NETFILTER]: Fix section mismatch warnings
> 
> Fix section mismatch warnings caused by netfilter's init_or_cleanup
> functions used in many places by splitting the init from the cleanup
> parts.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied, but lots of trailing whitespace I had to clean up
before applying.  Please test your patches with:

   git apply --check --whitespace=error-all $1

Thanks.
