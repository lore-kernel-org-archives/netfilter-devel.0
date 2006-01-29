From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.16-rc1-mm3 XFRM+NAT issue
Date: Mon, 30 Jan 2006 00:29:04 +0100
Message-ID: <43DD4FC0.30704@trash.net>
References: <1138563710.26998.22.camel@leto.intern.saout.de>	<43DD1E3E.70503@trash.net>	<1138568354.21229.1.camel@leto.intern.saout.de>	<43DD3E3D.5070201@trash.net>	<1138573848.28464.1.camel@leto.intern.saout.de>	<43DD48CC.9070709@trash.net>	<1138577096.28609.13.camel@leto.intern.saout.de>
	<43DD4F31.8030807@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Christophe Saout <christophe@saout.de>
In-Reply-To: <43DD4F31.8030807@trash.net>
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

Patrick McHardy wrote:
> Christophe Saout wrote:
> 
>>Looks like I can finally move on trying to upgrade my kernel...
> 
> 
> Actually it seems I got confused, the check looks right. Can you post
> the output of /proc/net/ip_conntrack for this connection please?

Seems like I'm too tired to think, I was looking at the already
patched kernel when making that statement :) The patch is indeed
correct.
