From: Patrick McHardy <kaber@trash.net>
Subject: Re: [H.323 Helper 1/3]: Add support for Call Forwarding
Date: Fri, 28 Apr 2006 17:13:52 +0200
Message-ID: <44523130.20007@trash.net>
References: <BAY109-DAV265AE2E1870989462F689B3BE0@phx.gbl><444F7A3F.9080507@trash.net><BAY109-DAV1099B645E5820953632189B3BC0@phx.gbl><444FA4A7.7060105@trash.net><BAY109-DAV107DE91F0E0B272EC778E4B3BC0@phx.gbl><444FD64F.5020002@trash.net><BAY109-DAV19D24F345ECC0228FE364B3BC0@phx.gbl>	<44512214.9050703@trash.net>
	<BAY109-DAV10B763E5C4658D4D61C39CB3B20@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb18030
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jing Min Zhao <zhaojingmin@hotmail.com>
In-Reply-To: <BAY109-DAV10B763E5C4658D4D61C39CB3B20@phx.gbl>
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

Jing Min Zhao wrote:
> Hi, Patrick,
> 
> I applied your patch, it compiled ok, but there are some
> linking warnings:
> 
> WARNING: "free_fib_info" [net/ipv4/netfilter/ip_conntrack_h323.ko] undefined!
> WARNING: "fib_lookup" [net/ipv4/netfilter/ip_conntrack_h323.ko] undefined!
> WARNING: "fib_rule_put" [net/ipv4/netfilter/ip_conntrack_h323.ko] undefined!
> 
> When I disabled IP: policy routing (CONFIG_IP_MULTIPLE_TABLES), I got 
> different warnings:
> 
> WARNING: "ip_fib_main_table" [net/ipv4/netfilter/ip_conntrack_h323.ko] undefined!
> WARNING: "ip_fib_local_table" [net/ipv4/netfilter/ip_conntrack_h323.ko] undefined!
> WARNING: "free_fib_info" [net/ipv4/netfilter/ip_conntrack_h323.ko] undefined!

Oops .. these aren't exported. Just drop the patch, I'll send you a
better one this weekend.
