From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] icmpv6 match --icmpv6-type confusion
Date: Tue, 04 Jul 2006 10:21:52 +0200
Message-ID: <44AA2520.20006@trash.net>
References: <44A95957.4040805@trash.net>	<200607040030.k640U4e5004273@toshiba.co.jp>	<44A9BA71.2050303@trash.net>
	<200607040426.k644QCpQ026660@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: kernel@linuxace.com, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200607040426.k644QCpQ026660@toshiba.co.jp>
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
> From: Patrick McHardy <kaber@trash.net>
> Date: Tue, 04 Jul 2006 02:46:41 +0200
> 
>>I tend to agree with Phil's interpretation that this is actually
>>unexpected behaviour, so I don't think anyone is doing this
>>intentional. I would expect either a parser error or type any.
> 
> 
> parser error is good idea. It's not neccesary for icmpv6 match to support
> "--icmpv6-type any" because people can get same behavior with only
> "-p ipv6-icmp".

Agreed. Too bad we already have this hack in the kernel for IPv4.

> How about the attached patch ? That also fixes allowing double
> --icmp-type/--icmpv6-type.

Looks good to me.
