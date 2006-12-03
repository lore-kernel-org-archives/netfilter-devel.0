From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 28/33]: x_tables: add port of hashlimit match for
 IPv4 and IPv6
Date: Sat, 02 Dec 2006 22:19:23 -0800 (PST)
Message-ID: <20061202.221923.130238142.davem@davemloft.net>
References: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
	<20061129020926.21082.33516.sendpatchset@localhost.localdomain>
	<200612030401.kB341wWd013916@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: yasuyuki.kozakai@toshiba.co.jp
In-Reply-To: <200612030401.kB341wWd013916@toshiba.co.jp>
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

From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Date: Sun, 03 Dec 2006 13:01:56 +0900 (JST)

> Subject: [NETFILTER]: xtables: fixes warning on compilation of hashlimit
> 
> To use ipv6_find_hdr(), IP6_NF_IPTABLES is necessary.
> 
> Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

I've applied this patch as well.

Thanks everyone.
