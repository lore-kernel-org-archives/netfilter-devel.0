From: "liran tal" <liransgarage@gmail.com>
Subject: An ip_conntrack / nat problem with kernel 2.4.17_mvl21
Date: Fri, 20 Jul 2007 10:50:24 +0200
Message-ID: <3ed55890707200150j3a4548do58e94e3a224ccf46@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

Hey everyone,

I'm using a version of the 2.4.17_mvl21 kernel (from MontaVista
originally) which was modified by Texas Instruments for their
additions of some hardware.

The problem I'm facing is  this:
[computer A: 172.16.0.33] --> [LAN IP: 172.16.0.1 ...linuxbox... WAN
IP 172.17.1.4] -->[computer B: 172.17.1.44]
The situation is that a computer on the LAN side of the linux box
running that kernel with
an IP of say 172.16.0.33 (computer A) pings a computer behind the WAN
IP, say computer B with IP of 172.17.1.44
isn't getting an reply.
When I started wireshark on computer B to see what's going on I saw
that it receives icmp echo requests
from the IP address 172.16.0.33 and tries to reply back which is
ofcourse totally wrong as it's
unreachable and what should've happened is that it was supposed to see
a request from the WAN IP
172.17.1.4 and reply to that.

I can say that anything related to the actual configuration of the
NAT/Masquerading information
is irrelevant since it is working with a previous kernel version just fine.

That previous version we had of this kernel had a problem with
ip_conntrack or basically a nat problem and the guy who was dealing
with it before me "solved" it by overwriting some files from kernel
2.4.20 vanilla. Files like net/ipv4/netfilter/*
include/linux/netfilter_arp/* and include/linux/netfilter_ipv4 if I
can remember correctly.

Anyway, I can not do the same procedure with this new version of the
kernel they gave us because the guys at TI inserted some of their own
code into the networking stack which seems  about dealing with qos and
some files have includes to ti_qos.h etc


I'm really looking for a lead on which files to look at exactly and what
should I be exactly looking for?

If anyone has any idea how to approach this or any leads
I'll appreciate that very much.


Thanks,
Lir.
