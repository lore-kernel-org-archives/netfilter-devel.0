From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/4] TCPMSS: clamp to input interface MTU too
Date: Wed, 24 May 2006 18:18:12 +0200
Message-ID: <44748744.5060808@trash.net>
References: <20060524040441.111049000@snapgear.com>
	<20060524040950.965615000@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: philipc@snapgear.com
In-Reply-To: <20060524040950.965615000@snapgear.com>
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

philipc@snapgear.com wrote:
> Ideally we would clamp the MSS based on the PMTU from src to dst.
> Currently we use the PMTU from the packet filter to the dst.
> This patch better approximates the full PTMU by using the input
> interface MTU too.


Also one of the things I have a half-finished patch for :)
But it (optionally) does a routing lookup for the source
to get a better estimate than the interface MTU.
