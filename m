From: Patrick McHardy <kaber@trash.net>
Subject: Re: REJECT target
Date: Thu, 26 Jun 2003 17:20:34 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EFB0F42.5020707@trash.net>
References: <Pine.LNX.4.33.0306260830550.10452-100000@blackhole.kfki.hu> <1012141349.20030626165642@habitat-b.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: DarKRaveR <DarKRaveR@habitat-b.de>
In-Reply-To: <1012141349.20030626165642@habitat-b.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Have a look at the conntracl match from pom. This is probably what you want.

Bye,
Patrick

DarKRaveR wrote:

>Hello Jozsef, list,
>
>Okay, admitted. I would be glad to do that in the filtering table, the
>question is: How can I identify those packets, when the were modified
>in the nat table ?
>
>Assuming I have a subnet and a cluster of ip addresses, which get
>redirected in the PREROUTING chain. since the destination address is
>getting changed, how can I now reject some of those packets, when they
>are meant for certain hosts/networks. So, what I want to do, redirect
>packets, but those send to certain destination, or which were meant
>for certain destinations should be rejected. I don't want them to just
>be dropped (without further notice).
>
>In the current design I can't see any way, to do such a thing, that's
>why I wanted to reject them in nat(PREROUTING).
>
>Any thoughts on that ?
>
>Sorry for bothering again ...
>
>-Sven
>
>  
>
