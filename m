From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Delete nfcache use in ip_table
Date: Fri, 06 May 2005 17:05:37 +0200
Message-ID: <427B87C1.9050804@trash.net>
References: <427A469D.8030305@eurodev.net> <427A49F6.2090607@trash.net>
	<427AB976.8040402@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <427AB976.8040402@eurodev.net>
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

Pablo Neira wrote:
> Patrick McHardy wrote:
> 
>> No objections, but please remove it in all files under
>> net/ipv4/netfilter.
> 
> I've deleted all references to nfcache found in ipv4 and ipv6.

Thanks. I thought we couldn't remove them in ipv6/ because
ip6_maybe_reroute() reroutes packets with NFC_ALTERED, but
the flag wasn't set on any change that could affect routing,
so it should be fine. I've removed ip6_maybe_reroute() and
killed one more NFC_ALTERED in net/bridge.

> While I was at it, I thought about killing NFC_* stuff in
> include/linux/netfilter[_ipv4].h, then I realized that old iptables
> versions won't compile if I do so. Those will have to remain there to
> ensure backward compatibility compilation.

Yes, we can kill them once iptables versions that still include
them don't work anymore for other reasons.

BTW: Please also sign off resends. I've used the line from your first
patch.

Regards
Patrick
