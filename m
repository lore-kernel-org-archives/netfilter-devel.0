From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/3] nf_conntrack: fixes for nf_ct_attach in IPv6 stack
Date: Mon, 13 Feb 2006 17:44:30 +0100
Message-ID: <43F0B76E.7050007@trash.net>
References: <200602131628.k1DGSpc3019846@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org,
	laforge@gnumonks.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200602131628.k1DGSpc3019846@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> Hi,
> 
> These patches make nf_ct_attach work fine in IPv6 stack.
> 
> The locally generated reply packets in IPv6 stack, such as ICMPv6 error
> and TCP RST by REJECT target, need to be associated with the connection
> of original packet.

The reason why we manually attach these references (at least for ICMP)
is because the packet might be in the middle of two NAT manips and
unrecognizable for conntrack. For IPv6 this should be irrelevant. I'm
not sure why it is done for TCP RSTs, they should always be properly
tracked anyway.
