From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 01/03]: nf_conntrack: fix helper module unload races
Date: Tue, 05 Jun 2007 12:55:42 -0700 (PDT)
Message-ID: <20070605.125542.94888173.davem@davemloft.net>
References: <20070605133508.10309.36756.sendpatchset@localhost.localdomain>
	<20070605133509.10309.45032.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070605133509.10309.45032.sendpatchset@localhost.localdomain>
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
Date: Tue,  5 Jun 2007 15:35:10 +0200 (MEST)

> [NETFILTER]: nf_conntrack: fix helper module unload races
> 
> When a helper module is unloaded all conntracks refering to it have their
> helper pointer NULLed out, leading to lots of races. In most places this
> can be fixed by proper use of RCU (they do already check for != NULL,
> but in a racy way), additionally nf_conntrack_expect_related needs to
> bail out when no helper is present.
> 
> Also remove two paranoid BUG_ONs in nf_conntrack_proto_gre that are racy
> and not worth fixing.
> 
> Signed-off-by: Patrick McHarrdy <kaber@trash.net>

Applied.
