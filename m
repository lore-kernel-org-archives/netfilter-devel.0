From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 28/33]: x_tables: add port of hashlimit match for
 IPv4 and IPv6
Date: Sun, 03 Dec 2006 16:44:56 +0100
Message-ID: <4572F0F8.9080702@trash.net>
References: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>	<20061129020926.21082.33516.sendpatchset@localhost.localdomain>
	<200612030401.kB341wVQ010254@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200612030401.kB341wVQ010254@toshiba.co.jp>
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
> Hi, Patrick,
> 
> From: Patrick McHardy <kaber@trash.net>
> Date: Wed, 29 Nov 2006 03:09:27 +0100 (MET)
> 
> 
>>[NETFILTER]: x_tables: add port of hashlimit match for IPv4 and IPv6
> 
> 
> ipv6_find_hdr() is in ip6_tables.c, then why about CONFIG_IP6_NF_IPTABLES ?

Thanks for catching this, I tried compiling without IPv6 and it
broke, but apparently I didn't really think when fixing it :)
