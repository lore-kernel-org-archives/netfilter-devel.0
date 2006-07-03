From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] icmpv6 match --icmpv6-type confusion
Date: Mon, 03 Jul 2006 19:52:23 +0200
Message-ID: <44A95957.4040805@trash.net>
References: <20060630201858.GA5845@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20060630201858.GA5845@linuxace.com>
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

Phil Oester wrote:
> Adding a rule such as this:
> 
> -A INPUT -p ipv6-icmp -m icmpv6
> 
> ends up creating a rule with "ipv6-icmp type 0", instead of "ipv6-icmp type any"
> which is what was expected.  Granted, the match is redundant anyway, but it
> should not assume a specific type when one is not specified.
> 
> Below patches (to both kernel and userspace) fix this, and resolve bug #461.
> In keeping with icmpv4, 0xFF is used to designate "any". And since I was
> looking at it, I fixed up a 255 -> any in icmpv4 printing.

Thanks Phil. I have to admit that I never liked the ugly 255 hack,
its a perfectly valid value for the type field to use, even though
its currently not defined for IPv4 or IPv6. For IPv6 I even have
some concerns that it will stay unused for all times, the stategy
for choosing new values seems to be different from IPv4. I guess
an alternative would be to introduce a new revision.

Yasuyuki, do you have an opinion on this?
