From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 03/04]: sip: Fix RTP address NAT
Date: Thu, 03 May 2007 03:35:54 -0700 (PDT)
Message-ID: <20070503.033554.15429628.davem@davemloft.net>
References: <20070503012437.12818.39126.sendpatchset@localhost.localdomain>
	<20070503012441.12818.26845.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070503012441.12818.26845.sendpatchset@localhost.localdomain>
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
Date: Thu,  3 May 2007 03:26:00 +0200 (MEST)

> [NETFILTER]: sip: Fix RTP address NAT
> 
> I needed to use this recently to talk to a Cisco server.  In my case
> I only did SNAT while the Cisco server used a different address for
> RTP traffic than the one for SIP.  I discovered that nf_nat_sip NATed
> the RTP address to the SIP one which was unnecessary but OK.  However,
> in doing so it did not DNAT the destination address on the RTP traffic
> to the Cisco back to the original RTP address.
> 
> This patch corrects this by noting down the RTP address and using it
> when the expectation fires.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
