From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/3] nf_conntrack: fixes for nf_ct_attach in IPv6 stack
Date: Wed, 15 Feb 2006 11:10:41 +0100
Message-ID: <43F2FE21.5070707@trash.net>
References: <200602131628.k1DGSpc3019846@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
> These patches make nf_ct_attach work fine in IPv6 stack.
> 
> The locally generated reply packets in IPv6 stack, such as ICMPv6 error
> and TCP RST by REJECT target, need to be associated with the connection
> of original packet.

All three patches applied, thanks. I'll push them to Dave for 2.6.16
today.
