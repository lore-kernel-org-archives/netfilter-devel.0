From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 02/08]: nf_conntrack: make l3proto->prepare()
 generic and renames it
Date: Sat, 14 Jul 2007 20:45:00 -0700 (PDT)
Message-ID: <20070714.204500.38714616.davem@davemloft.net>
References: <20070714151150.9829.47674.sendpatchset@localhost.localdomain>
	<20070714151152.9829.1396.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070714151152.9829.1396.sendpatchset@localhost.localdomain>
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
Date: Sat, 14 Jul 2007 17:12:36 +0200 (MEST)

> [NETFILTER]: nf_conntrack: make l3proto->prepare() generic and renames it
> 
> The icmp[v6] l4proto modules parse headers in ICMP[v6] error to get tuple.
> But they have to find the offset to transport protocol header before that.
> Their processings are almost same as prepare() of l3proto modules.
> This makes prepare() more generic to simplify icmp[v6] l4proto module
> later.
> 
> Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
