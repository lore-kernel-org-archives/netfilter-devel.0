From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] REJECT for 2.6.9+
Date: Sun, 03 Apr 2005 20:26:49 +0200
Message-ID: <42503569.5080406@trash.net>
References: <423BF227.8030502@outerspace.dyndns.org> <423DA194.40100@trash.net>
	<200503300205.j2U25fCc021930@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200503300205.j2U25fCc021930@toshiba.co.jp>
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
> I wrote ip6t_REJECT so that the source address of ICMPv6 error was
> destination address of original packet. Because of this behavior,
> send_unreach could not use icmpv6_send().
> But now I have found that the behavior of ipt_REJECT is different.
> The source address of ICMP error is its node. I think the behavior of them
> should be same. Moreover, ipt_REJECT has changed to use icmp_send() recently.

That makes sense. Do you have any other issues with submitting
this patch?

Regards
Patrick
