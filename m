From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 04/08]: nf_conntrack: Don't track locally generated
 special ICMP error
Date: Sat, 14 Jul 2007 20:45:51 -0700 (PDT)
Message-ID: <20070714.204551.32096917.davem@davemloft.net>
References: <20070714151150.9829.47674.sendpatchset@localhost.localdomain>
	<20070714151155.9829.50994.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070714151155.9829.50994.sendpatchset@localhost.localdomain>
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
Date: Sat, 14 Jul 2007 17:12:39 +0200 (MEST)

> [NETFILTER]: nf_conntrack: Don't track locally generated special ICMP error
> 
> The conntrack assigned to locally generated ICMP error is usually the one
> assigned to the original packet which has caused the error. But if
> the original packet is handled as invalid by nf_conntrack, no conntrack
> is assigned to the original packet. Then nf_ct_attach() cannot assign
> any conntrack to the ICMP error packet. In that case the current
> nf_conntrack_icmp assigns appropriate conntrack to it. But the current
> code mistakes the direction of the packet. As a result, NAT code mistakes
> the address to be mangled.
> 
> To fix the bug, this changes nf_conntrack_icmp not to assign conntrack
> to such ICMP error. Actually no address is necessary to be mangled
> in this case.
> 
> Spotted by Jordan Russell.
> 
> Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
