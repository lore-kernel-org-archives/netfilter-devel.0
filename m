From: serjio <serjio@tajik.net>
Subject: New offers for an ULOG module.
Date: Thu, 17 Feb 2005 13:08:18 +0500
Message-ID: <421450F2.2010503@tajik.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
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

Hello All,

I had a some problems with using ULOG module. You can found a 
description of them in
my post at last month at 
http://lists.gnumonks.org/pipermail/ulogd/2005-January/000687.html

In shortly there were troubles with data transmissions between ULOG 
module and ULOGD daemon
program. I also was worried by repeteadly messages like "ipt_ULOG: can't 
alloc whole buffer"
from my ULOG module. Due to this I was unable to check my network 
traffic for 100%.

FYI: I have to control a large volume of traffic. It is about of 10Mbit 
per second or higher.
So I think this module should be a bit modified to get around above 
problems.

Please read my assumptions.

There will be an one large buffer for collecting headers of a packets.
This buffer will be shared between IRQ handler and userspace program. 
Due to this we will not need
to use timers and kernel socket functions. Kernel module will just write 
information
to this buffer and userspace programm will read one.

Here is some details about my idea.

1. Packet fetching
I offer to fetch only a particular fields from the packet IP header like:
source and destination IP addresses, protocol number,  protocol ports 
(for TCP and UDP cases)
and size of packet. It will much reduce a size of buffer.

2. Memory allocation and iteraction with an userscape program.

Also I would like to use memmory mapping for share data between module
and userspace program. I hope that using this technique instead of 
netlink_broadcast
function will always deliver data to the userscape program. Since an 
userspace program
is very much slower than IRQ handler I think that using a large buffer 
can help
to make them work together. I think we need about of 2 Mbyte of RAM. It 
is very pain that we
cannot allocate such memory in the kernel by using kmalloc or even 
vmalloc function.
For my mind the reserving memory on boot time will be best choice.


Thanks a lot,
Sergei Filippov
---------------------
ISP EASTERA,
http://www.tajik.net
e-mail: serjio@tajik.net
ICQ: 308835322
Dushanbe. Tajikistan
