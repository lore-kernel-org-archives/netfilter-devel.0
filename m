From: =?UTF-8?B?QXJ0xatyYXMgxaBsYWp1cw==?= <x11@arturaz.net>
Subject: Need an iptables module for hiding NAT.
Date: Mon, 05 Feb 2007 17:59:53 +0200
Message-ID: <45C75479.3090605@arturaz.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hello,

I don't really know if this is the right list so excuse me if I missed 
right spot. Anyway, here is my deal:

I need iptables module which would hide NAT. It means that all traffic 
being routed through the machine which is running netfilter and doing 
routing should be seen as originating from that host.

I have searched the net and found this:
http://lists.netfilter.org/pipermail/netfilter/2004-November/056947.html

It basically (probably) describes all factors how NAT detection works.

I have also found this article describing how to write such module for 
Windows NT (in Russian):
http://www.xakep.ru/post/29448/default.asp

I basically need to hide my network from such tools as 
http://elceef.itsec.pl/natdet/

I am willing to pay you for developing it. Name your price and perhaps 
we can negotiate something out of it.

I hope somebody can help me, any shared thoughts about difficulty of 
doing such task and time involved would be appreciated (i'm a programmer 
myself, just not C and kernel ;-))

Good day, Artūras Šlajus.
