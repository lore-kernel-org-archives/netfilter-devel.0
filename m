From: Patrick McHardy <kaber@trash.net>
Subject: Re: [netfilter-core] Possible bug in MASQ under 2.6?
Date: Tue, 19 Oct 2004 01:37:42 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <417453C6.9030903@trash.net>
References: <1097763939.32619.13.camel@castle.bigfiber.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: coreteam@netfilter.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Travis Morgan <travis@bigfiber.net>
In-Reply-To: <1097763939.32619.13.camel@castle.bigfiber.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Travis Morgan wrote:

>I think I've found what might be called a bug with MASQ under 2.6 but I
>want a second opinion. We have a Linux router box here and two home
>internet connections. We were using multipath to balance between the two
>connecions under 2.4 (2.4.26-gentoo-r2, has grsec and bunch of other
>stuff)
>
The proper place for bugs is netfilter-devel.

>
>default  proto static 
>      nexthop via 142.179.128.1  dev eth0 weight 2
>      nexthop via 68.148.196.1  dev eth1 weight 1
>
>For iptables POSTROUTING we had two MASQ rules, one with -o eth0 and one
>with -o eth1.
>
>Under 2.4 that worked beautifully. We decided to upgrade to 2.6 and had
>a slew of problems. I finally tracked it down to this dmesg:
>
>printk: 12 messages suppressed.
>MASQUERADE: Route sent us somewhere else.
>printk: 17 messages suppressed.
>MASQUERADE: Route sent us somewhere else.
>

You currently can't use MASQUERADE with multipath routes. The
MASQUERADE routing lookup to get the source adress must return
the same output device the packet is already heading for. With
multipath routes pointing to two different devices this oviously
isn't guaranteed.

Look for Rusty's patch "[PATCH] Fix MASQUERADE" in the netfilter-devel
archives, it should fix your problem.

Regards
Patrick
