From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/3] Netfilter: Remove ip_conntrack_tuple_hash "ctrack"
Date: Tue, 25 Jan 2005 21:45:24 -0800
Message-ID: <20050125214524.1774d6e6.davem@davemloft.net>
References: <1105444254.19331.43.camel@localhost.localdomain>
	<m3k6q52ubw.fsf@igel.m5r.de>
	<1106535381.19666.6.camel@localhost.localdomain>
	<jellajqguc.fsf@sykes.suse.de>
	<1106639193.19186.50.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: schwab@suse.de, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1106639193.19186.50.camel@localhost.localdomain>
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

On Tue, 25 Jan 2005 18:46:33 +1100
Rusty Russell <rusty@rustcorp.com.au> wrote:

> Name: Avoid breaking userspace due to tuple change
> Status: Trivial, Compiled
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> Andreas Schwab <schwab@suse.de> points out that the ipt_conntrack
> match exposes "struct ip_conntrack_tuple" to userspace, and we changed
> it recently.  Make it use a "special" one, to avoid breaking
> compatibility.

Applied, thanks Rusty.
