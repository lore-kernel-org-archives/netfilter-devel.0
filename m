From: Abraham van der Merwe <abz@frogfoot.net>
Subject: ULOG / netlink errors
Date: Sun, 28 Nov 2004 13:37:28 +0200
Message-ID: <20041128113728.GA17226@oasis.frogfoot.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development <netfilter-devel@lists.netfilter.org>
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

Hi!

I'm trying to gather statistics (for netflow stats) using ULOG.

What I do:

# tag packets
iptables -A FORWARD -j ULOG --ulog-cprange 64 --ulog-nlgroup 1

Then I open a netlink socket (socket AF_NETLINK,SOCK_RAW,NETLINK_NFLOG),
increase the receive buffer size to NLBUFSIZ and capture messages using
recvfrom().

I keep getting these errors:

------------< snip <------< snip <------< snip <------------
root@mojo:~# ./tuxprobe
Starting to log output.
recvfrom failed: No buffer space available
recvfrom failed: No buffer space available
recvfrom failed: No buffer space available
recvfrom failed: No buffer space available
...
------------< snip <------< snip <------< snip <------------

I have tried increasing the socket buffer size with:

sysctl -w net/core/rmem_max=1048576
sysctl -w net/core/rmem_default=1048576

(and even 4MB buffer sizes)

which doesn't help. I've also decreased the capture length to 64 bytes, but
I still get the same errors.

Could somebody please tell me how to solve this problem and/or why capturing
packets via a netlink socket might be a bad idea?

With libpcap (or normal raw socket) on the same machine I have no problems
capturing all the data, even with capturing complete packets so I can't see
why above doesn't/shouldn't work.

-- 

Regards
 Abraham

TODAY the Pond!
TOMORROW the World!
                -- Frogs (1972)

___________________________________________________
 Abraham vd Merwe - Frogfoot Networks CC
 1st Floor, Albion Springs, 183 Main Road, Newlands
 Phone: +27 21 689 3876 Cell: +27 82 565 4451
 Http: http://www.frogfoot.net/ Email: abz@frogfoot.net
