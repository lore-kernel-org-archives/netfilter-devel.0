From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.23-rc1: ipv4_get_l4proto: Frag of proto 17
Date: Thu, 26 Jul 2007 13:17:22 +0200
Message-ID: <46A882C2.6000206@trash.net>
References: <35590.81.207.0.53.1185382934.squirrel@secure.samage.net>
	<Pine.LNX.4.62.0707251912150.31124@wlug.westbo.se>
	<36349.81.207.0.53.1185385305.squirrel@secure.samage.net>
	<200707260127.l6Q1RPP6019173@toshiba.co.jp>
	<60467.81.207.0.53.1185443160.squirrel@secure.samage.net>
	<46A86E67.2050501@trash.net>
	<47728.81.207.0.53.1185444598.squirrel@secure.samage.net>
	<46A875C8.8030902@trash.net>
	<49914.81.207.0.53.1185448638.squirrel@secure.samage.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, gandalf@wlug.westbo.se,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
To: Indan Zupancic <indan@nul.nu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <49914.81.207.0.53.1185448638.squirrel@secure.samage.net>
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

Indan Zupancic wrote:
>
> Reading the comment in icmp.c iph->frag_off & htons(IP_OFFSET)
> being true means that it's a fragment, but not the first one.
>
> So what's happening is that the host sends a big UDP packet, it gets
> fragmentated, but never reaches its destination. ICMP error packets
> are generated. Conntrack drops the latter ones thanks to the check in
> ipv4_get_l4proto.
>
> So the question is whether those latter ICMP packets should be forwarded
> or not. If not, the code is fine and the warning message could be removed.
> If they should, then it might be hard for the current conntrack code know
> where to send the packet, as the UDP header is missing.

Yes, we can't associate them with the original connection.
We should catch this case in ICMP tracking though I think
instead of removing the message.
