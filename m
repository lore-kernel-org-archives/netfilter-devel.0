From: don-nfil1@isis.cs3-inc.com (Don Cohen)
Subject: NAT and ICMP
Date: Fri, 18 Feb 2005 11:43:34 -0800
Message-ID: <16918.17766.816573.731012@isis.cs3-inc.com>
References: <200502171912.j1HJCFV06530@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200502171912.j1HJCFV06530@isis.cs3-inc.com>
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


Here's some behavior that seems clearly wrong, though I'm not
sure what is right.  This is from a redhat 8 box, 2.4.18-14,
so it's possible that this could be either specific to redhat
or fixed (or at least altered) in later kernels.

This box is connected to a LAN, and doing NAT for that LAN:

inside 10.0.0.2 --- 10.0.0.1 redhat8 24... --- internet --- server

The inside machine connects to the server in the internet.
In my test case it's doing ssh, running a program that prints
the time every minute.
I now disconnect the inside machine.
The server sends the next time update (to 24..., the address of
the redhat NAT machine, to be forwarded to the inside machine).
The redhat machine can no longer reach the inside machine and
replies with ICMP host unreachable - returning the packet that
it could not deliver, which is addressed to 10.0.0.2 !
This is clearly wrong, since the server has no idea who 10.0.0.2
is.  On the other hand, it also makes no sense to claim that
24... is an unreachable host - that's the one that is actually
answering.  The best I can think of is that it ought to say that
the port is unreachable for the packet it received (pre-NAT, so
its own address and the port as seen at the server).
