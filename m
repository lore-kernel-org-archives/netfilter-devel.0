From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER 01/05]: x_tables: fix dependencies of conntrack
 related modules
Date: Wed, 15 Feb 2006 15:21:44 -0800 (PST)
Message-ID: <20060215.152144.30588545.davem@davemloft.net>
References: <20060215230026.25078.33875.sendpatchset@localhost.localdomain>
	<20060215230028.25078.50030.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20060215230028.25078.50030.sendpatchset@localhost.localdomain>
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
Date: Thu, 16 Feb 2006 00:00:28 +0100 (MET)

> [NETFILTER]: x_tables: fix dependencies of conntrack related modules
> 
> NF_CONNTRACK_MARK is bool and depends on NF_CONNTRACK which is tristate.
> If a variable depends on NF_CONNTRACK_MARK and doesn't take care about
> NF_CONNTRACK, it can be y even if NF_CONNTRACK isn't y.
> NF_CT_ACCT have same issue, too.
> 
> Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied, thanks.
