From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: tcp match silently drops packets
Date: Mon, 17 Oct 2005 23:52:21 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0510172343270.23546@filer.marasystems.com>
References: <E1ERGOc-0008Hg-00@gondolin.me.apana.org.au>
	<Pine.LNX.4.61.0510172114290.23546@filer.marasystems.com>
	<20051017212732.GA7010@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
In-Reply-To: <20051017212732.GA7010@gondor.apana.org.au>
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

On Tue, 18 Oct 2005, Herbert Xu wrote:

> This is not true if tunnels are involved.

True, and perhaps the tcp match should be relaxed slightly to only hotdrop 
packets if it's the first fragment and what is needed to evaluate the 
match is not there..

The port matches can evaluate just fine if the first fragment is minimal. 
It's only the flags matches etc which would fail (and drop the packet 
to be safe)..

Regards
Henrik
