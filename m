From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.16-rc1-mm3 XFRM+NAT issue
Date: Fri, 03 Feb 2006 11:24:12 +0100
Message-ID: <43E32F4C.5060300@trash.net>
References: <43DD3E3D.5070201@trash.net>	<1138573848.28464.1.camel@leto.intern.saout.de>	<43DD48CC.9070709@trash.net>
	<20060202.171637.09393987.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, herbert@gondor.apana.org.au
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20060202.171637.09393987.davem@davemloft.net>
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
> Date: Sun, 29 Jan 2006 23:59:24 +0100
> 
> 
>>Found it, the packet doesn't have its dst_entry released after DNAT in
>>PRE_ROUTING because of an incorrect check and is delivered locally.
>>This patch should fix it.
> 
> 
> Patrick, want me to apply this?
> 
> I need a changelog and signed-off-by line if so.

Please wait, I've planned to submit this with a bunch of other
fixes tonight or tommorrow.
