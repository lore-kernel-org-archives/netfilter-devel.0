From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [NETFILTER 03/05]: nf_conntrack: move conntrack protocol
 sysctls to individual modules
Date: Mon, 27 Nov 2006 14:27:19 +0900 (JST)
Message-ID: <200611270527.kAR5RLrb003178@toshiba.co.jp>
References: <20061126144447.4215.87216.sendpatchset@localhost.localdomain>
	<20061126144451.4215.77390.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp,
	kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20061126144451.4215.77390.sendpatchset@localhost.localdomain>
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
Date: Sun, 26 Nov 2006 15:44:52 +0100 (MET)

> [NETFILTER]: nf_conntrack: move conntrack protocol sysctls to individual modules
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>


> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c

(snip)

> +#ifdef CONFIG_SYSCTL
> +static unsigned int tcp_syctl_table_users;

tcp_sysctl_table_users ? (second 's' is missing)

-- Yasuyuki Kozakai
