From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER 02/05]: nf_conntrack: move registration of
 __nf_ct_attach
Date: Wed, 15 Feb 2006 15:22:30 -0800 (PST)
Message-ID: <20060215.152230.114831178.davem@davemloft.net>
References: <20060215230026.25078.33875.sendpatchset@localhost.localdomain>
	<20060215230029.25078.58330.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20060215230029.25078.58330.sendpatchset@localhost.localdomain>
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
Date: Thu, 16 Feb 2006 00:00:29 +0100 (MET)

> [NETFILTER]: nf_conntrack: move registration of __nf_ct_attach
> 
> Move registration of __nf_ct_attach to nf_conntrack_core to make it usable
> for IPv6 connection tracking as well.
> 
> Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
