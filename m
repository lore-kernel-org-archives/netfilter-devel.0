From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] undefined "csum_ipv6_magic" in
	net/ipv6/netfilter/nf_conntrack_ipv6.ko
Date: Tue, 03 May 2005 20:05:20 +0200
Message-ID: <4277BD60.1010906@trash.net>
References: <200505030911.51011.pluto@pld-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pawel Sikora <pluto@pld-linux.org>
In-Reply-To: <200505030911.51011.pluto@pld-linux.org>
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

Pawel Sikora wrote:
> Hi All,
> 
> The asm/arch-ppc/checksum.h doesn't provide an optimizied version
> of `csum_ipv6_magic'. You shoud use a generic version.

Applied, thanks.
