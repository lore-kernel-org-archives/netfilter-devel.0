From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] Fix MASQUERADE
Date: Tue, 7 Sep 2004 08:09:44 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040907080944.3f80976c.davem@davemloft.net>
References: <1094566809.25641.9.camel@bach>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net,
	herbert@gondor.apana.org.au
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1094566809.25641.9.camel@bach>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 08 Sep 2004 00:20:09 +1000
Rusty Russell <rusty@rustcorp.com.au> wrote:

> Please test.  Also resets assured bit.
> 
> Name: Change MASQUERADE to Use Device Address Directly
> Status: Untested
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> Instead of doing a dubious route lookup, just use the first IP address
> of the (dynamic) interface.  Also, reset assured bit so after masq
> connections can be cleaned up if memory pressure.

Didn't Herbert Xu et al. come to the conclusion that this isn't
the way to fix this and that using inet_select_addr() had
some problems especially in policy routing situations?
