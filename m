From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] IRC Zero Port Fix
Date: Tue, 25 Jan 2005 21:45:01 -0800
Message-ID: <20050125214501.16424ba1.davem@davemloft.net>
References: <1106412163.7965.10.camel@debian>
	<1106636928.19186.47.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, pomac@vapor.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1106636928.19186.47.camel@localhost.localdomain>
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

On Tue, 25 Jan 2005 18:08:48 +1100
Rusty Russell <rusty@rustcorp.com.au> wrote:

> Name: IRC Zero Port Fix
> Status: Tested under nfsim, booted under qemu
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> Ian Kumlien reported that new NAT code started sending out DCC
> requests with 0 as the IP address.  That prompted me to write a simple
> IRC test case, which both illustrated the bug, and found another one
> in that the wrong expectation was being set up when NAT occurred.

Applied, thanks Rusty.
