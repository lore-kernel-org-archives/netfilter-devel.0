From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] trivial patch for TCPLAG iptables version
Date: Wed, 16 Mar 2005 15:41:04 +0100
Message-ID: <42384580.4010502@trash.net>
References: <1110978420.5786.9.camel@scaramouche>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter-Devel <netfilter-devel@lists.netfilter.org>
To: Torsten Luettgert <t.luettgert@pressestimmen.de>
In-Reply-To: <1110978420.5786.9.camel@scaramouche>
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

Torsten Luettgert wrote:
> Hi,
> 
> iptables/extensions/libipt_TCPLAG.c from svn requires
> iptables version 1.2.3 in its struct iptables_target, so
> the TCPLAG target cannot be used from iptables other than
> 1.2.3.
> 
> The attached trivial patch sets .version to IPTABLES_VERSION,
> just as all the other libipt_*.c matches have.
> 

Applied, thanks Torsten.

Regards
Patrick
