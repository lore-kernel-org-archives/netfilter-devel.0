From: William Stearns <wstearns@pobox.com>
Subject: Bug with netfilter and NFS server on same machine (fwd)
Date: Sat, 23 Nov 2002 13:44:45 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0211231342530.3237-100000@sparrow>
Reply-To: William Stearns <wstearns@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lars Knudsen <gandalfit@virgilio.it>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: ML-netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Good day, Lars,
	Whether or not the netfilter list was able to find an answer, it 
might still make sense to CC that list.
	Cheers,
	- Bill

---------------------------------------------------------------------------
        > It just DOES NOT BELONG in to the kernel-space.
        "People who start using capital letters always seem to have
emotional rather than logical reasons for their argument."
        -- Alan Cox <alan@lxorguk.ukuu.org.uk>
--------------------------------------------------------------------------
William Stearns (wstearns@pobox.com).  Mason, Buildkernel, named2hosts, 
and ipfwadm2ipchains are at:                        http://www.stearns.org
--------------------------------------------------------------------------


---------- Forwarded message ----------
Date: Sat, 23 Nov 2002 19:37:34 +0100
From: Lars Knudsen <gandalfit@virgilio.it>
To: linux-kernel@vger.kernel.org
Subject: Bug with netfilter and NFS server on same machine

I have been experiencing problems running a nfs server and iptables on 
the same machine.The problem was also reported almost a year ago by Paul 
Raines on the netfilter mailing list 
http://lists.netfilter.org/pipermail/netfilter/2002-January/030002.html 
but it seems no solution has been found yet.

The problem is this: A machine running linux 2.4.18 or 2.4.19 works just 
fine when running just the kernel nfsd. A single client connected to the 
server with 100Mbit ethernet sees throughput of 5-10MByte/sec even after 
an hour or two of continous transfers. If the nfs server is also running 
iptables the throughput is initially the same (5-10MByte/sec) but after 
a while (200MByte-500MByte total transfer) the client starts reporting 
"nfs server not responding" followed after a while by "nfs server OK" 
and of course the transfer rate goes way down (< 1MByte/sec). Using 
tcpdump on the client seems to indicate that some packets have their 
headers garbled - wrong fragment ids being the typical error.

Having iptables compiled as modules and simply loading or unloading the 
ipt_conntrack module is
sufficient for causing/removing the problem. Having iptables support 
compiled into the kernel causes the problem allways.

The problem has been verified on 4 different machines with a variety of 
different ethernet cards. In
all cases the network continues to work without problems for all other 
types of traffic - i.e a telnet connection from client to server works 
with no delay and a ftp transfer goes at >5MByte/sec even when nfs 
throughput is suffering.

\Lars Knudsen

